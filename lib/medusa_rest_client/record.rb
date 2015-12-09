module MedusaRestClient
	class Record < Base

        def self.instantiate_record(record, prefix_options = {})
			myclass = ("MedusaRestClient::" + record["datum_type"].classify).constantize
			attributes = record["datum_attributes"].dup
			myclass.new(attributes, true)
        end

        def self.download_casteml(id, opts = {})
            File.open(id + ".pml", "wb") {|f|
                f.puts download_one(:from => casteml_path(id))
            }
        end

        def self.casteml_path(id)
            path = element_path(id)
            dirname = File.dirname(path)
            basename = File.basename(path, ".*")
            ext = File.extname(path)
            "#{dirname}/#{basename}/casteml"
        end


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

        def self.specimen?(id_or_path)
        	obj = find_by_id_or_path(id_or_path)
        	obj.kind_of?(Specimen)
        end

        def self.stone?(id_or_path)
            self.specimen?(id_or_path)
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
	    	obj = Specimen.find_by_path(path)
	    	rescue RuntimeError => ex
	    		raise RuntimeError.new("#{path}: No such record")
	    	end
	    end
	end
end