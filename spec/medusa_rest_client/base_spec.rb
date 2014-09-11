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
	end
end
