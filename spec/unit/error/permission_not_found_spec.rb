require 'spec_helper'

describe Authorizable::Error::PermissionNotFound do
  let(:klass){ Authorizable::Error::PermissionNotFound }

  it 'initializes without parameters' do
    expect{
      klass.new
    }.to_not raise_error
  end

  it 'has a different default message from the super class' do
    e = klass.new
    super_class = Authorizable::Error::AuthorizableError.new
    actual = e.default_message

    expect(actual).to_not eq super_class.default_message
  end
end
