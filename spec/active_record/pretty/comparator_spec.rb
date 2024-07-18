# frozen_string_literal: true

RSpec.describe ActiveRecord::Pretty::Comparator do
  it "has a version number" do
    expect(ActiveRecord::Pretty::Comparator::VERSION).not_to be_nil
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

    describe "alias_attribute :comments_count, :legacy_comments_count" do
      before do
        Post.create!(comments_count: 4)
        Post.create!(comments_count: 5)
        Post.create!(comments_count: 6)
      end

      it "allows querying using the aliased attribute name 'comments_count'" do
        expect(Post.where("comments_count >=": 5).count).to eq(2)
        expect(Post.where("comments_count >": 5).count).to eq(1)
        expect(Post.where("comments_count <=": 5).count).to eq(2)
        expect(Post.where("comments_count <": 5).count).to eq(1)
      end
    end

    describe "#unscope" do
      let(:post1) { Post.create!(comments_count: 1) }
      let!(:comment1) { post1.comments.create! }
      let(:post2) { Post.create!(comments_count: 1) }
      let!(:comment2) { post2.comments.create! }

      it "correctly unscopes table name qualified column" do
        comments = Comment.joins(:post).where("posts.id <=": post1.id)
        expect(comments).to eq([comment1])

        comments = comments.where("id >=": post2.id)
        expect(comments).to be_empty

        comments = comments.unscope(where: :"posts.id")
        expect(comments).to eq([comment2])
      end
    end

    describe "#merge" do
      let!(:post1) { Post.create! }
      let!(:post2) { Post.create! }

      it "merges with a post condition" do
        expect(Post.where("id <=": post2.id).merge(Post.where(id: post2.id))).to eq([post2])
        expect(Post.where(id: post2.id).merge(Post.where("id <=": post2.id))).to eq([post1, post2])
      end
    end

    describe "references detection" do
      let(:post) { Post.create!(comments_count: 1) }
      let!(:comment) { post.comments.create! }

      it "correctly adds references when using string or hash conditions" do
        expect(Post.eager_load(:comments).where("comments.id >= ?", comment.id).references_values).to eq([])
        expect(Post.eager_load(:comments).where("comments.id >=": comment.id).references_values).to eq(["comments"])
      end
    end

    describe "datetime precision" do
      let(:time) { Time.utc(2014, 8, 17, 12, 30, 0, 999_999) }

      before do
        Post.create!(created_at: time, updated_at: time)
      end

      it "formats datetime according to precision" do
        expect(Post.find_by("created_at >= ?", time)).to be_nil
        expect(Post.where("updated_at >= ?", time).count).to eq(0)
        expect(Post.find_by("created_at >=": time)).to be_truthy
        expect(Post.where("updated_at >=": time).count).to eq(1)
      end
    end

    describe "time precision" do
      let(:time) { Time.utc(2000, 1, 1, 12, 30, 0, 999_999) }

      before do
        Post.create!(start: time, finish: time)
      end

      it "handles time precision correctly" do
        expect(Post.find_by("start >= ?", time)).to be_nil
        expect(Post.where("finish >= ?", time).count).to eq(0)

        expect(Post.find_by("start >=": time)).to be_truthy
        expect(Post.where("finish >=": time).count).to eq(1)
      end
    end
  end
end
