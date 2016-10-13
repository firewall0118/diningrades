# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#  user = CreateAdminService.new.call
#  puts 'CREATED ADMIN USER: ' << user.email

def create_roles
  ['user', 'banned', 'admin'].each do |role|
    Role.find_or_create_by({name: role})
  end
end

def create_admin
  admin_role = Role.find_by({name: 'admin'})
  User.create(name: 'Admin', email: 'admin@dininggrades.com', password: 'admin1234', password_confirmation: 'admin1234', role: admin_role)
end

def create_questions
  q1 = Question.create(question: 'Was the restaurant facility clean?', category: '', position: 1)
  Option.create(question_id: q1.id, title: 'Yes', deduction: 0, position: 1)
  Option.create(question_id: q1.id, title: 'No', deduction: 10, position: 2)

  q2 = Question.create(question: 'Were condiment containers clean?', category: '', position: 2)
  Option.create(question_id: q2.id, title: 'Yes', deduction: 0, position: 1)
  Option.create(question_id: q2.id, title: 'No', deduction: 10, position: 2)

  q3 = Question.create(question: 'Was the floor around the table clean?', category: '', position: 3)
  Option.create(question_id: q3.id, title: 'Yes', deduction: 0, position: 1)
  Option.create(question_id: q3.id, title: 'No', deduction: 10, position: 2)
end

create_roles
create_admin
create_questions