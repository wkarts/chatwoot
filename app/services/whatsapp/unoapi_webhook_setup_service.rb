class Whatsapp::UnoapiWebhookSetupService
  def perform(whatsapp_channel)
    if whatsapp_channel.provider_config['disconnect']
      whatsapp_channel.provider_config.delete('connect')
      whatsapp_channel.provider_config.delete('disconnect')
      return disconnect(whatsapp_channel)
    end
    return unless whatsapp_channel.provider_config['connect']

    whatsapp_channel.provider_config.delete('connect')
    whatsapp_channel.provider_config.delete('disconnect')
    connect(whatsapp_channel)
  end

  private

  def disconnect(whatsapp_channel)
    phone_number = whatsapp_channel.provider_config['business_account_id']
    Rails.logger.debug { "Disconnecting #{phone_number} from unoapi" }
    response = HTTParty.post("#{url(whatsapp_channel)}/deregister", headers: headers(whatsapp_channel))
    if response.success?
      true
    else
      whatsapp_channel.errors.add(:provider_config, response.body)
      false
    end
  end

  def connect(whatsapp_channel)
    phone_number = whatsapp_channel.provider_config['business_account_id']
    Rails.logger.debug { "Connecting #{phone_number} from unoapi" }

    body = prepare_body(whatsapp_channel)
    response = HTTParty.post("#{url(whatsapp_channel)}/register", headers: headers(whatsapp_channel), body: body.to_json)

    Rails.logger.debug { "Response #{response}" }
    return send_message(whatsapp_channel) if response.success?

    whatsapp_channel.errors.add(:provider_config, response.body)
    true
  end

  def prepare_body(whatsapp_channel)
    {
      ignoreGroupMessages: whatsapp_channel.provider_config['ignore_group_messages'],
      ignoreBroadcastStatuses: whatsapp_channel.provider_config['ignore_broadcast_statuses'],
      ignoreBroadcastMessages: whatsapp_channel.provider_config['ignore_broadcast_messages'],
      ignoreHistoryMessages: whatsapp_channel.provider_config['ignore_history_messages'],
      ignoreOwnMessages: whatsapp_channel.provider_config['ignore_own_messages'],
      ignoreYourselfMessages: whatsapp_channel.provider_config['ignore_yourself_messages'],
      sendConnectionStatus: whatsapp_channel.provider_config['send_connection_status'],
      notifyFailedMessages: whatsapp_channel.provider_config['notify_failed_messages'],
      composingMessage: whatsapp_channel.provider_config['composing_message'],
      rejectCalls: whatsapp_channel.provider_config['reject_calls'],
      messageCallsWebhook: whatsapp_channel.provider_config['message_calls_webhook'],
      webhooks: prepare_webhooks(whatsapp_channel),
      sendReactionAsReply: whatsapp_channel.provider_config['send_reaction_as_reply'],
      sendProfilePicture: whatsapp_channel.provider_config['send_profile_picture'],
      authToken: whatsapp_channel.provider_config['api_key'],
      useRejectCalls: whatsapp_channel.provider_config['use_reject_calls']
    }
  end

  # A função 'prepare_webhooks' permite editar os campos do webhook padrão, exceto o 'id', e editar todos os campos para webhooks adicionais.
  def prepare_webhooks(whatsapp_channel)
    phone_number = whatsapp_channel.provider_config['business_account_id']

    # Verifica se o webhook padrão existe, senão cria
    default_webhook = {
      sendNewMessages: whatsapp_channel.provider_config['webhook_send_new_messages'],
      id: 'default', # ID fixo para o webhook padrão
      urlAbsolute: "#{ENV.fetch('FRONTEND_URL', nil)}/webhooks/whatsapp/#{phone_number}",
      token: whatsapp_channel.provider_config['webhook_verify_token'],
      header: :Authorization
    }

    additional_webhooks = whatsapp_channel.provider_config['webhooks'] || []
    
    # Garante que o webhook padrão esteja sempre presente no início da lista
    webhooks = [default_webhook]

    # Processa os webhooks adicionais
    additional_webhooks.each do |webhook|
      next if webhook['id'] == 'default' # Ignora se tentar modificar o id 'default'

      webhooks << {
        id: webhook['id'] || "webhook_#{webhooks.size}", # Permite editar o ID dos webhooks adicionais
        urlAbsolute: webhook['urlAbsolute'],
        token: webhook['token'],
        sendNewMessages: webhook['sendNewMessages'],
        header: webhook['header']
      }
    end

    webhooks
  end

  def send_message(whatsapp_channel)
    phone_number = whatsapp_channel.provider_config['business_account_id']
    Rails.logger.debug { "Save #{phone_number} configuration unoapi" }
    body = {
      messaging_product: :whatsapp,
      to: phone_number,
      type: :text,
      text: {
        body: 'connect...'
      }
    }
    Rails.logger.debug { "Sending message to #{phone_number} unoapi" }
    response = HTTParty.post("#{url(whatsapp_channel)}/messages", headers: headers(whatsapp_channel), body: body.to_json)
    Rails.logger.debug { "Response #{response}" }
    return true if response.success?

    whatsapp_channel.errors.add(:provider_config, response.body)
    false
  end

  def url(whatsapp_channel)
    "#{whatsapp_channel.provider_config['url']}/v15.0/#{whatsapp_channel.provider_config['business_account_id']}"
  end

  def headers(whatsapp_channel)
    {
      Authorization: GlobalConfigService.load('UNOAPI_AUTH_TOKEN', whatsapp_channel.provider_config['api_key']),
      'Content-Type': 'application/json'
    }
  end
end
