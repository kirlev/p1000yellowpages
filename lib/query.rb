module P1000YellowPages
  class Query

    def initialize query_str
      @stripped_phones = []
      @ages = []
      @names = []

      query_str.gsub! /\s+/, ' '
      keywords = query_str.split

      keywords.each { |keyword| categorize keyword }
    end

    def legal?
      all_keywords = [@stripped_phones, @ages, @names].flatten

      @legal ||= !all_keywords.empty? &&
          @ages.count < 2 &&
          @stripped_phones.count < 2
    end

    def age
      @ages.first
    end

    def stripped_phone
      @stripped_phones.first
    end

    def ordered_name
      @names.sort.join(' ').downcase
    end

    def to_hash
      {"stripped_phone.like" => stripped_phone,
      "ordered_name.like" => ("%#{ordered_name}%" if ordered_name),
      age: age}.select do |_,v|
        !v.nil?
      end
    end

    private

    def categorize keyword
      case keyword
        when /\A[0-9]{4}-[0-9]{5,6}\z|\A[0-9]{9,10}\z/
          @stripped_phones << keyword.gsub('-', '')
        when /\A\d+\z/
          @ages << keyword.to_i
        else
          @names << keyword
      end
    end
  end
end