class Trend < ApplicationRecord

  #各地域の設定
  areas = []
  areas << {woeid: 23424856, name: "Japan", id: 1}
  areas << {woeid: 1118370, name: "Tokyo", id: 2}
  areas << {woeid: 15015370, name: "Osaka", id: 3}
  areas << {woeid: 1117817, name: "Nagoya", id: 4}
  areas << {woeid: 1118108, name: "Sapporo", id: 5}
  areas << {woeid: 1118129, name: "Sendai", id: 6}
  areas << {woeid: 1117099, name: "Fukuoka", id: 7}
  areas << {woeid: 2345896, name: "Okinawa", id: 8}
  areas << {woeid: 23424977, name: "United States", id: 9}

  AREA_DATA = areas

end
