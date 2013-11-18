# encoding: utf-8
$: << File.dirname(__FILE__)
require 'spec_helper'
require 'currency'
require 'rspec'

describe Currency do
  it 'should read from a manifest' do
    rate =  Currency.rate('CHF', 'EUR')
    rate.class.should eql Float
    rate.should < 1.0
    rate.should > 0.5
  end
end
