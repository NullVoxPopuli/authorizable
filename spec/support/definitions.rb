
Authorizable::Permissions.set(
  edit_organization:   [Authorizable::OBJECT, [true, false]],
  delete_organization: [Authorizable::OBJECT, [true, false], nil, ->(e, user){ e.user == user }, ->(e, user){ e.owner == user }],
  create_organization: [Authorizable::ACCESS, true, nil, nil],

  view_collaborators: [Authorizable::ACCESS, [true, false]]
)