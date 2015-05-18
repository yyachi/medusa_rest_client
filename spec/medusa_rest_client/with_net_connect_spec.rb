require 'spec_helper'

module MedusaRestClient
	@allow_net_connect = false
	if @allow_net_connect
	describe Stone do
		before do
			setup
			FakeWeb.clean_registry
			FakeWeb.allow_net_connect = true
		end

		describe "#upload_file to real server" do
			let(:stone){ Stone.create(:name => 'sample-1')}
			let(:upload_file){ 'tmp/Desert.jpg'}
			let(:filename){'example.jpg'}
			before do
				setup_empty_dir('tmp')
				setup_file(upload_file)
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
			let(:stone){ Stone.create(:name => 'test-stone') }
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
			let(:stone){ Stone.create(:name => 'test-stone') }
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