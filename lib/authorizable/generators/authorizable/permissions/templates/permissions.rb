module Authorizable

  # the following class is a definition of all permissions in your system
  # and is independent of
  class Permissions

    # The following is just copied from the Authorizable README.md
    #
    # There are a couple ways that permissions can be defined.
    #
    # If you like calling methods for configuration:
    #
    #     module Authorizable
    #       class Permissions
    #         can :delete_event
    #       end
    #     end
    #
    # will create a permission definition called `delete_event` which can be accessed by calling
    # `user.can_delete_event?(@event)`
    #
    #     module Authorizable
    #       class Permissions
    #         can :edit_event, true, "Edit an Event", nil, ->(e, user){ e.user == user }
    #       end
    #     end
    #
    # will create a permission definition called `edit_event` with an additional condition allowing editing only if the user owns the event
    #
    #     Authorizable::Permissions.set(
    #       edit_organization:   [Authorizable::OBJECT, true],
    #       delete_organization: [Authorizable::OBJECT, [true, false], nil, ->(e, user){ e.user == user }, ->(e, user){ e.owner == user }]
    #     )
    #
    # This is how Authorizable references the permission definitions internally, just as raw permission: definition sets. Note that `Authorizable::Permissions.set` overrides the definitions list each time.

  end
end
