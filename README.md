# El Morfo

[![Build Status](https://travis-ci.org/leifg/morfo.png?branch=master)](https://travis-ci.org/leifg/morfo) [![Coverage Status](https://coveralls.io/repos/leifg/morfo/badge.png?branch=master)](https://coveralls.io/r/leifg/morfo) [![Code Climate](https://codeclimate.com/github/leifg/morfo.png)](https://codeclimate.com/github/leifg/morfo) [![Dependency Status](https://gemnasium.com/leifg/morfo.png)](https://gemnasium.com/leifg/morfo) [![Gem Version](https://badge.fury.io/rb/morfo.png)](http://badge.fury.io/rb/morfo)

This gem acts like a universal converter from hashes into other hashes. You just define where your hash should get its data from and morfo will do the rest for you.

## Compatibility

This gem is currently only tested on Ruby 2.0 (including 2.0 mode of JRuby and RBX).

## Installation

Add this line to your application's Gemfile:

    gem "morfo"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install morfo

## Usage

In order to morf the hashes you have to provide a class that extends `Morf::Base`

Use the `field` method to specify what fields exist and where they will get their data from:

### Simple Mapping

The most basic form is copying the value from another field.

```ruby
class Title < Morfo::Base
  field(:tv_show_title).from(:title)
end
```

Afterwards use the `morf` method to morf all hashes in one array to the end result:

```ruby
Title.morf([
          { title: "The Walking Dead" },
          { title: "Breaking Bad" },
        ])

# [
#   { tv_show_title: "The Walking Dead" },
#   { tv_show_title: "Breaking Bad" },
# ]
```

If you want to have access to nested values, just provide the path to that field comma separated.

```ruby
class Name < Morfo::Base
  field(:first_name).from(:name, :first)
  field(:last_name).from(:name, :last)
end

Name.morf([
      {
        name: {
          first: "Clark",
          last: "Kent",
        },
      },
      {
        name: {
          first: "Bruce",
          last: "Wayne",
        },
      },
    ])

# [
#   { first_name: "Clark", last_name: "Kent" },
#   { first_name: "Bruce", last_name: "Wayne" },
# ]
```

### Transformations

It's also possible to transform the value in any way ruby lets you transform a value. just provide a block in the `transformed` method.

```ruby
class AndZombies < Morfo::Base
  field(:title).from(title).transformed {|title| "#{title} and Zombies"}
end

AndZombies.morf([
      { title: "Pride and Prejudice" },
      { title: "Fifty Shades of Grey" },
    ])

# [
#   { title: "Pride and Prejudice and Zombies" },
#   { title: "Fifty Shades of Grey and Zombies" },
# ]
```

### Calculations

If the value of your field should be based on multiple fields of the input row, yoy can specify a calculation block via the `calculated` method. As an argument the whole input row is passed in.

```ruby
class NameConcatenator < Morfo::Base
  field(:name).calculated {|row| "#{row[:first_name]} #{row[:last_name]}"}
  field(:status).calculated {"Best Friend"}
end

NameConcatenator.morf([
      { first_name: "Robin", last_name: "Hood" },
      { first_name: "Sherlock", last_name: "Holmes" },
    ])

# [
#   { name: "Robin Hood", status: "Best Friend" },
#   { name: "Sherlock Holmes", status: "Best Friend" }
# ]
```

### Builder

On top of creating transformers with Ruby classes, it is also possible to build transformers with a hash syntax (which could then be serialized as json and stored somewhere else).

```ruby
morfer = Morfo::Builder.new([
  { field: :first_name, from: [:name, :first] },
  { field: :last_name, from: [:name, :last] },
])

morfer.morf([
      {
        name: {
          first: "Clark",
          last: "Kent",
        },
      },
      {
        name: {
          first: "Bruce",
          last: "Wayne",
        },
      },
    ])

# [
#   { first_name: "Clark", last_name: "Kent" },
#   { first_name: "Bruce", last_name: "Wayne" },
# ]
```

The builder includes all other features such as calculation and transformation

#### Builder Transformations

To transform a value, use the placeholder %{value}

```ruby
class AndZombies < Morfo::Base
  field(:title).from(title).transformed {|title| "#{title} and Zombies"}
end

morfer = Morfo::Builder.new([
  { field: :title, from: :title, transformed: "%{title} and Zombies" },
])

morfer.morf([
      { title: "Pride and Prejudice" },
      { title: "Fifty Shades of Grey" },
    ])

# [
#   { title: "Pride and Prejudice and Zombies" },
#   { title: "Fifty Shades of Grey and Zombies" },
# ]
```

#### Builder Calculations

To get access to the other fields use the [ruby string format syntax](http://ruby-doc.org/core-2.2.0/String.html#method-i-25).

```ruby
morfer = Morfo::Builder.new([
  { field: :name, calculated: "%{first_name} %{last_name}" },
  { field: :status, calculated: "Best Friend" },
])

morfer.morf([
  { first_name: "Robin", last_name: "Hood" },
  { first_name: "Sherlock", last_name: "Holmes" },
])

# [
#   { name: "Robin Hood", status: "Best Friend" },
#   { name: "Sherlock Holmes", status: "Best Friend" }
# ]
```

It's even possible to get access to nested keys, using a dot as separator:

```ruby
morfer = Morfo::Builder.new([
  { field: :name, calculated: "%{name.first} %{name.last}" },
])

morfer.morf([
      {
        name: {
          first: "Clark",
          last: "Kent",
        },
      },
      {
        name: {
          first: "Bruce",
          last: "Wayne",
        },
      },
])

# [
#   { name: "Clark Kent" },
#   { name: "Bruce Wayne" },
# ]
```

