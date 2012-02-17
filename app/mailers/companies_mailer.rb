class CompaniesMailer < ActionMailer::Base
  default from: "updates@fundinglist.us"

  def update(round, recepient)
    @recepient = recepient
    @round = round
    mail to: recepient.email, :subject => "#{@round.company.name} is raising more money | FundingList.us "
  end

  def keeping_you_updated(email, name)
    @name  = name
    @email = email
    mail :to => email, :subject => "Keeping you updated on #{name}'s funding | FundingList.us"
  end
end
