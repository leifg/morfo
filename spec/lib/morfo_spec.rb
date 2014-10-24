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

  let(:single_input) do
    input.first
  end

  context 'errors' do
    subject(:no_from) do
      class NilMorfer < Morfo::Base
        field(:my_field)
      end
      NilMorfer
    end

    describe '#morf' do
      it 'raises error for nil field' do
        expect{no_from.morf([{my_field: :something}])}.to raise_error(ArgumentError)
      end
    end

    describe '#morf_single' do
      it 'raises error for nil field' do
        expect{no_from.morf_single({my_field: :something})}.to raise_error(ArgumentError)
      end
    end
  end

  context '1 to 1 conversion' do
    subject do
      class TitleMorfer < Morfo::Base
        field(:tv_show_title).from(:title)
      end
      TitleMorfer
    end

    describe '#morf' do
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

    describe '#morf_single' do
      it 'maps title correctly' do
        expected_output = { tv_show_title: single_input[:title] }
        expect(subject.morf_single(single_input)).to eq(expected_output)
      end

      it 'leaves out nil values in result' do
        expected_output = {}
        modified_input = single_input.reject { |k, v| k == :title }
        expect(subject.morf_single(modified_input)).to eq(expected_output)
      end
    end
  end

  context '1 to 1 conversion with transformation' do
    subject do
      class NumCastMorfer < Morfo::Base
        field(:cast_num).from(:cast).transformed{|v| v.size}
      end
      NumCastMorfer
    end

    describe '#morf' do
      it 'calls transformation correctly' do
        expected_output = input.map{|v| {cast_num: v[:cast].size} }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    describe '#morf_single' do
      it 'calls transformation correctly' do
        expected_output = { cast_num: single_input[:cast].size }
        expect(subject.morf_single(single_input)).to eq(expected_output)
      end
    end
  end

  context '1 to many conversion' do
    subject do
      class MutliTitleMorfer < Morfo::Base
        field(:title).from(:title)
        field(:also_title).from(:title)
      end
      MutliTitleMorfer
    end

    describe '#morf' do
      it 'maps title to multiple fields' do
        expected_output = input.map{|v| {title: v[:title], also_title: v[:title]} }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    describe '#morf_single' do
      it 'maps title to multiple fields' do
        expected_output = {title: single_input[:title], also_title: single_input[:title]}
        expect(subject.morf_single(single_input)).to eq(expected_output)
      end
    end
  end

  context 'nested conversion' do
    context 'nested source' do
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

      subject(:invalid_path) do
        class InvalidImdbRatingMorfer < Morfo::Base
          field(:rating).from(:very, :long, :path, :that, :might, :not, :exist)
        end
        InvalidImdbRatingMorfer
      end

      describe '#morf' do
        it 'maps nested attributes' do
          expected_output = input.map{|v| {rating: v[:ratings][:imdb]} }
          expect(valid_path.morf(input)).to eq(expected_output)
        end

        it 'maps nested attributes with transformation' do
          expected_output = input.map{|v| {rating: "Rating: #{v[:ratings][:imdb]}"} }
          expect(valid_path_with_transformation.morf(input)).to eq(expected_output)
        end

        it 'doesn\'t raise error for invalid path' do
          expected_output = [{},{}]
          expect(invalid_path.morf(input)).to eq(expected_output)
        end
      end

      describe '#morf_single' do
        it 'maps nested attributes' do
          expected_output = {rating: single_input[:ratings][:imdb]}
          expect(valid_path.morf_single(single_input)).to eq(expected_output)
        end

        it 'maps nested attributes with transformation' do
          expected_output = {rating: "Rating: #{single_input[:ratings][:imdb]}"}
          expect(valid_path_with_transformation.morf_single(single_input)).to eq(expected_output)
        end

        it 'doesn\'t raise error for invalid path' do
          expected_output = { }
          expect(invalid_path.morf_single(single_input)).to eq(expected_output)
        end
      end
    end

    context 'nested destination' do
      subject do
        class WrapperMorfer < Morfo::Base
          field(:tv_show, :title).from(:title)
          field(:tv_show, :channel).from(:channel).transformed {|v| "Channel: #{v}"}
        end
        WrapperMorfer
      end

      describe '#morf' do
        it 'maps to nested destination' do
          expected_output = input.map{|v|
            {
              tv_show: {
                title: v[:title],
                channel: "Channel: #{v[:channel]}",
              }
            }
          }
          expect(subject.morf(input)).to eq(expected_output)
        end
      end

      describe '#morf_single' do
        it 'maps to nested destination' do
          expected_output = {
            tv_show: {
              title: single_input[:title],
              channel: "Channel: #{single_input[:channel]}",
            }
          }
          expect(subject.morf_single(single_input)).to eq(expected_output)
        end
      end
    end
  end

  context 'calculations' do
    subject do
      class TitlePrefixMorfer < Morfo::Base
        field(:title_with_channel).calculated{|r| "#{r[:title]}, (#{r[:channel]})"}
      end
      TitlePrefixMorfer
    end

    describe '#morf' do
      it 'maps calculation correctly' do
        expected_output = input.map{|r|
          {
            title_with_channel: "#{r[:title]}, (#{r[:channel]})"
          }
        }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    describe '#morf_single' do
      it 'maps calculation correctly' do
        expected_output = {
          title_with_channel: "#{single_input[:title]}, (#{single_input[:channel]})"
        }

        expect(subject.morf_single(single_input)).to eq(expected_output)
      end
    end
  end

  context 'static values' do
    subject do
      class StaticTitleMorfer < Morfo::Base
        field(:new_title).calculated{ 'Static Title' }
      end
      StaticTitleMorfer
    end

    describe '#morf' do
      it 'maps static value correctly' do
        expected_output = input.map{|r| {new_title: 'Static Title'} }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    describe '#morf_single' do
      it 'maps static value correctly' do
        expected_output = { new_title: 'Static Title' }
        expect(subject.morf_single(single_input)).to eq(expected_output)
      end
    end
  end
end
