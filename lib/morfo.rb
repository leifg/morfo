require 'morfo/version'

module Morfo
  class Base
    def self.field field_name, definition
      if definition[:calculation]
        mapping_actions << TransformationAction.new(field_name, definition[:calculation])
      else
        raise(
          ArgumentError,
          "No field to map from is specified for #{field_name.inspect}"
        ) unless definition[:from]
        mapping_actions << MapAction.new(definition[:from], field_name, definition[:transformation])
      end
    end

    def self.morf input
      input.map do |row|
        mapping_actions.inject({}) do |output, action|
          deep_merge!(output, action.execute(row))
        end
      end
    end

    private
    def self.mapping_actions
      @actions ||= []
    end

    def self.deep_merge! hash, other_hash, &block
      other_hash.each_pair do |k,v|
        tv = hash[k]
        if tv.is_a?(Hash) && v.is_a?(Hash)
          hash[k] = deep_merge!(tv, v, &block)
        else
          hash[k] = block && tv ? block.call(k, tv, v) : v
        end
      end
      hash
    end
  end

  class TransformationAction
    attr_reader :to
    attr_reader :calculation

    def initialize to, calculation
      @to = to
      @calculation = calculation
    end

    def execute row
      {to => calculation.call(row)}
    end
  end

  class MapAction
    attr_reader :from
    attr_reader :to
    attr_reader :transformation

    def initialize from, to, transformation
      @from = from
      @to = to
      @transformation = transformation
    end

    def execute row
      resulting_value = apply_transformation(extract_value(row))
      resulting_value ? store_value(to, resulting_value) : {}
    end

    private
    def extract_value row
      Array(from).inject(row) do |resulting_value, key|
        resulting_value ? resulting_value[key] : nil
      end
    end

    def apply_transformation row
      transformation ? transformation.call(row) : row
    end

    def store_value to, value
      Array(to).reverse.inject({}) do |hash, key|
        if hash.keys.first.nil?
          hash.merge!(key => value)
        else
          { key => hash }
        end
      end
    end
  end
end
