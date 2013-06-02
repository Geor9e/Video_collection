require 'json'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'


def run_sql(sql)
  conn = PG.connect(dbname: 'video_store', host: 'localhost')
  results = conn.exec(sql)
  conn.close
  results
end

get '/' do
   erb :home
end


get '/new' do
    erb :new
end


post '/create' do

end

