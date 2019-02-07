require 'spec_helper'

module MedusaRestClient
  describe Record do
    describe ".download_casteml" do
      subject{ Record.download_casteml(global_id, opts) } 
      let(:filename){ global_id + ".pml"}
      let(:global_id){ '0000-001' }
      let(:opts){ {} }
      let(:obj){ FactoryGirl.remote(:stone)}
      before do
        obj
        FakeWeb.register_uri(:get, %r|/records/#{global_id}/casteml|, :body => nil, :status => ["200", "Ok"])
      end

      it {
        subject 
        expect(FakeWeb).to have_requested(:get, %r|/records/#{global_id}/casteml|) 
      }

      after do
        File.unlink(filename)
      end
    end

    describe ".download" do
      subject{ Record.download_single(global_id, opts)}
      let(:filename){ global_id + ".json"}
      let(:global_id){ '0000-001' }
      let(:opts){ {} }
      before do
        #obj
        FakeWeb.register_uri(:get, %r|/records/#{global_id}.json|, :body => FactoryGirl.remote(:stone).to_json, :status => ["200", "Ok"])
#       Record.download_single(arg, opts)
      end

      it { 
        subject
        expect(FakeWeb).to have_requested(:get, %r|/records/#{global_id}.json|) 
      # expect(File.exists?(filename)).to be_truthy
      }

      after do
        File.unlink(filename)
      end
    end

    describe ".box?" do

      context "with root path" do
        subject{ Record.box?(arg) }
        let(:arg){ '/' }
        let(:obj){ FactoryGirl.remote(:box) }
        before do
          allow(Record).to receive(:find_by_id_or_path).and_return(obj)
        end
        it { 
          expect(Record).to receive(:find_by_id_or_path).with(arg).and_return(obj)
          subject 
        }

      end

      context "with box's global_id" do
        subject{ Record.box?(arg) }
        let(:arg){ '0000-001' }
        let(:obj){ FactoryGirl.remote(:box) }
        it { 
          expect(Record).to receive(:find_by_id_or_path).with(arg).and_return(obj)
          subject 
        }

      end

      context "with box's path" do
        subject{ Record.box?(arg) }
        let(:arg){ '/A/B/C' }
        let(:obj){ FactoryGirl.remote(:box) }
        before do
          allow(Record).to receive(:find_by_id_or_path).and_return(obj)
        end
        it { 
          expect(subject).to be_truthy
        }

      end

      context "with stone's global_id" do
        subject{ Record.box?(arg) }
        let(:arg){ '0000-001' }
        let(:obj){ FactoryGirl.remote(:stone) }
        before do
          allow(Record).to receive(:find_by_id_or_path).with(arg).and_return(obj)
        end
        it { expect(subject).not_to be_truthy }

      end

    end

    describe "entries" do

      context "with global_id" do
        subject{ Record.entries(arg) }
        let(:arg){ '0000-001' }
        let(:obj){ FactoryGirl.remote(:box) }
        before do
          allow(Record).to receive(:find_by_id_or_path).with(arg).and_return([])
        end

        it { expect(subject).to be_an_instance_of(Array) }

      end

    end


  end
end
