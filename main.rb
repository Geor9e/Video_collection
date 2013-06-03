require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'



# This line of code lets you run this action before any other method.
#before do
#  sql = 'select distinct genre from videos'
#  genre = run_sql(sql)
#end


get('/') {
  @genre = genre
  sql = "select distinct genre from videos"
  erb :home
}


post('/create') {
  @genre = genre
  sql = "Insert into videos (title, description, url, genre)
         values ('#{params['title']}', '#{params['description']}', '#{params['url']}', '#{params['genre'].downcase}')"
  run_sql(sql)
  redirect to('/videos')
}

get('/videos') {
  sql = 'select * from videos'
  @rows = run_sql(sql)
  @genre = genre
  erb :videos
}

get('/videos/:id/edit') {
  @genre = genre
  sql = "select * from videos where id = #{params['id']}"
  @row = run_sql(sql).first
  erb :edit
}

#This was a major issue its :genre not videos/:genre/genre
get('/videos/:genre') {
  @genre = genre
  sql = "select * from videos where genre = '#{params[:genre]}'"
  puts sql
  @rows = run_sql(sql)
  erb :genre
}

post('/videos/:id/edit') {
  @genre = genre
  sql = "update videos set
         title='#{params['title']}', description='#{params['description']}', url='#{params['url']}', genre='#{params['genre']}'
         where id = #{params['id']}"
  run_sql(sql)
  redirect '/videos'
}

post('/videos/:id/delete') {
  @genre = genre
  sql = "delete from videos where id = #{params['id']}"
  run_sql(sql)
  redirect '/videos'
}

def run_sql(sql)
  conn = PG.connect(dbname: 'video_store', host: 'localhost')
  results = conn.exec(sql)
  conn.close
  results
end


def genre
  sql = 'select distinct genre from videos'
  genre = run_sql(sql)
end