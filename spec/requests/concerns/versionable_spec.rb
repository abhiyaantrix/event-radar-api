# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Versionable, type: :request do
  before(:all) do
    module API
      module V1
        class VersionableTestController < ApplicationController

          include Versionable

          def index = render json: { message: "API version is #{api_version.version}" }

        end
      end
    end

    Rails.application.routes.draw do
      namespace :api do
        get 'v2/versionable_test', action: :index, controller: 'v1/versionable_test'

        namespace :v1 do
          get '/versionable_test', to: 'versionable_test#index'
        end
      end
    end
  end

  after(:all) do
    Rails.application.reload_routes!

    API::V1.send(:remove_const, :VersionableTestController)
  end

  context 'when valid version' do
    it 'returns success' do
      get '/api/v1/versionable_test'

      expect(response).to have_http_status(:success)
      expect(json_symbolize[:message]).to eq("API version is v1")
    end
  end

  context 'when invalid version' do
    it 'returns API version mismatch error' do
      expect {
        get '/api/v2/versionable_test'
      }.to raise_error(Versionable::APIVersionMismatchError)
    end
  end
end
