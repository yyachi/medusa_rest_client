require 'spec_helper'
module MedusaRestClient

  describe SurfaceImage do
    before do
        ActiveResource::Base.logger = Logger.new(STDOUT)
        ActiveResource::Base.logger.level = Logger::DEBUG
    end

    describe "surface.images", :current => true do
      subject{ surface.images }
      let(:surface){ FactoryGirl.remote(:surface, id: 2530) }
      before do
        surface
        FakeWeb.register_uri(:get, %r|/surfaces/#{surface.id}/images.json|, :body => [].to_json, :status => ["200", ""])                                
      end

      it { 
        expect(FakeWeb).to have_requested(:get, %r|/surfaces/#{surface.id}/images.json|)        
      }
    end
  end
end