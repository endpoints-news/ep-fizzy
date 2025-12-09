class SignupsController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_signup_path, alert: "Try again later." }
  before_action :redirect_authenticated_user

  layout "public"

  def new
    @signup = Signup.new
  end

  def create
    @signup = Signup.new(signup_params)
    if @signup.valid?(:identity_creation)
      begin
        redirect_to_session_magic_link @signup.create_identity
      rescue ActiveRecord::RecordInvalid
        flash.now[:alert] = DomainRestricted.error_message
        render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = @signup.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  private
    def redirect_authenticated_user
      redirect_to new_signup_completion_path if authenticated?
    end

    def signup_params
      params.expect signup: :email_address
    end
end
