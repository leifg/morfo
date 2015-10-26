module Morfo
  module Tools
    class FlattenHashKeys
      attr_reader :input_hash

      def initialize(input_hash)
        @input_hash = input_hash.dup.freeze
      end

      def flatten
        input_hash.inject({}) do |result_hash, (key, value)|
          inner_hash = false
          if value.is_a?(Hash)
            inner_hash = true
            value.each do |inner_key, inner_value|
              if inner_value.is_a?(Hash)
                inner_hash = true
              end
              result_hash.merge!("#{key}.#{inner_key}".to_sym => inner_value)
            end
          else
            result_hash.merge!(key.to_sym => value)
          end

          if inner_hash
            FlattenHashKeys.new(result_hash).flatten
          else
            result_hash
          end
        end
      end
    end

    class BaseKeys
      attr_reader :input_string

      def initialize(input_string)
        @input_string = input_string.nil? ? "" : input_string.dup.freeze
      end

      def build
        keys = input_string.scan(/\%\{([^\}]+)\}/).flatten

        keys.inject({}) do |hash, key|
          hash.merge!(key.to_sym => nil)
        end
      end
    end
  end
end
