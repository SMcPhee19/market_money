# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe 'relationships' do
    it { should have_many(:market_vendors) }
    it { should have_many(:markets).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
  end

  it 'credit_accepted_presence' do
    vendor = Vendor.new

    vendor.validate
    expect(vendor.errors[:credit_accepted]).to include('must be provided')

    vendor.credit_accepted = true
    vendor.validate
    expect(vendor.errors[:credit_accepted]).to be_empty

    vendor.credit_accepted = false
    vendor.validate
    expect(vendor.errors[:credit_accepted]).to be_empty
  end
end
