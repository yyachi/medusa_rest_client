require 'spec_helper'

module MedusaRestClient
	describe BoxRoot do
		before do
			setup
			FakeWeb.clean_registry
		end

		describe "new" do
			it { expect(BoxRoot.new).to be_an_instance_of(BoxRoot) }
			it { expect(BoxRoot.new).to be_a_kind_of(Box) }			
		end

		describe ".entries", :current => true do
			subject { BoxRoot.entries }
			#let(:box_root){ BoxRoot.new }
			before do
				setup
				FakeWeb.allow_net_connect = true
			end

			it { expect(subject).to be_an_instance_of(Array) }

			after do
				FakeWeb.allow_net_connect = false				
			end			
		end
		
		describe "parent" do
			before do
				setup
				FakeWeb.allow_net_connect = true
			end

			let(:box){ BoxRoot.new }
			before do
				box
			end
			it { expect(box.parent).to be_nil}

			after do
				FakeWeb.allow_net_connect = false				
			end

		end

		describe "box" do
			before do
				setup
				FakeWeb.allow_net_connect = true
			end

			let(:box){ BoxRoot.new}
			before do
				box
			end
			it { expect(box.box).to be_nil}

			after do
				FakeWeb.allow_net_connect = false				
			end
		end

	end
end