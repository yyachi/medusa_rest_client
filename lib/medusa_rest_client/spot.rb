module MedusaRestClient
    class Spot < Base
        def collection_path(options = nil)
            if prefix_options[:attachment_file_id]
                prefix = File.join(MedusaRestClient.prefix, "attachment_files/#{prefix_options[:attachment_file_id]}/")
            elsif prefix_options[:image_id]
                prefix = File.join(MedusaRestClient.prefix, "attachment_files/#{prefix_options[:image_id]}/")
            else
                prefix = File.join(MedusaRestClient.prefix, "surfaces/#{prefix_options[:surface_id]}/")
            end
            path = "#{prefix}#{self.class.collection_name}#{self.class.format_extension}"
            return path
        end
    end
end
