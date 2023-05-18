class TomTomService
  def self.conn
    Faraday.new(url: 'https://api.tomtom.com/') do |f|
      f.params['key'] = ENV['TOMTOM_KEY']
    end
  end

  def self.get_atms(lat, lon)
    JSON.parse(conn.get("/search/2/categorySearch/atm.json?lat=#{lat}&lon=#{lon}").body, symbolize_names: true)
  end
end