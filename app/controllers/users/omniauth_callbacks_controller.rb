module Users
  class OmniauthCallbacksController < DeviseTokenAuth::OmniauthCallbacksController
    include Devise::Controllers::Rememberable

    def omniauth_success
      super do |resource|
        remember_me resource
        sign_in_and_redirect resource and return
      end
    end

    protected

    def get_resource_from_auth_hash
      @resource = resource_class.where(email: auth_hash['info']['email']).first
      @resource
    end
  end
end
