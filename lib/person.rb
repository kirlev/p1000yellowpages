require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")
DataMapper::Model.raise_on_save_failure = true

module P1000YellowPages
  class Person
    include DataMapper::Resource
    property :id,           Serial
    property :name,         String, :required => true
    property :ordered_name,         String, :required => true, index: true
    property :phone,         String, :required => true
    property :stripped_phone,         String, :required => true, index: true
    property :avatar_origin,         String, :required => true, length: 120
    property :avatar_image,         String, :required => true, length: 120
    property :age,         Integer, :required => true, index: true
    property :address,         Object, :required => true


    def normalize
      self.stripped_phone ||= phone.gsub('-', '')
      self.ordered_name ||= name.split.sort.join(' ').downcase
      birth_year = Time.at(age).utc.year
      self.age = Time.now.utc.year - birth_year
    end

    def avatar_source
      "#{avatar_origin}/#{avatar_image}"
    end

    def pretty_address
      "#{address['street']}, #{address['city']}, #{address['country']}."
    end
  end
end

DataMapper.finalize
