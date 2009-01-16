require 'test/unit'
require 'rubygems'
require 'active_record'
require 'active_support/test_case'
require File.dirname(__FILE__) + '/../init'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

def setup_db
	ActiveRecord::Schema.define(:version => 1) do
		create_table :comments do |t|
			t.text :body
			t.references :commentable, :polymorphic => true
			t.timestamps
		end
		create_table :posts do |t|
			t.string :title
			t.text   :body
			t.timestamps
		end
	end
end

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end

class Post < ActiveRecord::Base
	acts_as_commentable
end

class ActsAsCommentableTest < Test::Unit::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	def test_the_truth
		assert true
	end

	def test_post
		assert_difference('Post.count', 1, "1 Post should've been created") {
			@post = Post.create!({:title => "My Title", :body => "My Post Body"})
		}
		assert_difference('Post.first.comments.count', 1, "1 Comment should've been created") {
		assert_difference('Comment.count', 1, "1 Comment should've been created") {
			@post.add_comment(Comment.create!({:body => "My Comment"}))
		} }

		@comments = Post.find_comments_for(@post)
		assert @comments.length == 1
	end

end
