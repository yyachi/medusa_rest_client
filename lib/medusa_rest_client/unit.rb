module MedusaRestClient
  class Unit < ActiveResource::Base
    self.site = MedusaRestClient.site
    self.prefix = MedusaRestClient.prefix
    self.user = MedusaRestClient.user
    self.password = MedusaRestClient.password

    def self.find_by_name(name)
      self.find(:first, :params => {:q => {:name_eq => name}} )
    end

    def self.find_by_text(text)
      self.find(:first, :params => {:q => {:text_eq => text}} )
    end

    def self.find_by_name_or_text(name_or_text)
      self.find_by_name(name_or_text) || self.find_by_text(name_or_text)
    end
  end
end