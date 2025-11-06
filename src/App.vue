<script setup>

import { ref } from 'vue'
import ChoiceScreen from './ChoiceScreen.vue'


</script>



<template>

  <ChoiceScreen v-model:selectedFig="maFig"></ChoiceScreen>

</template>

<style>

@font-face {
  font-family: 'Gotham-Book';
  src: url('/assets/Gotham-Book.otf');
}

@font-face {
  font-family: 'Gotham-Black';
  src: url('/assets/Gotham-Black.otf');
}

html {
  font-family: 'Gotham-Book';
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

button {
    font-family: 'Gotham-Book';

}

</style>
