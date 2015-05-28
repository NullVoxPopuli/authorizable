require 'rails_helper'

describe Authorizable::Model, type: :model do

  let(:user){ create(:user) }

  describe "can?" do

    it 'gets the default value' do
      result = user.can? :edit_event
      expect(result).to eq true
    end

    it 'gets the defalut value for a disallowed permission' do
      result = user.can? :always_deny
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
        @event = create(:event, user: user)
      end

      it 'is owner' do
        result = user.send(:permission_proxy).send(:get_role_of, @event)
        expect(result).to eq Authorizable::Proxy::IS_OWNER
      end

      it 'is collaborator' do
        @event.collaborators << @collaborator
        @event.save
        result = @collaborator.send(:permission_proxy).send(:get_role_of, @event)
        expect(result).to eq Authorizable::Proxy::IS_UNRELATED
      end

      it 'is unrelated' do
        result = @unrelated.send(:permission_proxy).send(:get_role_of, @event)
        expect(result).to eq Authorizable::Proxy::IS_UNRELATED
      end
    end
  end

  describe "has_role_with" do

    let(:proxy){ Authorizable::Proxy.new(user) }

    it 'is the owner' do
      @event = create(:event, user: user)
      result = proxy.send(:has_role_with, @event)
      expect(result).to eq Authorizable::Proxy::IS_OWNER
    end
    #
    # it 'is not the owner' do
    #   user = create(:user)
    #   @event = create(:event, user: @user)
    #   result = user.send(:has_role_with, @event)
    #   expect(result).to eq Authorizable::Model::IS_UNRELATED
    # end

    it 'object does not respond to user_id' do
      result = proxy.send(:has_role_with, 3)
      expect(result).to eq Authorizable::Proxy::IS_UNRELATED
    end

  end
end
