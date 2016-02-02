require "active_support/core_ext/hash"
require "morfo/version"
require "morfo/tools"
require "morfo/actions"
require "morfo/builder"
require "morfo/errors"

module Morfo
  class Base
    def self.field *field_path
      act = Morfo::Actions::Field.new(field_path, mapping_actions)
      mapping_actions[field_path] = act
      act
    end

    def self.morf input, options = {}
      input.map { |row| morf_single(row, options) }
    end

    def self.morf_single input, options = {}
      output = {}
      mapping_actions.each do |field_path, action|
        output.deep_merge!(store_value(action.execute(input), field_path, options))
      end
      output
    end

    private
    def self.mapping_actions
      @actions ||= {}
    end

    def self.store_value value, to, options
      return {} if value.nil? && !options[:include_nil_values]

      to.reverse.inject({}) do |hash, key|
        if hash.empty?
          hash.merge!(key => value)
        else
          { key => hash }
        end
      end
    end
  end
end
