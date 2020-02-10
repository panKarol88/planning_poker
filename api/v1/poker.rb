namespace '/api/v1' do
  connections = []

  namespace '/host' do
    before do
      content_type 'text/event-stream'
    end

    get '/subscribe/:host_name' do
    end
  end

  namespace '/client' do
    before do
      content_type 'application/json'
    end

    post '/vote' do
      body = request.body.read
      body_hash = JSON.parse body if body.present?
      host_mame = body_hash['host_name']

      p connections.map{|c| c.app.env['REQUEST_URI'].split('/').last}
      connections.select{|c| c.app.env['REQUEST_URI'].split('/').last == host_mame}.each do |out|
        out << body
      end
    end
  end
end
