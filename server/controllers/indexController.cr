require "../router/router"

module IndexController
    def self.indexAction(context)
        context.response.content_type = "text/html"
        context.response.print "<h1>index</h1>"
    end
    
    def self.route
        Router::Route.new("/", ["GET"], ->indexAction(HTTP::Server::Context))
    end
end