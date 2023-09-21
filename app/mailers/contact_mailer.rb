class ContactMailer < ApplicationMailer
  def send_when_owner_announce(user, group, notice)
    @user = user
    @group = group
    @notice = notice
    mail to: user.email, subject: '【Bookers2】 メッセージが届きました'
  end
end
