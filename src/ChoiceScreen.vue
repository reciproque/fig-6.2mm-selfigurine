<script setup>

import WebcamScreen from './WebcamScreen.vue';
import ResScreen from './ResScreen.vue';
import { gsap } from 'gsap';
import { ref } from 'vue';
import Footer from './Footer.vue'

let selectedFig = 1;

const begin = ref(true)

const showChoice = ref(true);
const showWebcam = ref(false);
const showResult = ref(false);

function select(n) {
  begin.value = false;

  showWebcam.value = true;
  showChoice.value = false;
  selectedFig = n;
}

function back() {
  begin.value  = true;
  showWebcam.value = false;
  showChoice.value = true;
}

function forward(selectedFig) {
  begin.value  = false;
  showWebcam.value = false;
  showResult.value = true;

  document.querySelector(".res-photo-image").remove();

  runBatch(selectedFig);

}

async function runBatch(selectedFig) {
  try {
    const res = await fetch('http://localhost:3000/compteur/increment', {
      method: 'POST',
    });
    const data = await res.json();
    const count = data.count - 1;
    const source_path = `photos/photo_${count}.png`;
    const output_path = `figurines/fig${selectedFig}.png`;
    const final_path = `final/final_${count}.png`;

    const body = { source: source_path, output: output_path, final: final_path };
    console.log(body);

    const runRes = await fetch('http://localhost:3000/run', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });

    const text = await runRes.text().then(() => showRes(count));
    console.log('Batch exécuté :', text);

  } catch (err) {
    console.error('Erreur dans runBatch:', err);
  }
}

const finalImageUrl = ref(null);

function showRes(count) {
  finalImageUrl.value = `backend/final/final_${count}.png`;
}

</script>

<template>

  <WebcamScreen v-if="showWebcam" class="webcam-screen" @back-to-choice="back" @validation="() => forward(selectedFig)"></WebcamScreen>
  <ResScreen v-if="showResult" :finalImageUrl="finalImageUrl" class="res-screen"></ResScreen>

  <div v-if = "showChoice" class="choice-screen">
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
    <p>Paragraphe explicatif sur l'utilisation de l'IA et le droit à l'image. <br></br>Musée Figurine de Compiègne</p>
  </div>

  <Footer v-if="begin"></Footer>

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

</style>
