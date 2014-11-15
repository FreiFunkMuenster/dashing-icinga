# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '15s', :first_in => 0 do |job|
  if ! defined? settings.nodes_json
    print_warning("Please configure nodes_json in config.ru!")
    next
  end
  
  # nodes
  result = get_nodes(settings.nodes_json)
  
  moreinfo = []
  color = 'blue'
  legend = ''
  
  send_event('node_count', {
    value: result["nodes"],
    moreinfo: moreinfo * " | ",
    color: color,
    legend: legend
  })
  
  send_event('gateway_count', {
    value: result["gateways"],
    moreinfo: moreinfo * " | ",
    color: color,
    legend: legend
  })
  
  send_event('client_count', {
    value: result["clients"],
    moreinfo: moreinfo * " | ",
    color: color,
    legend: legend
  })
end

def get_nodes(url)
  result = { "nodes" => 0, "gateways" => 0, "clients" => 0 }
  uri = URI.parse(url)
  Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new uri
    response = http.request(request)
    JSON.parse(response.body)["nodes"].each do |node|
      if node["flags"]["online"]
        if node["flags"]["client"]
          result["clients"] += 1
        else
          if node["flags"]["gateway"]
            result["gateways"] += 1
          else
            result["nodes"] += 1
          end
        end
      end
    end
    return result
  end
end
