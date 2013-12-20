require 'spec_helper'

describe Morfo::Base do
  let(:input) do
    [
      {
        title: 'The Walking Dead',
        channel: 'AMC',
        watchers: 1337,
        status: 'running',
        cast: ['Lincoln, Andrew', 'McBride, Melissa'],
        ratings: {
          imdb: 8.7,
          trakt: 89,
          rotten_tomatoes: 93,
        },
      },
      {
        title: 'Breaking Bad',
        channel: 'AMC',
        watchers: 72891,
        status: 'ended',
        cast: ['Cranston, Bryan', 'Gunn, Anna'],
        ratings: {
          imdb: 9.5,
          trakt: 95,
          rotten_tomatoes: 100,
        },
      }
    ]
  end

  describe '#morf' do
    context '1 to 1 conversion' do
      subject do
        class TitleMapper < Morfo::Base
          map :title, :tv_show_title
        end
        TitleMapper
      end

      it 'maps title correctly' do
        expected_output = input.map{|v| {tv_show_title: v[:title]} }
        expect(subject.morf(input)).to eq(expected_output)
      end

      it 'leaves out nil values in result' do
        expected_output = [{},{}]
        modified_input = input.map{|h| h.reject{|k, v| k == :title}}
        expect(subject.morf(modified_input)).to eq(expected_output)
      end
    end

    context '1 to 1 conversion with transformation' do
      subject do
        class NumCastMapper < Morfo::Base
          map :cast, :cast_num do |cast|
            cast.size
          end
        end
        NumCastMapper
      end

      it 'calls transformation correctly' do
        expected_output = input.map{|v| {cast_num: v[:cast].size} }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    context 'nested conversion' do
      subject(:valid_path) do
        class ImdbRatingMapper < Morfo::Base
          map [:ratings, :imdb], :rating
        end
        ImdbRatingMapper
      end

      subject(:invalid_path) do
        class InvalidImdbRatingMapper < Morfo::Base
          map [:very, :long, :path, :that, :might, :not, :exist], :rating
        end
        InvalidImdbRatingMapper
      end

      it 'maps nested attributes' do
        expected_output = input.map{|v| {rating: v[:ratings][:imdb]} }
        expect(valid_path.morf(input)).to eq(expected_output)
      end

      it 'doesn\'t raise error for invalid path' do
        expected_output = [{},{}]
        expect(invalid_path.morf(input)).to eq(expected_output)
      end
    end
  end
end
