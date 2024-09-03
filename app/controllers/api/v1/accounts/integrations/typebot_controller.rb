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

  private

  def set_account
    @account = Current.account
  end

  def set_integration_hook
    @integration_hook = @account.integration_hooks.find_by!(app_id: 'typebot')
  end
end
