<script setup>

import WebcamScreen from './WebcamScreen.vue';
import ResScreen from './ResScreen.vue';
import { gsap } from 'gsap';

// const props = defineProps({
//   selectedFig: Number
// })

// const emit = defineEmits(["update:selectedFig"])

let selectedFig = 1;

function select(n) {
  // emit("update:selectedFig", n)

  selectedFig = n;

  let webcamScreen = document.querySelector(".webcam-screen");
  let choiceScreen = document.querySelector(".choice-screen");
  webcamScreen.style.display = "block";
  choiceScreen.style.display = "none";
  //gsap.from(webcamScreen, {x:300, opacity:0, duration:1})

  console.log(selectedFig);
}

function back() {
  let webcamScreen = document.querySelector(".webcam-screen");
  let choiceScreen = document.querySelector(".choice-screen");
  webcamScreen.style.display = "none";
  choiceScreen.style.display = "block";
  
  // gsap.from(choiceScreen, {x:-300, opacity:0, duration:1})

}

function forward(selectedFig) {
  let webcamScreen = document.querySelector(".webcam-screen");
  let resScreen = document.querySelector(".res-screen");
  webcamScreen.style.display = "none";
  resScreen.style.display = "flex";
  document.querySelector(".res-photo-image").remove();

  runBatch(selectedFig);

}

async function runBatch(selectedFig) {
  try {
    const res = await fetch('http://localhost:3000/compteur/increment', {
      method: 'POST',
    });
    const data = await res.json();
    const count = data.count -1;

    const source_path = `../backend/photos/photo_${count}.png`;
    const output_path = `../backend/figurines/fig${selectedFig}.png`;
    const mask_path = `../backend/figurines/fig${selectedFig}-mask.png`;
    const harmonized_path = `../backend/harmonized/harmonized_${count}.png`;
    const final_path = `../backend/final/final_${count}.png`;

    const body = {source: source_path, output: output_path, mask: mask_path, harmonized: harmonized_path, final: final_path };
    console.log(body);
    const runRes = await fetch('http://localhost:3000/run', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });

    const text = await runRes.text();
    console.log('Batch exécuté :', text);

  } catch (err) {
    console.error('Erreur dans runBatch:', err);
  }
}

</script>

<template>

  <WebcamScreen class="webcam-screen" @back-to-choice="back" @validation="() => forward(selectedFig)"></WebcamScreen>
  <ResScreen class="res-screen"></ResScreen>

  <div class="choice-screen">
    <h1>Choix image</h1>
    <div class="grille-choix">
      <div class="choix" @click="select(1)">
        <img src="/assets/fig1.png" alt="">
      </div>
      <div class="choix" @click="select(2)">
        <img src="/assets/fig2.png" alt="">
      </div>
      <div class="choix" @click="select(3)">
        <img src="/assets/fig3.png" alt="">
      </div>
      <div class="choix" @click="select(4)">
        <img src="/assets/fig4.png" alt="">
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
