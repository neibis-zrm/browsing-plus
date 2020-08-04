require 'net/http'
require 'open-uri'
require 'uri'

class Tweet < ApplicationRecord
  # 初期化
  @contents = ""
  @hyperlink = ""
  @title = ""

  begin
    def initialize(contents)
      if contents.include?("http://")
        @contents = contents.gsub(%r{http?://[\w_.!*\/')(-]+}, "")
        hyperlink = contents.match(%r{http?://[\w_.!*\/')(-]+})
        @hyperlink = expand_url(hyperlink)
        @title = expand_node(@hyperlink.to_s)
      elsif contents.include?("https://")
        @contents = contents.gsub(%r{https?://[\w_.!*\/')(-]+},"")
        hyperlink = contents.match(%r{https?://[\w_.!*\/')(-]+})
        @hyperlink = expand_url(hyperlink.to_s)
        @title = expand_node(@hyperlink.to_s)
      else
        @contents = ""
        @hyperlink = ""
        @title = contents
      end
    end
  rescue => error
    logger.debug(error)
  end

  def contents
    return @contents
  end

  def hyperlink
    return @hyperlink
  end

  def title
    return @title
  end

  private

  def expand_url(url)
    begin
      response = Net::HTTP.get_response(URI.parse(url))
    rescue
      return url
    end
    case response
    when Net::HTTPRedirection
      expand_url(response['location'])
    else
      url
    end
  end

  def expand_node(url)  

    begin
      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end
      # htmlをパース(解析)してオブジェクトを作成
      doc = Nokogiri::HTML.parse(html, nil, charset)
      # タイトルの取得
      return doc.title
    rescue => error
      logger.debug(error)
      return ""
    end

  end
end
