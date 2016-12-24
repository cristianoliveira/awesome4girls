# frozen_string_literal: false
require 'kramdown'

# Markdown Parser.
#
# It parses markdown to formatted hash.
class MarkdownParser
  def self.to_hash(markdown)
    doc = Kramdown::Document.new(markdown).to_data
    JSON.parse(doc)
  end
end

module Kramdown
  module Converter
    # Markdown Converter implementation.
    #
    # It converts an Markdown in formatted data.
    class Data < Base
      def initialize(root, options)
        super(root, options)
        @sections = []
      end

      # Converts markdown in a formatted data.
      #
      def convert(root)
        root.children.map do |element|
          method = "convert_#{element.type}"
          send(method, element) if respond_to?(method)
        end.compact.flatten

        JSON.generate(@sections)
      end

      # Converts markdown header in a section item
      #
      def convert_header(element)
        @sections.push(
          text: element.options[:raw_text],
          level: element.options[:level],
          description: extract_text(element.children.pop),
          items: []
        )
      end

      # Converts markdown ul in a section item "Project"
      #
      def convert_ul(element)
        element.children.each do |li|
          @sections.last[:items].push(extract_list(li))
        end
      end

      # Converts a p element in a description section.
      #
      def convert_p(element)
        @sections.last.merge!(extract_p(element))
      end

      # Extracts a link from a given element.
      #
      def extract_link(element)
        {
          href: element.attr['href'],
          text: extract_text(element.children.first)
        }
      end

      def extract_text(element)
        element.value
      end

      def extract_list(element)
        element.children.map { |e| extract_p(e) }.inject({}) do |acc, elem|
          acc.merge(elem)
        end
      end

      def extract_p(element)
        item = {}
        element.children.each do |el|
          case el.type
          when :a
            item[:link] = extract_link(el)
          when :text
            item[:description] = extract_text(el)
          end
        end
        item
      end
    end
  end
end
