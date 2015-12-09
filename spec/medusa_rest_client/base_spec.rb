require 'spec_helper'

module MedusaRestClient
	describe Base do
		describe ".site_with_userinfo" do
			before do
				Base.site = "http://example.com/"
			end
			context "without userinfo" do
				before do
					Base.user = nil
					Base.password = nil
				end
				it { expect(Base.site_with_userinfo.to_s).to eq(Base.site.to_s) }
			end
			context "with userinfo" do
				let(:user){ 'admin'}
				let(:password){ 'pass' }
				before do
					Base.user = user
					Base.password = password
				end
				it { expect(Base.site_with_userinfo.to_s).to include("#{user}:#{password}") }
			end			
		end

		describe "#record_property" do
			subject { specimen.record_property }
			let(:specimen){ FactoryGirl.remote(:specimen, id: specimen_id) }

			let(:record_property_attributes){ {id: prop_id, datum_type: 'Specimen', datum_id: specimen_id} }			
			let(:specimen_id){ 10 }
			let(:prop_id){ 1000 }

			before do
				FakeWeb.register_uri(:get, Regexp.new("specimens/#{specimen_id}/record_property.json"), :body => record_property_attributes.to_json, :status => ["200", "OK"])
				specimen
			end
			it { 
				expect(subject["id"]).to be_eql(prop_id)
				expect(FakeWeb).to have_requested(:get, %r|/specimens/10/record_property.json|) 
			}
		end

		describe "#update_record_property", :current => true do
			subject { stone.update_record_property(attrib) }
			let(:stone){ FactoryGirl.remote(:stone, id: stone_id) }
			let(:stone_id){ 10 }
			let(:attrib){ {global_id:'0000-001', user_id: 10 } }
			before do
				stone
				FakeWeb.register_uri(:put, Regexp.new("specimens/#{stone_id}/record_property.json"), :body => attrib.to_json, :status => ["200", "OK"])
			end
			it { 
				subject				
				expect(FakeWeb).to have_requested(:put, %r|/specimens/10/record_property.json|) 
			}
		end

		describe "#update_global_id" do
			subject { stone.update_global_id(new_global_id) }
			let(:stone){ FactoryGirl.remote(:stone, id: stone_id) }
			let(:stone_id){ 10 }
			let(:new_global_id){ '0000-001' }

			before do
				stone
			end
			it { 
				expect(stone).to receive(:update_record_property).with(:global_id => new_global_id)				
				subject
			}
		end

	end
end
