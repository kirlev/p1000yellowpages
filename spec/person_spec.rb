require_relative '../lib/person'

describe 'Person' do
    context "creating a person" do
       context "with missing arguments" do
          it "raises an error" do
              args = {'name' => 'Gon Freecss'}
             expect {P1000YellowPages::Person.new args}.to raise_error(
                                              "Missing arguments! got #{args}") 
          end
       end
       context "with correct arguments" do
          let(:valid_args) {{
              'name' => 'Ging Freecss',
              'phone' => '1234-123456',
              'birthday' => 347155200,
              'address' => {
                  "city" => "Avsås",
                  "street" => "Larssons Gata 4",
                  "country" => "Norrland"
                  
              },
          'avatar_origin' => 'some.site.com',
          'avatar_image' => 'some-image.jpg'
          }}
          
          it "can be created" do
             expect {P1000YellowPages::Person.new valid_args}.to_not raise_error
          end
          
          it "has the correct arguments" do
              person = P1000YellowPages::Person.new valid_args
              expect(person.age).to eq 35 
              expect(person.stripped_phone).to eq '1234123456'
              expect(person.ordered_name).to eq 'freecss ging'
              expect(person.avatar_source).to eq 'some.site.com/some-image.jpg'
              expect(person.address).to eq 'Larssons Gata 4, Avsås, Norrland.'
          end
       end
    end
end