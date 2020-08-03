class TrendsController < ApplicationController
  def index
    client = access_key()
    @trendtree = []

    # 各リージョンのトレンドを取得
    Trend::AREA_DATA.each do |area|
      trends = client.trends_place(area[:woeid])
      trendnames = []
      trends.attrs[:trends].each do |trend|
        trendnames << trend[:name]
      end
      @trendtree << {region: area[:name], trends: trendnames}
    end

  end

  private

  def access_key()
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.development[:twitter_consumer_key]
      config.consumer_secret = Rails.application.credentials.development[:twitter_consumer_secret]
    end
    return client
  end
end
