<template>
  <div class="typebot-integration">
    <h1>Typebot Integration</h1>
    
    <div v-if="loading" class="loading">Loading...</div>
    
    <div v-else>
      <form @submit.prevent="saveSettings">
        <div class="form-group">
          <label for="api_key">API Key</label>
          <input
            type="text"
            id="api_key"
            v-model="settings.api_key"
            placeholder="Enter your Typebot API Key"
            required
          />
        </div>
        
        <div class="form-group">
          <label for="project_id">Project ID</label>
          <input
            type="text"
            id="project_id"
            v-model="settings.project_id"
            placeholder="Enter your Typebot Project ID"
            required
          />
        </div>
        
        <div class="form-group">
          <label for="inbox_ids">Inbox IDs</label>
          <input
            type="text"
            id="inbox_ids"
            v-model="settings.inbox_ids"
            placeholder="Enter the Inbox IDs (comma-separated)"
          />
        </div>
        
        <button type="submit" class="btn btn-primary">Save Settings</button>
      </form>

      <hr />

      <div class="integration-status">
        <h2>Integration Status</h2>
        <p v-if="integrationActive">The Typebot integration is currently <strong>active</strong>.</p>
        <p v-else>The Typebot integration is currently <strong>inactive</strong>.</p>
        <button @click="toggleIntegration" class="btn" :class="integrationActive ? 'btn-danger' : 'btn-success'">
          {{ integrationActive ? 'Deactivate' : 'Activate' }} Integration
        </button>

        <div class="iframe-container" v-if="integrationActive">
          <iframe
            :src="'https://app.typebot.io/editor/' + settings.project_id"
            width="100%"
            height="600px"
            frameborder="0"
          ></iframe>
        </div>
      </div>
    </div>
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
        inbox_ids: '',
      },
      loading: true,
      integrationActive: false,
    };
  },
  methods: {
    async fetchSettings() {
      try {
        const response = await typebotAPI.getSettings();
        this.settings = response.data.settings;
        this.integrationActive = response.data.active;
        this.loading = false;
      } catch (error) {
        console.error('Failed to fetch Typebot settings:', error);
        this.loading = false;
      }
    },
    async saveSettings() {
      try {
        await typebotAPI.saveSettings(this.settings);
        alert('Settings saved successfully.');
      } catch (error) {
        console.error('Failed to save Typebot settings:', error);
        alert('Failed to save settings. Please try again.');
      }
    },
    async toggleIntegration() {
      try {
        if (this.integrationActive) {
          await typebotAPI.deactivate();
        } else {
          await typebotAPI.activate();
        }
        this.integrationActive = !this.integrationActive;
        alert(`Integration ${this.integrationActive ? 'activated' : 'deactivated'} successfully.`);
      } catch (error) {
        console.error('Failed to toggle Typebot integration:', error);
        alert('Failed to toggle integration. Please try again.');
      }
    },
  },
  async created() {
    await this.fetchSettings();
  },
};
</script>

<style scoped>
.typebot-integration {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px;
}

.loading {
  text-align: center;
  font-size: 1.2em;
}

.form-group {
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 5px;
}

.form-group input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

.btn {
  padding: 10px 15px;
  margin-top: 10px;
}

.iframe-container {
  margin-top: 30px;
}

.iframe-container iframe {
  width: 100%;
  height: 600px;
  border: 0;
}
</style>
