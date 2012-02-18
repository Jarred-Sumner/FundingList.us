class EmailUpdate < ActiveRecord::Base
  belongs_to :company
  after_create :notify_of_updates
  
  def self.notify_new_round(round)
    @emails = EmailUpdate.where(:company_id => round.company_id)
    @emails.each { |recepient| CompaniesMailer.update(round, email).deliver }
  end

  def notify_of_updates
    CompaniesMailer.keeping_you_updated(self.email, self.company.name).deliver
  end

end
