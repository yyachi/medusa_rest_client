require 'medusa_rest_client'
module MedusaRestClient
	describe Unit do
		describe ".find" do
			before do
				Unit.find(:all).each do |unit|
					p unit
				end
			end
			it { expect{Unit.find(:all)}.not_to raise_error }
		end
		describe ".find_by_name" do
			subject { Unit.find_by_name(unit_name)}
			let(:unit_name){ "gram_per_gram"}
			before do
				unit_name
			end
			it { expect(subject.name).to eql(unit_name) }
		end

	end

end
