class TypebotService
  def initialize(integration_hook)
    @api_key = integration_hook.settings['api_key']
    @project_id = integration_hook.settings['project_id']
    @api_url = Rails.application.config_for(:installation_config)['typebot_api_url']
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
      content: "Please choose an option:",
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

  def process_widget_triggered(data)
    conversation_id = data['conversation_id']
    send_interactive_message(conversation_id, [
      { "title" => "Support", "value" => "support" },
      { "title" => "Sales", "value" => "sales" },
      { "title" => "Other", "value" => "other" }
    ])
  end

  def process_message_created(data)
    message = data['message']
    # Implementação da lógica de processamento
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
end
