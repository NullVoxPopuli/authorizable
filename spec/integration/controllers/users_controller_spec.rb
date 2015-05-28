require 'rails_helper'

# this is for testing default, non-specified functionality
# in controllers
describe UsersController, type: :controller do

  it 'includes authorizable' do
    expect(controller.class.ancestors).to include(Authorizable::Controller)
  end

  context 'actions' do

  end


end
