class Tweet < ApplicationRecord
  # @contentsを直接アクセス出来るように
  attr_accessor :contents

  def initialize(contents)
    @contents = contents
  end
end
