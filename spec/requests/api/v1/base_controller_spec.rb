# frozen_string_literal: true

require 'rails_helper'

RSpec.describe API::V1::BaseController, type: :request do
  before do
    Rails.application.routes.draw do
      namespace :api do
        namespace :v1 do
          resources :base, only: [ :index ]
        end
      end
    end

    API::V1::BaseController.class_eval do
      def index
        render json: { message: 'Dummy action' }
      end
    end
  end

  after { Rails.application.reload_routes! }

  describe 'Request format' do
    context 'when JSON' do
      before do
        headers = { 'Accept' => Mime[:json].to_s }

        get '/api/v1/base', headers: headers
      end

      it 'allows request and responds with JSON' do
        expect(response).to have_http_status(:ok)
        expect(json_symbolize[:message]).to eq('Dummy action')
      end
    end

    context 'when non-JSON' do
      before do
        headers = { 'Accept' => Mime[:html].to_s }

        get '/api/v1/base', headers: headers
      end

      it 'responds with HTTP 406 - Not Acceptable' do
        expect(response).to have_http_status(:not_acceptable)
        expect(json_symbolize[:error][:message]).to eq(I18n.t('api.v1.errors.request.format.only_json_accepted'))
      end
    end
  end

  describe 'Error handlers' do
    shared_examples 'error handler' do |error_class, status, message_key|
      before do
        headers = { 'Accept' => Mime[:json].to_s }

        allow_any_instance_of(API::V1::BaseController).to receive(:index).and_raise(error_class)

        get '/api/v1/base', headers: headers
      end

      it "handles #{error_class} correctly" do
        expect(response).to have_http_status(status)

        error_json = json_symbolize[:error]
        expect(error_json[:code]).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE[status])
        expect(error_json[:message]).to eq(I18n.t(message_key))
        expect(error_json[:status]).to eq(status.to_s)
      end
    end

    it_behaves_like 'error handler', StandardError, :internal_server_error,
      'api.v1.errors.response.internal_server_error'
    it_behaves_like 'error handler', RuntimeError, :internal_server_error,
      'api.v1.errors.response.internal_server_error'
    it_behaves_like 'error handler', ActiveRecord::RecordNotFound, :not_found, 'api.v1.errors.response.record_not_found'
    it_behaves_like 'error handler', ActiveRecord::RecordNotSaved, :unprocessable_content,
      'api.v1.errors.response.unprocessable_content'
    it_behaves_like 'error handler', ActiveRecord::RecordInvalid, :bad_request, 'api.v1.errors.response.bad_request'
    it_behaves_like 'error handler', ActionController::ParameterMissing.new(:param_name), :bad_request,
      'api.v1.errors.response.bad_request'
  end
end
