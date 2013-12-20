# Morfo

This Gem is inspired by the [active_importer](https://github.com/continuum/active_importer) Gem.

But instead of importing spreadsheets into models, you can morf (typo intended) arrays of Hashes into other arrays of hashes.

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

    class TitleMorfer < Morfo::Base
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
      map [:name, :firs], :first_name
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
    #     {first_name: 'Bruce',last_name: 'Wayne'},,
    # ]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
