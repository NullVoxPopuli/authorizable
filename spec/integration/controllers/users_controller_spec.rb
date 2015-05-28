require 'rails_helper'

# this is for testing default, non-specified functionality
# in controllers
describe UsersController, type: :controller do

  it 'includes authorizable' do
    expect(controller.class.ancestors).to include(Authorizable::Controller)
  end

  context 'actions' do

    context 'index' do

      it 'allows' do
        Authorizable::Permissions.class_eval {
          can :view_users, true
        }

        get :index
        expect(response).to be_success
      end

      it 'denies' do
        Authorizable::Permissions.class_eval {
          can :view_users, false
        }

        get :index
        expect(response).to be_redirect
        expect(flash[:notice]).to be_present
      end

    end

    context 'show' do

    end

    context 'create' do

    end

    context 'destroy' do

    end

    context 'edit' do

    end

    context 'update' do

    end

  end


end
