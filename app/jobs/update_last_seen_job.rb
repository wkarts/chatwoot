class UpdateLastSeenJob < ApplicationJob
  queue_as :default

  def perform(conversation_id, user, agent_last_seen_at)
    conversation = Conversation.find(conversation_id)

    agent_viewed(conversation, user) if conversation.account.feature_enabled?('agent_conversation_viewed')

    read_message(conversation, agent_last_seen_at) if conversation.account.feature_enabled?('read_message')
  end

  private

  def read_message(conversation, agent_last_seen_at)
    messages = conversation.messages.to_read(agent_last_seen_at)
    Rails.logger.debug { "Conversation #{conversation.id} with #{messages.size} message(s) to update status to read" }
    messages.each do |message|
      Rails.logger.debug { "Update message id #{message.id} source #{message.source_id} status to read" }
      message.update(status: :read)
    end
  end

  def agent_viewed(conversation, user)
    return unless conversation.open?

    key = "conversation:last_seen:#{conversation.id}:#{user.id}"
    key_exists = ::Redis::Alfred.get(key)
    
    Rails.logger.debug { "Checking if Redis key exists: #{key_exists}" }

    if key_exists
      Rails.logger.debug { "Redis key #{key} already exists, skipping message creation." }
      return
    end

    Rails.logger.debug { "Setting Redis key #{key}" }
    ::Redis::Alfred.setex(key, 1.hour, true)
    
    params = {
      message_type: :activity,
      content_type: :text,
      content: "Conversa visualizada por #{user.id} - #{user.name}"
    }

    message = Messages::MessageBuilder.new(user, conversation, params).perform

    if message.persisted?
      Rails.logger.debug { "Message created successfully with id #{message.id}" }
    else
      Rails.logger.error { "Failed to create message" }
    end
  end
end
