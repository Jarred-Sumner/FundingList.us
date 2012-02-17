module CompaniesHelper
  def related_people(company)
    people = []
    company.rounds.all.each do |round|
      round.people.each do |person|
        people.push(person)
      end
    end
  end
end
