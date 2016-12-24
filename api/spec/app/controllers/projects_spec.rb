# frozen_string_literal: true
require 'spec_helper'

describe 'ProjectsController', type: :controller do
  let(:data) { JSON.parse(last_response.body) }

  describe 'authentication' do
    context 'without basic authentication' do
      describe 'get projects' do

        before { get '/projects' }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(200) }
        it { expect(data).to_not include('errors') }
      end

      describe 'create projects' do
        before { post '/projects', title: 'baz', description: 'foo' }

        it { expect(last_response.content_type).to eq 'application/json' }
        it { expect(last_response.status).to be(401) }
        it { expect(data).to eq('errors' => 'Basic Authentication not provided.') }
      end

      describe 'delete projects' do
        before do
          create(:project)
          delete '/projects/1'
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

        describe 'get projects' do
          before { get '/projects' }

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(200) }
          it { expect(data).to_not include('errors') }
        end

        describe 'create projects' do
          before { post '/projects', title: 'roy', description: 'foo' }

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
        end

        describe 'delete projects' do
          before do
            project = create(:project, title: 'fooproject')
            delete "/projects/#{project.id}"
          end

          it { expect(last_response.content_type).to eq 'application/json' }
          it { expect(last_response.status).to be(401) }
          it { expect(data).to eq('errors' => 'User not authorized.') }
          it 'does not delete project' do
            get '/projects'
            expect(last_response.body).to include('fooproject')
          end
        end
      end
    end
  end

  describe 'listing projects' do
    before do
      create(:admin, name: 'jonh', password: '123')
      basic_authorize 'jonh', '123'
      create(:project)
      get '/projects'
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(data.size).to eq(1) }
    it 'accepts optional params' do
      subsection = create(:subsection)
      create(:project, title: 'some', subsection: subsection)
      create(:project, title: 'other', subsection: subsection)
      create(:project)

      get "subsections/#{subsection.id}/projects"

      expect(data['data'].size).to eq(2)
    end
  end

  describe 'adding projects' do
    let(:user)  { create(:admin, name: 'jonh', password: '123') }
    let(:subsection) { create(:subsection) }

    before do
      basic_authorize user.name, '123'
    end

    context 'passing required params' do
      before do
        post '/projects', { title: 'fooproject',
                            link: 'http://somlink',
                            description: 'some foo',
                            subsection: subsection.id }
      end

      it { expect(last_response.content_type).to eq 'application/json' }
      it { expect(last_response.status).to be(200) }
      it { expect(data).to_not include('errors') }

      it 'contains project created' do
        get '/projects'
        expect(last_response.body).to include('fooproject')
      end

      it 'uses the current user as author' do
        get '/projects'
        expect(data['data'].first['attributes']['author']['id']).to eq(user.id)
      end
    end

    context 'without required params' do
      it 'validates title' do
        post '/projects', description: '123123'
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'validates description' do
        post '/projects', title: 'foo', subsection: subsection.id
        expect(last_response.status).to eq 400
        expect(data).to include('errors')
      end

      it 'accepts empty languages' do
        post '/projects', { title: 'foo',
                            link: 'http://somlink',
                            description: 'foodescription',
                            subsection: subsection.id }

        expect(last_response.status).to eq 200
        expect(data).to_not include('errors')
      end
    end
  end

  describe 'deleting projects' do
    let(:jonh) { create(:admin, name: 'jonh', password: '123') }

    before do
      basic_authorize 'jonh', '123'
      create(:project, title: 'bazproject')
      project = create(:project, title: 'fooproject', author_id: jonh.id)
      delete "/projects/#{project.id}"
    end

    it { expect(last_response.content_type).to eq 'application/json' }
    it { expect(last_response.status).to be(200) }
    it { expect(data).to_not include('errors') }

    it 'not contains project deleted' do
      get '/projects'
      expect(last_response.body).to include('bazproject')
      expect(last_response.body).to_not include('fooproject')
    end

    it 'validates the author when common user' do
      create(:user, name: 'bob', password: '123')
      basic_authorize 'bob', '123'
      jonh_project = create(:project, author_id: jonh.id)
      delete "/projects/#{jonh_project.id}"

      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.status).to be(405)
      expect(data).to include('errors')
    end

    it 'accepts deletion of others when admin' do
      create(:admin, name: 'bob', password: '123')
      basic_authorize 'bob', '123'
      jonh_project = create(:project, author_id: jonh.id)
      delete "/projects/#{jonh_project.id}"

      expect(last_response.content_type).to eq 'application/json'
      expect(last_response.status).to be(200)
      expect(data).to_not include('errors')
    end
  end
end
