module MedusaRestClient
    class SurfaceLayer < ActiveResource::Base
      self.site = MedusaRestClient.site
      self.prefix = File.join(MedusaRestClient.prefix, 'surfaces/:surface_id/')
      self.element_name = 'layer'
      self.user = MedusaRestClient.user
      self.password = MedusaRestClient.password

      def surface
        Surface.find(self.prefix_options[:surface_id])
      end
    end
end