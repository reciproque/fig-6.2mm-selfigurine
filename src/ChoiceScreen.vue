<script setup>

import WebcamScreen from './WebcamScreen.vue';
import ResScreen from './ResScreen.vue';
import TimeoutModal from './TimeoutModal.vue'

import { gsap } from 'gsap';
import { ref, onMounted } from 'vue';

import texts from '../assets/interface.json'

import 'vue3-carousel/carousel.css'
import { Carousel, Slide, Pagination, Navigation } from 'vue3-carousel'

const images = Array.from({ length: 4 }, (_, index) => ({
  id: index + 1,
  url: `assets/fig${index + 1}.png`,
}))

const config = {
  height: 1080,
  itemsToShow: 2,
  gap: 50,
  autoplay: 4000,
  wrapAround: true,
  pauseAutoplayOnHover: true
}
const carouselRef = ref()
const currentSlide = ref(1)

const next = () =>{carouselRef.value.next(); clickOnVoile(); gsap.from(document.getElementById("next"), { scale: 0.9, duration: 0.2, ease: "bounce.out" })}
const prev = () => {carouselRef.value.prev(); clickOnVoile(); gsap.from(document.getElementById("prev"), { scale: 0.9, duration: 0.2, ease: "bounce.out" })}

const currentLanguage = ref("FR");

onMounted(() => {

})

function getText(n, lang) {
  const entry = texts[n];
  if (!entry) return '';

  if (lang === "FR") return entry["texte-FR"] || '';
  if (lang === "EN") return entry["texte-EN"] || '';
  if (lang === "DE") return entry["texte-DE"] || '';

  return '';
}

function selectLanguage(lang) {
  currentLanguage.value = lang;
  document.querySelectorAll("span").forEach(element => element.classList.remove("active"));
  document.getElementById(lang).classList.add("active");
  clickOnVoile() ;
}

let selectedFig = 1;

const begin = ref(true)

const showChoice = ref(true);
const showWebcam = ref(false);
const showResult = ref(false);

function select(n) {
  stillHere();
  clickOnVoile() ;
  begin.value = false;
  showWebcam.value = true;
  showChoice.value = false;
  selectedFig = (carouselRef.value.activeSlide+1);
}

function back() {
  stillHere();
  clickOnVoile() ;
  begin.value = true;
  showWebcam.value = false;
  showChoice.value = true;
}

function forward(selectedFig) {
  stillHere();
  clickOnVoile() ;
  begin.value = false;
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
    stillHere();

  } catch (err) {
    console.error('Erreur dans runBatch:', err);
  }
}

const finalImageUrl = ref(null);

function showRes(count) {
  finalImageUrl.value = `backend/final/final_${count}.png`;
}

const isInactive = ref(false);
let TO1 = setTimeout(()=>{isInactive.value=true}, getText(17, currentLanguage.value)*1000);

const showVoile = ref(true);
let TOvoile = setTimeout(()=>{showVoile.value=true}, getText(19, currentLanguage.value)*1000);

function stillHere() {
  isInactive.value = false;
  clearTimeout(TO1);
  TO1 = setTimeout(()=>{isInactive.value=true}, getText(17, currentLanguage.value)*1000);
}

function clickOnVoile() {
  showVoile.value = false;
  clearTimeout(TOvoile);
  TOvoile = setTimeout(()=>{showVoile.value=true}, getText(19, currentLanguage.value)*1000);
}

</script>

