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

    def is_authorized_for_action?
      action = params[:action].to_sym
      self.class.authorizable_config ||= DefaultConfig.config

      if !self.class.authorizable_config[action]
        action = Authorizable::Controller.alias_action(action)
      end

      settings_for_action = self.class.authorizable_config[action]

      is_authorized_for_action_with_config?(action, settings_for_action)
    end

    def is_authorized_for_action_with_config?(action, config)
      request_may_proceed = false
      return true unless config.present?

      defaults = {
        user: current_user,
        permission: action.to_s,
        message: I18n.t('authorizable.not_authorized'),
        flash_type: :alert
      }

      options = defaults.merge(config)

      # run permission
      request_may_proceed = evaluate_action_permission(options)

      # redirect
      unless request_may_proceed
        authorizable_respond_with(
          options[:flash_type],
          options[:message],
          options[:redirect_path]
        )

        # halt
        return false
      end

      # proceed with request execution
      true
    end

    # run the permission
    def evaluate_action_permission(options)
      # the target is the @resource
      # (@event, @user, @page, whatever)
      # it must exist in order to perform a permission check
      # involving the object
      if options[:target]
        object = instance_variable_get("@#{options[:target]}")
        return options[:user].can?(options[:permission], object)
      else
        return options[:user].can?(options[:permission])
      end
    end


    def authorizable_respond_with(flash_type, message, path)
      flash[flash_type] = message

      respond_to do |format|
        format.html{
          # instance_eval(&proc) evaluates the proc in
          # this scope, rather than the scope that the proc
          # was defined in
          path = path.is_a?(Proc) ? instance_eval(&path) : path
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
