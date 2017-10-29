require_relative '../lib/awesome_list'
require 'net/http'
require 'faraday'

describe 'formatting the list' do
  let(:readme) { File.open("README.md").read }
  let(:list) { AwesomeList.parse(readme) }

  describe 'summary' do
    context 'sections format' do
      it 'must be in alphabetical order' do
        list.summary.each do |section|
          titles = section.css('>li>a').map { |a| a.children.text.downcase }
          expect(titles).to eq(titles.sort)
        end
      end
    end

    context 'sub sections format' do
      it 'must be in alphabetical order' do
        list.summary.css('>li').each do |subsection|
          titles = subsection.css('li a').map { |a| a.children.text.downcase }
          expect(titles).to eq(titles.sort)
        end
      end
    end
  end

  describe 'projects' do
    context 'sections titles' do
      it 'must be in alphabetical order' do
        titles = list.section_titles.map { |t| t.text.downcase }
        expect(titles).to eq(titles.sort)
      end
    end

    context 'links' do
      it 'must be in alphabetical order' do
        list.projects.each_with_index do |project, i|
          link_texts = project.css('li a').map {|a| a.children.text.downcase }

          expect(link_texts).to eq(link_texts.sort),
            project_sort_error(list.subsection_titles[i-1], link_texts)
        end
      end
    end

    context 'descriptions' do
      it 'must start with captalized letter' do
        list.projects.css('li').each do |project|
          description = project.css('p').last.text

          expect(description).to start_with(description[0].upcase),
            project_format_error(
              project, "Description must start with a capitalized letter."
            )
        end
      end

      it 'must end with a period' do
        list.projects.css('li').each do |project|
          description = project.css('p').last.text

          expect(description.chars.last).to eq('.'),
            project_format_error(
              project, "Description must end with a period."
            )
        end
      end
    end
  end

  private

  def project_format_error(project, motive)
    "Project: #{project.css('p a').children.text} has a wrong format.\n" +
      "Cause: #{motive} \n"+
      "For more details see the CONTRIBUTING.md"
  end

  def project_sort_error(section, links)
    "The links of #{section} are in wrong order.\n" +
      "Expected \n #{links.sort} \n got \n #{links} \n" +
      "For more details see the CONTRIBUTING.md"
  end
end
