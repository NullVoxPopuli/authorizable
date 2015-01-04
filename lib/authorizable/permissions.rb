module Authorizable

  class Permissions

    # Aliased constants for easier typing / readability
    OBJECT = PermissionUtilities::OBJECT
    ACCESS = PermissionUtilities::ACCESS

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
      self.definitions = permissions
    end

  end

end
