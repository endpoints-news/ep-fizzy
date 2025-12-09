class SessionsController < ApplicationController
  disallow_account_scope
  require_unauthenticated_access except: :destroy
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  layout "public"

  def new
  end

  def create
    # Check domain first before doing anything
    unless DomainRestricted.allowed?(email_address)
      redirect_to new_session_path, alert: DomainRestricted.error_message
      return
    end

    if identity = Identity.find_by_email_address(email_address)
      redirect_to_session_magic_link identity.send_magic_link
    else
      signup = Signup.new(email_address: email_address)
      if signup.valid?(:identity_creation)
        begin
          redirect_to_session_magic_link signup.create_identity
        rescue ActiveRecord::RecordInvalid
          redirect_to new_session_path, alert: DomainRestricted.error_message
        end
      else
        redirect_to new_session_path, alert: "Please enter a valid email address."
      end
    end
  end

  def destroy
    terminate_session
    redirect_to_logout_url
  end

  private
    def email_address
      params.expect(:email_address)
    end
end
