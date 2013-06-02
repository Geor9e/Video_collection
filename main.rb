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


get '/my_videos' do
    sql = 'select * from videos'
    @rows = run_sql(sql)
    erb :my_videos
end


post '/create' do
    sql = "insert into videos (title,description,url,genre) values ('#{params['title']}','#{params['description']}','#{params['url']}','#{params['genre']}')"
    run_sql(sql)
    redirect '/'
end

