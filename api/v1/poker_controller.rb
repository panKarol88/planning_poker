namespace '/api/v1' do
  connections = []

  namespace '/stream' do
    before do
      content_type 'text/event-stream'
    end

    get '/subscribe/:host_name/:listener_name' do
      stream(:keep_open) do |out|
        EventMachine::PeriodicTimer.new(20) { out << " " unless out.closed? }
        connections << out
        # purge dead connections
        out.callback { connections.delete(out) }
      end
    end

    get '/unsubscribe/:host_name' do
      host_name = params['host_name']
      connections.select{|c| c.app.env['REQUEST_URI'].split('/')[-2] == host_name}.each do |out|
        out.close
      end
    end
  end

  namespace '/client' do
    before do
      content_type 'application/json'
    end

    get '/planning/:host_name' do
      host_name = params['host_name']
      (PokerStorageService.new.r_get(host_name) || {}).to_json
    end

    post '/upload_planning/:host_name' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = params['host_name']
      cache = PokerStorageService.new.r_set(host_name, body_hash)
      if cache
        [201]
      else
        [422]
      end
    end

    post '/force_upload_planning/:host_name' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = params['host_name']
      cache = PokerStorageService.new.r_set(host_name, body_hash, true)
      if cache
        [201]
      else
        [422]
      end
    end

    delete '/delete_planning/:host_name' do
      host_name = params['host_name']
      PokerStorageService.new.r_release(host_name)
      [204]
    end

    post '/vote' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = body_hash['host_name']
      vote = body_hash['vote']

      poker_storage = PokerStorageService.new
      vote = poker_storage.set_vote!(host_name: host_name,voter_name: vote['voter_name'], points: vote['points'])

      if vote
        connections.select{|c| c.app.env['REQUEST_URI'].split('/')[-2] == host_name}.each do |out|
          out << { event: poker_storage.voting_status }.to_json unless out.closed?
        end
      end
      [200, { status: poker_storage.voting_status }.to_json]
    end

    post '/push' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = body_hash['host_name']
      event = body_hash['event']
      text = body_hash['text']

      connections.select{|c| c.app.env['REQUEST_URI'].split('/')[-2] == host_name}.each do |out|
        out << { event: event, text: text }.to_json unless out.closed?
      end

      [200]
    end
  end
end
