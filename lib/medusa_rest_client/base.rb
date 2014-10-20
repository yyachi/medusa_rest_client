module MedusaRestClient
	class Base < ActiveResource::Base
		@@pref_path = nil
		@@default_config = {'uri' => 'database.misasa.okayama-u.ac.jp/stone/', 'user' => 'admin', 'password' => 'password'}
		@@config = nil
		@@boundary = "3948A8"
		attr_accessor :pref_path



		def self.pref_path=(pref) @@pref_path = pref end
		def self.pref_path() @@pref_path end
		def self.config=(config) @@config = config end
		def self.config() @@config end
		def self.init(opts = {})
			#@@pwd_id = ENV['OROCHI_PWD_ID'] || nil
			@@pwd_id = ENV['OROCHI_PWD'] || nil
			@@home_id = ENV['OROCHI_HOME'] || nil		
			self.pref_path = opts[:pref_path] || "~/.orochirc"
			begin
				self.config = self.read_config
			rescue
				self.config = @@default_config
				self.write_config
			end

			self.site = self.myuri.scheme + '://' + self.myuri.host + (self.myuri.port ? ":#{self.myuri.port}" : "")
			self.prefix = self.myuri.path
			self.user = self.config['user']
			self.password = self.config['password']

		end

		def self.myuri
			uri_string = self.config['uri']
			uri_string = "http://" + uri_string unless (/:\/\// =~ uri_string)
			uri_string = uri_string + "/" unless (/\/\z/ =~ uri_string)
			myuri = URI.parse(uri_string)				
		end

		def self.site_with_userinfo
			return self.site if !self.user || !self.password
			uri = self.site.dup
			uri.userinfo = [self.user, self.password]
			uri
		end

		def self.read_config
			config = YAML.load(File.read(File.expand_path(self.pref_path)))
		end

		def self.write_config
			config = Hash.new
			config = self.config
			STDERR.puts("writing |#{File.expand_path(self.pref_path)}|")
			open(File.expand_path(self.pref_path), "w") do |f|
				YAML.dump(config, f)
			end
		end

		def self.content_types
			{
	        ".pdf" => "application/pdf",
	        ".txt" => "text/plain",
	        ".tex" => "text/plain",        
	        ".gif" => "image/gif",
	        ".jpg" => "image/jpeg",
	        ".JPG" => "image/jpeg",
	        ".jpeg" => "image/jpeg",
	        ".png"=> "image/png",
	        ".flv" => "video/x-flv",
	        ".wmv" => "video/x-ms-wmv"
	      	}						
		end

		def self.default_content_type
			"application/octet-stream"
		end

		def self.get_content_type_from_extname(extname)
			#content_types.fetch(extname)
			content_types[extname]
		end

		def self.mycleanpath(path)
			path = Pathname.new(path)
			unless path.absolute?
				path = Pathname.new(self.pwd) + path
			end
			path = path.cleanpath
		end

		def self.find_by_name(name)
			self.find(:all, :params => {:q => {:name_cont => name}})
		end

		def self.search(params = {})
			self.find(:all, :params => {:q => params})
		end

		def post_multipart_form_data(data, post_path = collection_path)
			raise "could not find boundary" unless md = data.match(/^--(.*)\r\n/)
			boundary = md[1]
			header ={
	        	'Content-Length' => data.length.to_s,
	        	'Content-Type' => "multipart/form-data; boundary=#{boundary}",
	        	'Accept' => 'application/json'
	      	}
			connection.post(post_path, data, header).tap do |response|
				self.id = id_from_response(response)
				return load_attributes_from_response(response)
			end			
		end

		#def self.element_path_with_format_extension(id, prefix_options = {}, query_options = nil)
		#	check_prefix_options(prefix_options)
		#	prefix_options, query_options = split_options(prefix_options) if query_options.nil?
		#	"#{prefix(prefix_options)}#{collection_name}/#{URI.parser.escape id.to_s}#{query_string(query_options)}"
		#end


		def self.download_single(scope, options)
	 		prefix_options, query_options = split_options(options[:params])
			path = element_path(scope, prefix_options, query_options)
			basename = File.basename(path)
			File.open(basename, 'wb') {|f|
				f.puts connection.get(path, headers).body
			}
		end

		def self.download_one(options)
			content = nil
			case from = options[:from]
				when Symbol
					content = get(from, options[:params])
				when String
					path = "#{from}#{query_string(options[:params])}"
					content = connection.get(path, headers).body
			end
			content
		end


		def upload_file(opts = {})
			raise "specify :file" unless opts[:file]
			#file = AttachmentFile.new(:file => opts[:file])
			file = AttachmentFile.new(opts)
			#filepath = opts[:file]
			prefix = self.class.prefix
			collection_name = self.class.collection_name + '/' + self.id.to_s + '/' + AttachmentFile.collection_name
			format_extension = self.class.format_extension
        	upload_path = "#{prefix}#{collection_name}#{format_extension}"
        	file.post_multipart_form_data(file.to_multipart_form_data, upload_path)
        	return file
			#attachment_file = AttachmentFile.upload()
		end

		def to_multipart_form_data(opts = {})

			boundary = opts[:boundary] || @@boundary
			model = opts[:model] || self.class.element_name

			path = attributes.delete('file')
			data = []

			if path
				filename = attributes.delete('filename') || File.basename(path)
				#filename = File.basename(path)
				content_type = self.class.get_content_type_from_extname(File.extname(filename))	|| self.class.default_content_type			
				data << "--#{boundary}"
				data << "Content-Disposition: form-data; name=\"#{model}[data]\"; filename=\"#{filename}\""
				data << "Content-Type: #{content_type}"
				data << ""
				data << File.open(path){|file|
				  file.binmode
				  file.read
				}
			end

			attributes.each do |key , value|
				unless key == 'file'
				  data << "--#{boundary}"
				  data << "Content-disposition: form-data; name=\"#{model}[#{key}]"
				  data << ""
				  data << value
				end
			end
			data << ""
			data << "--#{boundary}--"
			data << ""
			data.join("\r\n")
		end

		def self.find_or_create_by_name(name, params = {})
			obj = self.find(:first, :params => {:q => {:name_eq => name}})
			unless obj
				params.merge!(:name => name)
				obj = self.create(params)
			end
			obj
		end

		#associations
		def parent
			p_id = self.attributes["parent_id"]
			return unless p_id
			self.class.find(p_id)
		end

		def box
			p_id = self.attributes["box_id"]
			return unless p_id
			Box.find(p_id)	
		end

		def stone
			p_id = self.attributes["stone_id"]
			return unless p_id
			Stone.find(p_id)
		end

		def place
			p_id = self.attributes["place_id"]
			return unless p_id
			Place.find(p_id)
		end

		def attachment_file
			p_id = self.attributes["attachment_file_id"]
			return unless p_id
			AttachmentFile.find(p_id)
		end

		def relatives
			MyAssociation.new(self)
		end

		def boxes
			MyAssociation.new(self, Box)			
		end

		def stones
			MyAssociation.new(self, Stone)
		end

		def attachment_files
			MyAssociation.new(self, AttachmentFile)			
		end

		def bibs
			MyAssociation.new(self, Bib)			
		end

		def analyses
			MyAssociation.new(self, Analysis)
		end

		def spots
			MyAssociation.new(self, Spot)			
		end

	end
end