require 'spec_helper'

describe Lote::Util do
  using Lote::Util

  describe String do
    let(:string) { 'string' }
    subject { string }

    describe '#camelize' do
      subject { string.camelize }

      it { should == 'String' }

      context 'when "string_module"' do
        let(:string) { 'string_module' }

        it { should == 'StringModule' }
      end

      context 'when "string/module' do
        let(:string) { 'string/module' }

        it { should == 'String::Module' }
      end
    end

    describe '#underscore' do
      let(:string) { 'String' }
      subject { string.underscore }

      it { should == 'string' }

      context 'when StringModule' do
        let(:string) { 'StringModule' }

        it { should == 'string_module' }
      end

      context 'when String::Module' do
        let(:string) { 'String::Module' }

        it { should == 'string/module' }
      end
    end

    describe '#html_safe' do
      subject { string.html_safe }

      it { should == string }

      it('#html_safe? should be true') { subject.html_safe?.should be_true }

      it('#object_id should not == string#object_id') {
        subject.object_id.should_not == string.object_id
      }
    end

    describe '#html_safe?' do
      subject { string.html_safe? }

      it { should be_false }
    end

    describe '#html_safe!' do
      subject { string.html_safe! }

      it { should == string }

      it('#html_safe? should be true') { subject.html_safe?.should be_true }

      it('#object_id should == string#object_id') {
        subject.object_id.should == string.object_id
      }
    end

    describe '#url_split' do
      let(:string) { '/hello/say/fantastic.xml' }
      subject { string.url_split }

      it { should == %w(hello say fantastic.xml) }
    end
  end
end
