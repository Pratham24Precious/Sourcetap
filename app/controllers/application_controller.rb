class ApplicationController < ActionController::API
  require 'json_web_token'

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from JWT::DecodeError, with: :unauthorized

  def not_found
    render json: { error: 'not_found' }, status: :not_found
  end

  def unauthorized
    render json: { error: 'unauthorized' }, status: :unauthorized
  end

  def generate_token_and_render_response(user, role)
    token = JsonWebToken.encode(user_id: user.id, role: role)
    time = Time.now + 24.hours.to_i
    render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), user_id: user.id, role: role }, status: :created
  end

  def authenticate_user(email, password, role)
    user = role.constantize.find_by(email: email)
    return user if user&.authenticate(password)

    nil
  end

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    token = token.gsub(/^"|"$/, '') if token
    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = authenticate_user_by_role(@decoded[:user_id], @decoded[:role])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private

  def authenticate_user_by_role(user_id, role)
    role.constantize.find(user_id)
  end
end
