module MedusaRestClient
  class BoxRoot < Box
    def fullpath
      "/"
    end

    def self.entries
    @entries = [] unless @entries
    if @entries.empty?
      @entries = @entries.concat(boxes.to_a)
      @entries = @entries.concat(specimens.to_a)
    end
#   return @entries 
    return @entries.sort{|a,b| a.name <=> b.name }
  
    end


  def entries
    self.class.entries
  end

  def global_id
    nil
  end

  def self.boxes
    Box.on_root
  end

  def self.specimens
    query = {}
    query[:box_id_blank] = true
    params = {:q => query}
    elements = []
    collection = Specimen.find(:all, :params => params)
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

  def self.stones
    self.specimens
  end

  end
end
