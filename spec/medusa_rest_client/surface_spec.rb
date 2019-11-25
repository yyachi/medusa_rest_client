require 'spec_helper'

module MedusaRestClient
  describe Surface do
    describe ".find" do
      subject { Surface.find(:all) }
      before do
        FakeWeb.register_uri(:get, %r|/surfaces.json|, :body => [].to_json, :status => ["200", "OK"])               
        subject
      end
      it { expect(FakeWeb).to have_requested(:get, %r|/surfaces.json|) }
    end


    describe "#upload_file" do
      let(:upload_file){ 'tmp/test_image.jpg' }
      before do
        setup_empty_dir('tmp')
        setup_file(upload_file)
        surface = FactoryGirl.build(:surface, id: 10)
        FakeWeb.register_uri(:post, %r|/surfaces/10/images.json|, :body => FactoryGirl.build(:attachment_file).to_json, :status => ["201", "Created"])               
        surface.upload_image(:file => upload_file, :filename => 'example.jpg')
      end
      it { expect(FakeWeb).to have_requested(:post, %r|/surfaces/10/images.json|) }
    end

    describe "#make_tiles" do
      before do
        surface = FactoryGirl.build(:surface, id: 10)
        FakeWeb.register_uri(:post, %r|/surfaces/10/tiles.json|, :body => nil, :status => ["201", "Created"])
        surface.make_tiles
      end
      it { expect(FakeWeb).to have_requested(:post, %r|/surfaces/10/tiles.json|) }
    end

    describe "#make_image_tiles" do
      before do
        surface = FactoryGirl.build(:surface, id: 10)
        FakeWeb.register_uri(:get, %r|/surfaces/10/images/55271.json|, :body => FactoryGirl.build(:surface_image, surface_id:10, image_id:55271).to_json, :status => ["200", "OK"])
        FakeWeb.register_uri(:post, %r|/surfaces/10/images/55271/tiles.json|, :body => nil, :status => ["201", "Created"])
        surface.make_image_tiles(55271)
      end
      it { expect(FakeWeb).to have_requested(:post, %r|/surfaces/10/images/55271/tiles.json|) }
    end
    describe "#make_layer_tiles" do
      before do
        surface = FactoryGirl.build(:surface, id: 10)
        FakeWeb.register_uri(:post, %r|/surfaces/10/layers/20/tiles.json|, :body => nil, :status => ["201", "Created"])
        surface.make_layer_tiles(20)
      end
      it { expect(FakeWeb).to have_requested(:post, %r|/surfaces/10/layers/20/tiles.json|) }
    end
  end
end
