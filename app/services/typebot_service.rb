class TypebotService
  def initialize(integration_hook)
    @api_key = integration_hook.settings['api_key']
    @project_id = integration_hook.settings['project_id']
    @api_url = integration_hook.settings['api_url']
    @frontend_url = integration_hook.settings['frontend_url']    
  end

  def frontend_link
    "#{@frontend_url}/editor/#{@project_id}"
  end
  
  def send_message(message)
    response = HTTParty.post(
      "#{@api_url}/projects/#{@project_id}/messages",
      headers: { "Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json" },
      body: { message: message }.to_json
    )
    JSON.parse(response.body)
  end

  def send_interactive_message(conversation_id, options)
    payload = {
      content: "Por favor, escolha uma opção:",
      content_type: "input_select",
      content_attributes: {
        items: options
      }
    }

    response = HTTParty.post(
      "#{@api_url}/conversations/#{conversation_id}/messages",
      headers: { "Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json" },
      body: payload.to_json
    )
    JSON.parse(response.body)
  end

  def transfer_to_agent(conversation_id, agent_id = nil)
    body = agent_id ? { agent_id: agent_id } : { group_id: default_group_id }
    
    response = HTTParty.post(
      "#{@api_url}/conversations/#{conversation_id}/assignments",
      headers: { "Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json" },
      body: body.to_json
    )
    JSON.parse(response.body)
  end

  def resolve_conversation(conversation_id)
    response = HTTParty.post(
      "#{@api_url}/conversations/#{conversation_id}/resolve",
      headers: { "Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json" }
    )
    JSON.parse(response.body)
  end

  def process_widget_triggered(data)
    conversation_id = data['conversation_id']
    send_interactive_message(conversation_id, [
      { "title" => "Suporte", "value" => "suporte" },
      { "title" => "Vendas", "value" => "vendas" },
      { "title" => "Outro", "value" => "outro" }
    ])
  end

  def process_message_created(data)
    message = data['message']
    conversation_id = data['conversation_id']

    if message.include?('suporte')
      transfer_to_agent(conversation_id, default_group_id)
      send_message("Você foi transferido para um agente de suporte. Aguarde.")
    elsif message.include?('encerrar')
      resolve_conversation(conversation_id)
      send_message("Conversa encerrada. Se precisar de mais ajuda, entre em contato novamente.")
    else
      send_message("Obrigado pela mensagem. Como podemos ajudar?")
    end
  end

  def activate_integration
    response = HTTParty.post(
      "#{@api_url}/projects/#{@project_id}/activate",
      headers: { "Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json" }
    )
    integration_hook.update(active: true) if response.success?
  end

  def deactivate_integration
    response = HTTParty.post(
      "#{@api_url}/projects/#{@project_id}/deactivate",
      headers: { "Authorization" => "Bearer #{@api_key}", "Content-Type" => "application/json" }
    )
    integration_hook.update(active: false) if response.success?
  end

  private

  attr_reader :integration_hook

  def default_group_id
    group = Group.find_by(name: 'Suporte')
    raise 'Grupo de suporte não encontrado.' unless group
    group.id
  end
end
