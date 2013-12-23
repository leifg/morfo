require 'morfo/version'

module Morfo
  class Base
    def self.map from, to, &transformation
      mapping_actions << MapAction.new(from, to, transformation)
    end

    def self.morf input
      input.map do |value|
        mapping_actions.inject({}) do |output, action|
          output.merge!(action.execute(value))
        end
      end
    end

    private
    def self.mapping_actions
      @actions ||= []
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

    def execute value
      resulting_value = apply_transformation(extract_value(value))
      resulting_value ? { to => resulting_value } : {}
    end

    private
    def extract_value value
      Array(from).inject(value) do |resulting_value, key|
        resulting_value ? resulting_value[key] : nil
      end
    end

    def apply_transformation value
      transformation ? transformation.call(value) : value
    end
  end
end
