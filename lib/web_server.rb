require 'socket'
require_relative 'response'
require_relative 'request'

class WebServer
  attr_reader :port, :host, :web_root

  def initialize(port:, host:, web_root:)
    @port = port
    @host = host
    @web_root = web_root
  end

  def start
    server = TCPServer.new(host, port)
    puts "Server started on: http://#{host}:#{port}/"

    while (session = server.accept)
      request = session.gets
      next unless request

      puts "#{time} -> #{request}"

      response = Response.new(Request.new(request), web_root)
      puts "#{time} <- #{response.status_line}"
      session.print response.to_s
      session.close
    end
  end

  private

  def time
    Time.now.strftime('%d.%m.%Y %H:%M:%S')
  end
end