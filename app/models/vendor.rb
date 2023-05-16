# frozen_string_literal: true

class Vendor < ApplicationRecord
  has_many :market_vendors
  has_many :markets, through: :market_vendors

  validates_presence_of :name, :description, :contact_name, :contact_phone
  validate :credit_accepted_presence

  private
  def credit_accepted_presence
    unless credit_accepted == true || credit_accepted == false
      errors.add(:credit_accepted, 'must be provided') 
    end
  end
end
