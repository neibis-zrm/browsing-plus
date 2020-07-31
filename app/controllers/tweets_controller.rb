class TweetsController < ApplicationController
  def index
    @tweets = []
    # cookies[:history_keyword] = nil
    history_check()
    @setoptions = setvalue_check()    
    @keywords = cookies[:history_keyword]
    @keyword = ""
    respond_to do |format|
      format.html 
      format.json
    end
  end

  def search

    #API接続
    client = access_key()

    #初期化
    @tweets = []
    history_check()
    @setoptions = setvalue_check()    
    @keywords = cookies[:history_keyword]
    searchtype = "recent"
    since_id = nil

    # 検索ワードが存在したらツイートを取得
    if params[:keyword].present?
      @keyword = params[:keyword]
      cookies[:history_keyword] << params[:keyword]
      @keywords = cookies[:history_keyword]
      if @setoptions[:searchorder] == 1 then
        searchtype = "recent"
      elsif @setoptions[:searchorder] == 2 then
        searchtype = "popular"
      end
      # リツイートを除く、検索ワードにひっかかったツイートを取得する
      tweets = client.search(params[:keyword], count: @setoptions[:searchvalue], result_type: searchtype, exclude: "retweets", since_id: since_id)
      # 取得したツイートをモデルに渡す
      tweets.take(@setoptions[:searchvalue]).each do |tw|
        if @setoptions[:searchdisplay] == 1 then
          #httpが付いているツイートのみを取得
          if (tw.full_text =~ /http:\/\/|https:\/\//) then
            tweet = Tweet.new(tw.full_text)
            unless (tweet.hyperlink =~ /https:\/\/twitter.com/) then
              @tweets << tweet
            end
          end
        else
          #全取得
          tweet = Tweet.new(tw.full_text)
          @tweets << tweet
        end
      end
    end
    respond_to do |format|
      format.html 
      format.json
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

  def history_check()

    if (cookies[:history_keyword] == "") || (cookies[:history_keyword] == nil) then
      cookies[:history_keyword] = []
    else
      cookies[:history_keyword] = cookies[:history_keyword].split("&")
    end
  end

  def setvalue_check()
    #設定値なしの場合は初期値を作成
    if cookies[:option] == nil then
      cookies[:option] = "searchvalue=10&searchorder=1&searchdisplay=1&displaybgc=1"
    end

    #初期化
    setoptions = {searchvalue: 10, searchorder: 1, searchdisplay: 1,displaybgc: 1}

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
      end
    rescue => exception
      logger.debug(exception)
    end

    return setoptions

  end

end
