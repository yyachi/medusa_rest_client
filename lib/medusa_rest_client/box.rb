module MedusaRestClient
	class Box < Base
#		@@pwd = nil
#		@@pwd_id = nil
		#has_many :stones, :class_name => 'medusa_api/stone'
		def self.find_by_path(path)
			unless path
				path = self.home
			end
			path = Pathname.new(path)
			unless path.absolute?
				path = Pathname.new(self.pwd) + path
			end

			path = path.cleanpath
			dirname = path.dirname
			basename = path.basename

			target_name = basename.to_s
			query = {:name_eq => target_name, :m => 'and'}
			if dirname == Pathname.new("/")
				query[:path_blank] = true
			else
				query[:path_eq] = dirname.to_s
			end

			self.find(:first, :params => {:q => query})
		end

		def self.chdir(path)
			if box = self.find_by_path(path)
				self.pwd_id = box.global_id
				@@pwd = path
				return true
			else
				return false
			end
		end

		def fullpath
			File.join(path, name)
		end
	end
end