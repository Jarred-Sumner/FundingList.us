collection @results
attributes :id
node(:name) { |result| result.name }
node(:kind) do |result|
  result.class.name.pluralize.downcase
end
