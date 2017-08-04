# server.rb
# this server runs the BleuNet chat service
# path: C:\Ruby23-x64\Programs\Network\2

require 'socket'
require 'colorize'

require_relative 'server_class.rb'

# get server's name and port from command line
server_name, port = ARGV

# make a new chat server and run it
server = ChatServer.new(server_name, port)
server.run
