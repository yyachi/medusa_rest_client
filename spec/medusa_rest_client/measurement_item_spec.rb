require 'medusa_rest_client'
module MedusaRestClient
	describe MeasurementItem do
		describe ".find" do
			before do
			end
			it { expect{MeasurementItem.find(:all)}.not_to raise_error }
		end
		describe ".find_by_nickname" do
#			subject { MeasurementItem.find(:first, :params => {:q => {:nickname_eq => nickname}} ) }
			subject { MeasurementItem.find_by_nickname(nickname) }

			let(:nickname){ 'Be' }
			before do
				nickname
			end
			it { expect(subject.nickname).to eql(nickname) }
		end

		describe ".find_or_create_by_nickname" do
			subject { MeasurementItem.find_or_create_by_nickname(nickname) }

			let(:nickname){ 'Be-deleteme' }
			before do
				nickname
				p subject
			end
			it { expect(subject.nickname).to eql(nickname) }
			after do
				subject.destroy
			end
		end
	end

end
