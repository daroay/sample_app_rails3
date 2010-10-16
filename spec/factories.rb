# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                  "prueba"
  user.email                 "prueba@prueba.com"
  user.password              "123456"
  user.password_confirmation "123456"
end

