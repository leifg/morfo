require "active_support/core_ext/hash"
require "morfo/version"
require "morfo/tools"
require "morfo/actions"
require "morfo/builder"

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
        output.deep_merge!(store_value(action.execute(input), field_path))
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
  end
end
