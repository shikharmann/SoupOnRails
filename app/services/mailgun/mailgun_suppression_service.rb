module Mailgun
  class MailgunSuppressionService

    def initialize(email)
      @email = email
    end

    def suppressed?
      bounced? || complained? || unsubscribed?
    end

    private

    def bounced?
      HTTParty.get(bounced_url).message != 'Not Found'
    end

    def complained?
      HTTParty.get(complained_url).message != 'Not Found'
    end

    def unsubscribed?
      HTTParty.get(unsubscribed_url).message != 'Not Found'
    end

    def base_url
      'https://api:' + ENV['MAILGUN_API'] +  '@' +  ENV['MAILGUN_BASE_URL']
    end

    def bounced_url
      base_url + 'bounces/' + @email.address
    end

    def complained_url
      base_url + 'complaints/' + @email.address
    end

    def unsubscribed_url
      base_url + 'unsubscribes/' + @email.address
    end

  end
end