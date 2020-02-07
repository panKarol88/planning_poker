namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  namespace '/host' do
    connections = []

    get '/subscribe' do
      content_type 'text/event-stream'
      stream(:keep_open) do |out|
        connections << out
        # purge dead connections
        out.callback { connections.delete(out) }
      end
    end

    post '/:message' do
      content_type 'text/event-stream'

      connections.each do |out|
        out << params['message'] << "\n"
      end
    end
  end
end
