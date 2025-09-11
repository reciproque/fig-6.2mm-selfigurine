<script setup>

import { ref } from 'vue'
import ChoiceScreen from './ChoiceScreen.vue'
import WebcamScreen from './WebcamScreen.vue'

</script>


<template>

  <ChoiceScreen v-model:selectedFig="maFig"></ChoiceScreen>

</template>

<style>

html {
  overflow: hidden;
}

body {
  margin: 0;
}

#video {
  height: 100vh !important;
  width: auto !important;
}

</style>
