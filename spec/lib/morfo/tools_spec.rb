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
  end
end
