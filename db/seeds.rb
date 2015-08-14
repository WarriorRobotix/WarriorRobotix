admins = []
admin = Member.new(admin: true)
admin.first_name = 'Shalin'
admin.last_name = 'Petal'
admin.email = 'shalin.petal@example.com'
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
