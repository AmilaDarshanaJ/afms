puts "🌱 Starting deployment seeding..."

# 1. Create/Find the Demo User
default_user = User.find_or_create_by!(email_address: "afms.demo@frmcore.com") do |u|
  u.password = "Omed@123!"
  u.role = 1
end

puts "✅ User: afms.demo@frmcore.com"
puts "✅ Password:Omed@123!"

# 2. Create Crop Type
coconut = CropType.find_or_create_by!(name: "Coconut") do |c|
  c.description = "Versatile tropical fruit used for food and oil."
  c.unit = "Nuts"
end

puts "✅ Crop Type: Coconut"

# 3. Create Land
_land = Land.find_or_create_by!(name: "Silver Palm Plantation") do |l|
  l.crop_type = "Coconut"
  l.address = "Kadirapola,Narangoda"
  l.latitude = 7.33177
  l.longitude = 80.12332
  l.extent = 10.5
  l.boundary_north = "Main Road"
  l.boundary_south = "Padddy Field"
  l.boundary_east = "Anura's Land"
  l.boundary_west = "Play Ground"
  l.owner_manager_name = "Amila Darshana"
end

puts "✅ Land: Silver Palm Plantation"

# 4. Create Harvest
Harvest.find_or_create_by!(land_id: _land.id) do |h|
  h.actual_date = Date.today - 2.days
  h.planned_date = Date.today - 3.days
  h.unit = "Nuts"
  h.crop_type = "Coconut"
  h.amount = 2500
end

puts "✅ Harvest: Silver Palm Plantation - 2500 Nuts"

# 5. Create Activity

Activity.find_or_create_by!(land_id: _land.id) do |a|
  a.start_date = Date.today - 7.days
  a.end_date = Date.today - 6.days
  a.summary =  "Initial Fertilizer Application"
  a.status = "Completed"
end

puts "✅ Activity: Fertilizer Application"

puts "🚀 Seeding Complete: 100% OK"