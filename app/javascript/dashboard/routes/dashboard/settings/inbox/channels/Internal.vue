<template>
  <div class="my-2 mx-8 text-base">
    <page-header
      :header-title="$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.TITLE')"
      :header-content="$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.DESC')"
    />
    <form class="mx-0 flex flex-wrap" @submit.prevent="createChannel()">
      <div class="w-1/4">
        <label :class="{ error: v$.channelName.$error }">
          {{ $t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.CHANNEL_NAME.LABEL') }}
          <input
            v-model.trim="channelName"
            type="text"
            :placeholder="$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.CHANNEL_NAME.PLACEHOLDER')"
            @blur="v$.channelName.$touch"
          />
          <span v-if="v$.channelName.$error" class="message">
            {{ $t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.CHANNEL_NAME.ERROR') }}
          </span>
        </label>
      </div>

      <div class="my-4 w-auto">
        <woot-submit-button
          :loading="uiFlags.isCreating"
          :button-text="$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.SUBMIT_BUTTON')"
        />
      </div>
    </form>
  </div>
</template>

<script>
import { mapGetters } from 'vuex';
import { useVuelidate } from '@vuelidate/core';
import { useAlert } from 'dashboard/composables';
import { required } from '@vuelidate/validators';
import router from '../../../../index';
import PageHeader from '../../SettingsSubPageHeader';

export default {
  components: {
    PageHeader,
  },
  setup() {
    const v$ = useVuelidate();
    const { showAlert } = useAlert();
    return { v$, showAlert };
  },
  data() {
    return {
      channelName: '',
    };
  },
  computed: {
    ...mapGetters({
      uiFlags: 'inboxes/getUIFlags',
    }),
  },
  validations: {
    channelName: { required },
  },
  methods: {
    async createChannel() {
      this.v$.$touch();
      if (this.v$.$invalid) {
        return;
      }
      try {
        const internalChannel = await this.$store.dispatch('inboxes/createChannel', {
          name: this.channelName,
          channel: {
            type: 'internal',
          },
        });
        router.replace({
          name: 'settings_inboxes_add_agents',
          params: {
            page: 'new',
            inbox_id: internalChannel.id,
          },
        });
        this.showAlert(this.$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.API.SUCCESS_MESSAGE'));
      } catch (error) {
        this.showAlert(this.$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.API.ERROR_MESSAGE') + '\n detail:' + error);
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.switch {
  flex: 0 0 auto;
  margin-right: 10px;
}
.switch-label {
  display: flex;
  align-items: center;
}
</style>
