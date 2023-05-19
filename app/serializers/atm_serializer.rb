class AtmSerializer
  include JSONAPI::Serializer

  attributes :name, :address, :lat, :lon, :distance
  set_id :id
end
