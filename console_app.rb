require 'rubygems'
require 'dm-core'
require 'dm-validations'
require 'models/chat'
require 'models/message'
require 'models/user'
DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/development.sqlite3") 
DataMapper.auto_upgrade!

