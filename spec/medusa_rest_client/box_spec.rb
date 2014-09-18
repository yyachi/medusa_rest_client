require 'spec_helper'

module MedusaRestClient
	describe Box do
		before do
			setup
			FakeWeb.clean_registry
		end
		
		describe "pwd_id", :current => true do
			before do
				Base.init
			end
			it { expect(Box.pwd_id).to eq(ENV['OROCHI_PWD']) }
		end

		describe "chdir" do
			let(:home_path){ '/ISEI/main'}
			before do
				FakeWeb.allow_net_connect = true
				Box.home = home_path
				Box.chdir(path)
			end

			context "without path and home" do
				let(:path){ nil }
				let(:home_path){ '/ISEI/main'}
				it { expect(Box.pwd.to_s).to eq(home_path) }
			end


			context "with relative path and pwd", :current => true do
				before do
					Box.chdir(rpath)
				end
				let(:path){ '/ISEI'}
				let(:rpath){ 'main'}
				it { expect(Box.pwd.to_s).to eq('/ISEI/main') }				
			end

			context "with relative path and no pwd", :current => true do
				before do
					Box.pwd_id = nil
					Box.chdir(rpath)
				end
				let(:path){ '/ISEI'}
				let(:rpath){ 'ISEI'}
				it { expect(Box.pwd.to_s).to eq('/ISEI') }				
			end

			context "to /ISEI/main" do
				let(:path){ "/ISEI/main"}
				it { expect(Box.pwd.to_s).to eq(path) }
			end

			context "to /ISEI" do
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
				FakeWeb.register_uri(:put, %r|/boxes/#{obj.id}/stones/#{stone_1.id}.json|, :body => nil, :status => ["201", ""])												
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
				FakeWeb.register_uri(:put, %r|/boxes/#{obj.id}/stones/#{stone_1.id}.json|, :body => nil, :status => ["201", ""])												
				obj.stones << stone_1
			end
			it { expect(nil).to be_nil }
		end

	end
end