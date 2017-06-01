require 'rails_helper'

RSpec.describe Mailgun::MailgunSuppressionService, type: :service do

    describe 'suppressed?' do
        let(:email) { Email.create(address:'my_user@example.com') }
        let(:mailgun_service) { Mailgun::MailgunSuppressionService.new(email) }
        it 'should return true when email is in bounce list' do
            response = double('response')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:bounced_url)).and_return(response)
            expect(response).to receive(:message).and_return('Found')
            expect(mailgun_service.suppressed?).to eq(true)
        end
        it 'should return true when email is in complained list' do
            bounce_response = double('bounce_response')
            complained_response = double('complained_response')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:bounced_url)).and_return(bounce_response)
            expect(bounce_response).to receive(:message).and_return('Not Found')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:complained_url)).and_return(complained_response)
            expect(complained_response).to receive(:message).and_return('Found')
            expect(mailgun_service.suppressed?).to eq(true)
        end
        it 'should return true when email is in unsubscribed list' do
            bounce_response = double('bounce_response')
            complained_response = double('complained_response')
            unsubscribed_response = double('unsubscribed_response')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:bounced_url)).and_return(bounce_response)
            expect(bounce_response).to receive(:message).and_return('Not Found')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:complained_url)).and_return(complained_response)
            expect(complained_response).to receive(:message).and_return('Not Found')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:unsubscribed_url)).and_return(unsubscribed_response)
            expect(unsubscribed_response).to receive(:message).and_return('Found')
            expect(mailgun_service.suppressed?).to eq(true)
        end
        it 'should return false when email is not in any suppression list' do
            bounce_response = double('bounce_response')
            complained_response = double('complained_response')
            unsubscribed_response = double('unsubscribed_response')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:bounced_url)).and_return(bounce_response)
            expect(bounce_response).to receive(:message).and_return('Not Found')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:complained_url)).and_return(complained_response)
            expect(complained_response).to receive(:message).and_return('Not Found')
            expect(HTTParty).to receive(:get).with(mailgun_service.send(:unsubscribed_url)).and_return(unsubscribed_response)
            expect(unsubscribed_response).to receive(:message).and_return('Not Found')
            expect(mailgun_service.suppressed?).to eq(false)
        end
    end
end