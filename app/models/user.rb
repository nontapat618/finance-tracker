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
  
  def self.search(search_param)
    search_param.strip!
    search_param.downcase!
    result = ( first_name_match(search_param) + last_name_match(search_param) + email_match(search_param) ).uniq
    return nil unless result
    result
  end
  
  def self.first_name_match(search_param)
      matches('first_name',search_param)
  end

  def self.last_name_match(search_param)
      matches('last_name',search_param)
  end

  def self.email_match(search_param)
      matches('email',search_param)
  end
  
  def self.matches(field,search_param)
    where("#{field} like ?","%#{search_param}%")
  end
  
  def except_current_user(users)
    users.reject { |user| user.id == self.id  }
  end

  def not_frined_with?(friend_id)
    friendships.where(friend_id: friend_id).count < 1
  end
  
end
