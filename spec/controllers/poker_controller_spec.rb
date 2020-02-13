require File.expand_path '../../spec_helper.rb', __FILE__

describe 'API v1 - PokerController' do
  describe 'stream' do
    it 'should close stream exists' do
      get '/api/v1/stream/unsubscribe/:host_name'
      expect(last_response).to be_ok
    end
  end

  describe 'client' do
    it 'should get planning exists' do
      get '/api/v1/client/planning/:host_name'
      expect(last_response).to be_ok
    end

    it 'should upload planning exists and return success' do
      post '/api/v1/client/upload_planning/host_test', '{ "dummy": "data" }'
      expect(last_response).to be_successful
    end

    it 'should force upload planning exists' do
      post '/api/v1/client/force_upload_planning/host_test', '{ "dummy": "data" }'
      expect(last_response).to be_successful
    end

    it 'should delete planning exists' do
      delete '/api/v1/client/delete_planning/host_test'
      expect(last_response).to be_successful
    end

    it 'should vote exists' do
      post '/api/v1/client/vote', '{ "host_name": "data", "vote": {"voter_name": "data", "points": "data"} }'
      expect(last_response).to be_ok
    end

    it 'should push exists' do
      post '/api/v1/client/push', '{ "host_name": "data", "event": "data", "text": "data" }'
      expect(last_response).to be_ok
    end
  end
end
