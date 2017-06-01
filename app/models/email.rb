class Email < ApplicationRecord

  # Associations
  belongs_to :user

  # Validations
  validates_uniqueness_of :address
  validates_presence_of :address
  validates_format_of :address, with: /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  def update_email(email_params, log_data)
    assign_attributes(email_params)
    if valid? && save
      log_changes(log_data)
      true
    else
      false
    end
  end

  private

  def log_changes(log_data)
    logs = Logging::MailgunWebhook.new
    logs.log(log_data)
    logs.close
  end

end
