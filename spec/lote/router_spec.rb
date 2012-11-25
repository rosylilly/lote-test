require 'spec_helper'

describe Lote::Router do
  class MockRouter < Lote::Router
  end

  let(:router) do
    MockRouter.new do
      get '/', 'home#index'
      post 'user', 'user#create'
      get 'user/:id', 'user#show', id: /\d+/
    end
  end

  subject { router }

  describe '#routing' do
    subject { router.routing(method, path) }

    context 'when GET /' do
      let(:method) { :get }
      let(:path) { '/' }

      its(:controller) { should == 'home' }
      its(:action) { should == 'index' }
    end

    context 'when GET /user/25' do
      let(:method) { :get }
      let(:path) { '/user/25' }

      its(:controller) { should == 'user' }
      its(:action) { should == 'show' }
      its(:id) { should == '25' }
    end

    context 'when GET /users/25' do
      let(:method) { :get }
      let(:path) { '/users/25' }

      it { should be_false }
    end
  end
end
