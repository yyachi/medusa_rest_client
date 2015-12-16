module MedusaRestClient
	class Box < Base
		@@pwd_id = nil
		@@home_id = nil
		@@pwd = nil
		@@home = nil

		def self.home_id()
			@@home_id
		end

		def self.home_id=(id)
			@@home_id = id
			@@home = nil
		end

		def self.home()
			return "/" if @@home_id.blank?
			if @@home.blank?
				@@home = Record.find(@@home_id).path
			end
			return @@home
		end

		def self.home=(path)
			if path.blank?
				self.home_id = nil
			end
			if home = Box.find_by_path(path)
				self.home_id = home.global_id
				@@home = home.fullpath
			end
		end

		def self.pwd()
			return "/" if @@pwd_id.blank?
			if @@pwd.blank?
				@@pwd = Record.find(@@pwd_id).fullpath
			end
			return @@pwd
		end

		def self.pwd_id()
			@@pwd_id
		end

		def self.pwd_id=(id)
			@@pwd_id = id
			@@pwd = nil
		end


		def self.entries(path)
			# path = mycleanpath(path)
			# if path == Pathname.new("/")
			# 	root_entries
			# else
			box = find_by_path(path)
			box.entries if box
			# end
		end

		def self.root_entries
			@entries = on_root.elements
		end

		def self.find_by_path(path)
			# path = Pathname.new(path)
			# unless path.absolute?
			# 	path = Pathname.new(self.pwd) + path
			# end

			# path = path.cleanpath
			path = mycleanpath(path)

			if path == Pathname.new("/")
				BoxRoot.new
			else
				dirname = path.dirname
				basename = path.basename

				target_name = basename.to_s
				query = {:name_eq => target_name, :m => 'and'}
				if dirname == Pathname.new("/")
					query[:path_blank] = true
				else
					query[:path_eq] = dirname.to_s
				end

				obj = self.find(:first, :params => {:q => query})
				raise RuntimeError.new("#{path}: No such box") unless obj
				obj
			end
		end

		def self.on_root(opts = {})
			query = {}
			query[:path_blank] = true
			params = {:q => query}
			elements = []
			collection = self.find(:all, :params => params)
			unless collection.elements.empty?
				next_collection = collection.dup
			 	while true
			 		next_collection = next_collection.next_page
			 		break if next_collection.elements.empty?
			 		collection.elements.concat(next_collection.elements)
			 	end
			end
			collection
		end

		def self.chdir(path)
			path = self.home if path.blank?

			if path == '/'
				self.pwd_id = nil
				return true
			end

			if box = self.find_by_path(path)
				self.pwd_id = box.global_id
				#@@pwd = path
				return true
			else
				return false
			end
		end

		def fullpath
			File.join(path, name)
		end

		def entries(opts = {})
			@entries = [] unless @entries
			if @entries.empty?
				@entries = @entries.concat(boxes.to_a)
				@entries = @entries.concat(specimens.to_a)
			end
			return @entries.sort{|a,b| a.name <=> b.name }
		end

	  	def inventory_path(obj)
			  "#{self.class.prefix}#{self.class.collection_name}/#{self.id}/#{obj.class.collection_name}/#{obj.id}/inventory#{obj.class.format_extension}"
	  	end

		def inventory(obj)
	        connection.post(inventory_path(obj), obj.encode, obj.class.headers).tap do |response|
	          #load_attributes_from_response(response)
	        end
		end

		def box
			parent
		end
	end
end