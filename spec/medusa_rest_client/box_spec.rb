require 'spec_helper'

module MedusaRestClient
	describe Box do
		before do
			setup
			FakeWeb.clean_registry
		end

		describe "entries" do
			subject { Box.entries(path) }
			before do
				setup
				FakeWeb.allow_net_connect = true
			end


			context "with root path" do
				let(:path){ "/" }
				before do
					path
				end
				it { expect(subject).to be_an_instance_of(Array) }
			end


			context "with fullpath" do
				let(:path){ "/ISEI/main/clean-lab" }
				before do
					path
				end
				it { expect(subject).to be_an_instance_of(Array) }
			end

			context "with relative path" do
				let(:pwd){"/ISEI/main"}
				let(:path){ "./clean-lab" }
				before do
					Box.chdir(pwd)
					path
				end
				it { expect(subject).to be_an_instance_of(Array) }
			end

			context "with invalid path" do
				let(:path){ "/ISEI/main/clean-l" }
				before do
					path
				end
				it { expect{Box.entries(path)}.to raise_error(RuntimeError) }
			end

			after do
				FakeWeb.allow_net_connect = false				
			end			
		end

		describe "on_root" do
			subject{ Box.on_root }
			before do
				setup
				FakeWeb.allow_net_connect = true
			end
			it { expect(subject).to be_an_instance_of(ActiveResource::Collection) }
			after do
				FakeWeb.allow_net_connect = false				
			end			
		end
		
		describe "parent" do
			before do
				setup
				FakeWeb.allow_net_connect = true
			end

			context "of /ISEI/main" do
				let(:box){ Box.find_by_path('/ISEI/main')}
				before do
					box
				end
				it { expect(box.parent.fullpath).to eq('/ISEI')}
			end

			after do
				FakeWeb.allow_net_connect = false				
			end

		end

		describe "box" do
			before do
				setup
				FakeWeb.allow_net_connect = true
			end

			context "of /ISEI/main" do
				let(:box){ Box.find_by_path('/ISEI/main')}
				before do
					box
				end
				it { expect(box.box.fullpath).to eq('/ISEI')}
			end

			after do
				FakeWeb.allow_net_connect = false				
			end

		end

		describe "pwd_id" do
			before do
				Base.init
			end
			it { expect(Box.pwd_id).to eq(ENV['OROCHI_PWD']) }
		end

		describe "pwd" do
			before do
				setup
				FakeWeb.allow_net_connect = true
			end

			context "when valid pwd_id" do
				let(:box){ Box.find_by_path('/ISEI/main')}
				before do
					Box.pwd_id = box.global_id
				end
				it { expect(Box.pwd).to eq(box.fullpath)}
			end

			context "when pwd_id = nil" do
				before do
					Box.pwd_id = nil
				end
				it { expect(Box.pwd).to eq('/')}
			end

			context "when pwd_id = ''" do
				before do
					Box.pwd_id = ''
				end
				it { expect(Box.pwd).to eq('/')}
			end

			after do
				FakeWeb.allow_net_connect = false				
			end
		end

		describe "find_by_path" do

			before do
				FakeWeb.allow_net_connect = true				
			end
			context "with absolute path" do
				let(:path){'/ISEI/main'}
				before do
					@box = Box.find_by_path(path)
				end
				it { expect(@box.fullpath).to eq(path)}
			end

			context "with root path" do
				let(:path){'/'}
				before do
					@box = Box.find_by_path(path)
				end
				it { expect(@box.fullpath).to eq(path)}
			end


			context "with relative path" do
				let(:path){'ISEI'}
				before do
					@box = Box.find_by_path(path)
				end
				it { expect(@box.fullpath).to eq('/' + path)}
			end

			context "with relative path" do
				let(:path){'main'}
				before do
					Box.chdir('/ISEI')
					@box = Box.find_by_path(path)
				end
				it { expect(@box.fullpath).to eq('/ISEI/' + path)}
			end

			context "with empty path on /ISEI" do
				let(:path){''}
				before do
					Box.chdir('/ISEI')					
					@box = Box.find_by_path(path)
				end
				it { expect(@box.fullpath).to eq('/ISEI')}
			end


			after do
				FakeWeb.allow_net_connect = false				
			end
		end

		describe "chdir" do
			let(:home_path){ '/ISEI/main'}
			before do
				FakeWeb.allow_net_connect = true
				Box.home = home_path
