module MedusaRestClient
	class Bib < Base
		def to_json(options={})
		  super({ :root => self.class.element_name }.merge(options))
		end

	end
end