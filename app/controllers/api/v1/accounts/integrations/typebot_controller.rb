class Api::V1::Accounts::Integrations::TypebotController < Api::V1::Accounts::BaseController
  before_action :set_account

  def settings
    render json: { settings: typebot_settings }
  end

  def update_settings
    @account.update!(typebot_settings: permitted_params)
    render json: { settings: typebot_settings }
  end

  private

  def typebot_settings
    @account.typebot_settings || {}
  end

  def permitted_params
    params.require(:settings).permit(:api_key, :project_id, :api_url, :frontend_url)
  end

  def set_account
    @account = Current.account
  end
end
