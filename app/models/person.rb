class Person < ActiveRecord::Base
  has_many :rounds, :through => :related_people

  def self.find_or_create(xml)
    person = nil
    first_name          = xml.at_xpath('relatedPersonName/firstName').child.to_s
    last_name           = xml.at_xpath('relatedPersonName/lastName').child.to_s
    if Person.find_by_first_name_and_last_name(first_name, last_name)
      person = Person.find_by_first_name_and_last_name(first_name, last_name)
    else
      person = Person.new
      person.first_name = first_name
      person.last_name  = last_name
    end
    person.street_address_one  = xml.at_xpath('relatedPersonAddress/street1').child.to_s
    person.street_address_two  = xml.at_xpath('relatedPersonAddress/street2').child.to_s if xml.at_xpath('relatedPersonAddress/street2')
    person.city                = xml.at_xpath('relatedPersonAddress/city').child.to_s if xml.at_xpath('relatedPersonAddress/city')
    person.zip_code            = xml.at_xpath('relatedPersonAddress/zipCode').child.to_s if xml.at_xpath('relatedPersonAddress/zipCode')
    person.save
    person
  end

  def full_name
    if    self.first_name and self.last_name
      self.first_name + " " + self.last_name 
    elsif self.first_name and not self.last_name
      self.first_name
    elsif self.last_name and not self.first_name
      self.last_name
    end 
  end

  def name
    full_name
  end

end
