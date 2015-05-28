require 'spec_helper'


describe Authorizable::Proxy do

  class DummyUser

  end

  let(:proxy){ Authorizable::Proxy.new(DummyUser.new) }

  describe '#full_permission_name' do

    it 'appends the object name suffix' do
      actual = proxy.send(:full_permission_name, :edit, Object.new)
      expect(actual).to eq :edit_object
    end

    it 'returns the root name' do
      actual = proxy.send(:full_permission_name, :edit_object, Object.new)
      expect(actual).to eq :edit_object
    end

    it 'ignores namespaces' do
      class Object::Nothin; end
      actual = proxy.send(:full_permission_name, :edit, Object::Nothin.new)
      expect(actual).to eq :edit_nothin
    end

    it 'ignores nils' do
      actual = proxy.send(:full_permission_name, :edit)
      expect(actual).to eq :edit
    end

  end

  describe '#can?' do
    it 'allows permission short hand' do
      result = proxy.can?(:edit, @event)
      expect(result).to eq true
    end

    it 'errors if the permission does not exist' do
      expect{
        proxy.can?(:wiggle)
      }.to raise_error(Authorizable::Error::PermissionNotFound)
    end

    it 'passes permission evaluating on to process permission' do
      expect(proxy).to receive(:process_permission)
      result = proxy.can?(:view_collaborators, nil)
    end

  end

  describe '#process_permission' do

    it 'disallows a permission' do
      result = proxy.can?(:always_deny)
      expect(result).to eq false
    end

    it 'sets cache' do
      cache = Authorizable::Cache.new
      allow(proxy).to receive(:cache){ cache }
      expect(cache).to receive(:set_for_role).and_call_original

      proxy.can?(:view_collaborators, nil)
      cache_store = cache.store
      actual = cache_store[Authorizable::Proxy::IS_UNRELATED]

      expect(actual).to have_key(:view_collaborators)
    end

    it 'returns from cache' do
      cache = Authorizable::Cache.new
      allow(proxy).to receive(:cache){ cache }

      # call once - store cache
      proxy.can?(:view_collaborators, nil)
      cache_store = cache.store
      actual = cache_store[Authorizable::Proxy::IS_UNRELATED]
      expect(actual).to have_key(:view_collaborators)

      # call again, return from cache
      expect(cache).to_not receive(:set_for_role)
      proxy.can?(:view_collaborators, nil)
    end
  end

end
