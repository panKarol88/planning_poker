namespace '/api/v1' do
  connections = []

  namespace '/stream' do
    before do
      content_type 'text/event-stream'
    end

    get '/subscribe/:host_name/:listener_name' do
      stream(:keep_open) do |out|
        connections << out
        # purge dead connections
        # out.callback { connections.delete(out) }
      end
    end

    get '/unsubscribe/:host_name' do
      host_name = params['host_name']
      connections.select{|c| c.app.env['REQUEST_URI'].split('/').last == host_name}.each do |out|
        out.close
      end
    end
  end

  namespace '/client' do
    before do
      content_type 'application/json'
    end

    # { vote: { voter_name: voter_name, points: points }, host_name: host_name }
    post '/vote' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = body_hash['host_name']
      vote = body_hash['vote']

      vote = PokerStorageService.new(
          host_name: host_name,
          voter_name: vote['voter_name'],
          points: vote['points'])

      if vote.set_vote!
        binding.pry
        connections.select{|c| c.app.env['REQUEST_URI'].split('/')[-2] == host_name}.each do |out|
          out << { event: vote.voting_status }.to_json unless out.closed?
        end
      end
      [200, { status: vote.voting_status }.to_json]
    end

    post '/push' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_name = body_hash['host_name']
      recipient = body_hash['recipient']

      p 'BOOM'
      p body
      p connections.count
      p connections.map{|c| c.app.env['REQUEST_URI'].split('/').last}
      p connections.map{|c| c.app.env['REQUEST_URI'].split('/')[-2]}
      p recipient

      subscribers = if recipient == 'all'
                      connections.select{|c| c.app.env['REQUEST_URI'].split('/')[-2] == host_name}
                    else
                      connections.select{|c| c.app.env['REQUEST_URI'].split('/').last == host_name}
                    end
      p subscribers.map{|c| c.app.env['REQUEST_URI'].split('/').last}
      if subscribers.present?
        subscribers.each do |out|
          out << body unless out.closed?
        end
      else
        [204, { message: 'no-content' }]
      end
    end
  end
end
