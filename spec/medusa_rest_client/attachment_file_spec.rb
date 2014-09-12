require 'spec_helper'

module MedusaRestClient
	describe AttachmentFile do
		before do
			setup
		end
		describe ".save with new object" do
			let(:obj){ FactoryGirl.build(:attachment_file) }
			before do
				obj
			end
			it "calls create_with_upload_data" do
				allow(obj).to receive(:post_multipart_form_data)
				obj.save
			end
		end

		describe ".save with exsisting object" do
			let(:obj){ AttachmentFile.find(1) }
			before do
				FactoryGirl.remote(:attachment_file, id: 1)
				obj
			end
			it "calls update" do
				allow(obj).to receive(:update)
				obj.save
			end
		end

		describe "#post_multipart_form_data", :current => true do
	    	let(:obj){ AttachmentFile.new(:file => upload_file)}
			let(:upload_file){ 'tmp/upload.txt' }
			before do
				setup_empty_dir('tmp')
				setup_file(upload_file)
				obj
				data = obj.to_multipart_form_data
				FakeWeb.register_uri(:post, %r|/attachment_files.json|, :body => FactoryGirl.build(:attachment_file).to_json, :status => ["201", "Created"])				
				obj.post_multipart_form_data(data)
			end
			it { expect(FakeWeb).to have_requested(:post, %r|/attachment_files.json|) }

		end

	    #data = make_post_data(boundary,self.class.element_name,self.attributes)
	    describe ".get_content_type", :current => false do
	    	let(:extname) { File.extname(filepath) }
	    	let(:filepath){ 'upload.txt' }
	    	it { expect(AttachmentFile.get_content_type_from_extname(extname)).to eq('text/plain') }
	    end

		describe ".upload" do
			let(:upload_file){ 'tmp/upload.txt' }
			before do
				setup_empty_dir('tmp')
				setup_file(upload_file)
				FakeWeb.register_uri(:post, %r|/attachment_files.json|, :body => FactoryGirl.build(:attachment_file).to_json, :status => ["201", "Created"])
				AttachmentFile.upload(upload_file)
			end
			it { expect(FakeWeb).to have_requested(:post, %r|/attachment_files.json|) }
		end
	end
end