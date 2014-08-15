require 'spec_helper'

describe Person do
  it { should validate_presence_of :name }

  context '#spouse' do
    it 'returns the person with their spouse_id' do
      earl = Person.create(:name => 'Earl')
      steve = Person.create(:name => 'Steve')
      steve.update(:spouse_id => earl.id)
      steve.spouse.should eq earl
    end

    it "is nil if they aren't married" do
      earl = Person.create(:name => 'Earl')
      earl.spouse.should be_nil
    end
  end

  context '#child' do
    it 'returns the person with their child_id' do
      vladimir = Person.create(:name => 'Vladimir')
      marina = Person.create(:name => 'Marina')
      ivan = Person.create(:name => 'Ivan')
      relationship1 = Relationship.create(person_id: vladimir.id, child_id: ivan.id)
      relationship2 = Relationship.create(person_id: ivan.id, parent_id: vladimir.id)
      relationship1.child_id.should eq ivan.id
    end
  end

  it "updates the spouse's id when it's spouse_id is changed" do
    earl = Person.create(:name => 'Earl')
    steve = Person.create(:name => 'Steve')
    steve.update(:spouse_id => earl.id)
    earl.reload
    earl.spouse_id.should eq steve.id
  end
end
