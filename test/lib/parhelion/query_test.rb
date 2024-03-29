require 'test_helper'
module Parhelion
  class QueryTest < ActiveSupport::TestCase
    it 'reponds to the params message' do
      _(Query.new(params: {'foo' => 'bar'}).params).must_equal({'foo' => 'bar'})
    end

    it 'tells us if any params are active' do
      _(Query.new(params: {'foo' => 'bar'}).active?).must_equal true
      _(Query.new(params: {}).active?).must_equal false
    end

    it 'tells us if there is an active query of any kind (facet, sort, q, etc)' do
      _(Query.new(params: {'foo' => 'bar'}).active?).must_equal true
      _(Query.new(params: {}).active?).must_equal false
    end

    it 'responds to Rails::Hash except' do
      _(Query.new(params: {'blah' => 'blah', 'foo' => 'bar'})
           .except('foo')
       ).must_equal({'blah' => 'blah'})
    end

    it 'responds to Hash merge' do
      _(Query.new(params: {'foo' => 'bar'})
           .merge('blah' => 'blah')
       ).must_equal({'blah' => 'blah', 'foo' => 'bar'})
    end

    it 'responds to Rails::Hash deep_merge' do
      _(Query.new(params: { 'foo' => 'bar',
                          'facets' => {
                            'publisher' => 'Tribune',
                            'year' => '1998'
                          } })
           .deep_merge('facets' => {'year' => '1998'})
       ).must_equal(
             'foo' => 'bar',
             'facets' => {
               'publisher' => 'Tribune',
               'year' => '1998'
             }
           )
    end

    it 'responds to Hash fetch' do
      _(Query.new(params: {'foo' => 'bar'})
           .fetch('foo')
       ).must_equal('bar')
      _(Query.new(params: {'foo' => 'bar'})
           .fetch('ferb',  '')
       ).must_equal('')
    end

    it 'knows how to become a hash' do
      _(Query.new(params: {'foo' => 'bar'})
           .to_h
       ).must_equal({"foo"=>"bar"})
    end
  end
end
