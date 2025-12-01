<script setup>

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
  font-family: 'Gotham-Bold';
  src: url('/assets/Gotham-Bold.otf');
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
  background: #0e0e0b;
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

h1, h2 {
  color: #f5f2f2;
  text-align: center;
  text-transform: uppercase;
}

h1 {
  font-family: 'Gotham-Bold';
  font-weight: 700;
  font-size: 72px;
}

h2 {
  margin: 0;
  font-size: 39px;
}
</style>
