require 'rails_helper'

describe EventsController, type: :controller do

  it 'includes authorizable' do
    expect(controller.class.ancestors).to include(Authorizable::Controller)
  end

  it 'calls authorizable' do
    allow_any_instance_of(EventsController).to receive(:authorizable)
    get :index
  end

  context 'actions' do
    before(:each) do
      EventsController.send(
        :authorizable,
        edit: {
          target: :event,
          redirect_path: Proc.new{ event_path(@event) }
        },
        create: {
          permission: :can_create_event?,
          redirect_path: Proc.new{ events_path }
        },
        destroy: {
          target: :event,
          redirect_path: Proc.new{ event_path(@event) }
        }
      )
    end

    context 'redirects on' do
      let(:event){ create(:event) }
      let(:user){ create(:user) }

      after(:each) do
        expect(flash[:alert]).to eq I18n.t('authorizable.not_authorized')
      end

      context 'edit' do
        before(:each) do
          allow(user).to receive(:can_edit?){ false }
          allow(controller).to receive(:current_user){ user }
        end

        it 'to show' do
          get :edit, id: event.id
          expected = { action: :show, id: event.id }
          expect(response).to redirect_to expected
        end

        context 'and update' do
          it 'to show' do
            put :update, id: event.id
            expected = { action: :show, id: event.id }
            expect(response).to redirect_to expected
          end
        end

      end

      context 'create' do
        before(:each) do
          allow(user).to receive(:can_create_event?){ false }
          allow(controller).to receive(:current_user){ user }
        end

        it 'to index' do
          post :create
          expect(response).to redirect_to action: :index
        end

        context 'and new' do
          it 'to index' do
            get :new
            expect(response).to redirect_to action: :index
          end
        end

      end

      context 'destroy' do
        before(:each) do
          allow(user).to receive(:can_destroy?).and_return(false)
          allow(controller).to receive(:current_user){ user }
        end

        it 'to show' do
          delete :destroy, id: event.id
          expect(response).to redirect_to action: :show
        end
      end
    end
  end

end
