require "http/server"

module Router
    class Route
        @path : String | Regex
        @verb : String
        #@handler
        @pathMatcher : Proc(HTTP::Server::Context, Bool)
        
        def initialize(path, verb, handler) 
            @path = path
            @verb = verb
            #@handler = ->handler
            
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
            @pathMatcher.call(context) && @verb == context.request.method
        end
        
        def handle(context)
            #@handler.call(context)
            context.response.content_type = "text/plain"
            context.response.print @verb
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
        
        def initialize 
            @routes = [
                Route.new("/", "GET", ""),
                Route.new("/about", "GET", ""),
                Route.new(/^\/api\/?/, "GET", "")
            ]
        end
        
        def route(context)
            routed = @routes.reduce(false) do |matched, route|
                matched || route.checkPathAndHandle(context)
            end
            
            if !routed
                context.response.content_type = "text/plain"
                context.response.print "404"
            end
        end
        
    end
end