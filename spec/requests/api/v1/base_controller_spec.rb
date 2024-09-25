# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::BaseController, type: :request do
  before(:all) do
    API::V1::BaseController.class_eval do
      def index
        render json: { message: 'Dummy action' }
      end
    end

    Rails.application.routes.draw do
      namespace :api do
        namespace :v1 do
          resources :base, only: [ :index ]
        end
      end
    end
  end

  after(:all) { Rails.application.reload_routes! }

  describe 'Request format' do
    context 'when JSON' do
      before { get '/api/v1/base', headers: { 'Accept' => Mime[:json].to_s } }

      it 'allows request and responds with JSON' do
        expect(response).to be_successful

        expect(json_symbolize[:message]).to eq('Dummy action')
      end
    end

    context 'when non-JSON' do
      before { get '/api/v1/base', headers: { 'Accept' => Mime[:html].to_s } }

      it 'responds with HTTP 406 - Not Acceptable' do
        expect(response).to have_http_status(:not_acceptable)
        expect(json_symbolize[:error][:message]).to eq(I18n.t('api.v1.request.errors.format.only_json_accepted'))
      end
    end
  end
end
