# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "Brian Bai"
  user.email                 "brian@test.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@test.com"
end

Factory.define :profile do |p|
  p.user_id 1
  p.birthday Date.today -20.years
  p.gender "m"
  p.address "Tokyo"
  p.phone "123456789"
end
