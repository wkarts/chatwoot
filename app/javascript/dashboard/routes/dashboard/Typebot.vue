<template>
  <div class="typebot-integration">
    <h1>{{ $t('TYPEBOT.HEADER') }}</h1>
    <iframe
      v-if="settings.frontend_url"
      :src="settings.frontend_url"
      width="100%"
      height="800"
      frameborder="0"
      allowfullscreen
    ></iframe>
  </div>
</template>

<script>
import typebotAPI from '@/dashboard/api/integrations';

export default {
  name: 'Typebot',
  data() {
    return {
      settings: {
        frontend_url: '',  // Apenas a URL do frontend
      },
    };
  },
  async created() {
    const response = await typebotAPI.getSettings();  // Carrega as configurações
    this.settings = response.data.settings;
  },
};
</script>

<style scoped>
.typebot-integration {
  max-width: 100%;
  margin: 0 auto;
  padding: 20px;
}
</style>
