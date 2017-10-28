require 'redcarpet'
require 'nokogiri'

class AwesomeListRender
  def self.parse(markdown)
    renderer = Redcarpet::Render::HTML.new
    html = Redcarpet::Markdown.new(renderer).render(markdown)
    self.new(html)
  end

  def initialize(html)
    @raw = html
    @html = Nokogiri::HTML(html)
  end

  def links
    @html.css('a')
  end

  def project_links
    @html.css('li a').select { |link| !internal?(link) }
  end

  def internal_links
    @html.css('li a').select { |link| internal?(link) }
  end

  def to_html
    @raw
  end

  private

    def internal?(link)
      link['href'][0] == '#'
    end
end
