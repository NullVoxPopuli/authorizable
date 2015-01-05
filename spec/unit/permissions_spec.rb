require 'spec_helper'

describe Authorizable::Permissions do

  after(:each) do

  end

  it 'sets class attribute' do
    Authorizable::Permissions.set(
      edit_event:   [Authorizable::OBJECT, true],
      delete_event: [Authorizable::OBJECT, true, nil, ->(e, user){ e.hosted_by == user }, ->(e, user){ e.hosted_by == user }],
      create_event: [Authorizable::ACCESS, true],
    )

    keys = Authorizable::Permissions.definitions.keys
    expect(keys.count).to eq 3
    expect(keys).to include(:edit_event)
    expect(keys).to include(:delete_event)
    expect(keys).to include(:create_event)
  end

  it 'expands crud' do
    expect{
      Authorizable::Permissions.set(
        crud: [
          event: [true, false, false]
        ]
      )
    }.to change(Authorizable::Permissions.definitions.keys, :count).by 4
  end

end
