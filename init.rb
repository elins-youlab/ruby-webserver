require_relative 'lib/web_server'

WebServer.new(
  port: 9999,
  host: 'localhost',
  web_root: "#{__dir__}/webroot"
).start