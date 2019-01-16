require 'kiba'
require 'kiba-common/sources/csv'
require 'kiba-common/destinations/csv'
require 'kiba-common/dsl_extensions/show_me'

module Lookup
  module_function

  def csv_to_hash(file)
    CSV.foreach(file, headers: true).each_with_object({}) do |r, memo|
      memo[r.fetch("id")] = r.to_h
    end
  end
end
