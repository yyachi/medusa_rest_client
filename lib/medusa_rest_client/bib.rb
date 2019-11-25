module MedusaRestClient
  class Bib < Base
    def to_json(options={})
      super({ :root => self.class.element_name }.merge(options))
    end


    def tables(scope = :all)
      Table.find(scope, :params => {:bib_id => self.id})
    end    
  end
end