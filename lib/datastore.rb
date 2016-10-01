require 'json'
require 'triez'

class Datastore
  attr_reader :people, :index

  def initialize
    load_data
    create_index
  end

  private

  def load_data
    file = File.read('data/people.json')
    str_arr = file.split('}},').map! { |p| p + '}}' }

    #remove the extra characters
    str_arr.first[0] = ''
    str_arr.last.chop!.chop!.chop!

    @people = str_arr.map do |p,|
      JSON.parse p
    end
  end

  def create_index
    @index = Triez.new

    people.each_with_index do |p, i|
      names_perm = p['name'].downcase.split.permutation.to_a

      [p['phone'], p['phone'].gsub('-', '')].each do |phone_format|
        age_phone_perm = [get_age(p['birthday']).to_s, phone_format].permutation.to_a
        names_perm.each do |names|
          age_phone_perm.each do |age_phone|
            attributes = names + age_phone
            index.change_all(:suffix, attributes.join(' ') + p["id"]) { i }
          end
        end
      end
    end
  end

  # def create_name_index
  #   @name_index = Triez.new
  #   people.each_with_index do |p, i|
  #     @name_index.change_all(:suffix, p["name"].downcase + p["id"]) { i }
  #   end
  # end
  #
  # def create_age_index
  #   @age_index = {}
  #   people.each_with_index do |p, i|
  #     age = get_age(p['birthday'])
  #     @age_index[age] ||= []
  #     @age_index[age] << i
  #   end
  # end
  #
  # def create_phone_index
  #   @phone
  # end

  def get_age timestamp
    this_year = Time.now.utc.year
    birth_year = Time.at(timestamp).utc.year
    this_year - birth_year
  end
end