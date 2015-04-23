require "spec_helper"

describe Morfo::Builder do
  describe "#build" do
    subject { described_class.new(definition) }

    let(:definition) do
      [
        {
          field: :tv_show_title,
          from: :title,
        }
      ]
    end

    let(:morfer) { subject.build }

    it "has a morf method" do
      expect(morfer).to respond_to(:morf)
    end

    it "has a morf_single method" do
      expect(morfer).to respond_to(:morf_single)
    end
  end

  context "on the fly morfers" do
    subject { described_class.new(definitions).build }

    it_behaves_like "a 1 to 1 morfer" do
      let(:definitions) do
        [
          { field: :tv_show_title, from: :title }
        ]
      end
    end

    it_behaves_like "a 1 to many morfer" do
      let(:definitions) do
        [
          { field: :title, from: :title },
          { field: :also_title, from: :title },
        ]
      end
    end

    it_behaves_like "a static morfer" do
      let(:definitions) do
        [
          { field: :new_title, static: "Static Title" },
        ]
      end
    end

    it_behaves_like "a 1 to 1 morfer with transformation" do
      let(:definitions) do
        [
          {field: :title, from: :title, transformation: "%{value} and Zombies"}
        ]
      end
    end
  end
end
