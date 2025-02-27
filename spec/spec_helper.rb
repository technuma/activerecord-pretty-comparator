# frozen_string_literal: true

require "logger"
require "active_record/pretty/comparator"

require "database_cleaner"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:suite) do
    ActiveRecord::Base.logger = Logger.new($stdout)
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
    ActiveRecord::Schema.define do
      create_table :posts, force: true do |t|
        t.integer :legacy_comments_count, default: 0
        t.time :start, precision: 0
        t.time :finish, precision: 4
        t.datetime :created_at, precision: 0
        t.datetime :updated_at, precision: 4
      end

      create_table :comments, force: true do |t|
        t.integer :post_id
      end
    end

    class Post < ActiveRecord::Base # rubocop: disable Lint/ConstantDefinitionInBlock
      has_many :comments
      alias_attribute :comments_count, :legacy_comments_count
    end

    class Comment < ActiveRecord::Base # rubocop: disable Lint/ConstantDefinitionInBlock
      belongs_to :post
    end
  end
  config.before do
    DatabaseCleaner.start
  end
  config.after do
    DatabaseCleaner.clean
  end
end
