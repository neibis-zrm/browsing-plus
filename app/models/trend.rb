class Trend < ApplicationRecord

  #各地域の設定
  areas = []
  areas << {woeid: 23424856, name: "Japan"}
  areas << {woeid: 23424977, name: "United States"}

  AREA_DATA = areas

end
