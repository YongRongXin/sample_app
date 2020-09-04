class UserMailer < ApplicationMailer
  def account_activation
    @user = user
    mail to: user.email, subject: t "mailers.user.acc_activation"
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t "mailers.user.password_reset"
  end
end
