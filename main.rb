require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_support/all'
require 'pg'


get('/') {
  @genre = get_genre
  erb :home
}


post('/create') {
  sql = "Insert into videos (title, description, url, genre)
         values ('#{params['title']}', '#{params['description']}', '#{params['url']}', '#{params['genre'].downcase}')"
  run_sql(sql)
  redirect to('/videos')
}

get('/videos') {
  sql = 'select * from videos'
  @rows = run_sql(sql)
  @genre = get_genre
  erb :videos
}

get('/videos/:id/edit') {
  sql = "select * from videos where id = #{params['id']}"
  @row = run_sql(sql).first
  erb :edit
}


get '/videos/genre/:genre' do
  @genre = get_genre
  sql = "select * from videos where genre = '#{params['genre']}'"
  @rows = run_sql(sql)
  erb :genre
end

post('/videos/:id/edit') {
  sql = "update videos set
         title='#{params['title']}', description='#{params['description']}', url='#{params['url']}', genre='#{params['genre']}'
         where id = #{params['id']}"
  run_sql(sql)
  redirect '/videos'
}

post('/videos/:id/delete') {
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


def get_genre
  sql = "select distinct genre from videos"
  genre = run_sql(sql)
end