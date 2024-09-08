class Api::V1::Accounts::Integrations::TypebotController < Api::V1::Accounts::BaseController
  before_action :set_account
  before_action :set_integration_hook

  def settings
    render json: { frontend_url: @integration_hook.settings['frontend_url'] }
  end

  def update_settings
    @integration_hook.update!(settings: params[:settings])
    render json: { success: true }
  end

  private

  def set_account
    @account = Current.account
  end

  def set_integration_hook
    @integration_hook = @account.integration_hooks.find_by!(app_id: 'typebot')
  end
end
