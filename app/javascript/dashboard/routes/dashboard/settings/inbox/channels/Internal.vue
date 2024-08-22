<template>
  <div class="border border-slate-25 dark:border-slate-800/60 bg-white dark:bg-slate-900 h-full p-6 w-full max-w-full md:w-3/4 md:max-w-[75%] flex-shrink-0 flex-grow-0">
    <page-header
      :header-title="$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.TITLE')"
      :header-content="$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.DESC')"
    />
    <form class="flex flex-col" @submit.prevent="createChannel()">
      <div class="w-[65%] flex-shrink-0 flex-grow-0 max-w-[65%]">
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

      <div class="w-full" style="margin-top: 20px;">
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
    return { v$: useVuelidate() };
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
        useAlert(this.$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.API.SUCCESS_MESSAGE'));
      } catch (error) {
        useAlert(this.$t('INBOX_MGMT.ADD.INTERNAL_CHANNEL.API.ERROR_MESSAGE') + '\n detail:' + error);
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
