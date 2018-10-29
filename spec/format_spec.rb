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

          expect(link_texts).to eq(link_texts.sort), project_sort_error(link_texts)
        end
      end

      it 'must not have trailling spaces' do
        list.projects.each_with_index do |project, i|
          link_texts = project.css('li a').map {|a| a.children.text.downcase }

          link_texts.each do |text|
            expect(text).to eq(text.strip),
              "Make sure your text editor is set to remove trailing whitespace. \n" +
              "Text: #{text}"
          end
        end
      end
    end

    context 'descriptions' do
      it 'must start with captalized letter' do
        list.projects.css('li').each do |project|

          expect(project.css('p').last).to_not be_nil,
            "Expected to have a paragraph (empty line) after the link for description."

          description = project.css('p').last.text
          description = description.strip

          expect(description).to start_with(description[0].upcase),
            project_format_error(
              project, "Description must start with a capitalized letter."
            )
        end
      end

      it 'must end with a period' do
        list.projects.css('li').each do |project|

          expect(project.css('p').last).to_not be_nil,
            "Expected to have a paragraph (empty line) after the link for description."

          description = project.css('p').last.text
          description = description.strip

          expect(description.chars.last).to eq('.'),
            project_format_error(
              project, "Description must end with a period."
            )
        end
      end

      it 'must not have trailling spaces' do
        list.projects.css('li').each do |project|
          description = project.css('p').last.text

          expect(description).to eq(description.strip),
            project_format_error(
              project,
              "Make sure your text editor is set to remove trailing whitespace."
            )
        end
      end
    end

    it 'must have a link and description' do
      list.projects.css('li').each do |project|

        blocks = project.css('p')
        expect(blocks.size).to eq(2),
          must_have_error("a valid link and description", project)

        link  = blocks[0].css('a')
        expect(link).to_not be_empty,
          must_have_error("a valid link", project)

        expect(blocks.last.text).to_not be_nil,
          must_have_error("a paragraph for description", project)
      end
    end
  end

  private

  def must_have_error(message, html)
    "Each project must have #{message}. Looks like it doesn't have. \n" +
      "HTML: #{html}\n\n"+
      "Make sure to follow the correct template: \n\n"+
      "(2 spaces)-(link and title) \n"+
      "(empty line)\n"+
      "(4 spaces)(description)\n"+
      "(empty line)\n\n"+
      "For more details see the CONTRIBUTING.md"
  end

  def project_format_error(project, motive)
    "Project: #{project.css('p a').children.text} has a wrong format.\n" +
      "Cause: #{motive} \n"+
      "For more details see the CONTRIBUTING.md"
  end

  def project_sort_error(links)
    "The links of a section are in wrong order.\n" +
      "Expected \n #{links.sort} \n got \n #{links} \n" +
      "For more details see the CONTRIBUTING.md"
  end
end
