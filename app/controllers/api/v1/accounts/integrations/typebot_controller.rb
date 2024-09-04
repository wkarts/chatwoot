class Api::V1::Accounts::Integrations::TypebotController < Api::V1::Accounts::BaseController
  before_action :set_account
  before_action :set_integration_hook

  def create_message
    response = TypebotService.new(@integration_hook).send_message(params[:message])
    render json: response, status: :ok
  end

  def activate
    response = TypebotService.new(@integration_hook).activate_integration
    render json: response, status: :ok
  end

  def deactivate
    response = TypebotService.new(@integration_hook).deactivate_integration
    render json: response, status: :ok
  end

  def webhook
    event = params[:event]
    
    case event
    when 'widget_triggered'
      handle_widget_triggered(params[:data])
    when 'message_created'
      handle_message_created(params[:data])
    else
      render json: { error: 'Unknown event' }, status: :bad_request
    end
  end

  private

  def set_account
    @account = Current.account
  end

  def set_integration_hook
    @integration_hook = @account.integration_hooks.find_by!(app_id: 'typebot')
  end

  def handle_widget_triggered(data)
    TypebotService.new(@integration_hook).process_widget_triggered(data)
  end

  def handle_message_created(data)
    TypebotService.new(@integration_hook).process_message_created(data)
  end
end
