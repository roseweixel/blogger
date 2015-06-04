class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@flatironblogger.com"
  layout 'mailer'
end
