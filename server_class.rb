# server_class.rb
# this is the class for the server that runs the BleuNet chat service
# it has cool colors too
# path: C:\Ruby23-x64\Programs\Network\2

require 'socket'
require 'colorize'

class ChatServer 
	def initialize(name, port='80')
		@name    = name
		@port    = port
		@server  = TCPServer.open port
		@sockets = [@server]

		# this array holds a record of all the messages everyone's sent
		@messages = []
		
		clear 
		# print a cool-looking startup message
		STDOUT.puts "BleuNet server '#{@name}' is up and running on port #{@port}.\nCurrent time: #{Time.now}".colorize(:color => :cyan, :mode => :bold)
	end 
	
	# the main loop for the chat
	def run 
		loop do
			# get all the sockets that have input to be read
			available = select @sockets 
			readable  = available[0]
			
			readable.each do |s|
				if s == @server 
					# put new clients into the sockets array
					client = @server.accept 
					@sockets << client 
					# give them a greeting
					client.puts "Welcome to #{@name} chat server on port #{@port}!\nMade with BleuNet Server v0.1"
					STDOUT.puts "#{client.peeraddr} connected.".colorize(:color => :green, :mode => :bold)
				else 
					# if we aren't dealing with the server, then
					# take input from what must be a client
					
					# only take input if all the messages have been printed
					input = s.gets
					# if the client isn't giving input, it must not be there anymore
					# so disconnect it and jump to the next iteration
					if !input 
						disconnect(s, @sockets) 
						next 
					end
					
					input.chop!
					
					# print input to server just because
					puts input
					
					# save input to messages
					@messages << input
					 
					# send the conversation to all of the clients so they can have 
					# the most updated version of it
					readable.each do |sock|
						@messages.each do |msg|
							sock.puts msg
							sock.flush
						end
					end
					
					# type ':q' to quit the chat
					if input[-2..-1] == ':q' 
						disconnect(s, @sockets) 
					end
				end
			end
		end
	end
	
	private 
	
	# disconnect the given socket
	def disconnect(socket, arr) 
		STDOUT.puts "#{socket.peeraddr} disconnected.".colorize(:color => :red, :mode => :bold)
		arr.delete socket 
		socket.close 
	end
	
	# clear screen
	def clear 
		system 'clear' or system 'cls'
	end 
end