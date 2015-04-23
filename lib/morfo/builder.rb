module Morfo
  class Builder
    def initialize(definitions)
      @definitions = definitions
    end

    def build
      # WTF??? `definitions` is not accessible inside class
      # so this javascript technique is necesseray
      tmp_definitions = definitions.map { |h| h.symbolize_keys }
      Class.new(Morfo::Base) do
        tmp_definitions.each do |definition|
          f = field(*definition[:field])

          if definition[:from]
            f = f.from(*definition[:from])
          end

          if definition[:calculated]
            f = f.calculated { |r| definition[:calculated] % Morfo::Tools::FlattenHashKeys.new(r).flatten }
          end

          if definition[:transformed]
            f = f.transformed { |v| definition[:transformed] % {value: v} }
          end
        end
      end
    end

    private

    attr_reader :definitions
  end
end
