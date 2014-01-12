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
          field :tv_show_title, from: :title
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
          field :cast_num, from: :cast, transformation: proc { |v| v.size}
        end
        NumCastMapper
      end

      it 'calls transformation correctly' do
        expected_output = input.map{|v| {cast_num: v[:cast].size} }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    context '1 to many conversion' do
      subject do
        class MutliTitleMapper < Morfo::Base
          field :title, from: :title
          field :also_title, from: :title
        end
        MutliTitleMapper
      end

      it 'maps title to multiple fields' do
        expected_output = input.map{|v| {title: v[:title], also_title: v[:title]} }
        expect(subject.morf(input)).to eq(expected_output)
      end
    end

    context 'nested conversion' do
      context 'nested source' do
        subject(:valid_path) do
          class ImdbRatingMapper < Morfo::Base
            field :rating, from: [:ratings, :imdb]
          end
          ImdbRatingMapper
        end

        subject(:invalid_path) do
          class InvalidImdbRatingMapper < Morfo::Base
            field :rating, from: [:very, :long, :path, :that, :might, :not, :exist]
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

      context 'nested destination' do
        subject do
          class WrapperMapper < Morfo::Base
            field([:tv_show, :title], from: :title)
            field([:tv_show, :channel], from: :channel)
          end
          WrapperMapper
        end

        it 'maps to nested destination' do
          expected_output = input.map{|v|
            {
              tv_show: {
                title: v[:title],
                channel: v[:channel],
              }
            }
          }
          expect(subject.morf(input)).to eq(expected_output)
        end
      end
    end
  end
end
