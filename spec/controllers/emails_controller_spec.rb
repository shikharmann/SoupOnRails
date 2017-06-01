require 'rails_helper'

RSpec.describe EmailsController, type: :controller do

    describe 'GET activate' do
        let(:email) { Email.create(address:"email@example.com")}
        it 'activates the email' do
            expect(email.activated).to eq(false)
            get :activate, email: "email@example.com"
            expect(response.code).to eq("200")
            expect(email.reload.activated).to eq(true)
        end
    end

    describe 'GET update' do
        let(:email) { Email.create(address:"email@example.com")}
        it 'should return fail and not update anything without secure webhook' do
            allow_any_instance_of(EmailsController).to receive(:secured_webhook?).and_return(false)
            post :update, recipient: "email@example.com", event: 'bounced', id: '123', tag: 'subject'
            expect(response.code).to eq("406")
        end
        it 'should return fail when webhook is secure but email update fails' do
            allow_any_instance_of(EmailsController).to receive(:secured_webhook?).and_return(true)
            expect(Email).to receive(:find_by_address).and_return(email)
            expect(email).to receive(:update_email).and_return(false)
            post :update, recipient: "email@example.com", event: 'bounced', id: '123', tag: 'subject'
            expect(response.code).to eq("406")
        end
        it 'should return success when webhook is secure and email update succeeds' do
            allow_any_instance_of(EmailsController).to receive(:secured_webhook?).and_return(true)
            expect(Email).to receive(:find_by_address).and_return(email)
            expect(email).to receive(:update_email).and_return(true)
            post :update, recipient: "email@example.com", event: 'bounced', id: '123', tag: 'subject'
            expect(response.code).to eq("200")
        end
    end

end