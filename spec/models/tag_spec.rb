require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { is_expected.to validate_presence_of(:title) }

  describe 'title uniqueness' do
    subject { build :tag }

    it { is_expected.to validate_uniqueness_of(:title).case_insensitive }
  end

  it 'should parameterize title' do
    tag = create(:tag, title: 'Home work')

    expect(tag.reload.title).to eq 'home_work'      
  end

  it { is_expected.to have_and_belong_to_many(:tasks) }

  it 'is valid with correct details' do
    expect(build(:tag)).to be_valid
  end
end
