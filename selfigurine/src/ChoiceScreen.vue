<script setup>

import WebcamScreen from './WebcamScreen.vue';
import ResScreen from './ResScreen.vue';
import { gsap } from 'gsap';

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

  //gsap.from(webcamScreen, {x:300, opacity:0, duration:1})
}

function back() {
  let webcamScreen = document.querySelector(".webcam-screen");
  let choiceScreen = document.querySelector(".choice-screen");
  webcamScreen.style.display = "none";
  choiceScreen.style.display = "block";
  
  // gsap.from(choiceScreen, {x:-300, opacity:0, duration:1})

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
  <p>Paragraphe explicatif sur l'utilisation de l'IA et le droit à l'image. <br></br>Musée Figurine de Compiègne</p>

</template>


<style scoped>

h1 {
  text-align: center;
}

p {
  padding: 100px;
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
