module MedusaRestClient
  class Surface < Base
    def to_json(options={})
      super({ :root => self.class.element_name }.merge(options))
    end

    def images(scope=:all)
      SurfaceImage.find(scope, :params => { :surface_id => id })      
    end

    def create_spot(spot_params)
      spot = Spot.new(spot_params)
      spot.prefix_options[:surface_id] = self.id
      spot.save
    end

    def make_tiles
      prefix = self.class.prefix
      collection_name = self.class.collection_name + '/' + self.id.to_s + '/tiles'
      path = "#{prefix}#{collection_name}#{self.class.format_extension}"
      connection.post(path,encode).tap do |response|
        return response
      end
    end

    def make_image_tiles(image_id)
      surface_image = self.images(image_id)
      surface_image.make_tiles
    end

    def make_layer_tiles(layer_id)
      prefix = self.class.prefix
      collection_name = self.class.collection_name + '/' + self.id.to_s + '/layers/' + layer_id.to_s + '/tiles'
      path = "#{prefix}#{collection_name}#{self.class.format_extension}"
      connection.post(path,encode).tap do |response|
        return response
      end      
    end
  end
end
