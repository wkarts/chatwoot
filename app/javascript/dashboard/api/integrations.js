/* global axios */

import ApiClient from './ApiClient';

class IntegrationsAPI extends ApiClient {
  constructor() {
    super('integrations/apps', { accountScoped: true });
  }

  connectSlack(code) {
    return axios.post(`${this.baseUrl()}/integrations/slack`, { code });
  }

  updateSlack({ referenceId }) {
    return axios.patch(`${this.baseUrl()}/integrations/slack`, {
      reference_id: referenceId,
    });
  }

  listAllSlackChannels() {
    return axios.get(`${this.baseUrl()}/integrations/slack/list_all_channels`);
  }

  delete(integrationId) {
    return axios.delete(`${this.baseUrl()}/integrations/${integrationId}`);
  }

  createHook(hookData) {
    return axios.post(`${this.baseUrl()}/integrations/hooks`, hookData);
  }

  deleteHook(hookId) {
    return axios.delete(`${this.baseUrl()}/integrations/hooks/${hookId}`);
  }

  fetchCaptainURL() {
    return axios.get(`${this.baseUrl()}/integrations/captain/sso_url`);
  }

  getTypebotSettings() {
    return axios.get(`${this.baseUrl()}/integrations/typebot/settings`);
  }

  saveTypebotSettings(settings) {
    return axios.post(`${this.baseUrl()}/integrations/typebot/settings`, { settings });
  }
}

export default new IntegrationsAPI();
