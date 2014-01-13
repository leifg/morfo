# El Morfo

[![Build Status](https://travis-ci.org/leifg/morfo.png?branch=master)](https://travis-ci.org/leifg/morfo) [![Coverage Status](https://coveralls.io/repos/leifg/morfo/badge.png?branch=master)](https://coveralls.io/r/leifg/morfo) [![Code Climate](https://codeclimate.com/github/leifg/morfo.png)](https://codeclimate.com/github/leifg/morfo) [![Dependency Status](https://gemnasium.com/leifg/morfo.png)](https://gemnasium.com/leifg/morfo) [![Gem Version](https://badge.fury.io/rb/morfo.png)](http://badge.fury.io/rb/morfo)

This gem acts like a universal converter from hashes into other hashes. You just define where your hash should get its data from and morfo will do the rest for you.

## Compatibility

This gem is currently only tested on Ruby 2.0 (including 2.0 mode of JRuby and RBX).

## Installation

Add this line to your application's Gemfile:

    gem 'morfo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install morfo

## Usage

In order to morf the hashes you have to provide a class that extends `Morf::Base`

Use the `field` method to specify what fields exist and where they will get their data from:

### Simple Mapping

The most basic form is, just define another field from the input hash. The value will just be copied.

    class Title < Morfo::Base
      field :tv_show_title, from: :title
    end

Afterwards use the `morf` method to morf all hashes in one array to the end result:

    Title.morf([
              {title: 'The Walking Dead'} ,
              {title: 'Breaking Bad'},
            ])

    # [
    #   {tv_show_title: 'The Walking Dead'},
    #   {tv_show_title: 'Breaking Bad'},
    # ]

If you want to have access to nested values, you'll have to provide an array as the key:


    class Name < Morfo::Base
      field :first_name, from: [:name, :first]
      field :last_name, from: [:name, :last]
    end

    Name.morf([
          {
            name: {
              first: 'Clark',
              last: 'Kent',
            },
          },
          {
            name: {
              first: 'Bruce',
              last: 'Wayne',
            },
          },
        ])

    # [
    #     {first_name: 'Clark',last_name: 'Kent'},
    #     {first_name: 'Bruce',last_name: 'Wayne'},
    # ]

## Transformations

Every field can also take a transformation block, so that the original input can be transformed.

    class AndZombies < Morfo::Base
      field(:title, from: :title) {|title| "#{title} and Zombies"}
    end

    AndZombies.morf([
          {title: 'Pride and Prejudice'},
          {title: 'Fifty Shades of Grey'},
        ])

    # [
    #     {title: 'Pride and Prejudice and Zombies'},
    #     {title: 'Fifty Shades of Grey and Zombies'},
    # ]

As the second argument, the whole row is passed into the block. So you can even do transformation based on the whole row. Or you can leave out all the arguments and return a static value.

    class NameConcatenator < Morfo::Base
      field(:name) {|_, row| "#{row[:first_name]} #{row[:last_name]}"}
      field(:status) { 'Best Friend' }
    end

    NameConcatenator.morf([
          {first_name: 'Robin', last_name: 'Hood'},
          {first_name: 'Sherlock', last_name: 'Holmes'},
        ])

    # [
    #   {:name=>"Robin Hood", :status=>"Best Friend"},
    #   {:name=>"Sherlock Holmes", :status=>'Best Friend'}
    # ]


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
