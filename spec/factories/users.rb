FactoryGirl.define do
  factory :user do
    fullname "John doe"
    email "example@example.com"
    phone "909012341234"
    copynumber "12341234"
    password "Foobar123"
  end

  factory :admin, class: User do
    fullname "admin"
    email "admin@admin.com"
    phone "12341234123"
    copynumber "admin"
    password "Admin123"
    admin true
  end
end
