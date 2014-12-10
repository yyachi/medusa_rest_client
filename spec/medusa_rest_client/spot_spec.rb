#require 'spec_helper'
require 'medusa_rest_client'
require 'factory_girl'
#require 'fakeweb'
#require 'fakeweb_matcher'
require 'webmock/rspec'

module MedusaRestClient

	describe Spot do
		before do
#			FactoryGirl.find_definitions
#			FakeWeb.allow_net_connect = false
#			FakeWeb.clean_registry
		end
		describe "attachment_file.spots", :current => true do
			let(:attachment_file){ AttachmentFile.new(:id => attachment_id) }
			let(:attachment_id){ 1000 }
			let(:spot_1){ Spot.new }
			let(:upload_file){ 'tmp/test_image.jpg' }
			before do
				stub_request(:post, "admin:password@localhost:3000/attachment_files/#{attachment_id}/spots.json")
			end
			it {
				attachment_file.spots << spot_1				
				expect(a_request(:post, "admin:password@localhost:3000/attachment_files/#{attachment_id}/spots.json")).to have_been_made.once
			}

		end

		describe ".create" do
			let(:attachment_file_id){ 100 }
			let(:spot_1){ Spot.new }
			let(:hash){ {:name => 'test', :attachment_file_id => attachment_file_id, :spot_x => 10.2, :spot_y => 20.2 } }
			before do
				spot_1.id = 10001
				spot_1.instance_variable_set(:@persisted, true)
				spot_1.attributes.update(hash)
				stub_request(:put, "admin:password@localhost:3000/spots/#{spot_1.id}.json")
			end
			it {
				spot_1.save
				expect(a_request(:put, "admin:password@localhost:3000/spots/#{spot_1.id}.json"))
				#Spot.create(:attachment_file_id => attachment_file_id)
			}
		end
	end
end