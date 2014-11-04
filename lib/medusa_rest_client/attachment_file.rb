module MedusaRestClient
	class AttachmentFile < Base

		def self.find_by_file(filepath)
			md5hash = Digest::MD5.hexdigest(File.open(filepath, 'rb').read)
			self.find(:first, :params => {:q => {:md5hash_eq => md5hash}} )
		end
		def self.find_or_create_by_file(filepath)
			mi = self.find_by_file(filepath)
			return mi if mi
			mi = self.new(:file => file)
			mi.save
			mi
		end


		def self.upload(filepath, opts = {})
			raise "#{filepath} does not exist" unless File.exists?(filepath)
			obj = AttachmentFile.create(opts.merge(:file => filepath))
			obj
		end

	    # def self.find_by_localfile(mylocalfile)
	    #   md5hash = Digest::MD5.hexdigest(File.open(mylocalfile, 'rb').read)
	    #   existings = Attachment.find(:all, :params => {:md5hash => md5hash})
	    # end


	    def save
	      if new?
	        #create_with_upload_data
	        post_multipart_form_data(to_multipart_form_data)
	      else
	        update
	      end
	    end

	    # def create_with_upload_data
	    #   boundary="-------------------3948A8"
	    #   data = make_post_data(boundary,self.class.element_name,self.attributes)

	    #   header ={
	    #     'Content-Length' => data.length.to_s,
	    #     'Content-Type' => "multipart/form-data; boundary=#{boundary}",
	    #     'Accept' => 'application/json'
	    #   }

	    #   connection.post(collection_path, data, header).tap do |response|
	    #     self.id = id_from_response(response)
	    #     return load_attributes_from_response(response)
	    #   end

	    # end

	    # def make_post_data(boundary, model, post_data={})
	    #   type = {
	    #     ".pdf" => "application/pdf",
	    #     ".txt" => "text/plain",
	    #     ".tex" => "text/plain",        
	    #     ".gif" => "image/gif",
	    #     ".jpg" => "image/jpeg",
	    #     ".JPG" => "image/jpeg",
	    #     ".jpeg" => "image/jpeg",
	    #     ".png"=> "image/png",
	    #     ".flv" => "video/x-flv",
	    #     ".wmv" => "video/x-ms-wmv"
	    #   }
	    #   data = ""
	    #   post_data.each do |key , value|
	    #     unless key == 'file'
	    #       data << %[--#{boundary}\r\n]
	    #       data << %[Content-disposition: form-data; name="#{model}[#{key}]"\r\n]
	    #       data << "\r\n"
	    #       data << "#{value}\r\n"
	    #     end
	    #   end

	    #   path = post_data['file']
	    #   if path
	    #     data << %[--#{boundary}] + "\r\n"
	    #     data << %[Content-Disposition: form-data; name="#{model}[data]"; filename="#{File.basename(path)}"] + "\r\n"
	    #     data << "Content-Type: #{type.fetch(File.extname(path))}" + "\r\n\r\n"
	    #     # data << "Content-Transfer-Encoding: binary\r\n"
	    #     #data << File.read(path)
	    #     data << File.open(path){|file|
	    #       file.binmode
	    #       file.read
	    #     }
	    #   end
	    #   data << %[\r\n--#{boundary}--\r\n]
	    #   data
	    # end

	end
end