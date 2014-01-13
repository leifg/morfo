require 'morfo/version'
require 'morfo/actions'

module Morfo
  class Base
    def self.field field_name, definition={}, &blk
      if blk
        mapping_actions << Morfo::Actions::TransformationAction.new(definition[:from], field_name, blk)
      else
        raise(
          ArgumentError,
          "No field to map from is specified for #{field_name.inspect}"
        ) unless definition[:from]
        mapping_actions << Morfo::Actions::MapAction.new(definition[:from], field_name)
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
end
