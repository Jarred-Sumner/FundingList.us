class RelatedPerson < ActiveRecord::Base
  belongs_to :round
  belongs_to :person

  def self.create_from_filing(related_persons_list, round_id)
    related_persons_list.each do |related_person|
      person = Person.find_or_create(related_person)
      relation = self.find_or_new_related_person(round_id, person)
      relation.person = person
      relation.round_id = round_id
      related_person.xpath('relatedPersonRelationshipList/relationship').each do |relationship|
        relation.director = true if relationship.child.to_s == 'Director'
        relation.executive_officer = true if relationship.child.to_s == 'Executive Officer'
        relation.promoter = true if relationship.child.to_s == 'Promoter'
      end
      relation.explanation = related_person.at_xpath('relationshipClarification').child.to_s unless related_person.at_xpath('relationshipClarification').nil?
      p "Added Related Person #{person.full_name} to Round with ID of #{ round_id }"
      relation.save
    end
  end

  def full_name
    self.person.full_name
  end
  def title
    title = ''
    title = title + 'Director, '  if self.director?
    title = title + 'Promoter, '  if self.promoter?
    title = title + 'Executive '  if self.executive_officer?
    title[-2] = '' if title[-2] == ','
    title.strip
  end

  def self.find_or_new_related_person(round_id, person)
    p "Round ID: #{round_id}"
    p "Person ID: #{}"
    Round.find(round_id).company.rounds.each do |round|
      related_person = RelatedPerson.find_by_round_id_and_person_id(round.id, person.id)
    end
    related_person = RelatedPerson.new if related_person.nil?
    related_person
  rescue
  end

  def companies
    companies = []
    RelatedPerson.where(:person_id => self.person_id).each do |related_person|
      companies.push(related_person.round.company)
    end
    companies.uniq
  end
end
