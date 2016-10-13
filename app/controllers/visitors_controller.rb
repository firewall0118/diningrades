class VisitorsController < ApplicationController

  def index
  end

  def generate_new_password_email
    user = User.find_for_authentication(email: params[:email])
    sent = false
    if user
      user.send_reset_password_instructions
      sent = true
    end
    render json: { 
      :success => sent
    }
  end
end
