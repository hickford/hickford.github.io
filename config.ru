require 'rack'
use Rack::Static,
    :urls => [""],
    :root => '_site',
    :index => 'index.html',
    # Cache all static files in public caches as well as in the browser
    :header_rules => [[:all, {'Cache-Control' => 'public, max-age=600'}]]
run proc { }

