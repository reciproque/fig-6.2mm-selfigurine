<script setup>

import { ref } from 'vue'
import ChoiceScreen from './ChoiceScreen.vue'

const uploadToFtp = async () => {
  const res = await fetch("http://localhost:3000/upload", { method: 'POST' });
  const data = await res.json();
  console.log(data);
};
</script>



<template>

  <ChoiceScreen v-model:selectedFig="maFig"></ChoiceScreen>

  <!-- Test // TODO : mettre dans RESScreen ? -->
  <button @click="uploadToFtp">Upload to FTP</button>

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

button {
  position: absolute;
  z-index: 100;
  scale: 2;
  top: 50px;
  left: 100px;
}
</style>
