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

  def setvalue_check()
    #設定値なしの場合は初期値を作成
    if cookies[:option] == nil then
      cookies[:option] = "searchvalue=10&searchorder=1&searchdisplay=1&displaybgc=1&trendsetting=1|9"
    end

    #初期化
    setoptions = {searchvalue: 10, searchorder: 1, searchdisplay: 1,displaybgc: 1,trendsetting: [1,9]}

    #分解
    begin      
      cookies[:option].split("&").each do |optionname|
        if optionname.split("=")[0] == "searchvalue"
          setoptions[:searchvalue] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "searchorder"
          setoptions[:searchorder] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "searchdisplay"
          setoptions[:searchdisplay] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "displaybgc"
          setoptions[:displaybgc] = optionname.split("=")[1].to_i
        end
        if optionname.split("=")[0] == "trendsetting"
          setoptions[:trendsetting] = optionname.split("=")[1].split("|")
        end
      end
    rescue => exception
      logger.debug(exception)
    end

    return setoptions

  end
end
