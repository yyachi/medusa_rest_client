module MedusaRestClient
	class Analysis < Base
		def download_casteml
			File.open(global_id + ".pml", "wb") {|f|
				f.puts self.class.download_one(:from => casteml_path)
			}
		end

		def casteml_path
			path = self.class.element_path(id)
			dirname = File.dirname(path)
			basename = File.basename(path, ".*")
			ext = File.extname(path)
			"#{dirname}/#{basename}/casteml"
		end

	end
end