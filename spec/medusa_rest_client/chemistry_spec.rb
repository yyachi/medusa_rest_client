require 'spec_helper'
module MedusaRestClient

	describe Chemistry do
		before do
			FakeWeb.allow_net_connect = true
			#FakeWeb.clean_registry
 			ActiveResource::Base.logger = Logger.new(STDOUT)
  			ActiveResource::Base.logger.level = Logger::DEBUG
		end

		describe ".find_all", :current => true do
			let(:analysis){ Analysis.find(2530) }			
			before do
			#	FakeWeb.allow_net_connect = true
				analysis
			end
			it { expect(Chemistry.find(:all, :params => {:analysis_id => analysis.id})).not_to be_nil }
			before do
			#	FakeWeb.allow_net_connect = false
			end			
		end
		describe "analysis.chemistries", :current => false do
			let(:analysis){ Analysis.find(2530) }
			before do
				analysis
				analysis.chemistries.each do |chem|
					p chem
				end
			end

			it { expect{analysis.chemistries}.not_to raise_error }
			after do
			end
		end

		describe ".create" do
			let(:analysis){ Analysis.create(:name => 'deleteme')}
			let(:chemistry_1){ Chemistry.new(:measurement_item_id => 198, :value => 0.123) }
			before do
				analysis
				chemistry_1.analysis = analysis
			end
			it { expect(analysis).not_to be_nil }
			it { expect{chemistry_1.save}.not_to raise_error}
			after do
				analysis.destroy
			end
		end

		describe ".unit=", :current => true do
			let(:chem_1){ Chemistry.new(:measurement_item_id => 198, :value => 0.155) }
			let(:unit){ Unit.find_by_name('centi_gram_per_gram') }

			before do
				chem_1.unit = unit
			end
			it { expect(chem_1.unit_id).to be_eql(unit.id)}
		end

		describe "#unit", :current => true do
			let(:chem_1){ Chemistry.create(chem_attrib) }			
			let(:chem_attrib){ {:analysis_id => analysis.id, :measurement_item_id => 198, :value => 0.155, :unit_id => unit.id} }
			let(:analysis){ Analysis.create(:name => 'deleteme')}
			let(:unit){ Unit.find_by_name('centi_gram_per_gram') }
			before do
				unit
				analysis
				chem_1
			end
			it { expect(chem_1.unit).to be_eql(unit) }
			after do
				analysis.destroy
			end
		end

		describe "analysis.create_chemistry" do
			let(:analysis){ Analysis.create(:name => 'deleteme')}
			let(:attrib){ {:measurement_item_id => 198, :value => 0.155} }
			before do
				analysis
			end
			it { expect{analysis.create_chemistry(attrib)}.not_to raise_error}
			after do
				analysis.destroy
			end


		end
		after do
			FakeWeb.allow_net_connect = false
		end

	end
end
