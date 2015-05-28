require 'spec_helper'

describe Authorizable::Error::AuthorizableError do
  let(:klass){ Authorizable::Error::AuthorizableError }

  it 'initializes without parameters' do
    expect{
      klass.new
    }.to_not raise_error
  end
end
