module MedusaRestClient
	class Analysis < Base
		def get_casteml
			#uri = URI(self.class.site.to_s + self.class.element_path(id))
			uri = URI(casteml_url)
			req = Net::HTTP::Get.new(uri.path)
			req.basic_auth 'tkunihiro', 'password'
			res = Net::HTTP.start(uri.hostname, uri.port){|http|
				http.request(req)
			}
			data = res.body

		    #global_id = global_id.gsub(/\./,'_')
	        ofilename = 'downloaded.pml' unless ofilename
	        File.open(ofilename, 'w') do |f|
	        	f.puts data
	        end
		end

		def casteml_url
			url_txt = self.class.site.to_s + self.class.element_path(id)
			uri = URI.parse(url_txt)
			uri.path = File.join(File.dirname(uri.path),File.basename(uri.path, ".json"), 'casteml')
      		#uri.path = File.join(File.dirname(uri.path),File.basename(uri.path, ".*") + "." + fmt.to_s)
      		return uri.to_s
		end
	end
end