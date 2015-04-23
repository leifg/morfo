require "spec_helper"

describe Morfo::Builder do
  describe "#build" do
    subject { described_class.new(definitions) }

    let(:definitions) do
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
          { field: :new_title, calculated: "Static Title" },
        ]
      end
    end

    it_behaves_like "a calculating morfer" do
      let(:definitions) do
        [
          { field: :title_with_channel, calculated: "%{title}, (%{channel})" },
        ]
      end
    end

    it_behaves_like "a 1 to 1 morfer with transformation" do
      let(:definitions) do
        [
          {field: :title, from: :title, transformed: "%{value} and Zombies"}
        ]
      end
    end

    it_behaves_like "a morfer with nested source" do
      subject(:valid_path) do
        described_class.new(
          [
            { field: :rating, from: [:ratings, :imdb] }
          ]
        ).build
      end

      subject(:valid_path_with_transformation) do
        described_class.new(
          [
            { field: :rating, from: [:ratings, :imdb], transformed: "Rating: %{value}" }
          ]
        ).build
      end

      subject(:valid_path_with_calculation) do
        described_class.new(
          [
            { field: :ratings, calculated: "IMDB: %{ratings.imdb}, Trakt: %{ratings.trakt}, Rotten Tommatoes: %{ratings.rotten_tomatoes}" }
          ]
        ).build
      end

      subject(:invalid_path) do
        described_class.new(
          [
            { field: :rating, from: [:very, :long, :path, :that, :might, :not, :exist] }
          ]
        ).build
      end
    end
  end
end
