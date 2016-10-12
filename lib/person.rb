module P1000YellowPages
  class Person
    attr_reader :name, :phone

    def initialize args
      @name = args['name']
      @phone = args['phone']
      @birthday = args['birthday']
      @address = args['address']
      @avatar_image = args['avatar_image']
      @avatar_origin = args['avatar_origin']

      unless @name && @phone && @birthday && @address &&
          @avatar_image && @avatar_origin
        raise "Missing arguments! got #{args}"
      end
    end

    def stripped_phone
      @stripped_phone ||= @phone.gsub('-', '')
    end

    def ordered_name
      @ordered_name ||= @name.split.sort.join(' ').downcase
    end

    def age
      birth_year = Time.at(@birthday).utc.year
      @age ||= Time.now.utc.year - birth_year
    end

    def avatar_source
      "#{@avatar_origin}/#{@avatar_image}"
    end

    def address
      "#{@address['street']}, #{@address['city']}, #{@address['country']}."
    end
  end
end