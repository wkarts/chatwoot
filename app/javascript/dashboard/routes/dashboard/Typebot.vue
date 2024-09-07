<template>
  <div class="typebot-integration">
    <h1>{{ $t('TYPEBOT.HEADER') }}</h1>

    <form @submit.prevent="saveSettings">
      <div class="form-group">
        <label for="api_key">{{ $t('TYPEBOT.SETTINGS.API_KEY_LABEL') }}</label>
        <input
          type="text"
          id="api_key"
          v-model="settings.api_key"
          placeholder="Enter your Typebot API Key"
          required
        />
      </div>

      <div class="form-group">
        <label for="project_id">{{ $t('TYPEBOT.SETTINGS.PROJECT_ID_LABEL') }}</label>
        <input
          type="text"
          id="project_id"
          v-model="settings.project_id"
          placeholder="Enter your Typebot Project ID"
          required
        />
      </div>

      <div class="form-group">
        <label for="api_url">{{ $t('TYPEBOT.SETTINGS.API_URL_LABEL') }}</label>
        <input
          type="text"
          id="api_url"
          v-model="settings.api_url"
          placeholder="Enter the API URL"
          required
        />
      </div>

      <div class="form-group">
        <label for="frontend_url">{{ $t('TYPEBOT.SETTINGS.FRONTEND_URL_LABEL') }}</label>
        <input
          type="text"
          id="frontend_url"
          v-model="settings.frontend_url"
          placeholder="Enter the Frontend URL"
          required
        />
      </div>

      <button type="submit" class="btn btn-primary">{{ $t('TYPEBOT.ACTIONS.SAVE_SETTINGS') }}</button>
    </form>
  </div>
</template>

<script>
import typebotAPI from '@/dashboard/api/integrations';

export default {
  name: 'Typebot',
  data() {
    return {
      settings: {
        api_key: '',
        project_id: '',
        api_url: '',
        frontend_url: '',
      },
    };
  },
  methods: {
    async saveSettings() {
      try {
        await typebotAPI.saveSettings(this.settings);
        alert(this.$t('TYPEBOT.NOTIFICATIONS.SAVE_SUCCESS'));
      } catch (error) {
        console.error('Failed to save Typebot settings:', error);
        alert(this.$t('TYPEBOT.NOTIFICATIONS.SAVE_ERROR'));
      }
    },
  },
  async created() {
    const response = await typebotAPI.getSettings();
    this.settings = response.data.settings;
  },
};
</script>

<style scoped>
.typebot-integration {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.form-group {
  margin-bottom: 15px;
}

.btn {
  padding: 10px 15px;
  margin-top: 10px;
}
</style>
