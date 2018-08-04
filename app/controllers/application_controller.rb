class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  include Response
  include ExceptionHandler

  # include DeviseTokenAuth::Concerns::SetUserByToken
end
