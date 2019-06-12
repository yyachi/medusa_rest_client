require 'spec_helper'

module MedusaRestClient
  @allow_net_connect = false
  if @allow_net_connect

  describe Surface do
    before do
      setup
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end

    describe "#upload_image to real server", :current => true do
      #let(:stone){ Specimen.create(:name => 'sample-1')}
      let(:surface){ Surface.create(:name => 'surface_1')}
      let(:remote_image){ surface.upload_image(:file => upload_file, :filename => 'example.jpg', :geo_path => 'tmp/example.geo') }
      let(:upload_file){ 'tmp/test_image.jpg'}
      let(:replace_file){ 'tmp/Desert.jpg'}
      let(:geo_file){ 'tmp/example.geo'}
      let(:filename){'example.jpg'}
      before do
        setup_empty_dir('tmp')
        setup_file(upload_file)
        setup_file(replace_file)
        setup_file(geo_file)
        surface
        remote_image
        image_id = remote_image.id
        remote_image = AttachmentFile.find(image_id)
        remote_image.update_file(replace_file)
        surface.images.each do |surface_image|
          surface_image.image.dump_geofile('tmp/deleteme.geo')
        end
      end
      it { expect(nil).to be_nil }

      after do
        remote_image.destroy
        surface.destroy
      end       
    end     


    after do
      FakeWeb.allow_net_connect = false
    end   
  end

  describe AttachmentFile do
    before do
      setup
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end

    

    describe "#upload_file to real server" do
      #let(:stone){ Specimen.create(:name => 'sample-1')}
      let(:remote_file){ AttachmentFile.find_or_create_by_file(upload_file) }
      let(:upload_file){ 'tmp/test_image.jpg'}
      let(:geo_file){ 'tmp/test_image.geo'}
      let(:filename){'example.jpg'}
      before do
        setup_empty_dir('tmp')
        setup_file(upload_file)
        setup_file(geo_file)
        remote_file
        #file = AttachmentFile.find_by_file(upload_file)
        #file.destroy
      end
      it { expect(nil).to be_nil }

      after do
        remote_file.destroy
        #@file.destroy
      end       
    end     


    after do
      FakeWeb.allow_net_connect = false
    end   
  end

  describe Box do
    before do
      setup
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end

                describe "relatives" do
                  subject { box.relatives << obj }
                  let(:box){ Box.create(:name => "box-for-relatives") }
                  before do
                    box
                    obj
                    subject
                  end
                  context "with specimen" do
                    let(:obj){ Specimen.create(:name => 'specimen_1')}
                    it { expect(box.specimens[0]).to be_eql(obj) }
                  end
                  context "with bib" do
                    let(:obj){ Bib.create(:name => 'bib_1', :author_ids => [1])}
                    it { expect(box.bibs[0]).to be_eql(obj)}
                  end
                  after do
                    obj.destroy
                    box.destroy
                  end
                end

    describe "inventory" do
      let(:box){ Box.create(:name => 'box-for-inventory')}

      subject { box.inventory(item) }

      before do
        box
        item
        subject
      end
      context "with specimen" do
        let(:item){ Specimen.create(:name => 'specimen_1')}
        it { expect(box.specimens[0]).to be_eql(item) }     
      end

      context "with box" do
        let(:item){ Box.create(:name => 'box_1')}
        it { expect(box.boxes[0]).to be_eql(item) }     
      end

      after do
        item.destroy
        box.destroy
      end
    end

    after do
      FakeWeb.allow_net_connect = false
    end
  end

        describe Bib do
    before do
      setup
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end
          describe "relatives" do
            subject { bib.relatives << obj }
            let(:bib){ Bib.create(:name => "bib-for-relatives", :author_ids => [1]) }
            before do
              bib
              obj
              subject
            end
            context "with specimen" do
              let(:obj){ Specimen.create(:name => 'specimen_1')}
              it { expect(bib.specimens[0]).to be_eql(obj) }
            end
            context "with box" do
              let(:obj){ Box.create(:name => 'box_1')}
              it { expect(bib.boxes[0]).to be_eql(obj)}
            end
            after do
              obj.destroy
              bib.destroy
            end
          end
    after do
      FakeWeb.allow_net_connect = false
    end
        end

  describe Specimen do
    before do
      setup
      FakeWeb.clean_registry
      FakeWeb.allow_net_connect = true
    end


    describe "#upload_file to real server" do
      let(:stone){ Specimen.create(:name => 'sample-1')}
      let(:upload_file){ 'tmp/test_image.jpg'}
      let(:geo_file){ 'tmp/test_image.geo'}
      let(:filename){'example.jpg'}
      before do
        setup_empty_dir('tmp')
        setup_file(upload_file)
        setup_file(geo_file)
        stone
        @file = stone.upload_file(:file => upload_file, :filename => filename )
      end
      it { expect(stone.attachment_files[0].data_file_name).to eql(filename) }

      after do
        @file.destroy
        stone.destroy
      end       
    end     

    describe "record_property" do
      subject { stone.record_property }
      let(:stone){ Specimen.create(:name => 'test-stone') }
      before do
        stone
      end
      it { expect(stone).not_to be_nil }
      after do
        stone.destroy
      end
    end

    describe "update_global_id" do
      subject { stone.update_global_id(new_global_id) }
      let(:stone){ Specimen.create(:name => 'test-stone') }
      let(:new_global_id){ '0000-001' }
      before do
        stone
      end
      it { expect(stone).not_to be_nil }
      it { 
        subject
        expect(stone.record_property["global_id"]).to be_eql(new_global_id)
      }

      after do
        stone.destroy
      end
    end

    after do
      FakeWeb.allow_net_connect = false
    end
  end
  end
end
