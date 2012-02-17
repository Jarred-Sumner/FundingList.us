class Security < ActiveRecord::Base
  belongs_to :round

  def self.create_from_filing(types_of_securities_offered, round_id)
    security          = Security.new
    security.debt     = true if types_of_securities_offered.at_xpath('isDebtType')
    security.acquired = true if types_of_securities_offered.at_xpath('isSecurityToBeAcquiredType')
    security.equity   = true if types_of_securities_offered.at_xpath('isEquityType')
    security.round_id = round_id
    p "Added Security to Round of ID: #{round_id}"
    security.save
  end

  def took
    results = []
    results.push('Equity')  if self.equity?
    results.push('Options') if self.option?
    results.push('Debt')    if self.debt?
    results
  end
end
