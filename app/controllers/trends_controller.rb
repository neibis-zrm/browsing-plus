class TrendsController < ApplicationController
  def index
    client = access_key()
    @trendtree = []

    # 日本リージョンのトレンドを取得
    trends = client.trends_place(23424856)
    trendnames = []
    trends.attrs[:trends].each do |trend|
      trendnames << trend[:name]
    end
    @trendtree << {region: "Japan", trends: trendnames}

    # アメリカリージョンのトレンドを取得
    trends = client.trends_place(23424977)
    trendnames = []
    trends.attrs[:trends].each do |trend|
      trendnames << trend[:name]
    end
    @trendtree << {region: "United States", trends: trendnames}

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
