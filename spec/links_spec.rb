require_relative '../lib/awesome_list'
require 'net/http'
require 'faraday'

describe 'links' do
  let(:readme) { File.open("README.md").read }
  let(:list) { AwesomeList.parse(readme) }
  let(:links) { list.projects.css('li a').map { |a| a['href'] } }

  it 'must not appear twice' do
    expect(links).to eq(links.uniq), duplicated_links_error(links)
  end

  it 'must not have broken links' do
    success_status = [ 200, 301, 302 ]
    links.each do |link|
      puts "Trying to reach #{link}"

      response = request(link)

      expect(success_status).to include(response.status),
        broken_links_error(link, response)
    end
  end

  private

  def duplicated_links_error(links)
    duplicated_links = links.detect{ |e| links.count(e) > 1}
    "Links #{duplicated_links} appear more than once on the list."
  end

  def broken_links_error(link, response)
    "Link #{link} seems not be reacheable. Could you double check?. \n" +
      "Status #{response&.status} Cause #{response&.body[0..400]}"
  end

  def request(link)
    begin
      Faraday.new(link, { ssl: { verify: false } }).get('/')
    rescue => e
      fail "Request failed for #{link}. Cause: #{e}"
    end
  end
end
