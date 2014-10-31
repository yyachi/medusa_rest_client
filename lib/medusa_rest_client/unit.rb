module MedusaRestClient
	class Unit < ActiveResource::Base
		self.site = MedusaRestClient.site
		self.prefix = MedusaRestClient.prefix
		self.user = MedusaRestClient.user
		self.password = MedusaRestClient.password

		def self.find_by_name(name)
			self.find(:first, :params => {:q => {:name_eq => name}} )
		end

	end
end