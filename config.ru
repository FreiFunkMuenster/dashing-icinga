require 'dashing'

configure do
  #set :auth_token, 'YOUR_AUTH_TOKEN'

  # Please configure your Icinga access here
  set :icinga_cgi,  'https://monitoring.freifunk-muenster.de/cgi-bin/icinga2-classicui/status.cgi'
  #set :icinga_user, 'icingaadmin'
  #set :icinga_pass, 'test123'

  set :nodes_json, 'https://freifunk-muenster.de/map/nodes.json'

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
