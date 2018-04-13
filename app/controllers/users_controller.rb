class UsersController < ApplicationController
   def my_portfolio 
    @user = current_user
    @user_stocks = current_user.stocks
   end
   
   def my_friends
       @friendships = current_user.friends
   end

   
   def search_friends
       if params[:search_param].blank?
           flash.now[:danger] = "you entered empty string"
       else 
           @users = User.search(params[:search_param])
           @users = current_user.except_current_user(@users)
           flash.now[:danger] = "can't find any user" if @users.blank?
       end
       render partial: 'friends/result'
   end
   
   def add_friend
    @friend = User.find(params[:friend])  
    current_user.friendships.build(friend_id: @friend.id);
    
    if current_user.save
        flash[:success] = "Add friend succesfully"
    else
        flash[:danger] = "Cannot add friend"
    end
    redirect_to my_friends_path
   end
   
   def show
    @user = User.find(params[:id])
    @user_stocks = @user.stocks
   end
   
end