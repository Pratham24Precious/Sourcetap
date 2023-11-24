module Api
  module V1
    module Admin
      class AdminLoginController < ApplicationController
        before_action :authorize_request, except: [:login, :signup]

        def login
          admin_user = authenticate_user(params[:email], params[:password], 'AdminUser')

          if admin_user
            generate_token_and_render_response(admin_user, 'AdminUser')
          else
            render json: { error: 'unauthorized' }, status: :unauthorized
          end
        end

        def signup
          admin_user = AdminUser.new(admin_user_params)

          if admin_user.save
            generate_token_and_render_response(admin_user, 'AdminUser')
          else
            render json: { errors: admin_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def admin_user_params
          params.permit(:name, :email, :password)
        end
      end
    end
  end
end
