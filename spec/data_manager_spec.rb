require_relative 'spec_helper'

describe "Datastore" do
    EXAMPLES_AMOUNT = 10
    before(:all) { @datastore = RSpec.configuration.datastore }
    
    context "#search" do
        let(:person){P1000YellowPages::Person.first}
        let(:query_str) {"#{person.name} #{person.phone} #{person.age}"}
            
        context "when the query is ilegal" do
            it "returns an empty array" do
                query = double("Query", 'legal?' => false)
                allow(P1000YellowPages::Query).to receive(:new).and_return(query)
                expect(@datastore.search person.name).to be_empty
            end
        end
        context "when the age is greater than the max age in the datastore" do
            it "returns an empty array" do
                max_age = 120
                query = double("Query", 'legal?' => true, age: max_age+1)
                allow(P1000YellowPages::Query).to receive(:new).and_return(query)
                expect(@datastore.search person.name).to be_empty
            end
        end
        context "when the age is lesser than the min age in the datastore" do
            it "returns an empty array" do
                min_age = 0
                query = double("Query", 'legal?' => true, age: min_age-1)
                allow(P1000YellowPages::Query).to receive(:new).and_return(query)
                expect(@datastore.search person.name).to be_empty
            end
        end
        context "when the person does not exist" do
           it "returns an empty array" do
               (query_str.split.count + 1).times do |n|
                   query_str.split.combination(n).each do |c|
                       (c + ["Kurosaki"]).permutation.each do |p|
                           results = @datastore.search(p.join(' '))
                           expect(results).to be_empty
                       end
                   end
               end
            end
        end
        context "with the correct keywords" do
            it "finds the person" do
                people = P1000YellowPages::Person.all
                people.first(EXAMPLES_AMOUNT).each do |person|
                    [person.phone, person.phone.sub('-','')].each do |phone|
                        query_arry = [person.name.split, phone, person.age]
                        query_arry.count.times do |n|
                            query_arry.combination(n+1).each do |c|
                                c.permutation.each do |p|
                                    str = p.join(' '*(1 + rand(10))) 
                                    results = @datastore.search str
                                    expect(results).to include(person)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end