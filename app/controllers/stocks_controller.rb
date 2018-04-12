class StocksController < ApplicationController 
   def search
        if params[:stock].blank?
            flash.now[:danger] = "you entered empty input"
        else 
            @stock = Stock.new_from_lookup(params[:stock])
            flash.now[:danger] = "can't find that stock" unless @stock
        end
        render partial: 'users/result'
   end
end