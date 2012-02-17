class Round < ActiveRecord::Base
  has_one :security
  has_many :people, :through => :related_people
  belongs_to :company
  after_create :parse_round_from_filing!, :notify_subscribers!

  def parse_round_from_filing!
    filing = Nokogiri::XML(open(full_url))
    fill_round(filing)
    self.company.update_data(filing.at_xpath("/edgarSubmission/primaryIssuer"))
    RelatedPerson.create_from_filing(filing.xpath('/edgarSubmission/relatedPersonsList/relatedPersonInfo'), self.id)
    Security.create_from_filing(filing.at_xpath('/edgarSubmission/offeringData/typesOfSecuritiesOffered'), self.id)
  end

  def notify_subscribers!
    EmailUpdate.notify_new_round(self)
  end


  def base_url
    'http://www.sec.gov/Archives/'
  end

  def full_url
    base_url + self.filing_url    
  end

  def human_readable_url
    full_url[0..full_url.index('primary_doc.xml') - 1] + 'xslFormDX01/primary_doc.xml'
  end

  def fill_round(filing)
    self.use_of_funds        = filing.at_xpath('/edgarSubmission/offeringData/useOfProceeds/clarificationOfResponse').child.to_s unless filing.at_xpath('/edgarSubmission/offeringData/useOfProceeds/clarificationOfResponse').nil?
    self.revenue_range       = filing.at_xpath('/edgarSubmission/offeringData/issuerSize/revenueRange').child.to_s unless filing.at_xpath('/edgarSubmission/offeringData/issuerSize/revenueRange').nil?
    self.kind                = filing.at_xpath('/edgarSubmission/submissionType').child.to_s
    self.first_investment    = get_first_investment(filing)
    self.end_date            = Date.parse(filing.at_xpath('/edgarSubmission/offeringData/signatureBlock/signature/signatureDate').child.to_s)
    self.raised              = filing.at_xpath('/edgarSubmission/offeringData/offeringSalesAmounts/totalAmountSold').child.to_s.to_i
    self.tried_to_raise      = filing.at_xpath('/edgarSubmission/offeringData/offeringSalesAmounts/totalOfferingAmount').child.to_s.to_i
    self.investor_count      = filing.at_xpath('/edgarSubmission/offeringData/investors/totalNumberAlreadyInvested').child.to_s.to_i
    self.minimum_invested    = filing.at_xpath('/edgarSubmission/offeringData/minimumInvestmentAccepted').child.to_s.to_i
    # TODO: Check for merger and acquisition
    p "Filled Round of ID: #{self.id}"
    self.save
  end

  def get_first_investment(filing)
    if filing.at_xpath('/edgarSubmission/offeringData/typeOfFiling/dateOfFirstSale/value')
      Date.parse(filing.at_xpath('/edgarSubmission/offeringData/typeOfFiling/dateOfFirstSale/value').child.to_s)
    else
      nil
    end
  end

  def average_raised
    '0' unless self.raised
    self.raised / self.investor_count unless self.raised == 0
  end

  validates_presence_of :filing_url, :accession
end
