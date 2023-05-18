class MarketsFacade
  def self.market_search(name, city, state)
    Market.where("name ILIKE ? AND city ILIKE ? AND state ILIKE ?", "%#{name}%", "%#{city}%", "%#{state}%")
  end
end