class Message < ActiveRecord::Base
    attr_accessible :text, :read
    belongs_to :group
    belongs_to :user, :foreign_key => "sender_id"
    belongs_to :user, :foreign_key => "recipient_id"
end
