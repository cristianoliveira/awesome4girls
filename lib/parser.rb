require 'redcarpet'
require 'nokogiri'

class AwesomeListRender
  def self.parse(markdown)
    renderer = Redcarpet::Render::HTML.new
    html = Redcarpet::Markdown.new(renderer).render(markdown)
    self.new(html)
  end

  attr_reader :raw_html

  def initialize(html)
    @raw_html = html
    @html = Nokogiri::HTML(html)
  end

  def links
    @html.css('a')
  end

  def summary
    @html.css('body>ul:first')
  end

  def section_titles
    @html.css('body>h2')[1..100]
  end

  def subsection_titles
    @html.css('body>h3')
  end

  def project_links
    @html.css('ul')[1..100].map{|list| list.css('>li a')
      .select{|l| !internal?(l)}}
  end

  def internal_links
    @html.css('li a').select { |link| internal?(link) }
  end

  private

    def internal?(link)
      link['href'].start_with?('#')
    end
end
