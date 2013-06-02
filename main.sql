create table videos
(
  id serial8 primary key,
  title varchar(255),
  description text,
  url text,
  genre varchar(255)
);