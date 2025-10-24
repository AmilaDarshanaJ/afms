json.extract! land, :id, :name, :crop_type, :address, :latitude, :longitude, :extent, :harvest_frequency, :boundary_north, :boundary_south, :boundary_east, :boundary_west, :owner_manager_name, :created_at, :updated_at
json.url land_url(land, format: :json)
