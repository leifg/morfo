require "spec_helper"

describe Morfo::Base do
  it_behaves_like "an error throwing morfer" do
    subject(:no_from) do
      class NilMorfer < Morfo::Base
        field(:my_field)
      end
      NilMorfer
    end
  end

  it_behaves_like "a 1 to 1 morfer" do
    subject do
      class TitleMorfer < Morfo::Base
        field(:tv_show_title).from(:title)
      end
      TitleMorfer
    end
  end

  it_behaves_like "a 1 to 1 morfer with transformation" do
    subject do
      class AndZombies < Morfo::Base
        field(:title).from(:title).transformed{|v| "#{v} and Zombies"}
      end
      AndZombies
    end
  end

  it_behaves_like "a 1 to many morfer" do
    subject do
      class MultiTitleMorfer < Morfo::Base
        field(:title).from(:title)
        field(:also_title).from(:title)
      end
      MultiTitleMorfer
    end
  end

  it_behaves_like "a calculating morfer" do
    subject do
      class TitlePrefixMorfer < Morfo::Base
        field(:title_with_channel).calculated{|r| "#{r[:title]}, (#{r[:channel]})"}
      end
      TitlePrefixMorfer
    end
  end

  it_behaves_like "a static morfer" do
    subject do
      class StaticTitleMorfer < Morfo::Base
        field(:new_title).calculated{ "Static Title" }
      end
      StaticTitleMorfer
    end
  end

  it_behaves_like "a morfer with nested source" do
    subject(:valid_path) do
      class ImdbRatingMorfer < Morfo::Base
        field(:rating).from(:ratings, :imdb)
      end
      ImdbRatingMorfer
    end

    subject(:valid_path_with_transformation) do
      class ImdbRatingMorferWithTransformation < Morfo::Base
        field(:rating).from(:ratings, :imdb).transformed {|v| "Rating: #{v}"}
      end
      ImdbRatingMorferWithTransformation
    end

    subject(:valid_path_with_calculation) do
      class ImdbRatingMorferWithCalculation < Morfo::Base
        field(:ratings).calculated {|r| "IMDB: #{r[:ratings][:imdb]}, Trakt: #{r[:ratings][:trakt]}, Rotten Tommatoes: #{r[:ratings][:rotten_tomatoes]}" }
      end
      ImdbRatingMorferWithCalculation
    end

    subject(:invalid_path) do
      class InvalidImdbRatingMorfer < Morfo::Base
        field(:rating).from(:very, :long, :path, :that, :might, :not, :exist)
      end
      InvalidImdbRatingMorfer
    end
  end

  it_behaves_like "a morfer with nested destination" do
    subject do
      class WrapperMorfer < Morfo::Base
        field(:tv_show, :title).from(:title)
        field(:tv_show, :channel).from(:channel).transformed {|v| "Channel: #{v}"}
      end
      WrapperMorfer
    end
  end
end
