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

get('/') {
  sql = "select * from videos"
  @rows = run_sql(sql)
  erb :home
}


get('/videos') {
  sql = 'select * from videos'
  @rows = run_sql(sql)
  erb :videos
}


post('/create') {
  sql = "insert into videos (title,description,url,genre)
           values ('#{params['title']}','#{params['description']}','#{params['url']}','#{params['genre']}')"
  run_sql(sql)
  redirect '/videos'
}


post('/videos/:id') {
  sql ="update videos set title='#{params['title']}', description='#{params['description']}', url='#{params['url']}',
        genre='#{params['genre']}' WHERE id=#{params['id']}"
  run_sql(sql)
  redirect to('/videos')
}


get('/videos/:id/edit') {
  sql = "update videos set title='#{params['title']}', description='#{params['description']}',
         url='#{params['url']}', genre='#{params['genre'].downcase}'
         where id = #{params['id']}"
  run_sql sql
  redirect to('/videos')
}

