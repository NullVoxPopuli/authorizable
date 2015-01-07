require 'rails_helper'

describe Authorizable::Model, type: :model do

  before(:each) do
    @user = create(:user)
    @user.class.send(:include, Authorizable::Model)
  end

  describe "process_permission" do
    before(:each) do
      @event = create(:event, user: @user)
      @collaborator = create(:user)

      @event.collaborators << @collaborator
      @event.save
    end

    it 'allows a permission' do
      result = @user.can_view_collaborators?(@event)
      expect(result).to eq true
    end

    it 'allows permission short hand' do
      result = @user.can_edit?(@event)
      expect(result).to eq true
    end

    it 'calls super if method does not match permission pattern' do
      expect{
        @user.do_something
      }.to raise_error(NoMethodError)
    end

    it 'disallows a permission' do
      result = @collaborator.can_view_collaborators?(@event)
      expect(result).to eq false
    end

    it 'sets cache' do
      expect(@user).to receive(:set_permission_cache).and_call_original
      @user.can_view_collaborators?(@event)
      cache = @user.instance_variable_get("@permission_cache")
      expect(cache[Authorizable::Model::IS_OWNER]).to have_key(:can_view_collaborators?)
    end

    it 'returns from cache' do
      # call once - store cache
      @user.can_view_collaborators?(@event)
      cache = @user.instance_variable_get("@permission_cache")
      expect(cache[Authorizable::Model::IS_OWNER]).to have_key(:can_view_collaborators?)

      # call again, return from cache
      expect(@user).to_not receive(:set_permission_cache)
      @user.can_view_collaborators?(@event)

    end
  end

  describe "can?" do

    it 'gets the default value' do
      result = @user.send(:can?, Authorizable.definitions.keys.first)
      expect(result).to eq true
    end

    it 'gets the value from a pre-defined set' do
      key = Authorizable.definitions.keys.first
      result = @user.send(:can?, key, Authorizable::Model::IS_OWNER, { key => false } )
      expect(result).to eq false
    end
  end

  describe "get_role_of" do
    before(:each) do
      @collaborator = create(:user)
      @unrelated = create(:user)
    end

    context 'event' do
      before(:each) do
        @event = create(:event, user: @user)
      end

      it 'is owner' do
        result = @user.send(:get_role_of, @event)
        expect(result).to eq Authorizable::Model::IS_OWNER
      end

      it 'is collaborator' do
        @event.collaborators << @collaborator
        @event.save
        result = @collaborator.send(:get_role_of, @event)
        expect(result).to eq Authorizable::Model::IS_UNRELATED
      end

      it 'is unrelated' do
        result = @unrelated.send(:get_role_of, @event)
        expect(result).to eq Authorizable::Model::IS_UNRELATED
      end
    end
  end

  describe "has_role_with" do

    it 'is the owner' do
      @event = create(:event, user: @user)
      result = @user.send(:has_role_with, @event)
      expect(result).to eq Authorizable::Model::IS_OWNER
    end

    it 'is not the owner' do
      user = create(:user)
      @event = create(:event, user: @user)
      result = user.send(:has_role_with, @event)
      expect(result).to eq Authorizable::Model::IS_UNRELATED
    end

    it 'object does not respond to user_id' do
      result = @user.send(:has_role_with, 3)
      expect(result).to eq Authorizable::Model::IS_UNRELATED
    end

  end

  context 'cache' do

    before(:each) do
      @user = create(:user)
    end

    describe "value_from_permission_cache" do
      before(:each) do
        @user.instance_variable_set(
          '@permission_cache',
          {
            1 => { "role" => true },
            "roleless" => true
          }
        )
      end

      it 'gets a value for a non-role-based permission' do
        expect(@user.send(:value_from_permission_cache, "roleless")).to eq true
      end

      it 'gets a value for a role-based permission' do
        expect(@user.send(:value_from_permission_cache, "role", 1)).to eq true
      end
    end

    describe "set_permission_cache" do
      it 'sets a role-based permission' do
        @user.send(:set_permission_cache, name: "permission_name", role: 1, value: true)
        cache = @user.instance_variable_get('@permission_cache')

        expect(cache[1]).to be_present
        expect(cache[1]["permission_name"]).to eq true
      end

      it 'sets a non-role-based permission' do
        @user.send(:set_permission_cache, name: "permission_name", value: true)
        cache = @user.instance_variable_get('@permission_cache')

        expect(cache["permission_name"]).to eq true
      end
    end
  end
end
