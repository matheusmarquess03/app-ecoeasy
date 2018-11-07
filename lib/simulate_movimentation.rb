require_relative '../config/initializers/firebase'

sleep 3
response = FIREBASE.push("#{Date.today.strftime('%Y-%m-%d')}/1", {
  latitude: '-22.9851002',
  longitude: '-43.4738838'
});

sleep 1
response = FIREBASE.push("#{Date.today.strftime('%Y-%m-%d')}/1", {
  latitude: '-22.9848037',
  longitude: '-43.4731491'
})

sleep 1
response = FIREBASE.push("#{Date.today.strftime('%Y-%m-%d')}/1", {
  latitude: '-22.9845101',
  longitude: '-43.4725356'
})

sleep 1
response = FIREBASE.push("#{Date.today.strftime('%Y-%m-%d')}/1", {
  latitude: '-22.9843296',
  longitude: '-43.4721298'
})

sleep 1
response = FIREBASE.push("#{Date.today.strftime('%Y-%m-%d')}/1", {
  latitude: '-22.9840103',
  longitude: '-43.4714845'
})

sleep 1
response = FIREBASE.push("#{Date.today.strftime('%Y-%m-%d')}/1", {
  latitude: '-22.9834527',
  longitude: '-43.4702299'
})
