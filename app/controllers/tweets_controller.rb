class TweetsController < ApplicationController
  def index
    @tweets = []
    @keyword = ""
    respond_to do |format|
      format.html 
    end
  end

  def search
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = Rails.application.credentials.development[:twitter_consumer_key]
      config.consumer_secret = Rails.application.credentials.development[:twitter_consumer_secret]
    end
    @tweets = []
    @keyword = ""
    since_id = nil
    # 検索ワードが存在したらツイートを取得
    if params[:keyword].present?
      @keyword = params[:keyword]
      # リツイートを除く、検索ワードにひっかかった最新10件のツイートを取得する
      tweets = client.search(params[:keyword], count: 10, result_type: "recent", exclude: "retweets", since_id: since_id)
      # 取得したツイートをモデルに渡す
      tweets.take(10).each do |tw|
        tweet = Tweet.new(tw.full_text)
        @tweets << tweet
      end
    end
    respond_to do |format|
      format.html 
    end
  end

end
