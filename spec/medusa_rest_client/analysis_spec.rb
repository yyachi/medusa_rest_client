require 'spec_helper'
module MedusaRestClient
	describe Analysis do
		describe ".download", :current => true do
			let(:filename){ obj.global_id + ".pml" }
			let(:opts){ {} }
			let(:obj){ Analysis.find(:first)}
			before do
				setup
				FakeWeb.allow_net_connect = true
				obj
				obj.download_casteml
				#Record.download_single(arg, opts)
			end

			it { expect(File.exists?(filename)).to be_truthy}

			after do
				File.unlink(filename)
				FakeWeb.allow_net_connect = false
			end
		end
	end
end
