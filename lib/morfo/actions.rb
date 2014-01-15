module Morfo
  module Actions
    class Field
      attr_reader :field_path
      attr_reader :actions

      def initialize field_path, actions
        @field_path = field_path
        @actions = actions
      end

      def from *from_field_path
        act = FromAction.new self, from_field_path
        actions[field_path] = act
        act
      end

      def calculated &calculate_blk
        act = CalculationAction.new self, field_path, calculate_blk
        actions[field_path] = act
        act
      end

      def execute row
        raise ArgumentError,
          "No field to get value from is specified for #{field_path.inspect}"
      end
    end

    class CalculationAction
      def initialize field, from_field_path, calculate_blk
        @field = field
        @from_field_path = from_field_path
        @calculate_blk = calculate_blk
      end

      def execute row
        calculate_blk.call(row)
      end

      private
      attr_reader :field
      attr_reader :from_field_path
      attr_reader :calculate_blk
    end

    class FromAction
      def initialize field, from_field_path
        @field = field
        @from_field_path = from_field_path
      end

      def transformed &blk
        act = TransformAction.new self, from_field_path, blk
        field.actions[field.field_path] = act
        act
      end

      def execute row
        extract_value(from_field_path, row)
      end

      private
      attr_reader :field
      attr_reader :from_field_path

      def extract_value from, row
        from.inject(row) do |resulting_value, key|
          resulting_value ? resulting_value[key] : nil
        end
      end
    end

    class TransformAction
      def initialize previous_action, from_field_path, transform_blk
        @previous_action = previous_action
        @from_field_path = from_field_path
        @transform_blk = transform_blk
      end

      def execute row
        transform_blk.call(previous_action.execute(row))
      end

      private
      attr_reader :previous_action
      attr_reader :from_field_path
      attr_reader :transform_blk
    end
  end
end
