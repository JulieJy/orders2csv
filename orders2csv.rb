require 'pry'
require 'shopify_api'
require 'dotenv'
require 'csv'
require 'json'
Dotenv.load

class Orders2csv
  attr_accessor :shop_url

  def initialize
    set_shop
    get_orders
  end

  def csv_file
    # Generate new csv file
    attributes = @orders.first.attributes.keys
    puts '*** creating csv file ***'
    CSV.open("#{Time.now.strftime("%Y%m%d%H%M%S")}_order_file.csv", "wb") do |csv|
      csv << attributes
      @orders.each do |obj|
        csv << attributes.map{ |attr| obj.attributes[attr] }
      end
    end
    puts '*** finished ! :) ***'
  end

  private

  def set_shop
    # Configure the Shopify connection
    shop_url = "https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_PASSWORD']}@#{ENV['SHOP']}.myshopify.com/admin"
    ShopifyAPI::Base.site = shop_url
    ShopifyAPI::Base.api_version = '2020-04'
  end

  def get_orders
    # Gather all orders from store
    puts "*** looking for shopify orders on store #{ENV['SHOP']} ***"
    @orders = ShopifyAPI::Order.find(:all, params: { status: 'any', limit: 250 })
  end
end

if __FILE__ == $PROGRAM_NAME
  Orders2csv.new.csv_file
end
