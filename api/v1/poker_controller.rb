namespace '/api/v1' do
  connections = []

  namespace '/host' do
    before do
      content_type 'text/event-stream'
    end

    get '/subscribe/:host_name' do
      stream(:keep_open) do |out|
        connections << out
        # purge dead connections
        # out.callback { connections.delete(out) }
      end
    end

    get '/unsubscribe/:host_name' do
      host_name = params['host_name']
      connections.select{|c| c.app.env['REQUEST_URI'].split('/').last == host_name}.each do |out|
        out << { text: 'Voting has been restarted. Please vote again.' }.to_json
        out.close
      end
    end
  end

  namespace '/client' do
    before do
      content_type 'application/json'
    end

    post '/vote' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = body_hash['host_name']

      connections.select{|c| c.app.env['REQUEST_URI'].split('/').last == host_name}.each do |out|
        out << body
      end
    end
  end
end
