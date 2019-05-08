require 'rails_helper'

RSpec.describe Task, type: :model do
  it { is_expected.to validate_presence_of(:title) }

  it { is_expected.to have_and_belong_to_many(:tags) }

  it 'is valid without tags' do
    expect(build(:task)).to be_valid
  end

  it 'is valid with tags' do
    expect(build(:task, :with_tags)).to be_valid
  end

  describe 'tags=' do  
    it 'raise an exception when not an array' do
      task = Task.create(title: 'Laundry')

      expect { task.tags = 3 }.to raise_exception(ActiveRecord::AssociationTypeMismatch)
    end 

    it 'raise an exception when not an array of strings' do
      task = Task.create(title: 'Laundry')

      expect { task.tags = ["boring", 3] }.to raise_exception(ActiveRecord::AssociationTypeMismatch)
    end 

    it 'accepts an array of String for tags' do
      task = Task.create(title: 'Laundry')

      expect { task.tags = ['urgent', 'boring'] }.to change { task.tags.count }.by(2)
    end

    it 'accepts an array of tags' do
      task = Task.create(title: 'Laundry')
      tags = create_list(:tag, 2)

      expect { task.tags = tags }.to change { task.tags.count }.by(2)
    end 
  end
end
