require_relative 'lib/datastore'
require 'sinatra'
require 'will_paginate'
require 'will_paginate/array'

DATASTORE = P1000YellowPages::Datastore.new

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/search' do
  query_str = params[:query] || ''
  page = params[:page] || 1
  @found_people = DATASTORE.search(query_str).paginate(page: page,
                                                       per_page: 10)
  erb :search_results
end