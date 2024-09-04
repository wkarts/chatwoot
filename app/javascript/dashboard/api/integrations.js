/* global axios */

import ApiClient from './ApiClient';
import API from 'dashboard/api';

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
  
  activateTypebot() {
    return API.post(`/api/v1/accounts/${window.accountId}/integrations/typebot/activate`);
  }

  deactivateTypebot() {
    return API.post(`/api/v1/accounts/${window.accountId}/integrations/typebot/deactivate`);
  }

  createTypebotMessage(message) {
    return API.post(`/api/v1/accounts/${window.accountId}/integrations/typebot/create_message`, { message });
  }

  getTypebotSettings() {
    return API.get(`/api/v1/accounts/${window.accountId}/integrations/typebot/settings`);
  }

  saveTypebotSettings(settings) {
    return API.post(`/api/v1/accounts/${window.accountId}/integrations/typebot/settings`, { settings });
  }  
}

export default new IntegrationsAPI();
