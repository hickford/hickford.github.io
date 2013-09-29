require 'rack'
use Rack::Static, :urls => [""], :root => '_site', :index => 'index.html'
run

