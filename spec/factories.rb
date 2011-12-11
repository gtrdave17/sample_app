# by using the symbol ":user"  we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name                   "ryan vanni"
  user.email                  "ryan.vanni@bkwld.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end