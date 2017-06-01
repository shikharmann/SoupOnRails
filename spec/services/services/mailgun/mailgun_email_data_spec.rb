require 'rails_helper'

RSpec.describe Mailgun::MailgunEmailData, type: :service do

    describe 'get message' do
        it 'should fetch message template for application email' do
            expect(Mailgun::MailgunEmailData.get_message('Activation','username','username@example.com')).to eq('Welcome username, please activate your account by clicking ' + ENV['DOMAIN'] + '?email=username@example.com.')
        end
        it 'should fetch message template for application reminder email' do
            expect(Mailgun::MailgunEmailData.get_message('ActivationReminder','username','username@example.com')).to eq("username, We still haven't seen your account activated.")
        end
    end

    describe 'get subject' do
        it 'should fetch subject for application email' do
            expect(Mailgun::MailgunEmailData.get_subject('Activation')).to eq('Activate your account')
        end
        it 'should fetch subject for application reminder email' do
            expect(Mailgun::MailgunEmailData.get_subject('ActivationReminder')).to eq('Waiting to hear from you')
        end
    end
end