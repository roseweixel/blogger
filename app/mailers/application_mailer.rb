class ApplicationMailer < ActionMailer::Base
  default from: "admin@flatironblogs.com"
  layout 'mailer'
end
