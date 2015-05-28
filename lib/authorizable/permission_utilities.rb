module Authorizable

  module PermissionUtilities

    KIND = 0
    DEFAULT_ACCESS = 1
    DESCRIPTION = 2
    VISIBILITY_PROC = 3
    ACCESS_PROC = 4

    OBJECT = 0
    ACCESS = 1
    DEFAULT_ROLE = 0

    def self.permissions
      Authorizable::Permissions.definitions
    end

    def self.set_for_role(role)
      permissions.inject({}) { |h,(k, v)|
        value = v[DEFAULT_ACCESS]
        h[k.to_sym] = value.is_a?(Array) ? value[role] : value
        h
      }
    end

    # returns procs or false
    def self.has_procs?(permission)
      permission_data_helper(permission, ACCESS_PROC)
    end

    def self.has_visibility_procs?(permission)
      permission_data_helper(permission, VISIBILITY_PROC)
    end

    def self.should_render?(permission, *args)
      result = true
      proc = self.has_visibility_procs?(permission)

      if proc
        result = proc.call(*args)
      end

      result
    end

    def self.description_for(permission)
      result = permission_data_helper(permission.to_sym, DESCRIPTION)

      if result.blank?
        result = permission.to_s.humanize
      end

      result
    end

    def self.value_for(permission, role = DEFAULT_ROLE)
      value = permissions[permission.to_sym][DEFAULT_ACCESS]
      value.is_a?(Array) ? value[role] : value
    end

    def self.has_key?(permission)
      permissions[permission.to_sym].present?
    end

    def self.exists?(permission)
      self.has_key?(permission)
    end

    def self.is_access?(permission)
      permissions[permission][KIND] == ACCESS
    end

    def self.is_object?(permission)
      permissions[permission][KIND] == OBJECT
    end

    private

    def self.permission_data_helper(permission, position)
      result = false
      data = permissions[permission]

      if data && data.length >= (position + 1)
        result = data[position]
      end

      result
    end

  end

end
