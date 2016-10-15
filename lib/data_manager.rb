require 'triez'
require 'json'
require_relative 'db_init'
require_relative 'query'

module P1000YellowPages
  class DataManager

    def initialize
      puts "Initializing the Datastore....."

      table = 'p1000_yellow_pages_people'
      unless DataMapper.repository(:default).adapter.storage_exists?(table)
        load_data
      end

      build_index

      puts "Datastore initialized successfully!"
    end

    def search query_str
      query = Query.new(query_str)
      unless query.legal? &&
          (query.age.nil? || (min_age..max_age).include?(query.age))
        return []
      end

      find_all(query)
    end

    private

    def find_all query
      ids = if query.ordered_name
              search_results = @names_trie.search_with_prefix(query.ordered_name)
              ordered_names = search_results.flat_map(&:last)
              @name_hash.values_at(*ordered_names).flatten.uniq
            end

      query_hash = {id: ids,
                    "stripped_phone.like" => query.stripped_phone,
                    age: query.age}.select { |_, v| v }

      Person.all(query_hash)
    end

    def load_data
      P1000YellowPages::Person.auto_migrate!

      file = File.read('data/people.json')
      str_arr = file.split('}},').map! { |p| p + '}}' }

      #remove the extra characters
      str_arr.first[0] = ''
      str_arr.last.chop!.chop!.chop!

      str_arr.map do |person_json|
        persist_person person_json
      end
    end

    def persist_person person_json
      args = JSON.parse(person_json)
      person = Person.first_or_new(name: args['name'],
                                   phone: args['phone'],
                                   birthday: args['birthday'],
                                   address: args['address'],
                                   avatar_image: args['avatar_image'],
                                   avatar_origin: args['avatar_origin'])
      person.normalize
      person.save
    end

    def build_index
      @names_trie = Triez.new(value_type: :object)
      @name_hash = {}

      Person.all.each do |person|
        @name_hash[person.ordered_name] ||= []

        @name_hash[person.ordered_name] << person.id

        @names_trie.change_all(:suffix, person.ordered_name) do |old_ordered_names|
          (Array(old_ordered_names).push person.ordered_name).uniq
        end
      end
    end

    def min_age
      @min_age ||= Person.all(:order => [:age.asc]).first.age
    end

    def max_age
      @max_age ||= Person.all(:order => [:age.desc]).first.age
    end
  end
end