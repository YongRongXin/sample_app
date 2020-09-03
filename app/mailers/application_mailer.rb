class ApplicationMailer < ActionMailer::Base
  default from: ENV["USER_EMAIL"]
  layout "mailer"
end
