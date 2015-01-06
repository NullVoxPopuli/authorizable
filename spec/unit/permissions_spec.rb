require 'spec_helper'

describe Authorizable::Permissions do

  describe 'set' do
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
      Authorizable::Permissions.definitions = {}
      before_count = Authorizable::Permissions.definitions.keys.count
      Authorizable::Permissions.set(
        crud: [
          event: [true, false, false]
        ]
      )

      after_count = Authorizable::Permissions.definitions.keys.count
      expect(after_count - before_count).to eq 4
    end

    it 'crud adds permissions' do
      Authorizable::Permissions.set(
        crud: [
          event: [true, false, false]
        ]
      )

      definitions = Authorizable::Permissions.definitions
      keys = definitions.keys
      expect(keys).to include(:edit_event)
      expect(keys).to include(:delete_event)
      expect(keys).to include(:create_event)
      expect(keys).to include(:view_events)
    end
  end

  describe 'can' do
    it 'adds a permission to the definitions list' do
      Authorizable::Permissions.module_eval do
        can(:some_permission)
      end
      expect(Authorizable::Permissions.definitions.keys).to include(:some_permission)
    end
  end

  describe 'add' do
    it 'adds an entry' do
      Authorizable::Permissions.add(:wat, [0, true])
      expect(Authorizable::Permissions.definitions.keys).to include(:wat)
    end
  end

end
