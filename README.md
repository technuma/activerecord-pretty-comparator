# ActiveRecord::Pretty::Comparator

A simple ActiveRecord extension to support `where` with comparison operators (`>`, `>=`, `<`, and `<=`).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activerecord-pretty-comparator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-pretty-comparator


## Usage
```ruby
posts = Post.order(:id)

posts.where("id >": 9).pluck(:id)  # => [10, 11]
posts.where("id >=": 9).pluck(:id) # => [9, 10, 11]
posts.where("id <": 3).pluck(:id)  # => [1, 2]
posts.where("id <=": 3).pluck(:id) # => [1, 2, 3]
```

## Why not `Post.where("id > ?", 1)` ?

As a main contributor of the predicate builder area, [@kamipo](https://github.com/kamipo) recommends
using the hash syntax, the hash syntax also have other useful
effects (making boundable queries, unscopeable queries, hash-like
relation merging friendly, automatic other table references detection).  
ref: https://github.com/rails/rails/pull/39863#issue-659298581

### Merge examples
```ruby
# it doesn't work
# SELECT `posts`.`id` FROM `posts` WHERE (id > 1) AND `posts`.`id` = ?  [["id", 1]]
Post.where("id > ?", 1).merge(Post.where(id: 1)).pluck(:id) # []

# it works
# SELECT `posts`.`id` FROM `posts` WHERE `posts`.`id` = ?  [["id", 1]]
Post.where("id >": 1).merge(Post.where(id: 1)).pluck(:id) # [1]
```

### Unscope examples
```ruby
# it doesn't work
# SELECT `posts`.* FROM `posts` WHERE (id > 1)
Post.where("id > ?", 1).unscope(where: :id)

# it works
# SELECT `posts`.* FROM `posts`
Post.where("id >": 1).unscope(where: :id)
```

### Precision examples
From type casting and table/column name resolution's point of view,
`where("created_at >=": time)` is better alternative than `where("created_at >= ?", time)`.

```ruby
class Post < ActiveRecord::Base
  attribute :created_at, :datetime, precision: 3
end

time = Time.now.utc # => 2020-06-24 10:11:12.123456 UTC

Post.create!(created_at: time) # => #<Post id: 1, created_at: "2020-06-24 10:11:12.123000">

# SELECT `posts`.* FROM `posts` WHERE (created_at >= '2020-06-24 10:11:12.123456')
Post.where("created_at >= ?", time) # => []

# SELECT `posts`.* FROM `posts` WHERE `posts`.`created_at` >= '2020-06-24 10:11:12.123000'
Post.where("created_at >=": time) # => [#<Post id: 1, created_at: "2020-06-24 10:11:12.123000">]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/technuma/activerecord-pretty-comparator.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Special thanks

[@kamipo](https://github.com/kamipo) :bow:

Original idea: https://blog.kamipo.net/entry/2021/01/14/191753 (ja)
