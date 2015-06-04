require 'rails_helper'

# this is for testing default, non-specified functionality
# in controllers
describe UsersController, type: :controller do

  it 'includes authorizable' do
    expect(controller.class.ancestors).to include(Authorizable::Controller)
  end

  context 'actions' do

    before(:each) do
      allow(controller).to receive(:current_user){ create(:user) }
    end

    context 'configuration behavior' do
      after(:each) do
        Authorizable.reset_config!
      end

      context 'unauthorized' do

        before(:each) do
          Authorizable::Permissions.class_eval {
            can :view_all_users, false
          }
        end

        it 'raises an exception' do
          Authorizable.configure do |config|
            config.raise_exception_on_denial = true
          end

          expect{
            get :index
          }.to raise_error(Authorizable::Error::NotAuthorized)
        end

        it 'uses a different flash type' do
          Authorizable.configure do |config|
            config.flash_error = :wut
          end

          get :index

          expect(response).to be_redirect
          expect(flash[:wut]).to be_present
        end

      end


    end


    context 'index' do

      it 'allows' do
        Authorizable::Permissions.class_eval {
          can :view_all_users, true
        }

        get :index
        expect(response).to be_success
      end

      it 'denies' do
        Authorizable::Permissions.class_eval {
          can :view_all_users, false
        }

        get :index
        expect(response).to be_redirect
        expect(flash[:alert]).to be_present
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
