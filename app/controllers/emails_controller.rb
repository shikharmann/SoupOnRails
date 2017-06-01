class EmailsController < ApplicationController

  def activate
    Email.find_by_address(params[:email]).update(activated: true)
  end

  def update
    if secured_webhook?
      email = Email.find_by_address(params[:recipient])
      render status: email.update_email(email_params, log_data) ? 200 : 406, json: {status: 200}
    else
      render status: 406, json: {status: 406}
    end
  end

  private

  def secured_webhook?
    digest = OpenSSL::Digest::SHA256.new
    data = [params[:timestamp], params[:token]].join
    params[:signature] == OpenSSL::HMAC.hexdigest(digest, ENV['MAILGUN_API'], data)
  end

  def resend?
    !%w(clicked unsubscribed complained bounced).include?(params[:event])
  end

  def email_params
    params.merge(email: {resend: resend?}).require(:email).permit(:resend)
  end

  def log_data
    {email: params[:recipient], ip: params[:id], subject: params[:tag], type: params[:event]}
  end

end
