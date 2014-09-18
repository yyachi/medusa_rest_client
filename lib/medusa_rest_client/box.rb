module MedusaRestClient
	class Box < Base
#		@@pwd = nil
#		@@pwd_id = nil
		#has_many :stones, :class_name => 'medusa_api/stone'
		def self.chdir(path)
			path = Pathname.new(path).cleanpath
			dirname = path.dirname
			basename = path.basename
			target_path = dirname.to_s
			if dirname == Pathname.new("/")
				target_path = ""
			end
			target_name = basename.to_s
			box = Box.find(:first, :params => {:q => {:path_eq => target_path, :name_eq => target_name, :m => 'and'}})
			if box
				@@pwd = path
				@@pwd_id = box.global_id
				return true
			else
				return false
			end
		end

		def self.pwd
			@@pwd
		end

		def self.pwd_id
			@@pwd_id
		end
	end
end