require 'sneakers'

Sneakers.configure(
	connection: Bunny.new(host: ENV['QUEUE_HOST'], port: ENV['QUEUE_PORT'], user: ENV['QUEUE_USER'], password:  ENV['QUEUE_PASSWORD']),
	log_stdout: true,
	ack: true,
)