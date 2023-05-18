require 'rails_helper'

RSpec.describe TomTomService do
  it 'can create a connnection, and get_atms', :vcr do
    atms = TomTomService.get_atms(39.750783, -104.996435)
    expect(atms).to be_a(Hash)
  end
end