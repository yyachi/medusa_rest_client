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

		describe ".find_by_name_or_text", :current => true do
			subject { Unit.find_by_name_or_text(unit_name_or_text)}
			let(:unit){ Unit.find_by_name(unit_name)}
			let(:unit_name){ "centi_gram_per_gram"}
			let(:unit_text){ unit.text }
			before do
				FakeWeb.allow_net_connect = true				
				unit_name
				unit
				unit_text
			end
			context "with name" do
				let(:unit_name_or_text){ unit_name }
				it { expect(subject.name).to eql(unit_name) }
			end

			context "with text" do
				let(:unit_name_or_text){ unit_text }
				it { expect(subject).to eql(unit) }
			end
			after do
				FakeWeb.allow_net_connect = false
			end

		end

	end

end
