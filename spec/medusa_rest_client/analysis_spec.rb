require 'spec_helper'
module MedusaRestClient
  describe Analysis do
    describe ".download" do
      subject { obj.download_casteml }
      let(:filename){ global_id + ".pml" }
      let(:obj){ FactoryGirl.remote(:analysis) }
      let(:obj_id){ 100 }
      let(:global_id){ '0000-001' }
      before do
        allow(obj).to receive(:global_id).and_return(global_id)
        FakeWeb.register_uri(:get, %r|/analyses/#{obj.id}.json|, :body => nil, :status => ["201", ""])
      end

      it { 
        subject
        expect(File.exists?(filename)).to be_truthy
      }

      after do
        File.unlink(filename)
      end
    end

    describe ".save" do
      let(:obj){ FactoryGirl.remote(:analysis) }
#     let(:obj){ Analysis.new(:name => 'hello') }
      before do
#       setup
#       FakeWeb.allow_net_connect = true
        obj
        FakeWeb.register_uri(:post, %r|/analyses.json|, :body => nil, :status => ["201", ""])
      end

      it { expect{obj.save}.not_to raise_error }
      after do
#       FakeWeb.allow_net_connect = false
      end
    end
  end
end
