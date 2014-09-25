require 'spec_helper'

module MedusaRestClient
	describe Record do

		describe ".box?", :current => true do
			before do
				setup
			end

			context "with root path" do
				subject{ Record.box?(arg) }
				let(:arg){ '/' }
				let(:obj){ Box.find_by_path('/ISEI/main')}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).to be_truthy }

				after do
					FakeWeb.allow_net_connect = false					
				end				
			end

			context "with box's global_id" do
				subject{ Record.box?(arg) }
				let(:arg){ obj.global_id }
				let(:obj){ Box.find_by_path('/ISEI/main')}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).to be_truthy }

				after do
					FakeWeb.allow_net_connect = false					
				end				
			end

			context "with box's path" do
				subject{ Record.box?(arg) }
				let(:arg){ obj.fullpath }
				let(:obj){ Box.find_by_path('/ISEI/main')}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).to be_truthy }

				after do
					FakeWeb.allow_net_connect = false					
				end				
			end

			context "with stone's global_id" do
				subject{ Record.box?(arg) }
				let(:arg){ obj.global_id }
				let(:obj){ Stone.find(:first)}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).not_to be_truthy }

				after do
					FakeWeb.allow_net_connect = false					
				end				
			end			

			context "with stone's path" do
				subject{ Record.box?(arg) }
				let(:arg){ obj.fullpath }
				let(:obj){ Stone.find(:first)}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).not_to be_truthy }

				after do
					FakeWeb.allow_net_connect = false					
				end				
			end			

		end

		describe "entries" do
			before do
				setup
			end

			context "with global_id" do
				subject{ Record.entries(arg) }
				let(:arg){ obj.global_id }
				let(:obj){ Box.find_by_path('/ISEI/main')}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).to be_an_instance_of(Array) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

		end

		describe "find" do
			before do
				setup
			end
			context "with global_id" do
				subject{ Record.find(arg) }
				let(:arg){ obj.global_id }
				let(:obj){ Box.find_by_path('/ISEI/main')}
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject.global_id).to eq(arg) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with invalid global_id" do
				subject{ Record.find(arg) }
				let(:arg){ '000-000' }
				before do
					FakeWeb.allow_net_connect = true
				end
				it { expect{ subject }.to raise_error(ActiveResource::ResourceNotFound) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with blank arg" do
				subject{ Record.find(arg) }
				let(:arg){ '' }
				before do
					Box.pwd_id = nil
					FakeWeb.allow_net_connect = true
				end
				it { expect{ subject }.to raise_error(ActiveResource::ResourceNotFound) }


				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with blank arg and pwd" do
				subject{ Record.find(arg) }
				let(:arg){ '' }
				let(:pwd){ '/ISEI/main'}
				before do
					FakeWeb.allow_net_connect = true
					Box.chdir(pwd)
				end
				it { expect{ subject }.to raise_error(ActiveResource::ResourceNotFound) }
				#it { expect(subject.fullpath).to eq(pwd) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with path" do
				subject{ Record.find(arg) }
				let(:arg){ path }
				let(:obj){ Box.find_by_path(path)}
				let(:path){ '/ISEI/main'}
				before do
					FakeWeb.allow_net_connect = true
				end
#				it { expect(subject.global_id).to eq(obj.global_id) }
				it { expect{ subject }.to raise_error(ActiveResource::ResourceNotFound) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			after do
			end
		end

		describe "find_by_id_or_path" do
			context "with global_id" do
				subject{ Record.find_by_id_or_path(arg) }
				let(:arg){ obj.global_id }
				let(:obj){ Box.find_by_path('/ISEI/main')}
				before do
					setup
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject.global_id).to eq(arg) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with invalid global_id" do
				subject{ Record.find_by_id_or_path(arg) }
				let(:arg){ '000-000' }
				before do
					setup
					FakeWeb.allow_net_connect = true
				end
				it { expect{ subject }.to raise_error(RuntimeError) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end


			context "with box path" do
				subject{ Record.find_by_id_or_path(arg) }
				let(:arg){ obj.fullpath }
				let(:obj){ Box.find_by_path('/ISEI/main/clean-lab')}
				before do
					setup
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject.fullpath).to eq(arg) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with stone path" do
				subject{ Record.find_by_id_or_path(arg) }
				let(:arg){ obj.fullpath }
				let(:obj){ Stone.find_by_path('/ISEI/main/clean-lab/Allende')}
				before do
					setup
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject.fullpath).to eq(arg) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			context "with invalid path" do
				subject{ Record.find_by_id_or_path(arg) }
				let(:arg){ '/ISEI/main/clean-lab/Alles' }
				before do
					setup
					FakeWeb.allow_net_connect = true
				end
				it { expect{ subject }.to raise_error(RuntimeError) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

		end

		describe "find_by_path" do
			context "with box path" do
				subject{ Record.find_by_path(path) }
				let(:path){ '/ISEI/main' }
				before do
					setup
					FakeWeb.allow_net_connect = true
				end
				it { expect(subject).to be_an_instance_of(Box) }
				after do
					FakeWeb.allow_net_connect = false
				end
			end

			context "with blank path" do
				subject{ Record.find_by_path(path) }
				let(:path){ "" }
				before do
					setup
					FakeWeb.allow_net_connect = true
					Box.chdir('/ISEI/main')
					path
				end
				it { expect(subject).to be_an_instance_of(Box) }
				after do
					FakeWeb.allow_net_connect = false
				end
			end

			context "with stone path" do
				subject{ Record.find_by_path(path) }
				let(:path){ '/ISEI/main/clean-lab/Allende' }
				before do
					setup
					FakeWeb.allow_net_connect = true
					path
				end
				it { expect(subject).to be_an_instance_of(Stone) }
				after do
					FakeWeb.allow_net_connect = false
				end
			end

			context "with invalid path" do
				subject{ Record.find_by_path(path) }
				let(:path){ '/ISEI/main/clean-lab/Alle' }
				before do
					setup
					FakeWeb.allow_net_connect = true
					path
				end
				it { expect{ subject }.to raise_error(RuntimeError) }
				after do
					FakeWeb.allow_net_connect = false
				end
			end

		end
	end
end
