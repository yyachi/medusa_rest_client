require 'spec_helper'

module MedusaRestClient
	describe Unit do
		describe ".find" do
			before do
				FakeWeb.allow_net_connect = true
			end
			it { expect{Unit.find(:all)}.not_to raise_error }
			after do
				FakeWeb.allow_net_connect = false
			end
		end
		describe ".find_by_name" do
			subject { Unit.find_by_name(unit_name)}
			let(:unit_name){ "gram_per_gram"}
			before do
				FakeWeb.allow_net_connect = true				
				unit_name
			end
			it { expect(subject.name).to eql(unit_name) }
			after do
				FakeWeb.allow_net_connect = false
			end

		end

	end

end
