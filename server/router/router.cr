require "http/server"

module Router
    
    def self.indexController(context : HTTP::Server::Context) : Bool
        if context.request.path == "/"
            context.response.content_type = "text/plain"
            context.response.print "Index"
            return true
        end
        return false
    end
    
    def self.aboutController(context : HTTP::Server::Context) : Bool
        if context.request.path == "/about"
            context.response.content_type = "text/plain"
            context.response.print "About"
            return true
        end
        return false
    end
    
    def self.apiRouter(context : HTTP::Server::Context) : Bool
        if /^\/api\/?/ =~ context.request.path
            context.response.content_type = "text/plain"
            context.response.print "API"
            return true
        end
        return false
    end
    
    def self.route(context)
        routes : Array(Proc(HTTP::Server::Context, Bool))
        routes = [
            ->indexController(HTTP::Server::Context),
            ->aboutController(HTTP::Server::Context),
            ->apiRouter(HTTP::Server::Context)
        ]
        
        routed = routes.reduce(false) do |matched, route|
            matched || route.call(context)
        end
        
        puts routed
        
        if !routed
            context.response.content_type = "text/plain"
            context.response.print "404"
        end
        
    end
    
    
end