require "http/server"

module Router
    class Route
        @path : String | Regex
        @verbs : Array(String)
        @handler : Proc(HTTP::Server::Context, Nil)
        @pathMatcher : Proc(HTTP::Server::Context, Bool)
        
        def initialize(path, verbs, handler) 
            @path = path
            @verbs = verbs
            @handler = handler
            
            if path.is_a?(String)
                @pathMatcher = ->(context : HTTP::Server::Context) {
                    if @path == context.request.path 
                        return true
                    else
                        return false
                    end
                }
            else
                @pathMatcher = ->(context : HTTP::Server::Context) {
                    if @path =~ context.request.path 
                        return true
                    else
                        return false
                    end
                }
            end
        end
        
        def isPath?(context)
            @pathMatcher.call(context) && @verbs.includes?(context.request.method)
        end
        
        def handle(context)
            @handler.call(context)
        end
        
        def checkPathAndHandle(context)
            if isPath?(context)
                handle(context)
                return true
            else
                return false
            end
        end
    end

    class Router
        @routes : Array(Route)
        
        def initialize(routes)
            @routes = routes
        end
        
        def route(context)
            routed = @routes.reduce(false) do |matched, route|
                matched || route.checkPathAndHandle(context)
            end
            
            if !routed
                context.response.content_type = "text/html"
                context.response.status_code = 404
                context.response.print "404"
            end
        end
        
    end
end