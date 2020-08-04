class TrendsController < ApplicationController
  def index
    client = access_key()
    @setoptions = setvalue_check() 
    @trendtree = []

    # 各リージョンのトレンドを取得
    Trend::AREA_DATA.each do |area|
      if @setoptions[:trendsetting].include?(area[:id].to_s) then
        trends = client.trends_place(area[:woeid])
        trendnames = []
        trends.attrs[:trends].each do |trend|
          trendnames << trend[:name]
        end
        @trendtree << {region: area[:name], trends: trendnames}
      end
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
