module MedusaRestClient
	class Record < Base

        def self.instantiate_record(record, prefix_options = {})
			myclass = ("MedusaRestClient::" + record["datum_type"].classify).constantize
			attributes = record["datum_attributes"]
			myclass.new(attributes, true)
        end

        def self.find_single(*args)
        	begin
        		super
        	rescue ActiveResource::ResourceNotFound
        		self.find_by_path(args[0])
        	end
        end

	    def self.find_by_path(path)
	    	obj = Box.find_by_path(path)
	    	unless obj
	    		obj = Stone.find_by_path(path)
	    	end
	    	obj
	    end
	end
end