require 'spec_helper'
module MedusaRestClient

  describe SurfaceImage do
    before do
        setup
        FakeWeb.clean_registry
        ActiveResource::Base.logger = Logger.new(STDOUT)
        ActiveResource::Base.logger.level = Logger::DEBUG
    end

    describe "surface.images" do
      subject{ surface.images }
      let(:surface){ FactoryGirl.remote(:surface, id: 2530) }
      before do
        FakeWeb.register_uri(:get, %r|/surfaces/#{surface.id}/images.json|, :body => [].to_json, :status => ["200", ""])
        subject
      end

      it {
        expect(FakeWeb).to have_requested(:get, %r|/surfaces/#{surface.id}/images.json|)        
      }
    end
  end
end