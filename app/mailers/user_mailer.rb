class UserMailer < ActionMailer::Base
  default from: "DiningGrades <noreply@dininggrades.com>"
  default to: 'info@dininggrades.com'
  layout 'email'

  def contact_submission(contact)
    @contact = contact
    #mail subject: 'DiningGrades - Contact', reply_to: contact[:email]
    mail subject: 'DiningGrades - Contact'
  end

  def claim_restaurant(claim)
    @user = User.find(claim.user_id)
    @restaurant = Restaurant.find(claim.restaurant_id)
    @claim = claim
    mail subject: 'DiningGrades - Contact', to: 'admin@dininggrades.com'
  end
end
