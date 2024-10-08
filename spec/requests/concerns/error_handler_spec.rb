# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorHandler, type: :request do
  before(:all) do
    module API
      module V1
        class ErrorHandlerTestController < ApplicationController

          include ErrorHandler

          def index = render json: { message: 'Dummy action' }

        end
      end
    end

    Rails.application.routes.draw do
      namespace :api do
        namespace :v1 do
          resources :error_handler_test, only: [ :index ]
        end
      end
    end
  end

  after(:all) do
    Rails.application.reload_routes!

    API::V1.send(:remove_const, :ErrorHandlerTestController)
  end

  describe 'Error handlers' do
    shared_examples 'error handler' do |error_class, status, message_key|
      before do
        allow_any_instance_of(API::V1::ErrorHandlerTestController).to receive(:index).and_raise(error_class)

        get '/api/v1/error_handler_test'
      end

      it "handles #{error_class} correctly" do
        expect(response).to have_http_status(status)

        error_json = json_symbolize[:error]
        expect(error_json[:code]).to eq(Rack::Utils::SYMBOL_TO_STATUS_CODE.fetch(status))
        expect(error_json[:message]).to eq(I18n.t(message_key))
        expect(error_json[:key]).to eq(status.to_s)
      end
    end

    it_behaves_like 'error handler', StandardError, :internal_server_error,
      'api.v1.response.errors.standard_error'
    it_behaves_like 'error handler', RuntimeError, :internal_server_error,
      'api.v1.response.errors.runtime_error'

    it_behaves_like 'error handler', ActiveRecord::RecordNotFound, :not_found, 'api.v1.response.errors.record_not_found'
    it_behaves_like 'error handler', ActiveRecord::RecordNotSaved, :unprocessable_content,
      'api.v1.response.errors.record_not_saved'
    it_behaves_like 'error handler', ActiveRecord::RecordInvalid, :bad_request, 'api.v1.response.errors.record_invalid'
    it_behaves_like 'error handler', ActionController::ParameterMissing.new(:param_name), :bad_request,
      'api.v1.response.errors.parameter_missing'
    it_behaves_like 'error handler', ActionController::BadRequest, :bad_request, 'api.v1.response.errors.bad_request'
  end
end
