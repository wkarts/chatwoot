<template>
  <div class="typebot-integration">
    <h1>{{ $t('typebot.name') }}</h1>
    <iframe v-if="settings.frontend_url" :src="settings.frontend_url" class="typebot-iframe"></iframe>
  </div>
</template>

<script>
import typebotAPI from '@/dashboard/api/integrations';

export default {
  name: 'Typebot',
  data() {
    return {
      settings: {
        frontend_url: '',
      },
    };
  },
  async created() {
    const response = await typebotAPI.getSettings();
    this.settings = response.data;
  },
};
</script>

<style scoped>
.typebot-integration {
  max-width: 100%;
  height: 100%;
}
.typebot-iframe {
  width: 100%;
  height: 600px;
  border: none;
}
</style>
