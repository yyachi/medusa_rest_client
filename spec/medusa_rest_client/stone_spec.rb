require 'spec_helper'

module MedusaRestClient
	describe Stone do
		before do
			setup
			FakeWeb.clean_registry
		end


		describe "find_by_path" do
			context "with absolute path" do
				subject{ Stone.find_by_path(path) }
				let(:path){ '/ISEI/main/clean-lab/Allende' }
				before do
					FakeWeb.allow_net_connect = true
					#@stone = Stone.find_by_path(path)
				end
				it { expect(subject.fullpath).to eq(path)  }
				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with root path " do
				subject{ Stone.find_by_path(path) }
				let(:path){ '/deleteme-1' }
				before do
					FakeWeb.allow_net_connect = true
					#@stone = Stone.find_by_path(path)
				end
				it { expect(subject.fullpath).to eq(path)  }
				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with relative path on root" do
				subject{ Stone.find_by_path(path) }
				let(:path){ 'deleteme-1' }
				before do
					FakeWeb.allow_net_connect = true
					Box.chdir("/")
					#@stone = Stone.find_by_path(path)
				end
				it { expect(subject.fullpath).to eq('/' + path)  }
				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with relative path on /ISEI/main/clean-lab" do
				subject{ Stone.find_by_path(path) }
				let(:pwd) {'/ISEI/main/clean-lab'}
				let(:path){ 'Allende' }
				before do
					FakeWeb.allow_net_connect = true
					Box.chdir(pwd)
					#@stone = Stone.find_by_path(path)
				end
				it { expect(subject.fullpath).to eq(pwd + '/' + path)  }
				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with relative invalid path on /ISEI/main/clean-lab" do
				subject{ Stone.find_by_path(path) }
				let(:pwd) {'/ISEI/main/clean-lab'}
				let(:path){ 'Alle' }
				before do
					FakeWeb.allow_net_connect = true
					Box.chdir(pwd)
					#@stone = Stone.find_by_path(path)
				end
				it { expect{ subject.fullpath }.to raise_error(RuntimeError)  }
				after do
					FakeWeb.allow_net_connect = false					
				end
			end

		end
		# describe "find_or_create_by_name finds existing obj", :current => false do
		# 	subject { Stone.find_or_create_by_name(name) }
		# 	let(:name) { "deleteme-123423"}
		# 	let(:params) { {:description => 'hello world'} }
		# 	let(:obj_1) { Stone.create(:name => name)}
		# 	before do
		# 		FakeWeb.allow_net_connect = true
		# 		obj_1
		# 	end

		# 	it { expect(subject.name).to eq(name) }
		# 	after do
		# 		obj_1.destroy
		# 		FakeWeb.allow_net_connect = false
		# 	end
		# end

		# describe "find_or_create_by_name creates obj", :current => true do
		# 	let(:name) { "deleteme-123423"}
		# 	let(:params) { {:description => 'hello world'} }
		# 	let(:obj_1) { Stone.find_or_create_by_name(name, params)}
		# 	before do
		# 		FakeWeb.allow_net_connect = true
		# 		obj_1
		# 		p obj_1
		# 	end

		# 	it { expect(obj_1.name).to eq(name) }
		# 	it { expect(obj_1.description).to eq(params[:description]) }

		# 	after do
		# 		obj_1.destroy
		# 		FakeWeb.allow_net_connect = false
		# 	end
		# end

		describe "box", :current => false do
			let(:stone) { Stone.find(stone_id)}
			let(:stone_id) { 10 }
			before do
				FactoryGirl.remote(:stone, id: stone_id)
				stone.box
			end
			it { expect(nil).to be_nil }
		end
		describe "#upload_file", :current => true do
			let(:upload_file){ 'tmp/upload.txt' }
			before do
				setup_empty_dir('tmp')
				setup_file(upload_file)
				stone = FactoryGirl.build(:stone, id: 10)
				FakeWeb.register_uri(:post, %r|/stones/10/attachment_files.json|, :body => FactoryGirl.build(:attachment_file).to_json, :status => ["201", "Created"])								
				stone.upload_file(:file => upload_file, :filename => 'example.txt')
			end
			it { expect(FakeWeb).to have_requested(:post, %r|/stones/10/attachment_files.json|) }
		end

	end
end