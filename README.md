# Morfo

[![Build Status](https://travis-ci.org/leifg/morfo.png?branch=master)](https://travis-ci.org/leifg/morfo) [![Coverage Status](https://coveralls.io/repos/leifg/morfo/badge.png?branch=master)](https://coveralls.io/r/leifg/morfo) [![Code Climate](https://codeclimate.com/github/leifg/morfo.png)](https://codeclimate.com/github/leifg/morfo) [![Dependency Status](https://gemnasium.com/leifg/morfo.png)](https://gemnasium.com/leifg/morfo) [![Gem Version](https://badge.fury.io/rb/morfo.png)](http://badge.fury.io/rb/morfo)

This Gem is inspired by the [active_importer](https://github.com/continuum/active_importer) Gem.

But instead of importing spreadsheets into models, you can morf (typo intended) arrays of Hashes into other arrays of hashes.

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

Use the `map` method to specify what field you map to another field:

    class Title < Morfo::Base
      map :title, :tv_show_title
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

It is also possible to map fields to multiple other fields

    class MultiTitle < Morfo::Base
      map :title, :tv_show_title
      map :title, :show_title
    end

    MultiTitle.morf([
              {title: 'The Walking Dead'} ,
              {title: 'Breaking Bad'},
            ])

    # [
    #   {tv_show_title: 'The Walking Dead', show_title: 'The Walking Dead'},
    #   {tv_show_title: 'Breaking Bad', show_title: 'Breaking Bad'},
    # ]

## Transformations

For each mapping you can define a block, that will be called on every input:

    class AndZombies < Morfo::Base
      map :title, :title do |title|
        "#{title} and Zombies"
      end
    end

    AndZombies.morf([
          {title: 'Pride and Prejudice'},
          {title: 'Fifty Shades of Grey'},
        ])

    # [
    #     {title: 'Pride and Prejudice and Zombies'},
    #     {title: 'Fifty Shades of Grey and Zombies'},
    # ]

## Nested Values

You can directly access nested values in the hashes:

    class Name < Morfo::Base
      map [:name, :first], :first_name
      map [:name, :last], :last_name
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
