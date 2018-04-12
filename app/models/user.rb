class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :user_stocks
  has_many :stocks , through: :user_stocks
  has_many :friendships
  has_many :friends , through: :friendships

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    "Annonymus"
  end
         
  def stock_already_add?(stock_ticker)
    stock = Stock.find_by_ticker(stock_ticker)
    return false unless stock
    user_stocks.where(stock_id: stock.id).exists?
  end
  
  def stock_not_exceed?
    (user_stocks.count < 10)
  end
  
  def can_add_stock?(stock_ticker)
    stock_not_exceed? && !stock_already_add?(stock_ticker)
  end
  
end
