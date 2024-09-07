<template>
  <div class="typebot-iframe-container">
    <iframe
      :src="typebotFrontendUrl"
      width="100%"
      height="100%"
      frameborder="0"
      allowfullscreen
    ></iframe>
  </div>
</template>

<script>
export default {
  name: 'Typebot',
  data() {
    return {
      typebotFrontendUrl: '', // URL do frontend Typebot será carregada aqui
    };
  },
  async created() {
    // Buscar as configurações do Typebot, incluindo a URL do frontend
    const response = await this.$api.integrations.getTypebotSettings();
    this.typebotFrontendUrl = response.data.settings.frontend_url;
  },
};
</script>

<style scoped>
.typebot-iframe-container {
  width: 100%;
  height: 100vh; /* Definir a altura total da janela para o iframe */
  overflow: hidden;
}
</style>
