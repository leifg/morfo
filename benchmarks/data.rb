module BenchmarkData
  extend self

  def nested_wrapper
    :person
  end

  def row
    {
      first_name: 'Jazmyn',
      last_name: 'Willms',
      gender: 'female',
      phone_number: '485-675-9228',
      cell_phone: '1-172-435-9402 x4907',
      street_name: 'Becker Inlet',
      street_number: '15a',
      city: 'Carolynchester',
      zip: '38189',
      country: 'USA',
    }
  end

  def row_string_keys
    stringify_keys(row)
  end

  def row_nested
    {
      nested_wrapper => row
    }
  end

  def row_nested_string_keys
    {
      nested_wrapper.to_s => row_string_keys
    }
  end

  private
  def stringify_keys hash
    hash.keys.each do |key|
      hash[key.to_s] = hash.delete(key)
    end
    hash
  end

  class SimpleMorferSymbol < Morfo::Base
    BenchmarkData.row.keys.each do |field|
      field(:"#{field}_mapped", from: field)
    end
  end

  class SimpleMorferString < Morfo::Base
    BenchmarkData.row_string_keys.keys.each do |field|
      field("#{field}_mapped", from: field)
    end
  end

  class NestedMorferSymbol < Morfo::Base
    BenchmarkData.row_nested.each do |key, value|
      value.keys.each do |field|
        field(:"#{field}_mapped", from: [key, field])
      end
    end
  end

  class NestedMorferString < Morfo::Base
    BenchmarkData.row_nested_string_keys.each do |key, value|
      value.keys.each do |field|
        field("#{field}_mapped", from: [key, field])
      end
    end
  end
end
