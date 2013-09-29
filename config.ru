require 'rack'
require 'rack/contrib/try_static'

use Rack::TryStatic, 
    :root => "_site",  # static files root dir
    :urls => ["/"],     # match all requests 
    :try => ['.html', 'index.html', '/index.html'] # try these postfixes sequentially

# otherwise 404 NotFound
run proc { [404, {'Content-Type' => 'text/plain'}, ['Not found']]}

