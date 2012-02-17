collection @companies
attributes :name
node(:raised) { |company| company.raised }
