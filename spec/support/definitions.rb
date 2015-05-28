$example_definitions = ->{
  Authorizable::Permissions.set(
    edit_organization:   [Authorizable::OBJECT, [true, false]],
    delete_organization: [Authorizable::OBJECT, [true, false], nil, ->(e, user){ e.user == user }, ->(e, user){ e.owner == user }],
    create_organization: [Authorizable::ACCESS, true, nil, nil],

    view_collaborators: [Authorizable::ACCESS, [true, false]]
  )


  Authorizable::Permissions.class_eval do
    can :edit_event
    can :delete_event
    can :not_do_this, false
    can :always_deny, false
    can :always_allow, true
  end
}
