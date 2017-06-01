require 'rails_helper'

RSpec.describe Mailgun::MailgunMessageService, type: :service do

    describe 'send_email' do
        let(:user) { User.create(name:'my_user') }
        let(:email) { Email.create(address:'my_user@example.com', user_id: user.id) }

        it 'should send email when sending first activation email' do
            expect(user).to receive(:email).and_return(email)
            expect(HTTParty).to receive(:post)
            Mailgun::MailgunMessageService.new(user).send_email('Activation')
        end
        it 'should not send email when email resend was updated to false' do
            expect(user).to receive(:email).and_return(email)
            expect(email).to receive(:resend).and_return(false)
            expect(HTTParty).to_not receive(:post)
            Mailgun::MailgunMessageService.new(user).send_email('ActivationReminder')
        end
        it 'should not send email when email activated was updated to true' do
            expect(user).to receive(:email).and_return(email)
            expect(email).to receive(:resend).and_return(true)
            expect(email).to receive(:activated).and_return(true)
            expect(HTTParty).to_not receive(:post)
            Mailgun::MailgunMessageService.new(user).send_email('ActivationReminder')
        end
        it 'should not send email when email is in suppression list' do
            expect(user).to receive(:email).and_return(email)
            expect(email).to receive(:resend).and_return(true)
            expect(email).to receive(:activated).and_return(false)
            suppression_service = Mailgun::MailgunSuppressionService.new(@email)
            expect(Mailgun::MailgunSuppressionService).to receive(:new).with(email).and_return(suppression_service)
            expect(suppression_service).to receive(:suppressed?).and_return(true)
            expect(HTTParty).to_not receive(:post)            
            Mailgun::MailgunMessageService.new(user).send_email('ActivationReminder')
        end
        it 'should not send email when email is in suppression list' do
            expect(user).to receive(:email).and_return(email)
            expect(email).to receive(:resend).and_return(true)
            expect(email).to receive(:activated).and_return(false)
            suppression_service = Mailgun::MailgunSuppressionService.new(@email)
            expect(Mailgun::MailgunSuppressionService).to receive(:new).with(email).and_return(suppression_service)
            expect(suppression_service).to receive(:suppressed?).and_return(false)
            expect(HTTParty).to receive(:post)
            Mailgun::MailgunMessageService.new(user).send_email('ActivationReminder')
        end
    end
end