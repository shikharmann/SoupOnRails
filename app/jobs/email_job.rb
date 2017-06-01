class EmailJob

  include Sidekiq::Worker

  sidekiq_options queue: :default

  def perform(id, mail_type)
    user = User.find(id)
    Mailgun::MailgunMessageService.new(user).send_email(mail_type)
  end

end
