module Morfo
  class Builder
    def initialize(definitions)
      @definitions = definitions
    end

    def build
      # WTF definitions is not accessable inside class
      # so this javascript technique is necesseray
      tmp_definitions = definitions
      Class.new(Morfo::Base) do
        tmp_definitions.each do |definition|
          f = field(definition[:field])
          if definition[:from]
            f = f.from(definition[:from])
          end
          if definition[:static]
            f = f.calculated { definition[:static] }
          end
        end
      end
    end

    private

    attr_reader :definitions
  end
end