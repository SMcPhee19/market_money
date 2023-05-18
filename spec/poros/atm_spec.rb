require 'rails_helper'

RSpec.describe Atm do
  it 'exists with attributes' do
    atm1 = Atm.new({name: "random-atm",
      address: "123 Main St",
      lat: 40.51550763111285,
      lon: -105.02115891053056,
      distance: 112.030111})

    expect(atm1).to be_a(Atm)
    expect(atm1.name).to eq("random-atm")
    expect(atm1.address).to eq("123 Main St")
    expect(atm1.lat).to eq(40.51550763111285)
    expect(atm1.lon).to eq(-105.02115891053056)
    expect(atm1.distance).to eq(112.030111)
  end
end