require 'rails_helper'

RSpec.describe Logging::MailgunWebhook, type: :service do

    describe 'webhook logging' do
        let (:data_to_record) { {:ip => '123', :email => 'my_email@example.com', :subject => 'subject', :type => 'type'} }
        it 'should create file and log data if file does not exist' do
            expect(File).to receive(:exists?).and_return(false)
            log_file = double('log_file')
            expect(File).to receive(:new).and_return(log_file)
            expect(log_file).to receive(:puts).with(('Email, IP, Subject, Type'))
            expect(log_file).to receive(:puts).with('my_email@example.com, 123, subject, type')
            Logging::MailgunWebhook.new.log(data_to_record)
        end
        it 'should use existing file and log data in it' do
            expect(File).to receive(:exists?).and_return(true)
            log_file = double('log_file')
            expect(File).to receive(:open).and_return(log_file)
            expect(log_file).to receive(:puts).with('my_email@example.com, 123, subject, type')
            Logging::MailgunWebhook.new.log(data_to_record)
        end
    end
end