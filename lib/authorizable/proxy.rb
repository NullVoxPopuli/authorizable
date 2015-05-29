module Authorizable
  class Proxy
    attr_reader :actor
    attr_reader :cache

    # @param [Object] the user or whatever that will be
    #  asking if it can perform actions
    def initialize(actor)
      @actor = actor
      @cache = Authorizable::Cache.new
    end

    # @TODO figure out how to make roles generic
    IS_OWNER = 0
    IS_UNRELATED = 1

    def can?(permission_name, *args)
      # object; Event, Discount, etc
      object = args[0]
      # convert permission to full name, if needed
      permission = full_permission_name(permission_name, object)

      # halt if the permission doesn't exist
      unless util.exists?(permission)
        raise Authorizable::Error::PermissionNotFound.new(action: permission_name, subject: args[0])
      end
      process_permission(permission, *args)
    end

    private

    def util#permissions
      PermissionUtilities
    end

    # Will convert :edit to :edit_event if object is an event
    # but if root_name is already edit_event, no change will be made
    #
    # @param [String] root_name the name of the permission
    # @param [Object] object the object the permission is for
    # @return [Symbol] full permission name
    def full_permission_name(root_name, object = nil)
      return root_name.to_sym unless object

      suffix = object.class.name.downcase
      if root_name.to_s.ends_with?(suffix)
        root_name.to_sym
      else
        "#{root_name}_#{suffix}".to_sym
      end
    end

    # checks if the permission has already been calculated
    # otherwise the permission needs to be evaluated
    def process_permission(permission, *args)
      cached = value_from_cache(permission, *args)

      if cached.nil?
        evaluate_permission(permission, *args)
      else
        cached
      end
    end

    # checks the cache if we have calculated this permission before
    # @return [Boolean|NilClass]
    def value_from_cache(permission, *args)
      # object; Event, Discount, etc
      o = args[0]
      role = get_role_of(o)

      # don't perform the permission evaluation, if we have already computed it
      cache.get_for_role(permission, role)
    end

    # performs a full evaluation of the permission
    # @return [Boolean]
    def evaluate_permission(permission, *args)
      # object; Event, Discount, etc
      o = args[0]
      # default to allow
      result = true
      role = get_role_of(o)


      # evaluate procs
      if (proc = PermissionUtilities.has_procs?(permission))
        result &= proc.call(o, self)
      end

      # Here is where the addition of adding collaborations may reside

      # finally, determine if the user (self) can do the requested action
      result &= allowed_to_perform?(permission, role)

      # so we don't need to do everything again
      cache.set_for_role(
        name: permission,
        value: result,
        role: role
      )

      result
    end

    # @param [String] permission name of the permission
    # @param [Number] role role of the user
    # @param [Hash] set a hash of string keys and values
    # @return [Boolean] the result of the whether or not the user, self,
    #   is allowed to perform the action
    def allowed_to_perform?(permission, role = IS_OWNER, set = {})
      result = true
      use_default = false

      use_default = true if set[permission].nil?

      if use_default
        result &= PermissionUtilities.value_for(permission, role)
      else
        result &= set[permission]
      end

      result
    end

    # By default this will just be a pass-through to has_role_with
    # This method is intended to be a part of a group/role implementation.
    # for example, if working with a hierarchy of objects, such as a
    # Book having many chapters, and the chapters themselves don't have a User
    # but the Book does, that logic should be added in a method that overrides this one.
    #
    # @param [ActiveRecord::Base] object should be the object that is being tested
    #   if the user can perform the action on
    def get_role_of(object)
      return has_role_with(object)
    end

    # This method can also be overridden if one desires to have multiple types of
    # ownership, such as a collaborator-type relationship
    #
    # @param [ActiveRecord::Base] object should be the object that is being tested
    #   if the user can perform the action on
    # @return [Number] true if self owns object
    def has_role_with(object)
      if object.respond_to?(:user_id)
        if object.user_id == actor.id
          return IS_OWNER
        else
          return IS_UNRELATED
        end
      end
      # hopefully the object passed always responds to user_id
      IS_UNRELATED
    end

  end
end
