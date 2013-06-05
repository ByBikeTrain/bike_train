class StaticPagesController < ApplicationController
  def home

  end

  def dashboard
    
    if !signed_in?
        redirect_to home_path
    else
        @messages = Message.where(:recipient_id => current_user.id, :read => false)
    end
  	
  end
end
