require 'json'
require_relative 'person'
require_relative 'query'

module P1000YellowPages
  class Datastore

    def initialize
      puts "Initializing the Datastore....."
      table = 'p1000_yellow_pages_people'
      unless DataMapper.repository(:default).adapter.storage_exists?(table)
        load_data
      end
      puts "Datastore initialized successfully!"
    end

    def search query_str
      query = Query.new(query_str)
      unless query.legal?
        return []
      end

      find_all(query)
    end

    private

    def find_all query
      Person.all(query.to_hash)
    end

    def load_data
      Person.auto_migrate!
      file = File.read('data/people.json')
      str_arr = file.split('}},').map! { |p| p + '}}' }

      #remove the extra characters
      str_arr.first[0] = ''
      str_arr.last.chop!.chop!.chop!

      str_arr.map do |p|
        args = JSON.parse(p)
        p = Person.first_or_new(name: args['name'],
                      phone: args['phone'],
                      age: args['birthday'],
                      address: args['address'],
                      avatar_image: args['avatar_image'],
                      avatar_origin: args['avatar_origin'])
        p.normalize
        p.save
      end
    end
  end
end