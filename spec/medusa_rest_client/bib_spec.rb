require 'spec_helper'

module MedusaRestClient
	describe Bib do
		describe ".find" do
			subject { Bib.find(:all) }
			before do
				FakeWeb.register_uri(:get, %r|/bibs.json|, :body => [].to_json, :status => ["200", "OK"])								
				subject
			end
			#it { expect(subject).not_to raise_error }
			it { expect(FakeWeb).to have_requested(:get, %r|/bibs.json|) }

		end
	end
end
