<script setup>

import { ref } from 'vue'
import ChoiceScreen from './ChoiceScreen.vue'


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
  transform: scaleX(-1);
}


.res-photo-image {
  position: absolute;
  z-index: 10;
  top: 0;
  left: 0;
  width: 100vw;
}
</style>
