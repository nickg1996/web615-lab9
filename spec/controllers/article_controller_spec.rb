require 'rails_helper'
model_name = 'Article'
controller_name = "#{model_name.pluralize}Controller".camelize.constantize

RSpec.describe controller_name, type: :controller do
  login_admin # This depends on the spec/support/controller_macros.rb for devise

  before(:each) do
    @user = FactoryBot.create(:admin)
    request.env['HTTP_ACCEPT'] = 'application/json'
  end

  describe 'GET #index' do
    describe 'valid: ' do
      it "should return an index of #{model_name}s" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)
        get :index

        expect(response).to have_http_status(200)
        returning_data = JSON.parse(response.body)
        expect(returning_data[0]['uuid']).to eq(@object.uuid)
      end
    end

    describe 'invalid: ' do
    end
  end

  describe 'GET #show' do
    describe 'valid: ' do
      it "should show a valid #{model_name} with an ID" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)
        get :show, params: { id: @object.id }

        expect(response).to have_http_status(200)
        returning_data = JSON.parse(response.body)
        expect(returning_data['uuid']).to eq(@object.uuid)
      end

      it "should show a valid #{model_name} with an UUID" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)
        get :show, params: { id: @object.uuid }

        returning_data = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(returning_data['uuid']).to eq(@object.uuid)
      end
    end

    describe 'invalid: ' do
      it "should not get a non existent #{model_name}" do
        get :show, params: { id: '8675309' }
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST #create' do
    describe 'valid: ' do
      it "should be able to create a valid #{model_name}" do
        params = {
            "#{model_name.parameterize.underscore.to_sym}": {
                title: SecureRandom.uuid,
                content: SecureRandom.uuid,
                user_id: @user.id
            }
        }

        post :create, params: params
        expect(response).to have_http_status(201)
        returning_data = JSON.parse(response.body)

        expect(returning_data['title']).to eq(params[:article][:title])
      end
    end

    describe 'invalid: ' do
      it "should not be able to create an invalid #{model_name}" do
        params = {
            "#{model_name.parameterize.underscore.to_sym}": {
                title: '',
                content: '',
                user_id: ''
            }
        }

        post :create, params: params
        expect(response).to have_http_status(400)
        returning_data = JSON.parse(response.body)
        expect(returning_data['title'][0]).to eq("can't be blank")
      end
    end
  end

  describe 'PUT #update' do
    describe 'valid: ' do
      it "'should be able to change the #{model_name}'s data via ID'" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)
        params = {
            id: @object.id,
            "#{model_name.parameterize.underscore.to_sym}": {
                title: SecureRandom.uuid,
                content: SecureRandom.uuid,
                user_id: @user.id
            }
        }

        put :update, params: params
        expect(response).to have_http_status(200)
        returning_data = JSON.parse(response.body)

        expect(returning_data['uuid']).to eq(@object.uuid)
        expect(returning_data['title']).to eq(params[:article][:title])
      end

      it "'should be able to change the #{model_name}'s data via UUID'" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)
        params = {
            id: @object.uuid,
            "#{model_name.parameterize.underscore.to_sym}": {
                title: SecureRandom.uuid,
                content: SecureRandom.uuid,
                user_id: @user.id
            }
        }

        put :update, params: params
        expect(response).to have_http_status(200)
        returning_data = JSON.parse(response.body)

        expect(returning_data['uuid']).to eq(@object.uuid)
        expect(returning_data['title']).to eq(params[:article][:title])
      end
    end

    describe 'invalid: ' do
      it "'should not be able to change the #{model_name}'s data with bad data'" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)
        params = {
            id: @object.id,
            "#{model_name.parameterize.underscore.to_sym}": {
                title: '',
                content: '',
                user_id: ''
            }
        }

        post :update, params: params
        expect(response).to have_http_status(400)
        returning_data = JSON.parse(response.body)
        expect(returning_data['title'][0]).to eq("can't be blank")
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'valid: ' do
      it "should be able to delete an #{model_name} via ID" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)

        post :destroy, params: { id: @object.id }
        expect(response).to have_http_status(204)
      end

      it "should be able to delete an #{model_name} via UUID" do
        @object = FactoryBot.create(model_name.to_s.underscore.downcase.to_sym)

        post :destroy, params: { id: @object.uuid }
        expect(response).to have_http_status(204)
      end
    end
  end
end
