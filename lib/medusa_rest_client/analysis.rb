module MedusaRestClient
  class Analysis < Base
    def download_casteml
      File.open(global_id + ".pml", "wb") {|f|
        f.puts self.class.download_one(:from => casteml_path)
      }
    end

    def casteml_path
      path = self.class.element_path(id)
      dirname = File.dirname(path)
      basename = File.basename(path, ".*")
      ext = File.extname(path)
      "#{dirname}/#{basename}/casteml"
    end

    def chemistries(scope = :all)
      Chemistry.find(scope, :params => {:analysis_id => self.id})
    end

    def chemistry(id)
      chemistries(id)
    end

    def create_chemistry(attrib)
      chem = Chemistry.new(attrib)
      chem.prefix_options[:analysis_id] = self.id
      chem.save
    end
  end
end