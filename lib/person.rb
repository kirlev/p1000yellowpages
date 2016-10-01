module P1000YellowPages
  class Person

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

    def to_json
      {
          name: @name,
          phone: @phone,
          age: age,
          address: @address,
          avatar_origin: @avatar_origin,
          avatar_image: @avatar_image
      }.to_json
    end
  end
end