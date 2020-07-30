class TweetsController < ApplicationController
  def index
    @tweets = []
    # cookies[:history_keyword] = nil
    history_check()
    @keywords = cookies[:history_keyword]
    @keyword = ""
    respond_to do |format|
      format.html 
    end
  end

  def search
    client = access_key()
    @tweets = []
    history_check()
    @keywords = cookies[:history_keyword]
    since_id = nil
    # 検索ワードが存在したらツイートを取得
    if params[:keyword].present?
      @keyword = params[:keyword]
      cookies[:history_keyword] << params[:keyword]
      @keywords = cookies[:history_keyword]
      # リツイートを除く、検索ワードにひっかかった最新10件のツイートを取得する
      tweets = client.search(params[:keyword], count: 10, result_type: "recent", exclude: "retweets", since_id: since_id)
      # 取得したツイートをモデルに渡す
      tweets.take(10).each do |tw|
        if (tw.full_text =~ /http:\/\/|https:\/\//) then
          tweet = Tweet.new(tw.full_text)
          unless (tweet.hyperlink =~ /https:\/\/twitter.com/) then
            @tweets << tweet
          end
        end
      end
    end
    respond_to do |format|
      format.html 
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

end
