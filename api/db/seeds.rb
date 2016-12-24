p "Creating seed data for this app..."

user = User.find_by_name("admin")
unless user
  user = User.create(name: "admin", password: "admin", role: User::ROLE_ADMIN)
end
p "Created admin user: #{user.name} pass: #{user.password}"

user = User.find_by_name("user")
unless user
  user = User.create(name: "user", password: "user", role: User::ROLE_USER)
end
p "Created simple user: #{user.name} pass: #{user.password}"

p "Seeding projects..."
meetups = Section.create(title: 'Meetups', description: 'desc')

java_meetups = Subsection.create(title: 'Java', section: meetups)
ruby_meetups = Subsection.create(title: 'Ruby', section: meetups)

Project.create(title: 'Javaduches', subsection: java_meetups)
Project.create(title: 'Rails Girls', subsection: ruby_meetups)

