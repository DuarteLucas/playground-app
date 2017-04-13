class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @lists = @user.lists
    @following = current_user.followees.include?(User.find(params[:id]))
  end
end
