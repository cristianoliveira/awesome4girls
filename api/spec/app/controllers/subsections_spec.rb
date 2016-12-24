# frozen_string_literal: true
require 'spec_helper'

describe 'SubsectionsController', type: :controller do
  let(:username) { 'jonh' }
  let(:password) { '123123' }
  let(:subsection) { create(:subsection) }
  let(:section) { create(:section, title: 'foosection') }
  let(:data) { JSON.parse(last_response.body) }

  describe 'authentication' do
    context 'without basic authentication' do
      describe 'get subsections' do
        before { get '/subsections' }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(200) }
        it { expect(data).to_not include('errors') }
      end

      describe 'create subsections' do
        before do
          post '/subsections', title: 'baz', description: 'foo'
        end

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      describe 'update subsections' do
        before do
          put "/subsections/#{subsection.id}", title: 'baz', description: 'foo'
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

        describe 'get subsections' do
          before { get '/subsections' }

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
            put "/subsections/#{subsection.id}", title: 'baz', description: 'foo'
          end

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end

        describe 'delete sections' do
          before do
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
      create(:admin, name: 'jonh', password: '123')
      basic_authorize 'jonh', '123'
      create(:subsection)
      create(:subsection)
      get '/subsections'
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(last_response.body).to include('subsections') }
    it { expect(data['data'].size).to eq(2) }
  end

  describe 'adding sections' do
    before do
      create(:admin, name: 'jonh', password: '123')
      basic_authorize 'jonh', '123'
    end

    context 'passing required params' do
      before do
        section = create(:section)
        post('/subsections',
             title: 'foosection', description: 'some foo', section: section.id)
      end

      it { expect(last_response.content_type).to eq 'application/json' }
      it { expect(last_response.status).to be(200) }
      it { expect(data).to_not include('errors') }

      it 'contains section created' do
        get '/subsections'
        expect(last_response.body).to include('foosection')
      end
    end

    context 'without required params' do
      let(:section) { create(:section) }

      it 'validates title' do
        post '/subsections', description: '123123', section: section.id
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'accepts empty description' do
        post '/subsections', title: 'foo', section: section.id
        expect(last_response.status).to eq 200
        expect(data).to_not include('errors')
      end
    end
  end

  describe 'updating sections' do
    before do
      create(:admin, name: 'jonh', password: '123')
      basic_authorize 'jonh', '123'
    end

    context 'passing required params' do
      before do
        section = create(:section)
        subsection = create(:subsection, title: 'foosubsction', section: section)
        put("/subsections/#{subsection.id}",
            title: 'newsubsection', description: 'foo', section: section.id)
      end

      it { expect(last_response.content_type).to eq 'application/json' }
      it { expect(last_response.status).to be(200) }
      it { expect(data).to_not include('errors') }

      it 'contains section created' do
        get '/subsections'
        expect(last_response.body).to_not include('foosubsction')
        expect(last_response.body).to_not include('newsubsction')
      end
    end
  end

  describe 'deleting sections' do
    before do
      create(:admin, name: username, password: password)
      basic_authorize username, password

      create(:subsection, title: 'baz')
      subsection = create(:subsection, title: 'foo')
      delete "/subsections/#{subsection.id}"
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(data).to_not include('errors') }

    it 'not contains section deleted' do
      get '/subsections'
      expect(last_response.body).to include('baz')
      expect(last_response.body).to_not include('foo')
    end
  end
end
