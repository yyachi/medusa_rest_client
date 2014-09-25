module MedusaRestClient
	class Record < Base

        def self.instantiate_record(record, prefix_options = {})
			myclass = ("MedusaRestClient::" + record["datum_type"].classify).constantize
			attributes = record["datum_attributes"]
			myclass.new(attributes, true)
        end

        # def self.find_single(*args)
        # 	begin
        # 		super
        # 	rescue ActiveResource::ResourceNotFound
        # 		self.find_by_path(args[0])
        # 	end
        # end

        def self.entries(id_or_path)
        	obj = find_by_id_or_path(id_or_path)
        	if obj.kind_of?(Box)
        		obj.entries
        	else
        		[obj]
        	end
        end

        def self.box?(id_or_path)
        	obj = find_by_id_or_path(id_or_path)
        	obj.kind_of?(Box)
        end

       def self.stone?(id_or_path)
        	obj = find_by_id_or_path(id_or_path)
        	obj.kind_of?(Stone)
        end

        def self.find_by_id_or_path(id_or_path)
        	self.find(id_or_path)
        rescue ActiveResource::ResourceNotFound
        	self.find_by_path(id_or_path)
        end

	    def self.find_by_path(path)
	    	obj = Box.find_by_path(path)
	    rescue RuntimeError
	    	begin
	    	obj = Stone.find_by_path(path)
	    	rescue RuntimeError => ex
	    		raise RuntimeError.new("#{path}: No such record")
	    	end
	    end
	end
end