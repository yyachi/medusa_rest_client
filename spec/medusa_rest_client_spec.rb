require 'spec_helper'
module MedusaRestClient
  describe ".config" do
    before do
    end
    it { expect(MedusaRestClient.site).not_to be_nil }
    it { expect(MedusaRestClient.prefix).not_to be_nil }    
    after do
    end
  end

  describe "specimen" do
    it { expect("specimen".pluralize).to eql("specimens")}
  end
end
