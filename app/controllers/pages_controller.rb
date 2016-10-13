class PagesController < ApplicationController
  
  def contact
  end

  def term
  end

  def about
  end

  def contact_submission
    contact = {
      firstname: params[:firstname],
      lastname: params[:lastname],
      email: params[:email],
      phone: params[:phone],
      message: params[:message]
    }
    UserMailer.contact_submission(contact).deliver
    render json: { 
      :success => true
    }
  end
  
end
