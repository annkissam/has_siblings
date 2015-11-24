require 'spec_helper'

describe 'has_siblings' do
  context "without :through" do
    let!(:child_class) { stub_const("BlackSheep", Class.new(ActiveRecord::Base)) }

    it "fails" do
      expect { BlackSheep.has_siblings }.to raise_error(KeyError)
    end
  end

  context "without parent association" do
    let!(:child_class) { stub_const("BlackSheep", Class.new(ActiveRecord::Base)) }

    it "fails" do
      expect { BlackSheep.has_siblings through: :parent }.to raise_error(HasSiblings::ReflectionNotFoundError)
    end
  end

  context "with parents" do
    let(:mother) { Mother.create! }
    let(:other_mother) { Mother.create! }
    let(:father) { Father.create! }

    subject!(:child) { Child.create!(mother: mother, father: father) }
    let!(:sister) { Child.create!(mother: mother, father: father) }
    let!(:brother) { Child.create!(mother: mother, father: father) }
    let!(:half_sister) { Child.create!(mother: mother) }
    let!(:just_a_friend) { Child.create!(mother: other_mother) }

    its(:siblings) { are_expected.to contain_exactly(sister, brother) }
    its(:siblings) { are_expected.to be_a(ActiveRecord::Relation) }

    its(:siblings_through_mother) { are_expected.to contain_exactly(sister, brother, half_sister) }
    its(:siblings_through_mother) { are_expected.to be_a(ActiveRecord::Relation) }
  end

  context "with a nil parent" do
    subject!(:orphaned_child) { Child.create! }

    its(:siblings) { are_expected.to eq([]) }
    its(:siblings) { are_expected.to be_a(ActiveRecord::Relation) }

    its(:siblings_through_mother) { are_expected.to eq([]) }
    its(:siblings_through_mother) { are_expected.to be_a(ActiveRecord::Relation) }
  end

  context "with polymorphic parents" do
    let(:grinch) { Grinch.create! }
    let(:boogeyman) { Boogeyman.create!(id: grinch.id) }

    subject!(:child) { Child.create!(monster: grinch) }
    let!(:sister) { Child.create!(monster: grinch) }
    let!(:boogey_child) { Child.create!(monster: boogeyman) }

    its(:siblings_through_monster) { are_expected.to contain_exactly(sister) }
    its(:siblings_through_monster) { are_expected.to be_a(ActiveRecord::Relation) }
  end
end
