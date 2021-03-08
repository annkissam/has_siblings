# HasSiblings

[![Build Status](https://travis-ci.org/annkissam/has_siblings.svg)](https://travis-ci.org/annkissam/has_siblings)

My brother from another mother!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'has_siblings'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_siblings

## Usage

Add has_siblings to a child model to get a siblings method that returns all of the parents'
other children.

```ruby
class Mother < ActiveRecord::Base
  has_many :children
end

class Father < ActiveRecord::Base
  has_many :children
end

class Child < ActiveRecord::Base
  belongs_to :mother, inverse_of: :children
  belongs_to :father, inverse_of: :children

  has_siblings through: [:mother, :father]
  has_siblings through: :mother, name: :step_siblings
end
```

An example of what it returns:

```ruby
[1] pry> child
=> #<Child:0x007fe5b3371c20 id: 6, mother_id: 3, father_id: 2>
[2] pry> sister
=> #<Child:0x007fe5b3379e70 id: 7, mother_id: 3, father_id: 2>
[3] pry> brother
=> #<Child:0x007fe5b337e0b0 id: 8, mother_id: 3, father_id: 2>
[4] pry> half_sister
=> #<Child:0x007fe5b3386300 id: 9, mother_id: 3, father_id: nil>
[5] pry> just_a_friend
=> #<Child:0x007fe5b338c390 id: 10, mother_id: 4, father_id: nil>
[6] pry> child.siblings
=> [#<Child:0x007fe5b33dc6b0 id: 7, mother_id: 3, father_id: 2>,
    #<Child:0x007fe5b33dc3e0 id: 8, mother_id: 3, father_id: 2>]
[7] pry> child.step_siblings
=> [#<Child:0x007fe5b335fcc8 id: 7, mother_id: 3, father_id: 2>,
    #<Child:0x007fe5b335f9d0 id: 8, mother_id: 3, father_id: 2>,
    #<Child:0x007fe5b335f598 id: 9, mother_id: 3, father_id: nil>]
```

## Options

`has_siblings` accepts a `through: [...]` option that specifies the parents and can
be an array or a single symbol, and an optional `name` that will be the name of
the siblings method (default to `siblings`). By default, when specifying an array of
parents, any `nil` association will result in an empty sibling collection, if parents
can optionally be blank setting `allow_nil: true` will include the present parents and
and the missing parent as conditions to the sibling scope.

## Compatibility

`ActiveRecord.version.to_s >= "4.0"`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/annkissam/has_siblings.
