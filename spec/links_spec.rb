require_relative '../lib/parser'
require 'net/http'
require 'faraday'

describe 'links' do
  let(:readme) { File.open("README.md").read }
  let(:list) { AwesomeListRender.parse(readme) }

  it 'must not appear twice' do
    list_links = list.project_links.map { |l| l.map{|ll| ll['href'] }}.flatten
    expect(list_links).to eq(list_links.uniq), duplicated_links_error(list_links)
  end

  it 'must not have broken links' do
    success_status = [ 200, 301, 302 ]
    links = list.project_links.map { |l| l.map{|ll| ll['href'] }}.flatten

    links.each do |link|
      puts "Trying to reach #{link}"

      res = request(link)

      expect(success_status).to include(res.status), broken_links_error(link, res)
    end
  end

  private

  def duplicated_links_error(links)
    duplicateds = links.detect{ |e| links.count(e) > 1}
    "Links #{duplicateds} appear more than once on the list."
  end

  def broken_links_error(link, response)
    "Link #{link} seems not be reacheable. Could you double check?. \n" +
      "Status #{response.status} Cause #{response.body[0..400]}"
  end

  def request(link)
    Faraday.get do |req|
      req.url link
      req.params['User-Agent']  = 'Awesome4Girls test script'
    end
  end
end
