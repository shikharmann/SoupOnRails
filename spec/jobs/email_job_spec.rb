require 'rails_helper'

RSpec.describe EmailJob, type: :worker do

    describe "#perform" do
        let(:user) { User.create(name:'my_user') }
        let(:email) { Email.create(address:'my_user@example.com', user_id: user.id) }

        it 'finds the user and calls mailgun message service' do
            expect(User).to receive(:find).with(user.id).and_return(user)
            message_service = Mailgun::MailgunMessageService.new(user)
            expect(Mailgun::MailgunMessageService).to receive(:new).with(user).and_return(message_service)
            expect(message_service).to receive(:send_email).with('mail_type')
            EmailJob.new.perform(user.id, 'mail_type')
        end
    end
end
