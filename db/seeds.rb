admins = []
admin = Member.new(admin: true)
admin.first_name = 'Shalin'
admin.last_name = 'Patel'
admin.email = 'shalin.patel@example.com'
admin.grade = 12
admin.student_number = '111'
admin.password = '123456'
admin.save!
admins << admin

admin = Member.new(admin: true)
admin.first_name = 'Edward'
admin.last_name = 'Guo'
admin.email = 'edward.guo@example.com'
admin.grade = 12
admin.student_number = '222'
admin.password = '123456'
admin.save!
admins << admin

RegistrationField.create!([
  {title: "First Name"},
  {title: "Last Name"},
  {title: "Email"},
  {title: "Grade"},
  {title: "Student Number"},
  {title: "What robots do you want to make?", input_type: :text_area, optional: true}
])

Post.create!({
  author: admins.sample,
  title: "Ipsa laboriosam quia aut quae ut facere",
  description: "bypassing the application won't do anything, we need to navigate the wireless SCSI array!",
  restriction: :everyone
})

Event.create!({
  author: admins.sample,
  title: "Dolores fugiat eaque cumque labore autem illo vel aut",
  description: "Distinctio est tempora dolorum rerum expedita. Praesentium eius veritatis. Sit aut aliquam voluptatem non esse. Et quis ab deleniti neque quidem in modi.",
  restriction: :everyone,
  start_at: Time.zone.parse('2015-09-23 09:00:00 -0400'),
  end_at: Time.zone.parse('2015-09-23 10:30:00 -0400')
})

poll = Poll.create!({
  author: admins.sample,
  title: "Nesciunt illo quia perspiciatis quam",
  description: "Corporis odit quo aspernatur quia et. Et dolor repellat. Qui velit iure a doloribus eius quo. Iusto ullam vel ut dolor voluptatem ducimus.",
  restriction: :member,
  ballots_privacy: :voters_viewable,
  multiple_choices: true,
  ballots_changeable: false,
  options_attributes: [
    { description: "vero" },
    { description: "dolorem" },
    { description: "amet" },
    { description: "optio" },
    { description: "placeat" },
  ]
})

Event.create!({
  author: admins.sample,
  title: "Dolores fugiat eaque cumque labore autem illo vel aut",
  description: "Distinctio est tempora dolorum rerum expedita. Praesentium eius veritatis. Sit aut aliquam voluptatem non esse. Et quis ab deleniti neque quidem in modi.",
  restriction: :admin,
  start_at: Time.zone.parse('2015-08-01 14:30:00 -0400'),
  end_at: Time.zone.parse('2015-08-01 16:30:00 -0400')
})

poll = Poll.create!({
  author: admins.sample,
  title: "Sint reiciendis pariatur fugiat",
  description: "Exercitationem vero ratione. Ea et quia consectetur voluptatem est qui omnis. Totam nesciunt dolores rerum cupiditate assumenda dolorum. Tenetur voluptatem a odit exercitationem in consequatur ullam.",
  restriction: :admin,
  ballots_privacy: :counts_viewable,
  multiple_choices: false,
  ballots_changeable: true,
  options_attributes: [
    { description: "sit" },
    { description: "dolorem" },
    { description: "tenetur" },
    { description: "quia" },
  ]
})

Sponsor.create!({
  name: "Boston Pizza",
  description: "Boston Pizza is Canada’s No. 1 casual dining brand with more than 365 restaurants in Canada serving more than 100 unique and delicious menu items such as gourmet pizzas and pastas, juicy burgers and our famous BP wings. Annually, Boston Pizza serves more than 40 million guests, and in 2014 achieved system-wide sales that surpassed $1 billion. Boston Pizza has proudly been recognized as a Platinum Member of Canada’s 50 Best Managed Companies for 21 consecutive years.",
  website_link: "https://bostonpizza.com/en",
  facebook_link: "https://www.facebook.com/BostonPizza",
  twitter_link: "https://twitter.com/bostonpizza",
  image_link: "sponsors/boston_pizza.png"
})

Sponsor.create!({
  name: "NASA",
  description: "The National Aeronautics and Space Administration (NASA) is the United States government agency responsible for the civilian space program as well as aeronautics and aerospace research.",
  website_link: "http://www.nasa.gov/",
  facebook_link: "https://www.facebook.com/NASA",
  twitter_link: "https://twitter.com/nasa",
  image_link: "http://www.nasa.gov/sites/default/files/images/nasaLogo-570x450.png"
})
