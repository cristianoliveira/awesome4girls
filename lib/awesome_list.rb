require 'redcarpet'
require 'nokogiri'

class AwesomeList

  LIST_DESCRIPTION_SECTION = 0
  SUMMARY_SECTION = 1
  PROJECT_SECTION = 2
  LICENSE_SECTION = 3

  def self.parse(markdown)
    renderer = Redcarpet::Render::HTML.new
    raw_html = Redcarpet::Markdown.new(renderer).render(markdown)
    self.new(raw_html)
  end

  attr_reader :raw_html

  def initialize(raw_html)
    @raw_html = raw_html
  end

  def links
    html.css('a')
  end

  def summary
    html_sections(SUMMARY_SECTION).css('ul')
  end

  def section_titles
    html_sections(PROJECT_SECTION).css('h2')
  end

  def subsection_titles
    html_sections(PROJECT_SECTION).css('h3')
  end

  def project_links
    html_sections(PROJECT_SECTION).css('li a').select { |l| !internal?(l) }
  end

  def projects
    html_sections(PROJECT_SECTION).css('ul')
  end

  def internal_links
    html.css('li a').select { |link| internal?(link) }
  end

  private

    def html
      Nokogiri::HTML(@raw_html)
    end

    def html_sections(section)
      Nokogiri::HTML(@raw_html.split('<hr>')[section])
    end

    def internal?(link)
      link['href'].start_with?('#')
    end
end
