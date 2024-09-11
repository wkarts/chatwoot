<template>
  <div class="my-2 mx-8 text-base">
    <!-- Tabs para navegação entre Parâmetros e Webhooks -->
    <woot-tabs :index="activeTab" @change="onTabChange">
      <woot-tabs-item name="Parâmetros" />
      <woot-tabs-item name="Webhooks" :count="webhooks.length" />
    </woot-tabs>

    <!-- Conteúdo da aba Parâmetros -->
    <div v-if="activeTab === 0">
      <form class="flex flex-col" @submit.prevent="updateInbox()">
        <div class="w-1/4">
          <label :class="{ error: v$.url.$error }">
            <span>
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.URL.LABEL') }}
            </span>
            <input
              v-model.trim="url"
              type="text"
              :placeholder="$t('INBOX_MGMT.ADD.WHATSAPP.URL.PLACEHOLDER')"
              @blur="v$.url.$touch"
            />
            <span v-if="v$.url.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.URL.ERROR') }}
            </span>
          </label>
        </div>

        <div class="w-1/4">
          <label :class="{ error: v$.apiKey.$error }">
            <span>
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.API_KEY.LABEL') }}
            </span>
            <input
              v-model.trim="apiKey"
              type="text"
              :placeholder="$t('INBOX_MGMT.ADD.WHATSAPP.API_KEY.PLACEHOLDER')"
              @blur="v$.apiKey.$touch"
            />
            <span v-if="v$.apiKey.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.API_KEY.ERROR') }}
            </span>
          </label>
        </div>

        <div class="max-w-[65%] w-full messagingServiceHelptext">
          <label for="useRejectCalls">
            <input
              id="useRejectCalls"
              v-model="useRejectCalls"
              type="checkbox"
              class="checkbox"
            />
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.REJECT_CALLS.SERVICE') }}
          </label>
        </div>

        <div v-if="useRejectCalls" class="w-1/4">
          <label :class="{ error: v$.rejectCalls.$error }">
            <span>
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.REJECT_CALLS.LABEL') }}
            </span>
            <input
              v-model.trim="rejectCalls"
              type="text"
              :placeholder="$t('INBOX_MGMT.ADD.WHATSAPP.REJECT_CALLS.PLACEHOLDER')"
              @blur="v$.rejectCalls.$touch"
            />
            <span v-if="v$.rejectCalls.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.REJECT_CALLS.ERROR') }}
            </span>
          </label>
        </div>

        <div v-if="useRejectCalls" class="w-1/4">
          <label :class="{ error: v$.messageCallsWebhook.$error }">
            <span>
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.MESSAGE_CALLS_WEBHOOK.LABEL') }}
            </span>
            <input
              v-model.trim="messageCallsWebhook"
              type="text"
              :placeholder="$t('INBOX_MGMT.ADD.WHATSAPP.MESSAGE_CALLS_WEBHOOK.PLACEHOLDER')"
              @blur="v$.messageCallsWebhook.$touch"
            />
            <span v-if="v$.messageCallsWebhook.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.MESSAGE_CALLS_WEBHOOK.ERROR') }}
            </span>
          </label>
        </div>

        <!-- Outras configurações de Parâmetros -->
        <div class="w-3/4 pb-4 config-helptext">
          <label :class="{ error: v$.sendAgentName.$error }" style="display: flex; align-items: center;">
            <woot-switch
              v-model="sendAgentName"
              :value="sendAgentName"
              style="flex: 0 0 auto; margin-right: 10px;"
            />
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.SEND_AGENT_NAME.LABEL') }}
            <span v-if="v$.sendAgentName.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.SEND_AGENT_NAME.ERROR') }}
            </span>
          </label>
        </div>

        <div class="w-3/4 pb-4 config-helptext">
          <label :class="{ error: v$.ignoreGroupMessages.$error }" style="display: flex; align-items: center;">
            <woot-switch
              v-model="ignoreGroupMessages"
              :value="ignoreGroupMessages"
              style="flex: 0 0 auto; margin-right: 10px;"
            />
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.IGNORE_GROUPS.LABEL') }}
            <span v-if="v$.ignoreGroupMessages.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.IGNORE_GROUPS.ERROR') }}
            </span>
          </label>
        </div>

        <div class="w-3/4 pb-4 config-helptext">
          <label :class="{ error: v$.ignoreHistoryMessages.$error }" style="display: flex; align-items: center;">
            <woot-switch
              v-model="ignoreHistoryMessages"
              :value="ignoreHistoryMessages"
              style="flex: 0 0 auto; margin-right: 10px;"
            />
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.IGNORE_HISTORY.LABEL') }}
            <span v-if="v$.ignoreHistoryMessages.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.IGNORE_HISTORY.ERROR') }}
            </span>
          </label>
        </div>

        <div class="w-3/4 pb-4 config-helptext">
          <label :class="{ error: v$.webhookSendNewMessages.$error }" style="display: flex; align-items: center;">
            <woot-switch
              v-model="webhookSendNewMessages"
              :value="webhookSendNewMessages"
              style="flex: 0 0 auto; margin-right: 10px;"
            />
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBWOOK_SEND_NEW_MESSAGES.LABEL') }}
            <span v-if="v$.webhookSendNewMessages.$error" class="message">
              {{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBWOOK_SEND_NEW_MESSAGES.ERROR') }}
            </span>
          </label>
        </div>

        <!-- Outros switches e botões -->
        <div class="w-3/4 pb-4 config-helptext">
          <img v-if="qrcode" :src="qrcode" />
          <div v-if="notice">{{ notice }}</div>
        </div>

        <div class="my-4 w-auto">
          <woot-submit-button
            :loading="uiFlags.isUpdating"
            :button-text="`${$t(
            'INBOX_MGMT.SETTINGS_POPUP.WHATSAPP_SECTION_UPDATE_BUTTON'
            )} and ${$t('INBOX_MGMT.SETTINGS_POPUP.WHATSAPP_CONNECT')}`"
            @click="connect = true"
          />
          <woot-submit-button
            :loading="uiFlags.isUpdating"
            :button-text="$t('INBOX_MGMT.SETTINGS_POPUP.WHATSAPP_DISCONNECT')"
            @click="disconnect = true"
          />
          <woot-submit-button
            :loading="uiFlags.isUpdating"          
            :button-text="$t('INBOX_MGMT.ADD.WHATSAPP.GENERATE_API_KEY.LABEL')"
            @click="generateToken"
          />
        </div>
      </form>
    </div>

    <!-- Conteúdo da aba Webhooks -->
    <div v-if="activeTab === 1">
      <div class="w-3/4 pb-4 config-helptext">
        <h3>{{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOKS') }}</h3>
        <table class="webhook-table">
          <thead>
            <tr>
              <th>{{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOK_NICKNAME') }}</th>
              <th>{{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOK_ID') }}</th>
              <th>{{ $t('INBOX_MGMT.ADD.WHATSAPP.ACTIONS') }}</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(webhook, index) in webhooks" :key="index">
              <td>{{ webhook.nickname }}</td>
              <td>{{ webhook.id }}</td>
              <td>
                <button @click.prevent="editWebhook(index)">
                  {{ $t('INBOX_MGMT.ADD.WHATSAPP.EDIT') }}
                </button>
                <button @click.prevent="removeWebhook(index)">
                  {{ $t('INBOX_MGMT.ADD.WHATSAPP.REMOVE') }}
                </button>
              </td>
            </tr>
          </tbody>
        </table>
        <button @click.prevent="showAddWebhookModal">
          {{ $t('INBOX_MGMT.ADD.WHATSAPP.ADD_WEBHOOK') }}
        </button>
      </div>

      <!-- Modal de Adicionar/Editar Webhook -->
      <modal v-if="showWebhookModal" @close="closeWebhookModal">
        <h3>{{ editingWebhook ? $t('INBOX_MGMT.ADD.WHATSAPP.EDIT_WEBHOOK') : $t('INBOX_MGMT.ADD.WHATSAPP.ADD_WEBHOOK') }}</h3>
        <form @submit.prevent="submitWebhook">
          <label>
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOK_NICKNAME') }}
            <input v-model="webhookForm.nickname" type="text" required />
          </label>
          <label>
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOK_ID') }}
            <input v-model="webhookForm.id" type="text" required />
          </label>
          <label>
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOK_URL') }}
            <input v-model="webhookForm.url" type="text" required />
          </label>
          <label>
            <woot-switch v-model="webhookForm.sendNewMessages" />
            {{ $t('INBOX_MGMT.ADD.WHATSAPP.WEBHOOK_SEND_NEW_MESSAGES') }}
          </label>
          <button type="submit">{{ editingWebhook ? $t('INBOX_MGMT.ADD.WHATSAPP.UPDATE_WEBHOOK') : $t('INBOX_MGMT.ADD.WHATSAPP.ADD_WEBHOOK') }}</button>
        </form>
      </modal>
    </div>
  </div>
</template>

<script type="module">
import { io } from 'socket.io-client';
import { useVuelidate } from '@vuelidate/core';
import { useAlert } from 'dashboard/composables';
import inboxMixin from 'shared/mixins/inboxMixin';
import { required } from '@vuelidate/validators';
import { mapGetters } from 'vuex';
import modal from 'components/Modal.vue';

export default {
  setup() {
    return { v$: useVuelidate() };
  },
  components: { modal },
  mixins: [inboxMixin],
  props: {
    inbox: {
      type: Object,
      default: () => ({}),
    },
  },
  data() {
    return {
      apiKey: '',
      url: 'https://cloud.hub.seudominio.com.br',
      ignoreGroupMessages: true,
      ignoreHistoryMessages: true,
      webhookSendNewMessages: true,
      sendAgentName: true,
      ignoreBroadcastStatuses: true,
      ignoreBroadcastMessages: true,
      ignoreOwnMessages: true,
      ignoreYourselfMessages: true,
      sendConnectionStatus: true,
      notifyFailedMessages: true,
      composingMessage: true,
      sendReactionAsReply: true,
      sendProfilePicture: true,
      useRejectCalls: false,
      connect: false,
      disconnect: false,
      qrcode: '',
      notice: '',
      rejectCalls: '',
      messageCallsWebhook: '',
      webhooks: [],
      showWebhookModal: false,
      editingWebhook: false,
      webhookForm: {
        nickname: '',
        id: '',
        url: '',
        sendNewMessages: false,
      },
      activeTab: 0, // Tab ativa: 0 para Parâmetros, 1 para Webhooks
    };
  },
  watch: {
    useRejectCalls(newValue) {
      if (!newValue) {
        this.rejectCalls = '';
        this.messageCallsWebhook = '';
      }
    },
    inbox() {
      this.setDefaults();
    },
  },
  computed: {
    ...mapGetters({ uiFlags: 'inboxes/getUIFlags' }),
  },
  validations: {
    apiKey: { required },
    url: { required },
    ignoreGroupMessages: { required },
    ignoreHistoryMessages: { required },
    webhookSendNewMessages: { required },
    sendAgentName: { required },
    rejectCalls: { required },
    messageCallsWebhook: { required },
  },
  methods: {
    setDefaults() {
      this.apiKey = this.inbox.provider_config.api_key;
      this.url = this.inbox.provider_config.url;
      this.ignoreGroupMessages = this.inbox.provider_config.ignore_group_messages;
      this.ignoreHistoryMessages = this.inbox.provider_config.ignore_history_messages;
      this.webhookSendNewMessages = this.inbox.provider_config.webhook_send_new_messages;
      this.sendAgentName = this.inbox.provider_config.send_agent_name;
      this.ignoreBroadcastStatuses = this.inbox.provider_config.ignore_broadcast_statuses;
      this.ignoreBroadcastMessages = this.inbox.provider_config.ignore_broadcast_messages;
      this.ignoreOwnMessages = this.inbox.provider_config.ignore_own_messages;
      this.ignoreYourselfMessages = this.inbox.provider_config.ignore_yourself_messages;
      this.sendConnectionStatus = this.inbox.provider_config.send_connection_status;
      this.notifyFailedMessages = this.inbox.provider_config.notify_failed_messages;
      this.composingMessage = this.inbox.provider_config.composing_message;
      this.sendReactionAsReply = this.inbox.provider_config.send_reaction_as_reply;
      this.sendProfilePicture = this.inbox.provider_config.send_profile_picture;
      this.useRejectCalls = this.inbox.provider_config.use_reject_calls;
      this.rejectCalls = this.inbox.provider_config.reject_calls;
      this.messageCallsWebhook = this.inbox.provider_config.message_calls_webhook;
      this.webhooks = this.inbox.provider_config.webhooks || [];
      this.connect = false;
      this.disconnect = false;
    },
    onTabChange(index) {
      this.activeTab = index;
    },
    showAddWebhookModal() {
      this.resetWebhookForm();
      this.showWebhookModal = true;
    },
    closeWebhookModal() {
      this.showWebhookModal = false;
    },
    resetWebhookForm() {
      this.webhookForm = {
        nickname: '',
        id: '',
        url: '',
        sendNewMessages: false,
      };
      this.editingWebhook = false;
    },
    editWebhook(index) {
      this.webhookForm = { ...this.webhooks[index] };
      this.editingWebhook = true;
      this.showWebhookModal = true;
    },
    submitWebhook() {
      if (this.editingWebhook) {
        const index = this.webhooks.findIndex(w => w.id === this.webhookForm.id);
        if (index !== -1) {
          this.webhooks.splice(index, 1, { ...this.webhookForm });
        }
      } else {
        this.webhooks.push({ ...this.webhookForm });
      }
      this.closeWebhookModal();
    },
    removeWebhook(index) {
      this.webhooks.splice(index, 1);
    },
    async updateInbox() {
      try {
        const payload = {
          id: this.inbox.id,
          formData: false,
          channel: {
            provider_config: {
              ...this.inbox.provider_config,
              api_key: this.apiKey,
              ignore_history_messages: this.ignoreHistoryMessages,
              ignore_group_messages: this.ignoreGroupMessages,
              send_agent_name: this.sendAgentName,
              webhook_send_new_messages: this.webhookSendNewMessages,
              url: this.url,
              ignore_broadcast_statuses: this.ignoreBroadcastStatuses,
              ignore_broadcast_messages: this.ignoreBroadcastMessages,
              ignore_own_messages: this.ignoreOwnMessages,
              ignore_yourself_messages: this.ignoreYourselfMessages,
              send_connection_status: this.sendConnectionStatus,
              notify_failed_messages: this.notifyFailedMessages,
              composing_message: this.composingMessage,
              send_reaction_as_reply: this.sendReactionAsReply,
              send_profile_picture: this.sendProfilePicture,
              use_reject_calls: this.useRejectCalls,
              reject_calls: this.rejectCalls,
              message_calls_webhook: this.messageCallsWebhook,
              webhooks: this.webhooks,
              connect: this.connect,
              disconnect: this.disconnect,
            },
          },
        };
        await this.$store.dispatch('inboxes/updateInbox', payload);
        useAlert(this.$t('INBOX_MGMT.EDIT.API.SUCCESS_MESSAGE'));
      } catch (error) {
        useAlert(this.$t('INBOX_MGMT.EDIT.API.ERROR_MESSAGE'));
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.whatsapp-settings--content {
  ::v-deep input {
    margin-bottom: 0;
  }

  .checkbox {
    margin: 0px 4px;
  }
}

.switch {
  flex: 0 0 auto;
  margin-right: 10px;
}

.switch-label {
  display: flex;
  align-items: center;
}

.webhook-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 16px;
}

.webhook-table th,
.webhook-table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}
</style>
