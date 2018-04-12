class Stock < ActiveRecord::Base

  has_many :user_stocks
  has_many :users , through: :user_stocks

    def self.find_by_ticker(ticket_symbol)
       where(ticker: ticket_symbol).first 
    end

    def self.new_from_lookup(ticket_symbol)
        begin
            lookup_stock =  StockQuote::Stock.quote(ticket_symbol)
            new(name: lookup_stock.company_name , ticker: lookup_stock.symbol , last_price: lookup_stock.latest_price)
            
        rescue Exception => e
            return nil
        end
        
    end
    

end
