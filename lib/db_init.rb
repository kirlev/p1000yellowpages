require_relative 'person'

DataMapper.setup(:default, ENV['DATABASE_URL'] ||
    "sqlite3://#{Dir.pwd}/p1000_yellow_pages.db")

DataMapper::Model.raise_on_save_failure = true

DataMapper.finalize
