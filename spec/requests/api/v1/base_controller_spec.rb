# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::BaseController, type: :controller do
  controller(API::V1::BaseController) do
    def index
      render json: { message: 'Dummy action' }
    end
  end

  before do
    routes.draw do
      namespace :api do
        namespace :v1 do
          resources :base, only: [ :index ]
        end
      end
    end
  end

  describe 'Request format' do
    context 'when JSON' do
      before do
        request.headers['Accept'] = Mime[:json].to_s
      end

      it 'allows request' do
        get :index

        expect(response).to have_http_status(:ok)
        expect(json_symbolize[:message]).to eq('Dummy action')
      end
    end

    context 'when non-JSON' do
      before do
        request.headers['Accept'] = Mime[:html].to_s
      end

      it 'responds with HTTP 406 - Not Acceptable' do
        get :index

        expect(response).to have_http_status(:not_acceptable)
        expect(json_symbolize[:message]).to eq(I18n.t('errors.request.format.only_json_accepted'))
      end
    end
  end
end
