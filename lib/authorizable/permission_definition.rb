module Authorizable

  # This class is the internal representation of a rule or set of rules
  # for allowing a certain activity
  class PermissionDefinition
    # what is the name of the permisison?
    # @example edit
    # @example create
    #
    # this, combined with subject creates a uinque key
    # among all permissions
    attr_accessor :action
    # the object class that the permission cares about
    # must be lowercase
    # @example Event
    # @example "event"
    attr_accessor :subject
    # any proc that aids the evaluation of determining
    # whether or not a user can perform the requested action
    attr_accessor :authorization
    # any logic that would govern whether or not a user would be
    # able to see / configure this permission
    attr_accessor :visibility
    # human readable description which is shown on the configuration page
    attr_accessor :description
    # default values for authorizing
    # default is true
    attr_accessor :default_access

    # @param [Hash] args
    # @option args [Symbol] action
    # @option args [Class] subject
    # @option args [String] subject
    # @option args [Proc] authorization
    # @option args [Proc] visibility
    # @option args [String] description
    # @option args [Boolean] default_access
    # @option args [Object] default_access
    def initialize(args = {})
      validate_args(args)
      set_args(args)
    end


    def key
      "#{action.to_s}_#{object.name.downcase}"
    end

    def subject_name
      subject.is_a?(Class) ? subject.name.downcase : subject
    end

    def should_render?(*args)

    end

    def has_procs?
      authorization_procs.present?
    end

    def has_visibility_procs?
      visibility_procs.present?
    end

    private

    def validate_args(args)
      action = args[:action]
      subject = args[:action]
      authorization = args[:authorization]
      visibility = args[:visibility]
      description = args[:description]
      default_access = args[:default_access]

      if not action.present? or not action.is_a?(Symbol)
        raise ArgumentError.new(":action must be present and be a symbol")
      end

      if not subject.present? or not (subject.is_a?(Class) or subject.is_a?(String))
        raise ArgumentError.new(":subject must be present and be either a class or a string")
      end

      if not default_access.present?
        raise Argument.new(":default_access must be present")
      end
    end

    def set_args(args)
      @action = args[:action]
      @subject = args[:action]
      @authorization = args[:authorization]
      @visibility = args[:visibility]
      @description = args[:description]
      @default_access = args[:default_access]
    end

  end
end
