# frozen_string_literal: true

RSpec.describe Activerecord::Pretty::Comparator do
  it "has a version number" do
    expect(Activerecord::Pretty::Comparator::VERSION).not_to be nil
  end

  describe "simple Post Model" do
    describe "where with comparison operator key" do
      let!(:post1) { Post.create! }
      let!(:post2) { Post.create! }
      let!(:post3) { Post.create! }
      let(:posts) { Post.order(:id) }

      it "correctly applies comparison operators in where clauses" do
        expect(posts.where("id >": post1.id).pluck(:id)).to eq([post2.id, post3.id])
        expect(posts.where("id >=": post1.id).pluck(:id)).to eq([post1.id, post2.id, post3.id])
        expect(posts.where("id <": post2.id).pluck(:id)).to eq([post1.id])
        expect(posts.where("id <=": post2.id).pluck(:id)).to eq([post1.id, post2.id])
      end
    end
  end
end
