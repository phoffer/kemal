require "kilt"

CONTENTS = {} of String => MemoryIO -> String

def content_for(name : String, &block : MemoryIO -> String)
  puts "Called content_for"
  CONTENTS[name] = block
  # CONTENTS[name] = block
end

def yield_content(name)
  puts "Called yield_content"
  CONTENTS[name].call
end

# Uses built-in ECR to render views.
# # Usage
# get '/' do
#   render 'hello.ecr'
# end
macro render(filename, layout)
  content = render {{filename}}
  if CONTENTS.size > 0
    puts "CONTENTS greater than 0"
    render {{layout}}
  else
    render {{layout}}
  end
end

macro render(filename, *args)
  Kilt.render({{filename}}, {{*args}})
end

macro return_with(env, status_code = 200, response = "")
  {{env}}.response.status_code = {{status_code}}
  {{env}}.response.print {{response}}
  next
end




# Adds given HTTP::Handler+ to handlers.
def add_handler(handler)
  Kemal.config.add_handler handler
end

# Uses Kemal::Middleware::HTTPBasicAuth to easily add HTTP Basic Auth support.
def basic_auth(username, password)
  auth_handler = Kemal::Middleware::HTTPBasicAuth.new(username, password)
  add_handler auth_handler
end

# Sets public folder from which the static assets will be served.
# By default this is `/public` not `src/public`.
def public_folder(path)
  Kemal.config.public_folder = path
end

# Logs to output stream.
# development: STDOUT in
# production: kemal.log
def log(message)
  Kemal.config.logger.write "#{message}\n"
end

# Enables / Disables logging
def logging(status)
  Kemal.config.logging = status
end

def logger(logger)
  Kemal.config.logger = logger
  Kemal.config.add_handler logger
end

def serve_static(status)
  Kemal.config.serve_static = status
end

def headers(env, additional_headers)
  env.response.headers.merge!(additional_headers)
end
