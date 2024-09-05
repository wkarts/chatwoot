<template>
  <div class="typebot-integration">
    <h1>Typebot Integration</h1>
    
    <div v-if="loading" class="loading">Loading...</div>
    
    <div v-else>
      <!-- Formulário para configurar as informações do Typebot -->
      <form @submit.prevent="saveSettings">
        <div class="form-group">
          <label for="api_key">API Key</label>
          <input
            type="text"
            id="api_key"
            v-model="settings.api_key"
            placeholder="Digite sua chave de API do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="project_id">Project ID</label>
          <input
            type="text"
            id="project_id"
            v-model="settings.project_id"
            placeholder="Digite o ID do projeto do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="api_url">API URL</label>
          <input
            type="text"
            id="api_url"
            v-model="settings.api_url"
            placeholder="Digite a URL da API do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="frontend_url">Frontend URL</label>
          <input
            type="text"
            id="frontend_url"
            v-model="settings.frontend_url"
            placeholder="Digite a URL do Frontend do Typebot"
            required
          />
        </div>

        <button type="submit" class="btn btn-primary">Salvar Configurações</button>
      </form>

      <hr />

      <div class="integration-status">
        <h2>Status da Integração</h2>
        <p v-if="integrationActive">A integração do Typebot está <strong>ativa</strong>.</p>
        <p v-else>A integração do Typebot está <strong>inativa</strong>.</p>
        <button @click="toggleIntegration" class="btn" :class="integrationActive ? 'btn-danger' : 'btn-success'">
          {{ integrationActive ? 'Desativar' : 'Ativar' }} Integração
        </button>

        <div class="iframe-container" v-if="integrationActive">
          <iframe
            :src="`${settings.frontend_url}/editor/${settings.project_id}`"
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
        api_url: '',
        frontend_url: '',
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
        console.error('Erro ao buscar configurações do Typebot:', error);
        this.loading = false;
      }
    },
    async saveSettings() {
      try {
        await typebotAPI.saveSettings(this.settings);
        alert('Configurações salvas com sucesso.');
      } catch (error) {
        console.error('Erro ao salvar configurações do Typebot:', error);
        alert('Erro ao salvar as configurações. Tente novamente.');
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
        alert(`Integração ${this.integrationActive ? 'ativada' : 'desativada'} com sucesso.`);
      } catch (error) {
        console.error('Erro ao alternar a integração do Typebot:', error);
        alert('Erro ao alternar a integração. Tente novamente.');
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
