class CreateEmails < ActiveRecord::Migration[5.0]
  def change
    create_table :emails do |t|
      # Email address of the email
      t.string :address, null: false, index: true
      # Foreign key to users
      t.belongs_to :user, index: true
      # Activated true if user has verified the email
      t.boolean :activated, default: false, null: false, index: true
      # Resend true if
      # user has not clicked the email and
      # email has not bounced and
      # email has not unsubscribed and
      # email has not complained and
      # resend mail has not been sent
      t.boolean :resend, default: true, null: false, index: true
      t.timestamps
    end
  end
end
