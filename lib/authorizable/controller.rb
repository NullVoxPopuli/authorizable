module Authorizable
  module Controller
    extend ActiveSupport::Concern
    include ClassMethods


    included do

      # where the config for this controller is stored
      # after validation
      class_attribute :authorizable_config
    end

    private

    def authorizable_authorized?
      result = false
      action = params[:action].to_sym

      if !self.class.authorizable_config[action]
        action = Authorizable::Controller.alias_action(action)
      end

      settings_for_action = self.class.authorizable_config[action]

      return true unless settings_for_action.present?

      defaults = {
        user: current_user,
        permission: "can_#{action.to_s}?",
        message: I18n.t('authorizable.not_authorized'),
        flash_type: :alert
      }

      options = defaults.merge(settings_for_action)

      # run permission
      if options[:target]
        object = instance_variable_get("@#{options[:target]}")
        result = options[:user].send(options[:permission], object)
      else
        result = options[:user].send(options[:permission])
      end

      # redirect
      unless result
        authorizable_respond_with(
          options[:flash_type],
          options[:message],
          options[:redirect_path]
        )

        # halt
        return false
      end

      # proceed with execution
      true
    end


    def authorizable_respond_with(flash_type, message, path)
      flash[flash_type] = message

      respond_to do |format|
        format.html{
          path = self.instance_eval(&path)
          redirect_to path
        }
        format.json{
          render json: {}, status: 401
        }
      end

    end

    def self.alias_action(action)
      if action == :update
        action = :edit
      elsif action == :edit
        action = :update
      elsif action == :create
        action = :new
      elsif action == :new
        action = :create
      end

      action
    end

    # @see @authorizable for options
    # @return [Boolean]
    def self.parameters_are_valid?(config)
      config.each do |action, settings|
        if !settings[:target]
          # permission is required
          if !settings[:permission]
            raise Authorizable::Error::ControllerConfigInvalid.new(
              message: I18n.t('authorizable.permission_required'))
          end
        end

        # redirect_path is always required
        redirect_path = settings[:redirect_path]
        if !redirect_path
          raise Authorizable::Error::ControllerConfigInvalid.new(
            message: I18n.t('authorizable.redirect_path_required'))
        else
          if !redirect_path.is_a?(Proc)
            raise Authorizable::Error::ControllerConfigInvalid.new(
              message: I18n.t("authorizable.redirect_path_must_be_proc"))
          end
        end
      end
    end

  end
end
