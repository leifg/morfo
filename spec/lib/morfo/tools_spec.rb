require "spec_helper"

module Morfo
  module Tools
    describe FlattenHashKeys do
      subject { described_class.new(input_hash) }

      context "symbol keys" do
        context "flat hash" do
          let(:input_hash) { { simple: :hash } }
          let(:expected_output) { { simple: :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end

        context "single nested hash" do
          let(:input_hash) { { a: { nested: :hash } } }
          let(:expected_output) { { :"a.nested" => :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end

        context "already nested" do
          let(:input_hash) { { :"a.nested" => :hash } }
          let(:expected_output) { { :"a.nested" => :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end

        context "multiple nested hash" do
          let(:input_hash) { { a: { deeper: { nested: :hash } } } }
          let(:expected_output) { { :"a.deeper.nested" => :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end
      end

      context "string keys" do
        context "flat hash" do
          let(:input_hash) { { "simple" => :hash } }
          let(:expected_output) { { simple: :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end

        context "single nested hash" do
          let(:input_hash) { { "a" => { "nested" => :hash } } }
          let(:expected_output) { { :"a.nested" => :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end

        context "multiple nested hash" do
          let(:input_hash) { { "a" => { "deeper" => { "nested" => :hash } } } }
          let(:expected_output) { { :"a.deeper.nested" => :hash } }

          it "returns a new hash" do
            expect(subject.flatten).not_to be(input_hash)
          end

          it "returns the correct hash" do
            expect(subject.flatten).to eq(expected_output)
          end
        end
      end
    end

    describe BaseKeys do
      subject { described_class.new(input_string) }

      describe "#build" do
        context "empty string" do
          let(:input_string) { "" }
          let(:expected_output) { { } }

          context "empty string" do
            it "returns empty hash" do
              expect(subject.build).to eq(expected_output)
            end
          end
        end

        context "nil input" do
          let(:input_string) { nil }
          let(:expected_output) { { } }

          context "empty string" do
            it "returns empty hash" do
              expect(subject.build).to eq(expected_output)
            end
          end
        end

        context "non nested values" do
          let(:input_string) { "The rating is: %{rating}" }
          let(:expected_output) { { rating: nil } }

          describe "build" do
            it "returns expected values" do
              expect(subject.build).to eq(expected_output)
            end
          end
        end
      end
    end
  end
end
