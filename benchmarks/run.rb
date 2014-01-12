require 'morfo'
require 'benchmark'
require './benchmarks/data'

iterations = 100
batch_size = 10000

definitions = [
  {
    label: 'Simple (strings)',
    row: BenchmarkData.row_string_keys,
    morf_class: BenchmarkData::SimpleMappingString
  },
  {
    label: 'Simple (symbols)',
    row: BenchmarkData.row,
    morf_class: BenchmarkData::SimpleMappingSymbol
  },
  {
    label: 'Nested (strings)',
    row: BenchmarkData.row_nested_string_keys,
    morf_class: BenchmarkData::NestedMappingString
  },
  {
    label: 'Nested (symbols)',
    row: BenchmarkData.row_nested,
    morf_class: BenchmarkData::NestedMappingSymbol
  },
]

definitions.each do |defintition|
  defintition.merge!(
    data: Array.new(batch_size){ defintition[:row] }
    )
end

Benchmark.bm(20) do |x|
  definitions.each do |defintition|
    x.report(defintition[:label]) do
      iterations.times do
        defintition[:morf_class].morf(defintition[:data])
      end
    end
  end
end

