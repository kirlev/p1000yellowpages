require 'spec_helper'

describe "P1000YellowPages" do
    context "Home page" do
        it "renders the index correctly" do
            get '/'
            expect(last_response).to be_ok
            expect(last_response.body).to include("Type your search query")
        end
    end
    
    context "Search" do
       context "when there is no match" do
           it "returns the correct message" do
               get 'search?query=Lelouch vi Britannia'
               expect(last_response).to be_ok
               expected_msg = "No results, please review your search or try a different one"
               expect(last_response.body).to include(expected_msg)
           end
       end 
       context "when there is a match" do
           it "returns the resilts" do
               name = 'Nilsson'
               get "search?query=#{name}"
               expect(last_response).to be_ok
               expect(last_response.body).to include(name)
           end
       end
    end
end