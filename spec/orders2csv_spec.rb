require 'spec_helper'
require 'orders2csv'

describe Orders2csv do
  describe 'I can access orders' do
    it 'should be ok' do
      shop_url = "https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_PASSWORD']}@#{ENV['SHOP']}.myshopify.com/admin"
      ShopifyAPI::Base.site = shop_url
      ShopifyAPI::Base.api_version = '2020-04'
      orders = ShopifyAPI::Order.find(:all, params: { status: 'any', limit: 250 })
      expect(orders).not_to be_blank
    end
  end
end
