require "morfo/version"
require "morfo/actions"
require "morfo/deserializer"

module Morfo
  class Base
    def self.field *field_path
      act = Morfo::Actions::Field.new(field_path, mapping_actions)
      mapping_actions[field_path] = act
      act
    end

    def self.morf input
      input.map { |row| morf_single(row) }
    end

    def self.morf_single input
      output = {}
      mapping_actions.each do |field_path, action|
        deep_merge!(output, store_value(action.execute(input), field_path))
      end
      output
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
