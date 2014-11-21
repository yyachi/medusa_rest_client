require 'medusa_rest_client'
require 'spec_helper'

module MedusaRestClient
	describe MeasurementItem do
		before do
			FakeWeb.allow_net_connect = true
		end

		describe ".find" do
			it { expect{MeasurementItem.find(:all)}.not_to raise_error }
		end
		describe ".find_by_nickname" do
#			subject { MeasurementItem.find(:first, :params => {:q => {:nickname_eq => nickname}} ) }
			subject { MeasurementItem.find_by_nickname(nickname) }
			context "with item exists" do
				let(:nickname){ 'Be' }
				before do
					nickname
				end
				it { expect(subject.nickname).to eql(nickname) }
			end
			context "with item does not exist" do
				let(:nickname){ 'UNK' }
				before do
					nickname
				end
				it { expect(subject).to be_nil }
			end

		end

		describe ".find_or_create_by_nickname" do
			subject { MeasurementItem.find_or_create_by_nickname(nickname) }

			let(:nickname){ 'Be-deleteme' }
			before do
				nickname
			end
			it { expect(subject.nickname).to eql(nickname) }
			after do
				subject.destroy
			end
		end
		after do
			FakeWeb.allow_net_connect = false
		end
		
	end

end
