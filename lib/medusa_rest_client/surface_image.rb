module MedusaRestClient
    class SurfaceImage < ActiveResource::Base
      self.site = MedusaRestClient.site
      self.prefix = File.join(MedusaRestClient.prefix, 'surfaces/:surface_id/')
      self.element_name = 'image'
      self.user = MedusaRestClient.user
      self.password = MedusaRestClient.password
      
      #def element_path(options = nil)
      #  self.class.element_path(image_id, options || prefix_options)
      #end

      def to_param
        image_id && image_id.to_s
      end

      def surface
        Surface.find(self.prefix_options[:surface_id])
      end

      def make_tiles
        prefix = self.class.prefix(surface_id: self.prefix_options[:surface_id])
        collection_name = self.class.collection_name + '/' + self.image_id.to_s + '/tiles'
        path = "#{prefix}#{collection_name}#{self.class.format_extension}"
        connection.post(path,encode).tap do |response|
          return response
        end
      end
  

    end
end