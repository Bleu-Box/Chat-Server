# client.rb
# this client connects to the BleuNet chat service
# it has cool colors just like the server does
# path: C:\Ruby23-x64\Programs\Network\2

require 'socket' 
require 'colorize'

host = 'localhost'
port = ARGV[0] || 80

# clear terminal
def clear 
	system 'clear' or system 'cls'
end

clear 

begin 
	# make a connection to the server and print the status
	STDOUT.puts 'Connecting to BleuNet...'.colorize(:color => :cyan, :mode => :bold)
	s = TCPSocket.open(host, port) 
	STDOUT.puts 'Connected successfully.'.colorize(:color => :cyan, :mode => :bold)
	
	# print the server's welcome message if it has one
	begin 
		sleep 0.5 
		STDOUT.puts(s.read_nonblock(4096).chop)
	rescue SystemCallError 
		# do nothing
	end
	
	# ask for user's name and then process it
	STDOUT.print "Enter your name: "
	STDOUT.flush 
	name = STDIN.gets
	name.chop!
	
	loop do 
		# we will use a fancy header with
		# the user's name and time 
		msg_header = "<#{name} #{[Time.now]}:> ".colorize(:color => :black, :mode => :bold)
		STDOUT.print msg_header 
		# wait for a message
		msg = STDIN.gets 
		# if we can't get a message at all, end the loop
		break if !msg 
		
		# send the message to the server 
		s.puts(msg_header + msg) 
		s.flush
		
		clear 
		
		# read the response 
		response = s.readpartial 4096 
		puts response.chop.colorize(:color => :yellow, :mode => :bold)
	end 
	
rescue 
	# if an error happens, show it to the user
	puts $! 
ensure 
	# make sure to close the socket 
	s.close if s 
end 