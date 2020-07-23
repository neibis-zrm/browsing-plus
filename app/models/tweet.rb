require 'net/http'
require 'uri'

class Tweet < ApplicationRecord
  # 初期化
  @contents = ""
  @hyperlink = ""

  def initialize(contents)
    if contents.include?("http://")
      @contents = contents.gsub(%r{http?://[\w_.!*\/')(-]+}, "")
      hyperlink = contents.match(%r{http?://[\w_.!*\/')(-]+})
      @hyperlink = expand_url(hyperlink)
    elsif contents.include?("https://")
      @contents = contents.gsub(%r{https?://[\w_.!*\/')(-]+},"")
      hyperlink = contents.match(%r{https?://[\w_.!*\/')(-]+})
      @hyperlink = expand_url(hyperlink.to_s)
    else
      @contents = contents
      @hyperlink = ""
    end
  end

  def contents
    return @contents
  end

  def hyperlink
    return @hyperlink
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

end
