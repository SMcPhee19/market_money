# frozen_string_literal: true

class TomTomFacade
  attr_reader :location

  def initialize(location)
    @location = location
  end

  def atms
    create_atm(atm_format)
  end

  private

  def service
    @service ||= TomTomService.new
  end

  def atm_data
    @atm_data ||= service.get_atms(@location.latitude, @location.longitude)
  end

  def create_atm(atms)
    atms.map do |atm|
      Atm.new(atm)
    end
  end

  def atm_format
    atms = atm_data[:results]
    atms.map do |atm|
      data = {
        name: atm[:poi][:name],
        address: atm[:address][:freeformAddress],
        lat: atm[:position][:lat],
        lon: atm[:position][:lon],
        distance: atm[:dist]
      }
    end
  end
end
