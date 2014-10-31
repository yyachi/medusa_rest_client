module MedusaRestClient
	class Chemistry < ActiveResource::Base
		self.site = MedusaRestClient.site
		self.prefix = File.join(MedusaRestClient.prefix, 'analyses/:analysis_id/')
		self.user = MedusaRestClient.user
		self.password = MedusaRestClient.password
		def analysis
			Analysis.find(self.prefix_options[:analysis_id])
		end
		def analysis=(analysis)
			self.prefix_options[:analysis_id] = analysis.id
		end
	end
end