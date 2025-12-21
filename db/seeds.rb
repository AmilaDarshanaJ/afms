# 🌱 Starting deployment seeding...

puts "--- 👤 SEEDING USERS ---"
default_user = User.find_or_create_by!(email_address: "afms.demo@frmcore.com") do |u|
  u.password = "Omed@123!"
  u.role = 1
end
puts "✅ Admin user ensured: afms.demo@frmcore.com"

puts "\n--- 🌾 SEEDING CROP TYPES ---"
crop_data = [
  { name: "Coconut", unit: "Nuts", desc: "Hardy tropical tree used for food, oil, and drink." },
  { name: "Paddy", unit: "Kg", desc: "Water-loving cereal crop grown in flooded fields." },
  { name: "Ginger", unit: "Kg", desc: "Aromatic root crop valued for its spicy flavor." },
  { name: "Banana", unit: "Kg", desc: "Tropical fruit crop producing high yields year-round." },
  { name: "Pineapple", unit: "Kg", desc: "Tangy tropical fruit grown in well-drained soil." }
]

crop_data.each do |data|
  CropType.find_or_create_by!(name: data[:name]) do |c|
    c.description = data[:desc]
    c.unit = data[:unit]
  end
  puts "✅ Crop Type ensured: #{data[:name]} (#{data[:unit]})"
end

puts "\n--- 🗺️ SEEDING LANDS ---"
land_names = ["Silver Palm", "Golden Field", "Ginger Valley", "Banana Grove", "Pineapple Hill"]
land_extents = [7.0, 2.0, 3.5, 1.5, 4.5]

lands = land_names.map.with_index do |name, i|
  land_obj = Land.find_or_create_by!(name: "#{name} Plantation") do |l|
    l.crop_type = crop_data[i % crop_data.size][:name]
    l.address = "Kadirapola, Narangoda"
    l.latitude = 7.33177
    l.longitude = 80.12332
    l.extent = land_extents[i]
    l.owner_manager_name = "Amila Darshana"
  end
  puts "✅ Land ensured: #{land_obj.name} (#{land_obj.extent} acres)"
  land_obj
end

puts "\n--- 📦 SEEDING HARVESTS ---"
lands.each do |land|
  crop_info = crop_data.find { |c| c[:name] == land.crop_type }
  unit_to_use = crop_info ? crop_info[:unit] : "Units"

  2.times do |i|
    harvest = Harvest.find_or_create_by!(
      land_id: land.id,
      actual_date: Date.today - i.months
    ) do |h|
      h.amount = rand(2000..3000)
      h.unit = unit_to_use
      h.crop_type = land.crop_type
      h.planned_date = Date.today - i.months - 2.days
    end
    puts "✅ Harvest added for #{land.name}: #{harvest.amount} #{harvest.unit}"
  end
end

puts "\n--- 📝 SEEDING ACTIVITIES ---"
activity_summaries = [
  "Initial Fertilizer Application", "Manual Weeding", "Irrigation System Check",
  "Pest Control Spray", "Soil pH Testing", "Boundary Fence Repair",
  "Organic Manure Distribution", "Drainage Cleaning", "Pruning Trees",
  "Seedling Preparation", "Harvest Equipment Maintenance", "Foliar Fertilizer Spray"
]

activity_summaries.each_with_index do |summary, i|
  target_land = lands[i % lands.size]

  activity = Activity.find_or_create_by!(
    land_id: target_land.id,
    summary: summary
  ) do |a|
    a[:land] = target_land.name
    a.status = ["Completed", "In Progress", "Pending", "On Hold", "Cancelled"].sample
    a.start_date = Date.today - (i * 2).days
    a.end_date = Date.today - (i * 2).days + 1.day
  end
  puts "✅ Activity [#{activity.status}] ensured for #{target_land.name}: #{summary}"
end

puts "\n🚀 SEEDING COMPLETE: 100% OK"