puts 'Adding users...'
%w[Ernesto Benjamin Barbara].each do |user|
  puts user
  User.create!(name: user, active: true)
end

puts 'Adding clients...'
puts 'Recorrido.cl'
Client.create!(
  name: 'Recorrido.cl',
  requested_hours: {
    'monday' => ['09:00-10:00', '10:00-11:00', '11:00-12:00'],
    'tuesday' => ['10:00-11:00', '11:00-12:00', '12:00-13:00'],
    'wednesday' => ['11:00-12:00', '12:00-13:00', '13:00-14:00'],
    'thursday' => ['12:00-13:00', '13:00-14:00', '14:00-15:00'],
    'friday' => ['13:00-14:00', '14:00-15:00', '15:00-16:00'],
    'saturday' => ['14:00-15:00', '15:00-16:00', '16:00-17:00'],
    'sunday' => ['15:00-16:00', '16:00-17:00', '18:00-19:00']
  }
)

puts 'SkydropX'
Client.create!(
  name: 'SkydropX',
  requested_hours: {
    'saturday' => ['14:00-15:00', '15:00-16:00', '16:00-17:00'],
    'sunday' => ['15:00-16:00', '16:00-17:00', '18:00-19:00']
  }
)
