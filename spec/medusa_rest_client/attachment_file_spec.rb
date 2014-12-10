require 'spec_helper'

module MedusaRestClient
	describe AttachmentFile do
		before do
			setup
		end

		describe ".find_or_create_by_file", :current => true do
			let(:obj){ AttachmentFile.find_or_create_by_file(upload_file) }
			let(:upload_file){ 'tmp/test_image.jpg' }
			let(:upload_file_md5){ Digest::MD5.hexdigest(File.open(upload_file, 'rb').read) }
			let(:md5){ }
			before do
				FakeWeb.allow_net_connect = true
				setup_empty_dir('tmp')
				setup_file(upload_file)
				obj
			end
			it { expect(obj.md5hash).to be_eql(upload_file_md5) }
			after do
				#obj.destroy
				FakeWeb.allow_net_connect = false
			end
		end

		describe ".find_by_file", :current => false do
			let(:obj){ AttachmentFile.create(:file => upload_file, :description => 'test upload hello world') }
			let(:upload_file){ 'tmp/Desert.jpg' }
			let(:upload_file_md5){ Digest::MD5.hexdigest(File.open(upload_file, 'rb').read) }
			let(:md5){ }
			before do
				FakeWeb.allow_net_connect = true
				setup_empty_dir('tmp')
				setup_file(upload_file)
				obj
			end
			it { expect(obj.md5hash).to be_eql(upload_file_md5) }
			it { expect(AttachmentFile.find_by_file(upload_file).md5hash).to eql(upload_file_md5)}
			after do
				obj.destroy
				FakeWeb.allow_net_connect = false
			end
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

		describe "#post_multipart_form_data" do
	    	let(:obj){ AttachmentFile.new(:file => upload_file, :filename => 'example.txt')}
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
	    describe ".get_content_type" do
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
				AttachmentFile.upload(upload_file, :filename => 'example.txt')
			end
			it { expect(FakeWeb).to have_requested(:post, %r|/attachment_files.json|) }
		end

		describe "#length", :current => true do
			subject{ obj.length }
			let(:obj){ AttachmentFile.new(:original_geometry => "#{width}x#{height}")}
			let(:width){ 1947 }
			let(:height){ 1537 }
			it {
				expect(subject).to be_eql(width)
			}
		end

		describe "#height", :current => true do
			subject{ obj.height }
			let(:obj){ AttachmentFile.new(:original_geometry => "#{width}x#{height}")}
			let(:width){ 1947 }
			let(:height){ 1537 }
			it {
				expect(subject).to be_eql(height)
			}
		end

		describe "#width", :current => true do
			subject{ obj.width }
			let(:obj){ AttachmentFile.new(:original_geometry => "#{width}x#{height}")}
			let(:width){ 1947 }
			let(:height){ 1537 }
			it {
				expect(subject).to be_eql(width)
			}
		end

	end
end