module MedusaRestClient
  class MeasurementItem < Base
    def self.find_by_nickname(nickname)
      self.find(:first, :params => {:q => {:nickname_eq => nickname}} )
    end
    def self.find_or_create_by_nickname(nickname)
      mi = self.find_by_nickname(nickname)
      return mi if mi
      mi = self.new(:nickname => nickname)
      mi.save
      mi
    end
  end
end