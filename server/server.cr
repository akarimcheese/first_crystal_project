require "http/server"
require "./router/router"

module Server
    include Router

    server = HTTP::Server.new("0.0.0.0", 8080) do |context|
        Router.route(context)
    end
    
    puts "Listening on http://0.0.0.0:8080"
    server.listen
    
end