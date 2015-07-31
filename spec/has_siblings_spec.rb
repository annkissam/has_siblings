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
      expect { BlackSheep.has_siblings through: :parent }.to raise_error(HasSiblings::ThroughAssociationNotFoundError)
    end
  end

  context "without parent association inverse_of" do
    let!(:parent_class) { stub_const("Parent", Class.new(ActiveRecord::Base)) }
    let!(:child_class) { stub_const("BlackSheep", Class.new(ActiveRecord::Base)) }

    it "fails" do
      expect do
        BlackSheep.belongs_to :parent
        BlackSheep.has_siblings through: :parent
      end.to raise_error(HasSiblings::InverseOfNotFoundError)
    end
  end

  context "with parents" do
    let(:mother) { Mother.create }
    let(:other_mother) { Mother.create }
    let(:father) { Father.create }

    subject!(:child) { Child.create(mother: mother, father: father) }
    let!(:sister) { Child.create(mother: mother, father: father) }
    let!(:brother) { Child.create(mother: mother, father: father) }
    let!(:half_sister) { Child.create(mother: mother) }
    let!(:just_a_friend) { Child.create(mother: other_mother) }

    its(:siblings) { are_expected.to contain_exactly(sister, brother) }
    its(:step_siblings) { are_expected.to contain_exactly(sister, brother, half_sister) }
  end
end
