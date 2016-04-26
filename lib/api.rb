require 'json'

module Api
  extend ActiveSupport::Concern

  private

  def get(url)
    Net::HTTP.get make_uri(url)
  end

  def post(url, body={})
    Net::HTTP.post_form make_uri(url), body

  end

  def parse(response)
    if response.class == String
      JSON.parse response
    else
      JSON.parse response.body
    end
  end

  def make_uri(url)
    URI(url)
  end

  def build_uri(api_url, path, id)
    api_url + path + "?hipchat_id=#{id}"
  end

end