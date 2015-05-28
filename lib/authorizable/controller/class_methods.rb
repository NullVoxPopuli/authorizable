module Authorizable
  module Controller
    module ClassMethods
      # sets up a before filter that will redirect if the permission
      # condition fails
      #
      # @example
      #  authorizable(
      #    edit: { # implies current_user.can_edit?(@event)
      #      target: :event,
      #      redirect_path: Proc.new{ hosted_event_path(@event) }
      #    }
      #  )
      #
      # @example
      #  authorizable(
      #    create: {
      #      permission: :can_create_event?,
      #      redirect_path: Proc.new{ hosted_events_path }
      #    },
      #    destroy: { # implies current_user.can_delete?(@event)
      #      target: :event,
      #      redirect_path: Proc.new{ hosted_event_path(@event) }
      #    }
      #  )
      #
      # @param [Hash] config the list of options to configure actions to be authorizable
      # @option config [Symbol] action the action to authorize with
      # @option action [ActiveRecord::Base] :user (current_user) object to run the condition on
      # @option action [Symbol] :permission (can_{action}?(target)) the condition to run on the :user
      # @option action [Symbol] :target ("@#{target}") the name of the object passed to the :permission
      #   if no target is provided :permission becomes a required option
      # @option action [Proc] :redirect_path where to go upon unauthorized
      # @option action [String] :message (I18n.t('authorizable.not_authorized'))
      #   message to display as a flash message upon an unauthorized attempt
      # @option action [Symbol] :flash_type (:alert) what flash type to use for displaying the :message
      def authorizable(config = {})
        Authorizable::Controller.parameters_are_valid?(config)

        self.authorizable_config = config

        self.send(:before_filter, :authorizable_authorized?)
      end
    end
  end
end
