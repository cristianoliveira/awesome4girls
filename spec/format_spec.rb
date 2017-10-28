require_relative '../lib/parser'
require 'net/http'
require 'faraday'

describe 'formatting' do
  let(:readme) { File.open("README.md").read }
  let(:list) { AwesomeListRender.parse(readme) }

  describe 'summary display' do
    context 'sections' do
      it 'must be in alphabetical order' do
        list.summary.each do |section|
          titles = section.css('>li>a').map{|a| a.children.text }
          expect(titles).to eq(titles.sort)
        end
      end
    end

    context 'sub sections' do
      it 'must be in alphabetical order' do
        list.summary.css('>li').each do |subsection|
          titles = subsection.css('li a').map{|a| a.children.text }
          expect(titles).to eq(titles.sort)
        end
      end
    end
  end

  describe 'projects display' do
    context 'sections titles' do
      it 'must be in alphabetical order' do
        titles = list.section_titles.map { |t| t.text }
        expect(titles).to eq(titles.sort)
      end
    end

    context 'links' do
      it 'must be in alphabetical order' do
        list.project_links.each_with_index do |plinks, i|
          link_texts = plinks.map{|a| a.children.text}

          expect(link_texts).to eq(link_texts.sort),
            project_sort_error(list.subsection_titles[i], link_texts)
        end
      end
    end
  end

  private

  def project_sort_error(section, links)
    "The links of one sections are in wrong order.\n" +
      "Expected \n #{links.sort} \n got \n #{links}"
  end
end
