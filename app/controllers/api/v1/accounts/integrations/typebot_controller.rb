class Api::V1::Accounts::Integrations::TypebotController < Api::V1::Accounts::BaseController
  before_action :set_account
  before_action :set_integration_hook, except: :fetch_inboxes

  # Foco na configuração das URLs de frontend e API
  def save_settings
    if @integration_hook.update(settings_params)
      render json: { message: 'Configurações salvas com sucesso' }, status: :ok
    else
      render json: { error: 'Erro ao salvar configurações' }, status: :unprocessable_entity
    end
  end

  def fetch_settings
    render json: { settings: @integration_hook.settings }, status: :ok
  end

  private

  def set_account
    @account = Current.account
  end

  def set_integration_hook
    @integration_hook = @account.integration_hooks.find_by!(app_id: 'typebot')
  end

  def settings_params
    params.require(:integration).permit(:api_key, :project_id, :api_url, :frontend_url)
  end
end
