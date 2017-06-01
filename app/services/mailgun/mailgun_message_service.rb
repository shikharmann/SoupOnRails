module Mailgun
  class MailgunMessageService

    def initialize(user)
      @email = user.email
      @name = user.name
    end

    def send_email(mail_type)
      @subject = MailgunEmailData.get_subject(mail_type)
      @message = MailgunEmailData.get_message(mail_type, @name, @email.address)
      send_email?(mail_type) ? HTTParty.post(url, query: query) : nil
    end

    # private

    def send_email?(mail_type)
      (mail_type != 'ActivationReminder') || ((mail_type == 'ActivationReminder') && @email.resend && !@email.activated && !MailgunSuppressionService.new(@email).suppressed?)
    end

    def url
      'https://api:' + ENV['MAILGUN_API'] +  '@' +  ENV['MAILGUN_BASE_URL'] + 'messages'
    end

    def query
      {

          'from' => ENV['MAILGUN_FROM'],
          'to' => @email.address,
          'subject' => @subject,
          'text' => @message,
          'o:tag' => @subject

      }
    end

  end
end
