# frozen_string_literal: true

class API::V1::UsersController < API::V1::BaseController

  def index
    users = User.all

    render json: API::V1::UserSerializer.new(users).serialize
  end

end
