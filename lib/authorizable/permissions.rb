module Authorizable

  class Permissions

    # Aliased constants for easier typing / readability
    OBJECT = PermissionUtilities::OBJECT
    ACCESS = PermissionUtilities::ACCESS

    # defaults for a resource
    CRUD_TYPES = {
      edit: OBJECT,
      delete: OBJECT,
      create: OBJECT,
      view: ACCESS
    }

    # where all the permission definitions are stored
    #
    # example structure:
    #   {
    #     edit_organization:   [OBJECT, [true, false]],
    #     delete_organization: [OBJECT, [true, false], nil, ->(e, user){ e.hosted_by == user }, ->(e, user){ e.owner == user }],
    #     create_organization: [ACCESS, [true, false], nil, nil],
    #
    #     edit_collaborator: [OBJECT, [true, false]],
    #     delete_collaborator: [OBJECT, [true, false]],
    #     create_collaborator: [OBJECT, [true, false]],
    #     view_collaborators: [OBJECT, [true, false]],
    #
    #     view_attendees: [OBJECT, true],
    #     view_unpaid_attendees: [OBJECT, true],
    #     view_cancelled_registrations: [OBJECT, true]
    #   }
    #
    # note that because this is a hash, order and organization of like-named
    # permissions is non-existent
    class_attribute :definitions

    # @example:
    #   {
    #     update_event:   [OBJECT, true, "Edit Event"],
    #     delete_event: [OBJECT, [true, false, false], nil, ->(e, user){ e.hosted_by == user }],
    #     create_event: [ACCESS, RESTRICT_COLLABORATORS]
    #   }
    #   CRUD authorizations can be expcitly defined
    #
    # @example
    #   {
    #     crud: [
    #       object_name: [true, false, false],
    #       ojbect2_name: true,
    #     ]
    #   }
    #   by providing a :crud array in the hash will generate permissions
    #   for the specified object: create, delete, read, and update
    #
    # @note:
    #   update is aliased with edit, and may be used interchangeably
    #   delete is aliased with destroy, and may be used interchangeably
    #
    # @note:
    #   descriptions are not provided by default, and are only specifiable
    #   when explicitly defining permissions (not using crud)
    #
    # @param [Hash] permissions
    def self.set(permissions)
      cruds = permissions.delete(:crud)

      self.definitions = permissions

      if cruds.present?
        cruds.each do |set|
          set.each do |key, values_for_roles|
            CRUD_TYPES.each do |action, kind|
              permission = "#{action}_#{key}"
              permission << "s" if kind == ACCESS # need a better way to pluralize
              permission = permission.to_sym
              permission_array = [kind, values_for_roles]
              self.definitions[permission] = permission_array
            end
          end
        end
      end
    end

    # similar to how CanCan does the creation of permission
    # but without the need for a user to exist immediately
    #
    # @param [Symbol] name what the permission should be called
    #   (the can prefix is automatic, and should be excluded)
    # @param [Boolean] allow (true) default authorization for this permission
    # @param [Array] allow (true) default authorization for this permission
    # @param [String] description (nil) how to explain this permission
    # @param [Proc] visibility (nil) conditions used when rendering this permission in the UI
    # @param [Proc] conditions (nil) additional conditions used when authorizing a user
    # @param [Number] kind (OBJECT) used to specify if this permission takes access on an object or not
    def self.can(name, allow = true, description = nil, visibility = nil, conditions = nil, kind = OBJECT)
      permission_array = [kind, allow, description, visibility, conditions]
      self.add(name, permission_array)
    end

    private

    # @param [Symbol] key permission name
    # @param [PermissionDefinition] permission_definition settings for permission
    def self.add(key, permission_definition)
      self.definitions[key.to_sym] = permission_definition
    end

  end

end
