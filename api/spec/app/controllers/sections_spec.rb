# frozen_string_literal: true
require 'spec_helper'

describe 'SectionsController', type: :controller do
  let(:username) { 'jonh' }
  let(:password) { '123123' }
  let(:subsection) { create(:subsection) }
  let(:section) { create(:section, title: 'foosection') }
  let(:data) { JSON.parse(last_response.body) }

  describe 'authentication' do
    context 'without basic authentication' do
      describe 'get sections' do
        before { get '/sections' }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(200) }
        it { expect(data).to_not include('errors') }
      end

      describe 'create sections' do
        before { post '/sections', title: 'baz', description: 'foo' }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      describe 'updating sections' do
        before do
          put "/sections/#{section.id}", title: 'new', description: 'new'
        end

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      describe 'delete sections' do
        before do
          create(:section)
          delete '/sections/1'
        end

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      context 'with wrong credentials' do
        before do
          create(:admin, name: username, password: password)
          basic_authorize username, "123#{password}"
        end

        describe 'get sections' do
          before { get '/sections' }

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(200) }
          it { expect(data).to_not include('errors') }
        end

        describe 'create sections' do
          before { post '/sections', title: 'roy', description: 'foo' }

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end

        describe 'update sections' do
          before do
            put "/sections/#{section.id}", title: 'new', description: 'new'
          end

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end

        describe 'delete sections' do
          before do
            section = create(:section, title: 'foosection')
            delete "/sections/#{section.id}"
          end

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
          it 'does not delete section' do
            get '/sections'
            expect(last_response.body).to include('foosection')
          end
        end
      end
    end
  end

  describe 'listing sections' do
    before do
      create(:admin, name: username, password: password)
      basic_authorize username, password
      create(:section)
      get '/sections'
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(data.size).to eq(1) }
  end

  describe 'adding sections' do
    before do
      create(:admin, name: username, password: password)
      basic_authorize username, password
    end

    context 'passing required params' do
      before do
        post '/sections', title: 'foosection', description: 'some foo'
      end

      it { expect(last_response.content_type).to eq 'application/json' }
      it { expect(last_response.status).to be(200) }
      it { expect(data).to_not include('errors') }

      it 'contains section created' do
        get '/sections'
        expect(last_response.body).to include('foosection')
      end
    end

    context 'without required params' do
      it 'validates title' do
        post '/sections', description: '123123'
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'accepts empty description' do
        post '/sections', title: 'foo'
        expect(last_response.status).to eq 200
        expect(data).to_not include('errors')
      end
    end
  end

  describe 'updating sections' do
    before do
      create(:admin, name: username, password: password)
      basic_authorize username, password
    end

    context 'passing required params' do
      before do
        section = create(:section, title: 'foosection')
        put "/sections/#{section.id}", title: 'newsection', description: 'new'
      end

      it { expect(last_response.content_type).to eq 'application/json' }
      it { expect(last_response.status).to be(200) }
      it { expect(data).to_not include('errors') }

      it 'contains section created' do
        get '/sections'
        expect(last_response.body).to_not include('foosection')
        expect(last_response.body).to include('newsection')
      end
    end

    context 'without required params' do
      it 'validates title' do
        post '/sections', description: '123123'
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'accepts empty description' do
        post '/sections', title: 'foo'
        expect(last_response.status).to eq 200
        expect(data).to_not include('errors')
      end
    end
  end

  describe 'deleting sections' do
    before do
      create(:admin, name: username, password: password)
      basic_authorize username, password
      create(:section, title: 'bazsection')
      section = create(:section, title: 'foosection')
      delete "/sections/#{section.id}"
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(data).to_not include('errors') }

    it 'not contains section deleted' do
      get '/sections'
      expect(last_response.body).to include('bazsection')
      expect(last_response.body).to_not include('foosection')
    end
  end
end
