json.array!(@variants) do |variant|
  json.extract! variant, :id, :name, :answer
  json.url variant_url(variant, format: :json)
end
