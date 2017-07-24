require "http/server"
require "./router/router"

require "./controllers/indexController"

module Server
    routes = [
        IndexController.route
    ]
    router = Router::Router.new(routes)

    server = HTTP::Server.new("0.0.0.0", 8080) do |context|
        router.route(context)
    end
    
    puts "Listening on http://0.0.0.0:8080"
    server.listen
    
end