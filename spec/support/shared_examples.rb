shared_examples "an error throwing morfer" do
  include_context "tv shows"

  describe "#morf" do
    it "raises error for nil field" do
      expect{no_from.morf([{my_field: :something}])}.to raise_error(ArgumentError)
    end
  end

  describe "#morf_single" do
    it "raises error for nil field" do
      expect{no_from.morf_single({my_field: :something})}.to raise_error(ArgumentError)
    end
  end
end

shared_examples "a 1 to 1 morfer" do
  include_context "tv shows"

  describe "#morf" do
    let(:expected_output) { input.map{|v| {tv_show_title: v[:title]} } }

    it "maps title correctly" do
      expect(subject.morf(input)).to eq(expected_output)
    end

    it "leaves out nil values in result" do
      expected_output = [{},{}]
      modified_input = input.map{|h| h.reject{|k, v| k == :title}}
      expect(subject.morf(modified_input)).to eq(expected_output)
    end
  end

  describe "#morf_single" do
    let(:expected_output) do
      { tv_show_title: single_input[:title] }
    end

    it "maps title correctly" do
      expect(subject.morf_single(single_input)).to eq(expected_output)
    end

    it "leaves out nil values in result" do
      expected_output = {}
      modified_input = single_input.reject { |k, v| k == :title }
      expect(subject.morf_single(modified_input)).to eq(expected_output)
    end
  end
end

shared_examples "a 1 to many morfer" do
  include_context "tv shows"

  describe "#morf" do
    let(:expected_output) { input.map{|v| {title: v[:title], also_title: v[:title]} } }

    it "maps title to multiple fields" do
      expect(subject.morf(input)).to eq(expected_output)
    end
  end

  describe "#morf_single" do
    let(:expected_output) { {title: single_input[:title], also_title: single_input[:title]} }

    it "maps title to multiple fields" do
      expect(subject.morf_single(single_input)).to eq(expected_output)
    end
  end
end

shared_examples "a 1 to 1 morfer with transformation" do
  include_context "tv shows"

  describe "#morf" do
    let(:expected_output) { input.map{|v| {title: "#{v[:title]} and Zombies"} } }

    it "calls transformation correctly" do
      expect(subject.morf(input)).to eq(expected_output)
    end
  end

  describe "#morf_single" do
    let(:expected_output) { { title: "#{single_input[:title]} and Zombies" } }

    it "calls transformation correctly" do
      expect(subject.morf_single(single_input)).to eq(expected_output)
    end
  end
end

shared_examples "a calculating morfer" do
  include_context "tv shows"

  describe "#morf" do
    let(:expected_output) do
      input.map{|r| { title_with_channel: "#{r[:title]}, (#{r[:channel]})" } }
    end

    it "maps calculation correctly" do
      expect(subject.morf(input)).to eq(expected_output)
    end
  end

  describe "#morf_single" do
    let(:expected_output) do
      {
        title_with_channel: "#{single_input[:title]}, (#{single_input[:channel]})"
      }
    end

    it "maps calculation correctly" do
      expect(subject.morf_single(single_input)).to eq(expected_output)
    end
  end
end

shared_examples "a static morfer" do
  include_context "tv shows"

  describe "#morf" do
    let(:expected_output) { input.map{|r| {new_title: "Static Title"} } }

    it "maps static value correctly" do
      expect(subject.morf(input)).to eq(expected_output)
    end
  end

  describe "#morf_single" do
    let(:expected_output) { { new_title: "Static Title" } }

    it "maps static value correctly" do
      expect(subject.morf_single(single_input)).to eq(expected_output)
    end
  end
end

shared_examples "a morfer with nested source" do
  include_context "tv shows"

  describe "#morf" do
    context "valid path" do
      let(:expected_output) { input.map{|v| {rating: v[:ratings][:imdb]} } }

      it "maps nested attributes correctly" do
        expect(valid_path.morf(input)).to eq(expected_output)
      end
    end

    context "valid path with transformation" do
      let(:expected_output) { input.map{|v| {rating: "Rating: #{v[:ratings][:imdb]}"} } }

      it "maps and transforms nested attributes correctly" do
        expect(valid_path_with_transformation.morf(input)).to eq(expected_output)
      end
    end

    context "valid path with calculation" do
      let(:expected_output) do
        [
          { ratings: "IMDB: 8.7, Trakt: 89, Rotten Tommatoes: 93" },
          { ratings: "IMDB: 9.5, Trakt: 95, Rotten Tommatoes: 100" },
        ]
      end

      it "maps nested attributes with transformation" do
        expect(valid_path_with_calculation.morf(input)).to eq(expected_output)
      end
    end

    context "invalid path" do
      let(:expected_output) { [{},{}] }

      it "doesn't raise error for invalid path" do
        expect(invalid_path.morf(input)).to eq(expected_output)
      end
    end
  end

  describe "#morf_single" do
    context "valid path" do
      let(:expected_output) { {rating: single_input[:ratings][:imdb]} }

      it "maps nested attributes correctly" do
        expect(valid_path.morf_single(single_input)).to eq(expected_output)
      end
    end

    context "valid path with transformation" do
      let(:expected_output) { {rating: "Rating: #{single_input[:ratings][:imdb]}"} }

      it "maps nested attributes with transformation" do
        expect(valid_path_with_transformation.morf_single(single_input)).to eq(expected_output)
      end
    end

    context "valid path with calculation" do
      let(:expected_output) { {ratings: "IMDB: 8.7, Trakt: 89, Rotten Tommatoes: 93"} }

      it "maps nested attributes with transformation" do
        expect(valid_path_with_calculation.morf_single(single_input)).to eq(expected_output)
      end
    end

    context "invalid path" do
      let(:expected_output) { {} }

      it "doesn't raise error for invalid path" do
        expect(invalid_path.morf_single(single_input)).to eq(expected_output)
      end
    end
  end
end

shared_examples "a morfer with nested destination" do
  include_context "tv shows"

  describe "#morf" do
    let(:expected_output) do
      input.map do |v|
        {
          tv_show: {
            title: v[:title],
            channel: "Channel: #{v[:channel]}",
          }
        }
      end
    end

    it "maps to nested destination" do
      expect(subject.morf(input)).to eq(expected_output)
    end
  end

  describe "#morf_single" do
    let(:expected_output) do
      {
        tv_show: {
          title: single_input[:title],
          channel: "Channel: #{single_input[:channel]}",
        }
      }
    end

    it "maps to nested destination" do
      expect(subject.morf_single(single_input)).to eq(expected_output)
    end
  end
end
