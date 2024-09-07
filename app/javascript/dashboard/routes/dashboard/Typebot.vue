<template>
  <div class="typebot-integration">
    <h1>Integração com Typebot</h1>
    
    <div v-if="loading" class="loading">Carregando...</div>
    
    <div v-else>
      <form @submit.prevent="saveSettings">
        <div class="form-group">
          <label for="api_key">Chave API</label>
          <input
            type="text"
            id="api_key"
            v-model="settings.api_key"
            placeholder="Digite sua chave API do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="project_id">ID do Projeto</label>
          <input
            type="text"
            id="project_id"
            v-model="settings.project_id"
            placeholder="Digite o ID do projeto do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="api_url">URL da API</label>
          <input
            type="text"
            id="api_url"
            v-model="settings.api_url"
            placeholder="Digite a URL da API do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="frontend_url">URL do Frontend</label>
          <input
            type="text"
            id="frontend_url"
            v-model="settings.frontend_url"
            placeholder="Digite a URL do Frontend do Typebot"
            required
          />
        </div>

        <div class="form-group">
          <label for="inboxes">Selecionar Inboxes</label>
          <multiselect
            v-model="settings.inbox_ids"
            :options="inboxes"
            :multiple="true"
            :close-on-select="false"
            placeholder="Selecione as Inboxes"
            label="name"
            track-by="id"
          ></multiselect>
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
import Multiselect from 'vue-multiselect';

export default {
  name: 'Typebot',
  components: { Multiselect },
  data() {
    return {
      settings: {
        api_key: '',
        project_id: '',
        api_url: '',
        frontend_url: '',
        inbox_ids: [], // Caixas de entrada selecionadas
      },
      inboxes: [], // Lista de todas as inboxes disponíveis
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
    async fetchInboxes() {
      try {
        const response = await typebotAPI.fetchInboxes(); // Chamada para buscar as inboxes
        this.inboxes = response.data.inboxes;
      } catch (error) {
        console.error('Erro ao buscar as inboxes:', error);
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
    await this.fetchInboxes(); // Carregar as inboxes disponíveis
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

.form-group input,
.multiselect {
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
