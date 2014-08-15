require 'pry'
require 'bundler/setup'
Bundler.require(:default)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

database_configurations = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configurations['development']
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts 'Welcome to the family tree!'
  puts 'What would you like to do?'

  loop do
    puts 'Press a to add a family member.'
    puts 'Press l to list out the family members.'
    puts 'Press m to add who someone is married to.'
    puts 'Press s to see who someone is married to.'
    puts "Press r to create child-parent relationships"
    puts "Press c to list the children of a person"
    puts "Press p to list the parents of a person"
    puts 'Press e to exit.'
    choice = gets.chomp
    case choice
      when 'a' then add_person
      when 'l' then list
      when 'm' then add_marriage
      when 's' then show_marriage
      when 'r' then create_relationship
      when 'c' then list_children
      when 'p' then list_parents
      when 'e' then exit
    end
  end
end

def add_person
  puts 'What is the name of the family member?'
  name = gets.chomp
  Person.create(:name => name)
  puts name + " was added to the family tree.\n\n"
end

def add_marriage
  list
  puts 'What is the number of the first spouse?'
  spouse1 = Person.find(gets.chomp)
  puts 'What is the number of the second spouse?'
  spouse2 = Person.find(gets.chomp)
  spouse1.update(:spouse_id => spouse2.id)
  puts spouse1.name + " is now married to " + spouse2.name + "."
end

def list
  puts 'Here are all your relatives:'
  people = Person.all
  people.each do |person|
    puts person.id.to_s + " " + person.name
  end
  puts "\n"
end

def show_marriage
  list
  puts "Enter the number of the relative and I'll show you who they're married to."
  person = Person.find(gets.chomp)
  spouse = Person.find(person.spouse_id)
  puts person.name + " is married to " + spouse.name + "."
end

def create_relationship
  list
  puts 'What is the number of the first parent?'
  parent1 = Person.find(gets.chomp)
  puts 'What is the number of the second parent?'
  parent2 = Person.find(gets.chomp)
  puts 'What is the number of the child?'
  child = Person.find(gets.chomp)
  new_relationship = Relationship.create(person_id: parent1.id, child_id: child.id)
  new_relationship2 = Relationship.create(person_id: parent2.id, child_id: child.id)
  new_relationship3 = Relationship.create(person_id: child.id, parent_id: parent1.id)
  new_relationship3 = Relationship.create(person_id: child.id, parent_id: parent2.id)
  puts parent1.name + " and " + parent2.name + " have a child " + child.name
end

def list_parents
  list
  puts "Choose a person to see who their parents are: "
  child = Person.find(gets.chomp)
  parents = Relationship.where("relationships.child_id = #{child.id}")
  puts "The parents of #{child.name} are:"
  parents_array = []
  parents.each do |parent|
    Person.all.each { |p| parents_array << p.name if p.id == parent.id }
  end
  puts parents_array
end

def list_children
  list
  puts "Choose a person to see who their child(ren) is(are): "
  parent = Person.find(gets.chomp)
  childs = Relationship.where("relationships.parent_id = #{parent.id}")
  puts "The child(ren) of #{parent.name} is(are):"
  childrens_array = []
  childs.each do |child|
    Person.all.each { |c| childrens_array << c.name if c.id == child.id }
  end
  puts childrens_array
end

menu
