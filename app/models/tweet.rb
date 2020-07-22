class Tweet < ApplicationRecord
  # @contentsを直接アクセス出来るように
  # attr_accessor :contents
  # attr_accessor :hyperlink

  def initialize(contents)
    if contents.include?("http://")
      @contents = contents.gsub(%r{http?://[\w_.!*\/')(-]+}, "")
      hyperlink = contents.match(%r{http?://[\w_.!*\/')(-]+})
    elsif contents.include?("https://")
      @contents = contents.gsub(%r{https?://[\w_.!*\/')(-]+},"")
      hyperlink = contents.match(%r{https?://[\w_.!*\/')(-]+})
    else
      @contents = contents
      hyperlink = ""
    end
    @hyperlink = hyperlink
  end

  def contents
    return @contents
  end

  def hyperlink
    return @hyperlink
  end

end
