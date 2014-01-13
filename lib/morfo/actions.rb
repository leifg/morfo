module Morfo
  module Actions
    module ValueMethods
      def extract_value from, row
        Array(from).inject(row) do |resulting_value, key|
          resulting_value ? resulting_value[key] : nil
        end
      end

      def store_value to, value
        return {} if value.nil?

        Array(to).reverse.inject({}) do |hash, key|
          if hash.keys.first.nil?
            hash.merge!(key => value)
          else
            { key => hash }
          end
        end
      end
    end

    class MapAction
      include ValueMethods
      attr_reader :from
      attr_reader :to

      def initialize from, to
        @from = from
        @to = to
      end

      def execute row
        store_value(to, extract_value(from, row))
      end
    end

    class TransformationAction
      include ValueMethods
      attr_reader :to
      attr_reader :from
      attr_reader :transformation

      def initialize from, to, transformation
        @from = from
        @to = to
        @transformation = transformation
      end

      def execute row
        resulting_value = from ? extract_value(from, row) : nil
        store_value(to, transformation.call(resulting_value,row))
      end
    end
  end
end