#				Box.chdir(path)
			end

			context "without path and blank home" do
				before do
					Box.home_id = nil
					Box.chdir(path)
				end
				let(:path){ nil }
				#let(:home_path){ nil }
				it { expect(Box.pwd.to_s).to eq('/') }
			end

			context "without path and home" do
				before do
					Box.chdir(path)
				end
				let(:path){ nil }
				let(:home_path){ '/ISEI/main'}
				it { expect(Box.pwd.to_s).to eq(home_path) }
			end

			context "with empty path and home" do
				let(:path){ "" }
				let(:home_path){ '/ISEI/main'}
				it { expect(Box.pwd.to_s).to eq(home_path) }
			end


			context "with relative path and pwd" do
				before do
					Box.chdir(path)
					Box.chdir(rpath)
				end
				let(:path){ '/ISEI'}
				let(:rpath){ 'main'}
				it { expect(Box.pwd.to_s).to eq('/ISEI/main') }				
			end

			context "with relative path and no pwd" do
				before do
					Box.pwd_id = nil
					Box.chdir(rpath)
				end
				let(:path){ '/ISEI'}
				let(:rpath){ 'ISEI'}
				it { expect(Box.pwd.to_s).to eq('/ISEI') }				
			end

			context "to /ISEI/main" do
				before do
					Box.chdir(path)
				end
				let(:path){ "/ISEI/main"}
				it { expect(Box.pwd.to_s).to eq(path) }
			end

			context "to /ISEI" do
				before do
					Box.chdir(path)
				end
				let(:path){ "/ISEI"}
				it { expect(Box.pwd.to_s).to eq(path) }
			end

			context "to /ISEC/main" do
				let(:path){ "/ISEC/main"}
				it { expect(Box.pwd.to_s).not_to eq(path) }
			end

			after do
				FakeWeb.allow_net_connect = false
			end
		end
		# describe "relatives", :current => true do
		# 	let(:box) { Box.create(:name => 'tmp_1') }
		# 	let(:stone) { Stone.create(:name => 'deleteme-1')}
		# 	before do
		# 		FakeWeb.allow_net_connect = true
		# 		box
		# 		stone
		# 		box.stones << stone
		# 	end

		# 	it { expect(box).to be_an_instance_of(Box) }
		# 	it { expect(stone.reload.box).to eq(box)}
		# 	after do
		# 		box.destroy
		# 		stone.destroy
		# 		FakeWeb.allow_net_connect = false
		# 	end
		# end

		describe "relatives" do
			let(:stone_1) { FactoryGirl.build(:stone)}
			let(:obj) { Box.find(obj_id)}
			let(:obj_id) { 10 }
			before do
				FactoryGirl.remote(:box, id: obj_id)
				FakeWeb.register_uri(:post, %r|/boxes/#{obj.id}/stones.json|, :body => nil, :status => ["201", ""])												
				obj.relatives << stone_1
			end
			it { expect(nil).to be_nil }
		end

		describe "stones" do
			let(:stone_1) { FactoryGirl.build(:stone)}
			let(:obj) { Box.find(obj_id)}
			let(:obj_id) { 10 }
			before do
				FactoryGirl.remote(:box, id: obj_id)
				FakeWeb.register_uri(:post, %r|/boxes/#{obj.id}/stones.json|, :body => nil, :status => ["201", ""])												
				obj.stones << stone_1
			end
			it { expect(nil).to be_nil }
		end

	end
end