require 'pry'
require 'shopify_api'
require 'dotenv'
require 'csv'
require 'json'
Dotenv.load

class Orders2csv
  attr_accessor :shop_url

  # Configure the Shopify connection
  def initialize
    shop_url = "https://#{ENV["SHOPIFY_API_KEY"]}:#{ENV["SHOPIFY_PASSWORD"]}@#{ENV["SHOP"]}.myshopify.com/admin"
    ShopifyAPI::Base.api_version = '2020-04'
    ShopifyAPI::Base.site = shop_url
    @orders = ShopifyAPI::Order.find(:all, :params => {:status => 'any', :limit => 250})
    puts "*** looking for shopify orders on store #{ENV["SHOP"]} ***"
    puts @orders
  end

  def csv_file
    attributes = %w(billing_address)
    orders_csv = CSV.generate do |csv|
      csv << attributes
      @orders.each do |obj|
        csv << attributes.map{ |attr| obj[attr.to_sym] }
      end
    end
    return orders_csv
  end
end

if __FILE__ == $PROGRAM_NAME
  Orders2csv.new.csv_file
end
