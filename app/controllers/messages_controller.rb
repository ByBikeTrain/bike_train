class MessagesController < ApplicationController

def read

    if(params[:id])
        @message = Message.find(params[:id])
        @message.read = true
        @message.save
    end

end

end
