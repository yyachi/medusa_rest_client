require 'spec_helper'

module MedusaApi
	describe Stone do
		before do
			setup
			FakeWeb.clean_registry
		end
		describe "box", :current => true do
			let(:stone) { Stone.find(stone_id)}
			let(:stone_id) { 10 }
			before do
				FactoryGirl.remote(:stone, id: stone_id)
				stone.box
			end
			it { expect(nil).to be_nil }
		end
		describe "#upload_file" do
			let(:upload_file){ 'tmp/upload.txt' }
			before do
				setup_empty_dir('tmp')
				setup_file(upload_file)
				stone = FactoryGirl.build(:stone, id: 10)
				FakeWeb.register_uri(:post, %r|/stones/10/attachment_files.json|, :body => FactoryGirl.build(:attachment_file).to_json, :status => ["201", "Created"])								
				stone.upload_file(:file => upload_file)
			end
			it { expect(FakeWeb).to have_requested(:post, %r|/stones/10/attachment_files.json|) }
		end

	end
end