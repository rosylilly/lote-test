require 'spec_helper'

describe Lote::Route do
  let(:route) { Lote::Route.new('/user/:id/', 'user#show') }

  subject { route }

  its(:controller) { should == 'user' }

  its(:action) { should == 'show' }

  describe '#match?' do
    subject { route.match?(path) }

    context 'when define /user/:id/' do
      let(:route) { Lote::Route.new('/user/:id/', 'user#show') }

      context 'when /user/12' do
        let(:path) { '/user/12' }

        it { should be_true }
      end

      context 'when /user/12/' do
        let(:path) { '/user/12/' }

        it { should be_true }
      end

      context 'when /user/show' do
        let(:path) { '/user/show' }

        it { should be_false }
      end

      context 'when /user' do
        let(:path) { '/user' }

        it { should be_false }
      end
    end

    context 'when define /author/:alphabets/:id' do
      let(:route) do
        Lote::Route.new('/author/:alphabets/:id', 'author#show', alphabets: /[a-z]+/)
      end

      context 'when /author/test/1' do
        let(:path) { '/author/test/1' }

        it { should be_true }
      end

      context 'when /author/test2/2' do
        let(:path) { '/author/test2/2' }

        it { should be_false }
      end
    end
  end
end
