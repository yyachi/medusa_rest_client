module MedusaRestClient
	class Record < Base

        def self.instantiate_record(record, prefix_options = {})
#        	p "Record.instantiate_record..."
			myclass = ("MedusaRestClient::" + record["datum_type"].classify).constantize
			attributes = record["datum_attributes"]
			myclass.new(attributes, true)
	          # new(record, true).tap do |resource|
	          #   resource.prefix_options = prefix_options
	          # end
        end

	  #   def destroy
	  #   	path = self.class.element_path(self.global_id)
			# connection.delete(path, self.class.headers)
	  #   end		
	end
end