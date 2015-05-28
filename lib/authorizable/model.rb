module Authorizable
  # this should be included on the 'User' model or whatever
  # is going to be performing action that need to be
  # authorized
  module Model
    extend ActiveSupport::Concern


    included do
      # set up our access to the permission checking
      after_initialize :permission_proxy
    end

    # alternative access via
    #   user.can_create_event?
    #   or
    #   user.can_update_event?(@event)
    #
    # TODO: What do we do if something else wants to use method_missing?
    def method_missing(name, *args, &block)
      string_name = name.to_s

      if string_name =~ /can_(.+)\?/
        self.can?(name, *args)
      else
        super(name, *args, &block)
      end
    end


    # simple delegation
    def can?(permission_name, *args)
      permission_proxy.can?(permission_name, *args)
    end

    # inverse? alias?
    def cannot?(*args)
      !can(*args)
    end

    private

    # the permission proxy is how the user or any other actor asks
    # if it can perform actions
    # (so the user class isn't polluted with a bunch of permission code)
    def permission_proxy
      @authorizable_permission_proxy ||= Authorizable::Proxy.new(self)
    end

  end
end
