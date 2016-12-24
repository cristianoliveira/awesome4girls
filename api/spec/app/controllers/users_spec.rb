# frozen_string_literal: true
require 'spec_helper'

describe 'UsersController', type: :controller do
  let(:data) { JSON.parse(last_response.body) }

  describe 'authentication' do
    context 'without basic authentication' do
      describe 'get users' do
        before { get '/users' }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      describe 'create users' do
        before { post '/users', name: 'roy', password: '123123', role: 1 }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      describe 'delete users' do
        before do
          create(:user, name: 'bob', password: '123')
          delete '/users/1'
        end

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      context 'with wrong credentials' do
        before do
          create(:admin, name: 'jonh', password: '123')
          basic_authorize 'jonh', '123qweqweq'
        end

        describe 'get users' do
          before { get '/users' }

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end

        describe 'create users' do
          before { post '/users', name: 'roy', password: '123123', role: 1 }

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end

        describe 'delete users' do
          before(:each) do
            create(:user, name: 'bob', password: '123  ')
            delete '/users/1'
          end


          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end
      end
    end
  end

  describe 'listing users' do
    before do
      create(:admin, name: 'jonh', password: '123')
      basic_authorize 'jonh', '123'
      get '/users'
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(last_response.body).to include('type') }
    it { expect(data['data'].size).to eq(1) }
  end

  describe 'adding users' do
    context 'passing required params' do
      before do
        create(:admin, name: 'jonh', password: '123')
        basic_authorize 'jonh', '123'
        post '/users', name: 'roy', password: '123123', role: 1
      end

      it { expect(last_response.content_type).to eq 'application/json' }
      it { expect(last_response.status).to be(200) }
      it { expect(data).to_not include('errors') }

      it 'contains user created' do
        get '/users'
        expect(last_response.body).to include('roy')
      end
    end

    context 'without required params' do
      before do
        create(:admin, name: 'jonh', password: '123')
        basic_authorize 'jonh', '123'
      end

      it 'validates name' do
        post '/users', password: '123123', role: 1
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'validates password' do
        post '/users', name: 'roy', role: 1
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'validates role' do
        post '/users', name: 'roy', password: '123123'
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end
    end
  end
end
