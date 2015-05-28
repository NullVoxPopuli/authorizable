require 'spec_helper'


describe Authorizable::Cache do
  describe "get_for_role" do
    before(:each) do
      proxy.instance_variable_set(
        '@permission_cache',
        {
          1 => { "role" => true },
          "roleless" => true
        }
      )
    end

    it 'gets a value for a non-role-based permission' do
      expect(proxy.send(:get_for_role, "roleless")).to eq true
    end

    it 'gets a value for a role-based permission' do
      expect(proxy.send(:get_for_role, "role", 1)).to eq true
    end
  end

  describe "set_for_role" do
    it 'sets a role-based permission' do
      proxy.send(:set_for_role, name: "permission_name", role: 1, value: true)
      cache = proxy.instance_variable_get('@permission_cache')

      expect(cache[1]).to be_present
      expect(cache[1]["permission_name"]).to eq true
    end

    it 'sets a non-role-based permission' do
      proxy.send(:set_for_role, name: "permission_name", value: true)
      cache = proxy.instance_variable_get('@permission_cache')

      expect(cache["permission_name"]).to eq true
    end
  end

end
