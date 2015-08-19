json.array!(@sponsors) do |sponsor|
  json.extract! sponsor, :id, :name, :description, :image_link, :facebook_link, :twitter_link, :website_link
  json.url sponsor_url(sponsor, format: :json)
end
