# bundle install
# bundle exec ruby demo.rb

require 'kiba'
require 'kiba-common/sources/csv'
require 'kiba-common/destinations/csv'
require 'kiba-common/dsl_extensions/show_me'

def csv_to_hash(file)
  CSV.foreach(file, headers: true).each_with_object({}) do |r, memo|
    memo[r.fetch("id")] = r.to_h
  end
end

job = Kiba.parse do
  source Kiba::Common::Sources::CSV, filename: 'data/main.csv', csv_options: {headers: true}
  # Ruby's CSV gives us "CSV::Row" but we want Hash
  transform { |r| r.to_h }
  
  transform do |row|
    @lookup_client ||= csv_to_hash('data/clients.csv')
    row.merge(
      client_name: @lookup_client.fetch(row.fetch('client_id')).fetch('name')
    )
  end

  transform do |row|
    @lookup_language ||= csv_to_hash('data/languages.csv')
    row.merge(
      language_name: @lookup_language.fetch(row.fetch('language_id')).fetch('name')
    )
  end

  # extend Kiba::Common::DSLExtensions::ShowMe
  # show_me!

  filename = 'data/main-enriched.csv'
  
  destination Kiba::Common::Destinations::CSV,
    filename: filename
  
  post_process do
    puts "File generated in #{filename}"
  end
end

Kiba.run(job)
