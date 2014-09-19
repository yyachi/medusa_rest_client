require 'spec_helper'

module MedusaRestClient
	describe Record do
		describe "find", :current => true do
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
				it { expect(subject).to be_nil }

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
				it { expect(subject).to be_nil }

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
				it { expect(subject.fullpath).to eq(pwd) }

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
				it { expect(subject.global_id).to eq(obj.global_id) }

				after do
					FakeWeb.allow_net_connect = false					
				end
			end

			after do
			end
		end

		describe "find_by_path", :current => false do
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

		end
	end
end
