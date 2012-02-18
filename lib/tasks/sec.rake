desc 'SEC'
namespace :sec do

  desc 'Parses SEC Data from Web'
  task 'load' => :environment do
    (2008..2012).each do |year|
      start_index = 1
      start_index = 4 if year == 2008
      (1..4).each do |quarter|
        break if year == 2012 and quarter > 1
        Company.parse_from_quarterly_filings(year, quarter, false, nil) 
      end
    end
  end

  desc 'Downloads all quarterly filings to disk'
  task 'download' => :environment do
    (2008..2012).each do |year|
      start_index = 1
      start_index = 4 if year == 2008
      (start_index..4).each do |quarter|
        partial_url = "#{year}/QTR#{quarter}"
        FileUtils.mkpath("./public/#{partial_url}")
        break if year == 2012 and quarter > 1
        full_url = "#{partial_url}/form.idx"
        p "Downloading #{full_url}"
        File.new("./public/#{full_url}", 'w') unless File.exists?("./public/#{full_url}")
        open("./public/#{full_url}", "wb").write(open("ftp://ftp.sec.gov/edgar/full-index/#{full_url}").read)
      end
    end
  end

  desc 'Installs all quarterly filings from disk'
  task 'load:disk:all' => :environment do
    (2008..2012).each do |year|
      start_index = 1
      start_index = 4 if year == 2008
      (start_index..4).each do |quarter|
        break if quarter > 1 and year == 2012
        Company.parse_from_quarterly_filings(year,quarter,false,"#{year}/QTR#{quarter}/form.idx")
      end
    end
  end

  desc 'Parses SEC Data from Disk'
  task 'load:disk' => :environment do
    # Year and Quarter don't matter in this case
    Company.parse_from_quarterly_filings(2011, 4, true, nil)
  end

  desc 'Downloads the latest SEC filing to disk'
  task 'download:latest' => :environment do
    File.new("./public/latest.idx", 'w') unless File.exists?('./public/latest.idx')
    p 'Downloading ftp://ftp.sec.gov/edgar/full-index/form.idx'
    open('./public/latest.idx', 'wb').write(open("ftp://ftp.sec.gov/edgar/full-index/form.idx"))
    p 'Downloaded Successfully'
  end
end
task 'deploy' => :environment do
  exec 'bundle install --deployment && bundle exec rake db:migrate RAILS_ENV=production && bundle exec rake sec:download RAILS_ENV=production && bundle exec rake sec:load:disk:all RAILS_ENV=production && bundle exec rake assets:precompile RAILS_ENV=production'
end
