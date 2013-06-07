class MembersController < ApplicationController

def read

    if(params[:id])
        @message = Message.find(params[:id])
    end

end

end
