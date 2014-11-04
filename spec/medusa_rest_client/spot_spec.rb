require 'spec_helper'

module MedusaRestClient
	describe Spot do
		before do
			setup
		end
		describe "attachment_file.spots", :current => true do
			let(:attachment_file){ AttachmentFile.create(:file => upload_file, :description => 'with spots') }
			let(:spot_1){ FactoryGirl.build(:spot, :name => 'deleteme') }
			let(:upload_file){ 'tmp/test_image.jpg' }
			before do
				FakeWeb.allow_net_connect = true
				setup_empty_dir('tmp')
				setup_file(upload_file)
				attachment_file.spots << spot_1
			end
			it { expect(attachment_file.spots[-1].name).to eql('deleteme') }
			after do
				attachment_file.destroy
				FakeWeb.allow_net_connect = false
			end
		end
	end
end