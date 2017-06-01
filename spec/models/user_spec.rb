require 'rails_helper'

RSpec.describe User, type: :model do

    describe 'validations' do
        it 'should have name' do
            user = User.new
            expect(user.valid?).to be(false)
            expect(user.errors.full_messages).to eq(["Name can't be blank"])
        end
    end

    describe 'send_activation_email' do
        # User.skip_callback(:after_create)
        let(:user) { User.new(id: 1, name: 'myuser') }
        it 'should create activation email job' do
            expect(EmailJob).to receive(:perform_async).with(user.id, 'Activation')
            user.send(:send_activation_email)
        end
    end

    describe 'schedule_reminder_email' do
        # User.skip_callback(:after_create)
        let(:user) { User.new(id: 1, name: 'myuser') }
        it 'should create activation reminder email job' do
            expect(EmailJob).to receive(:perform_at)
            user.send(:schedule_reminder_email)
        end
    end

    describe 'after create callbacks' do
        it 'should create email jobs with callbacks' do
            expect(EmailJob).to receive(:perform_async)
            expect(EmailJob).to receive(:perform_at)
            User.create(name: 'myuser')
        end
    end
end