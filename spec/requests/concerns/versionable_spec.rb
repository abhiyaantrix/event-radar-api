# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "API Versionable Concern", type: :request do
  before(:all) do
    module API
      module V1
        class TestVersionableController < ApplicationController

          include Versionable

          def index = render json: { message: "API version is #{api_version.version}" }

        end
      end
    end

    Rails.application.routes.draw do
      namespace :api do
        get 'v2/test_versionable', action: :index, controller: 'v1/test_versionable'

        namespace :v1 do
          get '/test_versionable', to: 'test_versionable#index'
        end
      end
    end
  end

  after(:all) do
    Rails.application.reload_routes!
  end

  context 'when valid version' do
    it 'returns success' do
      get '/api/v1/test_versionable'

      expect(response).to have_http_status(:success)
      expect(json_symbolize[:message]).to eq("API version is v1")
    end
  end

  context 'when invalid version' do
    it 'returns API version mismatch error' do
      expect {
        get '/api/v2/test_versionable'
      }.to raise_error(Versionable::APIVersionMismatchError)
    end
  end
end
