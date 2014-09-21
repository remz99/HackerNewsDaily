class BaseMailer < ActionMailer::Base
  default from: configatron.emails.from, to: configatron.emails.to
end
