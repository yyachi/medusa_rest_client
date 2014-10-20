module MedusaRestClient
  class MyAssociation
  	def initialize(resource, subclass = nil)
  		@resource = resource
   		@prefix = @resource.class.prefix
   		if subclass
  			@subclass = subclass
#  			@collection_name = resource.class.collection_name + '/' + resource.id.to_s + '/' + subclass.collection_name
  		end
#		@collection_path = "#{resource.class.prefix}#{@collection_name}#{subclass.format_extension}"
  	end

  	def element_path(obj)
		"#{@resource.class.prefix}#{@resource.class.collection_name}/#{@resource.id}/#{obj.class.collection_name}/#{obj.id}#{obj.class.format_extension}"
  	end

  #  	def collection_path(subclass)
		# "#{@resource.class.prefix}#{@collection_name}#{@subclass.format_extension}"  		
  # 	end

  	def <<(obj)
      Base.connection.put(element_path(obj), obj.encode, obj.class.headers).tap do |response|
        #load_attributes_from_response(response)
      end
  	end

  # 	def collection_name(subclass)
		# @resource.class.collection_name + '/' + @resource.id.to_s + '/' + subclass.collection_name
  # 	end

 	def inspect
 		self.to_a.inspect
 	end


 	def subclasses
 		{
 			MedusaRestClient::Stone => [Stone, Analysis, AttachmentFile, Bib],
 			MedusaRestClient::Box => [Box, Stone, AttachmentFile, Bib],
 			MedusaRestClient::Place => [Stone, AttachmentFile, Bib],
 			MedusaRestClient::Analysis => [AttachmentFile, Bib],
 			MedusaRestClient::AttachmentFile => [Box, Stone, Place, Analysis, Bib],
 			MedusaRestClient::Bib => [Box, Stone, Place, Analysis, AttachmentFile],						
 		}
 	end

  	def to_a
  		if @subclass
  			subclass_find(@subclass)
  		else
  			array = []
  			subclasses.fetch(@resource.class).each do |subclass|
  			 	array.concat(subclass_find(subclass))
  			end
  			array.compact
  		end
  	end

    def empty?
      size == 0 ? true : false
    end

  	def subclass_find(subclass)
  		subclass.find(:all, :from => "#{@resource.class.prefix}#{@resource.class.collection_name}/#{@resource.id}/#{subclass.collection_name}#{subclass.format_extension}")
  	end

  	def method_missing(method_id, *args, &block)
  		if to_a.respond_to?(method_id)
  			return to_a.send(method_id, *args, &block)
  		end
  		super
  	end
  end
end
