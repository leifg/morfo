require 'morfo/version'

module Morfo
  class Base
    def self.map from, to, &transformation
      mapping_actions << [from, to, transformation]
    end

    def self.morf input
      input.map do |value|
        mapping_actions.inject({}) do |output, (from, to, transformation)|
          resulting_value = apply_transformation(
                              extract_value(value, from),
                              transformation
                            )
          output.merge!(to => resulting_value) if resulting_value
          output
        end
      end
    end

    private
    def self.extract_value value, from
      Array(from).inject(value) do |resulting_value, key|
        resulting_value[key]
      end
    end

    def self.apply_transformation value, transformation
      transformation ? transformation.call(value) : value
    end

    def self.mapping_actions
      @actions ||= []
    end
  end
end
