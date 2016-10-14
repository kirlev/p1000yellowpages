require 'json'
require 'triez'
require_relative 'person'
require_relative 'query'

module P1000YellowPages
  class Datastore

    def initialize
      puts "Initializing the Datastore!!"
      load_data
      create_indices_map
      build_names_trie
    end

    def search query_str
      query = Query.new(query_str)
      unless query.legal? &&
          (query.age.nil? || (@min_age..@max_age).include?(query.age))
        return []
      end

      find_all(query)
    end

    private

    def find_all query
      indices = []

      if query.ordered_name
        search_results = @names_trie.search_with_prefix(query.ordered_name)
        indices << search_results.flat_map(&:last)
      end

      indices << (@phone_age_map[query.age] || []) if query.age
      indices << (@phone_age_map[query.stripped_phone] || []) if query.stripped_phone

      intersected_indices = indices.reduce(:&)

      @people.values_at(*intersected_indices)
    end

    def load_data
      file = File.read('data/people.json')
      str_arr = file.split('}},').map! { |p| p + '}}' }

      #remove the extra characters
      str_arr.first[0] = ''
      str_arr.last.chop!.chop!.chop!

      @people = str_arr.map do |p,|
        Person.new JSON.parse(p)
      end

      @min_age, @max_age = @people.map(&:age).minmax
    end

    def build_names_trie
      @names_trie = Triez.new(value_type: :object)

      @name_map.each do |ordered_name, indices|
        @names_trie.change_all(:suffix, ordered_name) do |old_indices| 
          (Array(old_indices) + indices).uniq 
        end
      end
      
      @name_map = nil
    end

    def create_indices_map
      @phone_age_map = {}
      @name_map = {}

      @people.each_with_index do |p, i|
        @phone_age_map[p.age] ||= []
        @phone_age_map[p.stripped_phone] ||= []
        @name_map[p.ordered_name] ||= []

        @phone_age_map[p.age] << i
        @phone_age_map[p.stripped_phone] << i
        @name_map[p.ordered_name] << i
      end
    end
  end
end