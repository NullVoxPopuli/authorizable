require 'spec_helper'

describe Authorizable::Permissions do

  it 'sets class attribute' do
    Authorizable::Permissions.set(
      edit_event:   [Authorizable::OBJECT, true],
      delete_event: [Authorizable::OBJECT, true, nil, ->(e, user){ e.hosted_by == user }, ->(e, user){ e.hosted_by == user }],
      create_event: [Authorizable::ACCESS, true],
    )
  end

end
