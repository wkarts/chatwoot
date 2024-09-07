class Api::V1::Accounts::Integrations::TypebotController < Api::V1::Accounts::BaseController
  before_action :set_account
  before_action :set_integration_hook

  def settings
    render json: {
      settings: @integration_hook.settings
    }
  end

  def save_settings
    @integration_hook.settings = params[:settings]
    @integration_hook.save!
    render json: { message: 'Settings saved successfully' }, status: :ok
  end

  private

  def set_account
    @account = Current.account
  end

  def set_integration_hook
    @integration_hook = @account.integration_hooks.find_by!(app_id: 'typebot')
  end
end
