class Message < ApplicationRecord
  attr_accessor :editable
  belongs_to :topic

  def self.list(topic, user_id)
    messages = topic.messages.map do |elem|
      elem.editable = (elem.user_id == user_id)
      elem
    end
    return messages
  end
end
