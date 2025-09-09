<script setup>
import { ref } from 'vue'
import ChoiceScreen from './ChoiceScreen.vue'
import WebcamScreen from './WebcamScreen.vue';

</script>

<template>
  <ChoiceScreen v-model:selectedFig="maFig"></ChoiceScreen>
  <!-- <WebcamScreen></WebcamScreen> -->
</template>

<style>
html {
  overflow: hidden;
}

body {
  width: 1080px;
  height: 1920px;
}

ChoiceScreen {
  position: absolute;
  z-index: 1;
}

WebcamScreen {
  position: absolute;
  z-index: 2;
}
</style>
