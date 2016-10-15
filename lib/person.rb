require 'data_mapper'

module P1000YellowPages
  class Person
    include DataMapper::Resource
    property :id,           Serial
    property :name,         String, :required => true
    property :ordered_name,         String, :required => true
    property :phone,         String, :required => true
    property :stripped_phone,         String, :required => true, index: true
    property :avatar_origin,         String, :required => true, length: 120
    property :avatar_image,         String, :required => true, length: 120
    property :birthday,         Integer, :required => true
    property :age,         Integer, :required => true, index: true
    property :address,         Object, :required => true


    def normalize
      self.stripped_phone ||= phone.gsub('-', '')
      self.ordered_name ||= name.split.sort.join(' ').downcase
      birth_year = Time.at(birthday).utc.year
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
