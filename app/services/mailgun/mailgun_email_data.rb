module Mailgun
  class MailgunEmailData

    def self.get_message(type, name, email)
      messages.values_at(type.to_sym).first.gsub('_name', name).gsub('_email', email)
    end

    def self.get_subject(type)
      subjects.values_at(type.to_sym).first
    end

    private

    def self.subjects
      {
          'Activation': 'Activate your account',
          'ActivationReminder': 'Waiting to hear from you'
      }
    end

    def self.messages
      {
          'Activation': "Welcome _name, please activate your account by clicking " + ENV['DOMAIN'] + "?email=_email.",
          'ActivationReminder': "_name, We still haven't seen your account activated."
      }
    end

  end
end