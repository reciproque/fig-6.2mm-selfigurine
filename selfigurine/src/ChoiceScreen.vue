<script setup>

import WebcamScreen from './WebcamScreen.vue';
// import { gsap } from 'gsap';

const props = defineProps({
  selectedFig: Number
})

const emit = defineEmits(["update:selectedFig"])


function select(n) {
  emit("update:selectedFig", n)
  console.log("Fig choisie :", n)
  let webcamScreen = document.querySelector(".webcam-screen");
  let choiceScreen = document.querySelector(".choice-screen");
  webcamScreen.style.display = "block";
  choiceScreen.style.display = "none";
}

function back() {
  let webcamScreen = document.querySelector(".webcam-screen");
  let choiceScreen = document.querySelector(".choice-screen");
  webcamScreen.style.display = "none";
  choiceScreen.style.display = "block";
}

</script>

<template>

  <WebcamScreen class="webcam-screen" @back-to-choice="back"></WebcamScreen>

  <div class="choice-screen">
    <h1>Choix image</h1>
    <div class="grille-choix">
      <div class="choix" @click="select(1)">
        <img src="/assets/images/figurines/fig1.jpg" alt="">
      </div>
      <div class="choix" @click="select(2)">
        <img src="/assets/images/figurines/fig2.jpg" alt="">
      </div>
      <div class="choix" @click="select(3)">
        <img src="/assets/images/figurines/fig3.jpg" alt="">
      </div>
      <div class="choix" @click="select(4)">
        <img src="/assets/images/figurines/fig4.jpg" alt="">
      </div>
    </div>
  </div>

</template>


<style scoped>

h1 {
  text-align: center;
}

.grille-choix {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  justify-content: center;
  align-items: center;
}

.choix {
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f9f9f9;
  border-radius: 12px;
  padding: 10px;
}

.grille-choix img {
  width: 300px;
  height: 600px;
  object-fit: cover;
  cursor: pointer;
}

.webcam-screen {
  display: none;
}

</style>
