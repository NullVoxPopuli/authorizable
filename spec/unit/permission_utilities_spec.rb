require 'spec_helper'

describe Authorizable::PermissionUtilities do
  let(:util){Authorizable::PermissionUtilities}

  describe 'permissions' do
    it 'mirrors the source definitions' do
      Authorizable::Permissions.definitions = 'test'
      expect(Authorizable::PermissionUtilities.permissions).to eq(Authorizable::Permissions.definitions)
    end
  end

  describe 'set_for_role' do
    before(:each) do
      Authorizable::Permissions.definitions = {
        one: [1, true],
        two: [2, [true, false]],
        three: [1, [true, true]]
      }
    end

    it 'generates a hash for a particular role' do
      set = Authorizable::PermissionUtilities.set_for_role(1)

      expect(set[:one]).to eq true
      expect(set[:two]).to eq false
      expect(set[:three]).to eq true
    end

    it 'generates a hash for the default role' do
      set = Authorizable::PermissionUtilities.set_for_role(0)

      expect(set[:one]).to eq true
      expect(set[:two]).to eq true
      expect(set[:three]).to eq true
    end
  end

  describe 'has_procs?' do
    before(:each) do
      Authorizable::Permissions.definitions = {
        procs: [0, true, "", nil, ->{ 'here is a proc' }],
        no_procs: [0, true, "", nil]
      }
    end

    it 'has procs' do
      result = Authorizable::PermissionUtilities.has_procs?(:procs)
      expect(result).to_not eq false
      expect(result).to be_kind_of Proc
    end

    it 'does not have procs' do
      result = Authorizable::PermissionUtilities.has_procs?(:no_procs)
      expect(result).to eq false
    end
  end

  describe 'has_visibility_procs?' do
    before(:each) do
      Authorizable::Permissions.definitions = {
        procs: [0, true, "", ->{ 'here is a proc' }],
        no_procs: [0, true, ""]
      }
    end

    it 'has procs' do
      result = Authorizable::PermissionUtilities.has_visibility_procs?(:procs)
      expect(result).to_not eq false
      expect(result).to be_kind_of Proc
    end

    it 'does not have procs' do
      result = Authorizable::PermissionUtilities.has_visibility_procs?(:no_procs)
      expect(result).to eq false
    end
  end

  describe 'should_render?' do
    before(:each) do
      Authorizable::Permissions.definitions = {
        dont_show: [0, true, "", ->{ false }],
        show: [0, true, ""]
      }
    end

    it 'should render' do
      result = Authorizable::PermissionUtilities.should_render?(:show)
      expect(result).to eq true
    end

    it 'should not render' do
      result = Authorizable::PermissionUtilities.should_render?(:dont_show)
      expect(result).to eq false
    end
  end

  context 'quick info' do
    before(:each) do
      Authorizable::Permissions.definitions = {
        access: [Authorizable::Permissions::ACCESS, true, "Is Access", ->{ false }],
        object: [Authorizable::Permissions::OBJECT, [false, true], ""]
      }
    end

    describe 'description_for' do
      it 'has a description' do
        expect(util.description_for(:access)).to eq "Is Access"
      end

      it 'does not have a descirption' do
        expect(util.description_for(:object)).to eq "Object"
      end
    end

    describe 'value_for' do
      it 'has a role' do
        expect(util.value_for(:object, 1)).to eq true
      end

      it 'does not have a role' do
        expect(util.value_for(:access)).to eq true
      end
    end

    describe 'has_key?' do
      it 'exists' do
        expect(util.has_key?(:object)).to eq true
      end

      it 'non exists' do
        expect(util.has_key?(:non_existant)).to eq false
      end
    end

    describe 'is_access?' do
      it 'is access' do
        expect(util.is_access?(:access)).to eq true
      end

      it 'is not access' do
        expect(util.is_access?(:object)).to eq false
      end
    end

    describe 'is_object?' do
      it 'is object' do
        expect(util.is_object?(:object)).to eq true
      end

      it 'is not object' do
        expect(util.is_object?(:access)).to eq false
      end
    end

  end
end
