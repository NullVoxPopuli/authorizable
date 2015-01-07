module Authorizable
  # this should be included on the 'User' model or whatever
  # is going to be performing action that need to be
  # authorized
  module Model
    extend ActiveSupport::Concern

    # @TODO figure out how to make roles generic
    IS_OWNER = 0
    IS_UNRELATED = 1

    def method_missing(name, *args, &block)
      string_name = name.to_s

      if string_name =~ /can_(.+)\?/
        permission_name = $1
        permission_name.gsub!('destroy', 'delete')
        if ["delete", "edit", "create"].include?(permission_name)
          # shorthand for delete_{object_name}
          object = args[0]
          object_name = object.class.name.downcase
          return send("can_#{permission_name}_#{object_name}?", *args, &block)
        else
          return process_permission(name, permission_name, args)
        end
      else
        super(name, *args, &block)
      end
    end

    private

    def process_permission(method_name, permission_name, args)
      permission = permission_name.to_sym
      o = args[0] # object; Event, Discount, etc
      # default to allow
      result = true

      role = get_role_of(o)

      # don't perform the permission evaluation, if we have already computed it
      permission_value_from_cache = value_from_permission_cache(method_name, role)
      return permission_value_from_cache if permission_value_from_cache.present?


      # evaluate procs
      if (proc = PermissionUtilities.has_procs?(permission))
        result &= proc.call(o, self)
      end

      # Here is where the addition of adding collaborations may reside

      # finally, determine if the user (self) can do the requested action
      result &= can?(permission, role)

      # so we don't need to do everything again
      set_permission_cache(
        name: method_name,
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
    def can?(permission, role = IS_OWNER, set = {})
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
        if object.user_id == self.id
          return IS_OWNER
        else
          return IS_UNRELATED
        end
      end
      # hopefully the object passed always responds to user_id
      IS_UNRELATED
    end

    # calculating the value of a permission is costly.
    # there are several Database lookups and lots of merging
    # of hashes.
    # once a permission is calculated, we'll store it here, so we don't
    # have to re-calculate/query/merge everything all over again
    #
    # for both object access and page access, check if we've
    # already calculated the permission
    #
    # the structure of this cache is the following:
    # {
    #   role_1: {
    #     permission1: true
    #     permission2: false
    #   },
    #   authorization_permission_name: true
    # }
    #
    # @param [String] name name of the permission
    # @param [Number] role role of the user
    # @param [Boolean] value
    def set_permission_cache(name: "", role: nil, value: nil)
      @permission_cache ||= {}
      if role
        @permission_cache[role] ||= {}
        @permission_cache[role][name] = value
      else
        @permission_cache[name] = value
      end
    end

    # @param [String] permission_name name of the permission
    # @param [Number] role role of the user
    # @return [Boolean] value of the previously stored permission
    def value_from_permission_cache(permission_name, role = nil)
      @permission_cache ||= {}

      if role
        @permission_cache[role] ||= {}
        @permission_cache[role][permission_name]
      else
        @permission_cache[permission_name]
      end
    end

  end
end
