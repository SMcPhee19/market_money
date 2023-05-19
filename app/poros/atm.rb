class Atm
  attr_reader :name,
              :address,
              :lat,
              :lon,
              :distance,
              :id

  def initialize(data)
    @name = data[:name]
    @address = data[:address]
    @lat = data[:lat]
    @lon = data[:lon]
    @distance = data[:distance]
    @id = nil
  end
end
