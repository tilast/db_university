class GifImage
  include Virtus.model

  attribute :id,     Integer
  attribute :url,    String
  attribute :gif_id, Integer
end
