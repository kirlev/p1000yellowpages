require_relative '../lib/query'

describe "Query"  do
    context "with ilegal string" do
       it "the query is ilegal with two ages" do
           query = P1000YellowPages::Query.new "45 54"
           expect(query).to_not be_legal
       end
       it "the query is ilegal with two phones" do
           query = P1000YellowPages::Query.new "1234-123456 4321-654321"
           expect(query).to_not be_legal
       end
    end
    context "with a legal string" do
        
        names = %W(Edward Alphonse Elric)
        age = "67"
        phone = "1234-123456"

        [*names, age, phone].permutation.each do |permutation|
            query_str = permutation.join(' '*(1 + rand(10)))
            
            let(:query){ P1000YellowPages::Query.new query_str }
            
            context "with query '#{query_str}'" do
                it "has the correct attributes" do
                    expect(query).to be_legal
                    expect(query.stripped_phone).to eq phone.sub('-','')
                    expect(query.age).to eq age.to_i
                    expect(query.ordered_name).to eq names.sort.join(' ').downcase
                end
            end
        end
    end
end