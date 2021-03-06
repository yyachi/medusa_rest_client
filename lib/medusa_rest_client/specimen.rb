module MedusaRestClient
  class Specimen < Base
    #self.element_name = "specimen"
    #self.collection_name = "specimens"

    def self.find_by_path(path)
      path = Pathname.new(path)
      unless path.absolute?
        path = Pathname.new(Box.pwd) + path
      end

      path = path.cleanpath
      dirname = path.dirname
      basename = path.basename

      target_name = basename.to_s
      query = {:name_eq => target_name, :m => 'and'}

      if dirname == Pathname.new("/")
        query[:box_id_blank] = true
      elsif box = Box.find_by_path(dirname.to_s)
        query[:box_id_eq] = box.id
      else
        return nil
      end
      obj = self.find(:first, :params => {:q => query})
      raise RuntimeError.new("#{path}: No such specimen") unless obj
      obj     
    end

    def fullpath
      if box
        path = Pathname.new(box.fullpath)
      else
        path = Pathname.new("/")
      end
      path = path + name
      path.to_s
    end
  end
end