<template>
  <TimeoutModal v-if="isInactive & !showChoice" class="modale" 
    @click="stillHere"

    :interface="[getText(15, currentLanguage), getText(16, currentLanguage), getText(20, currentLanguage)]" 
    :timer2="getText(18, currentLanguage)"/>

  <div class="voile" @mousedown="clickOnVoile" v-if="showChoice && showVoile">
    <img src="/assets/main.png" alt="">

  </div>
  <WebcamScreen v-if="showWebcam" class="webcam-screen" @back-to-choice="back" @validation="() => forward(selectedFig)" :interface="[getText(4, currentLanguage), getText(5, currentLanguage), getText(6, currentLanguage)]"></WebcamScreen>
  <ResScreen v-if="showResult" :finalImageUrl="finalImageUrl" class="res-screen" :interface="[getText(7, currentLanguage), getText(8, currentLanguage), getText(9, currentLanguage), getText(10, currentLanguage), getText(11, currentLanguage), getText(12, currentLanguage), getText(13, currentLanguage),getText(14, currentLanguage)]"></ResScreen>
  


  <div v-if="showChoice" class="choice-screen">

    <h1>{{ getText(0, currentLanguage) }}</h1>
    <h2>{{ getText(1, currentLanguage) }}</h2>

    <Carousel ref="carouselRef" v-bind="config" :transition="600" transition-easing="cubic-bezier(0.4, 0, 0.2, 1)">
      <Slide   @click="clickOnVoile" v-for="image in images" :key="image.id">
        <img :src="image.url" @click="select" />
      </Slide>
    </Carousel>

    <div class="nav-arrows">    
      <button @click="prev" id="prev"><img src="/assets/left.png" alt=""></button>
      <button @click="select" class="select-fig">{{ getText(2, currentLanguage) }}</button>
      <button @click="next" id="next"><img src="/assets/right.png" alt=""></button>
    </div>

  </div>

  <div v-if="begin" class="footer" >
      <span id="EN" @click="selectLanguage('EN')">ENGLISH</span> | <span id="FR" @click="selectLanguage('FR')" class="active">FRANÇAIS</span> | <span id="DE"
      @click="selectLanguage('DE')">DEUTSCH</span><br>
      
    <!-- <p>{{ getText(3, currentLanguage) }} </p> -->
    
  </div>

</template>


<style scoped>

body {
    margin: 0;
}

span {
  cursor: pointer;
  padding: 0 10px;
}

.active {
  color: #f5f2f2;
}

p {
  font-size: 12px;
  padding: 0 100px;
  text-align:justify;
  color: #f5f2f2;
}


h1 {
  padding-top: 160px;
  margin: 8px;
}

button {
  cursor: pointer;
  background: none;
  border: none;
  padding: 0 32px;
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
  border-radius: 12px;
  padding: 10px;
}

.grille-choix img {
  width: 300px;
  height: 600px;
  object-fit: cover;
  cursor: pointer;
}

.footer {
  position: absolute;
  bottom: 100px;
  width: 100vw;
  padding: 30px 0px;
  text-align: center;
  z-index: -1;
  color: #ffc759;
  font-size: 25px;
}

.footer span {
  cursor: pointer;
}

.select-fig {
  color: #ffc759;
  background: none;
  border: solid #ffc759 1px;
  font-family: 'Gotham-Book';
  text-transform: uppercase;
  border-radius: 100px;
  font-size: 24px;
  padding: 24px 48px;
}

.carousel {
  --vc-nav-border-radius: 100%;
}

img {
  width: 100%;
  height: 100%;
  object-fit: contain;
}

:root {
  --carousel-transition: 300ms;
  --carousel-opacity-inactive: 0.7;
  --carousel-opacity-active: 1;
  --carousel-opacity-near: 0.9;
  
}

.carousel__slide--sliding {
  transition:
    opacity var(--carousel-transition),
    transform var(--carousel-transition);
}

.carousel.is-dragging .carousel__slide {
  transition:
    opacity var(--carousel-transition),
    transform var(--carousel-transition);
}

.carousel__slide {
  opacity: var(--carousel-opacity-inactive);
  transform: translateX(10px) rotateY(-12deg) scale(0.9);
}

.carousel__slide--prev {
  opacity: var(--carousel-opacity-near);
  transform: rotateY(-10deg) scale(0.80) translateY(100px);
  opacity: 0.5;
  pointer-events: none;

}

.carousel__slide--active {
  opacity: var(--carousel-opacity-active);
  transform: rotateY(0) scale(1);
  cursor: pointer;
}

.carousel__slide--next {
  opacity: var(--carousel-opacity-near);
  transform: rotateY(10deg) scale(0.80) translateY(100px);
  opacity: 0.5;

  pointer-events: none;
}

.carousel__slide--next~.carousel__slide {
  opacity: var(--carousel-opacity-inactive);
  transform: translateX(-10px) rotateY(12deg) scale(0.9);
}

.nav-arrows {
  display: flex;
  align-items: center;
  justify-content: center;
}

.carousel__track {
  align-items: end;
}

.modale {
  z-index: 10000;
  position: absolute;
}


.voile {
  cursor: pointer;
  position: absolute;
  z-index: 100;
  width: 100vw;
  height: 100vh;
  background-color: #0e0e0b9c;
}

.voile img {
  width: 600px;
  position: absolute;
  right: 0px;
  bottom: -700px;
  animation: main 5s infinite;
}

@keyframes main {
  0% {
    transform: scale(1.1);
  }
  50% {
    transform: scale(1);
  }
  100% {
    transform: scale(1.1);
  }
}
</style>
