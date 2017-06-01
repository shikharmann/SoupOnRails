require 'rails_helper'

RSpec.describe Email, type: :model do

    describe 'validations' do
        it 'should have address' do
            email = Email.new()
            expect(email.valid?).to be(false)
            expect(email.errors.full_messages).to eq(["Address can't be blank", 'Address is invalid'])
        end
        it 'should fail on invalid email address' do
            email = Email.new(address:'wrongemailformat')
            expect(email.valid?).to be(false)
            expect(email.errors.full_messages).to eq(['Address is invalid'])
        end
        it 'should have unique email addresses' do
            Email.create(address:'myemail@example.com')
            duplicate_email = Email.new(address:'myemail@example.com')
            expect(duplicate_email.valid?).to be(false)
            expect(duplicate_email.errors.full_messages).to eq(['Address has already been taken'])
        end
    end

    describe 'update_email and log changes' do
        let(:email) { Email.create(address: 'myemail@example.com',user_id: 1) }
        it 'should call mail logging when update is successful' do
            email_params = {resend: false}
            log_data = "test data"
            log_service = Logging::MailgunWebhook.new
            expect(Logging::MailgunWebhook).to receive(:new).and_return(log_service)
            expect(log_service).to receive(:log).with(log_data)
            expect(log_service).to receive(:close)
            response = email.update_email(email_params,log_data)
            expect(response).to be(true)
        end
        it 'should not call mail logging when update fails with wrong params' do
            email_params = {address: 'bad_address', resend: false}
            log_data = "test data"
            expect(Logging::MailgunWebhook).to_not receive(:new)
            response = email.update_email(email_params,log_data)
            expect(response).to be(false)
        end
    end
end