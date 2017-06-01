class User < ApplicationRecord

  # Each user shall have one email
  has_one :email, dependent: :destroy

  # Email is created while creating user
  accepts_nested_attributes_for :email

  # Validations
  validates_presence_of :name

  # Callback
  after_create :send_activation_email, :schedule_reminder_email

  # Scope
  scope :by_activated, ->(activated) { joins(:email).where('emails.activated=?', activated) }
  scope :name_like, ->(name) { where('lower(name)~?', name.downcase) }
  scope :where_by_email, ->(email) { joins(:email).where('emails.address=?', email) }

  # Ransacker
  ransacker :email_activated,
            formatter: proc { |activated|
              results = User.by_activated(activated).map(&:id)
              results = results.present? ? results : nil
            }, splat_params: true do |parent|
    parent.table[:id]
  end

  ransacker :name,
            formatter: proc { |name|
              results = User.name_like(name).map(&:id)
              results = results.present? ? results : nil
            }, splat_params: true do |parent|
    parent.table[:id]
  end

  private

  def send_activation_email
    EmailJob.perform_async(id, 'Activation')
  end

  def schedule_reminder_email
    EmailJob.perform_at(2.days.from_now, id, 'ActivationReminder')
  end

end