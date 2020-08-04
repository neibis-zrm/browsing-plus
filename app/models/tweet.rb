require 'net/http'
require 'open-uri'
require 'uri'
require 'mechanize'

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
        @hyperlink = expand_urlnode(hyperlink.to_s)
      elsif contents.include?("https://")
        @contents = contents.gsub(%r{https?://[\w_.!*\/')(-]+},"")
        hyperlink = contents.match(%r{https?://[\w_.!*\/')(-]+})
        @hyperlink = expand_urlnode(hyperlink.to_s)
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

  def expand_urlnode(url)

    mecha = Mechanize.new
    mecha.redirect_ok = false
    begin
      response = mecha.get(url)
      status_code = response.code
      if status_code[/3\d\d/]
        return expand_urlnode(response.header['location'])
      else
        @title = response.search('title').inner_text
        return url
      end
    rescue => error
      logger.error(error)
      @title = ""
      return url
    end

  end

end
