class Messages::Internal::MessageBuilder < Messages::MessageBuilder
  def perform
    super
    @message
  end
end
