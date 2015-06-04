require 'spec_helper'

describe Authorizable::Configuration do

  after(:each) do
    Authorizable.reset_config!
  end

  it 'has defaults set' do
    actual = Authorizable.configuration.flash_error
    expect(actual).to eq :alert
  end

  it 'can set custom config values' do
    Authorizable.configure do |config|
      config.flash_error = :no
    end

    actual = Authorizable.configuration.flash_error
    expect(actual).to eq :no
  end

end
