require 'json'

module Api
  extend ActiveSupport::Concern

  private

  def get(url)
    HTTParty.get make_uri(url)
  end

  def post(url, body={})
    HTTParty.post make_uri(url), {body: body}
  end

  def delete(url)
    HTTParty.delete make_uri(url)
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
    api_key = Settings.config['api']['key']
    api_url + path + "?api_key=#{api_key}&hipchat_id=#{id}"
  end

  def valid_api_key?(request)
    request.params['api_key'] == Settings.config['api']['key']
  end

end