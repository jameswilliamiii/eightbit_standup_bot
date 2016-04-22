module Api
  extend ActiveSupport::Concern

  private

  def get(url)
    Net::HTTP.get make_uri(url)
  end

  def parse(obj)
    MultiJson.load(obj)
  end

  def make_uri(url)
    URI(url)
  end

  def build_uri(api_url, path, id)
    api_url + path + "?hipchat_id=#{id}"
  end
end