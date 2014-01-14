require 'morfo/version'
require 'morfo/actions'

module Morfo
  class Base
    def self.field *field_path
      act = Morfo::Actions::Field.new(field_path, mapping_actions)
      mapping_actions[field_path] = act
      act
    end

    def self.morf input
      input.map {|row|
        output_row = {}
        mapping_actions.each do |field_path, action|
          deep_merge!(output_row, store_value(action.execute(row), field_path))
        end
        output_row
      }
    end

    private
    def self.mapping_actions
      @actions ||= {}
    end

    def self.store_value value, to
      return {} if value.nil?

      to.reverse.inject({}) do |hash, key|
        if hash.keys.first.nil?
          hash.merge!(key => value)
        else
          { key => hash }
        end
      end
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
end
