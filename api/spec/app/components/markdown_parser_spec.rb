# frozen_string_literal: true
require 'spec_helper'

describe 'MarkdownParserSpec', type: :lib do
  let(:markdown) do
    path = File.join(File.dirname(__FILE__), '..', '..', 'fixtures/README.md')
    File.open(path).read
  end

  describe 'to_hash' do
    context 'parsing texts' do
      let(:markdown) do
        <<~EOF
# TitleLevel1
  description1

## TitleLevel2
  description2

### TitleLevel3
  description3

      EOF
      end
      subject(:json) { MarkdownParser.to_hash(markdown) }

      it { expect(json.size).to be(3) }

      it { expect(json.first).to include('text' => 'TitleLevel1') }
      it { expect(json.first).to include('description' => 'description1') }
      it { expect(json.first).to include('level' => 1) }

      it { expect(json.second).to include('text' => 'TitleLevel2') }
      it { expect(json.second).to include('description' => 'description2') }
      it { expect(json.second).to include('level' => 2) }

      it { expect(json.last).to include('text' => 'TitleLevel3') }
      it { expect(json.last).to include('description' => 'description3') }
      it { expect(json.last).to include('level' => 3) }
    end

    context 'parsing texts with links' do
      let(:markdown) do
        <<~EOF
# TitleLevel1

  text description1

## TitleLevel1

  text description2

  - [link1](http://somelink.com/1)

    link description1

  - [link2](http://somelink.com/2)

    link description2

## TitleLevel3
  text description3

  - [link1](http://somelink.com/1)

    link description3

  - [link2](http://somelink.com/2)

    link description4
EOF
      end
      subject(:json) { MarkdownParser.to_hash(markdown) }

      it { expect(json.first).to include('items' => []) }

      it do
        expect(json.second).to include('items' =>
        [
          {
            'link' => { 'href' => 'http://somelink.com/1', 'text' => 'link1' },
            'description' => 'link description1'
          },
          {
            'link' => { 'href' => 'http://somelink.com/2', 'text' => 'link2' },
            'description' => 'link description2'
          }
        ])
      end

      it do
        expect(json.last).to include('items' =>
        [
          {
            'link' => { 'href' => 'http://somelink.com/1', 'text' => 'link1' },
            'description' => 'link description3'
          },
          {
            'link' => { 'href' => 'http://somelink.com/2', 'text' => 'link2' },
            'description' => 'link description4'
          }
        ])
      end
    end
  end
end
