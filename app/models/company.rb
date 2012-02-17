class Company < ActiveRecord::Base
  has_many :email_updates
  has_many :rounds, :order => 'end_date DESC'
  validates_presence_of :cik
  validates_uniqueness_of :cik

  def raised
    raised = 0
    self.rounds.each do |round|
      raised = raised + round.raised.to_i
    end
    raised.to_s
  end

  def first_round_or_incorporation_year
    date = self.incorporation_year unless self.incorporation_year.nil?
    date = self.rounds.all.first.end_date unless self.rounds.all.empty?
  end

  def investor_count
    count = 0
    self.rounds.all.each do |round|
      count = count + round.investor_count
    end
    count
  end

  def invested_average
    unless raised.to_i == 0
      raised.to_i / investor_count
    else
      '0'
    end
  end

  def related_people
    people = []
    self.rounds.each do |round|
      RelatedPerson.where(:round_id => round.id).each do |related_person|
        hash = Hash.new
        hash['title']  = "#{related_person.person.full_name} - #{related_person.title}"
        hash['id']     = related_person.person_id
        people.push(hash)
      end
    end
    people.uniq
  end

  def related_people_names

  end

  def location
    "#{self.city}, #{self.state}"
  end

  def investors_took
    took = []
    self.rounds.each do |round|
      took = took + round.security.took
    end
    took.uniq!
  end
  def self.parse_from_quarterly_filings(year, quarter, disk, relative_path)
    # This turns "edgar/data/1525885/000152588511000001/primary_doc.xml" from "D MicroAngel Fund I LLC 1525885 2011-07-15 edgar/data/1525885/0001525885-11-000001.txt"         
    # Then, it separates the CIK from the relative url: "1525885"
    # After that, it gets the filing_id from it: "000152588511000001"
    # With that filing_id, it creates a new Filing. The Filing model takes care of itself from there 
    base_url = 'ftp://ftp.sec.gov/edgar/full-index'
    file_name = 'form.idx'
    full_url = "#{base_url}/#{year}/QTR#{quarter}/#{file_name}"
    full_url = "./public/form.idx" if disk
    full_url = "./public/#{relative_path}" if relative_path
    p "Downloading file from: #{full_url}"
    open(full_url) do |listing|
      p "File Downloaded"
      company_count = 0
      round_count   = 0
      listing.each_line do |line|
        if form_d?(line)
          company_count += 1
          round_count   += 1
          filing_url = get_filing_url(line)
          cik = get_cik(filing_url)
          name = get_name(line, cik)
          accession = get_accession(filing_url, cik)
          company = find_or_create_company(name, cik, filing_url)
          p "Created/Found Company ##{company_count} with an ID of :#{company.id}"
          round = find_or_create_round(accession, filing_url, company)
          p "Created/Found Round ##{round_count} with an ID of :#{round.id}"
        end
      end
    end
  end

  def self.form_d?(line)
    # That's how it ensures it's the right kind of form
    true if line[0..2] == 'D  ' or line[0..2] == 'D/A' 
  end

  def self.get_name(line, cik)
    # Gets the name of the company by getting the index of the CIK and the first space. Then, it strips it
    end_index = line.index(cik) - 1
    start_index = line.index(' ')
    capitalize_each_word(line[start_index..end_index].strip)
  end

  def self.get_filing_url(filing)
    # Turns "edgar/data/1525885/000152588511000001/primary_doc.xml from "D MicroAngel Fund I LLC 1525885 2011-07-15 edgar/data/1525885/0001525885-11-000001.txt"         
    url_start = 'edgar/data/'
    start_index = filing.rindex(url_start)
    relative_url = filing[start_index..filing.size - 1]
    relative_url.gsub('-', '').sub('.txt', '/').strip + 'primary_doc.xml'
  end

  def self.get_cik(filing_url)
    edgar_end = 11 # It's the index of the last 'a' in 'edgar/data'
    filing_url = filing_url[edgar_end..filing_url.size]
    middle_slash = filing_url.index('/') - 1
    filing_url[0..middle_slash] # It ends with a /, so gotta remove that
  end

  def self.get_accession(filing_url, cik)
    prefix_end = 12 # edgar/data/
    start_index = prefix_end + cik.size + 1
    filing_url = filing_url[start_index..filing_url.size] # Turns from "000152588511000001/primary_doc.xml" into "edgar/data/1525885/000152588511000001/primary_doc.xml"
    filing_url[0..filing_url.index('/') - 1] # Returns "000152588511000001" from "000152588511000001/primary_doc.xml"
  end

  def self.find_or_create_company(name, cik, filing_url)
    Company.find_by_cik(cik)||Company.create(:cik => cik, :name => name)
  end

  def self.find_or_create_round(accession, filing_url, company)
    Round.find_by_accession(accession)||Round.create(:filing_url => filing_url, :company_id => company.id, :accession => accession)
  end

  def self.capitalize_each_word(string)
    string.split(" ").each{|word| word.capitalize! unless word == "LLC" or word == "L.P." or word == 'LTD' }.join(" ")
  end

  def update_data(primary_issuer)
    self.incorporation_year = primary_issuer.at_xpath('yearOfInc/value').child.to_s              unless primary_issuer.at_xpath('yearOfInc/value').nil?
    self.city               = primary_issuer.at_xpath("issuerAddress/city").child.to_s           unless primary_issuer.at_xpath("issuerAddress/city").nil?
    self.state              = primary_issuer.at_xpath('issuerAddress/stateOrCountry').child.to_s unless primary_issuer.at_xpath('issuerAddress/stateOrCountry').nil?
    p "Updated Company of ID:  #{ self.id }"
    self.save
    
  end
end
