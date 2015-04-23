module Morfo
  module Tools
    class FlattenHashKeys
      attr_reader :input_hash

      def initialize(input_hash)
        @input_hash = input_hash.dup.freeze
      end

      def flatten
        input_hash.inject({}) do |result_hash, (key, value)|
          if value.is_a?(Hash)
            value.each do |inner_key, inner_value|
              if inner_value.is_a?(Hash)
                FlattenHashKeys.new(value).flatten.each do |inner_inner_key, inner_inner_value|
                  result_hash.merge!("#{key}.#{inner_inner_key}".to_sym => inner_inner_value)
                end
              else
                result_hash.merge!("#{key}.#{inner_key}".to_sym => inner_value)
              end
            end
          else
            result_hash.merge!(key.to_sym => value)
          end
          result_hash
        end
      end
    end
  end
end
