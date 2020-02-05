namespace '/api/v1' do
  before do
    content_type 'application/json'
  end

  namespace '/host' do
    get '/create_session' do
      'go go go'
    end
  end
end
