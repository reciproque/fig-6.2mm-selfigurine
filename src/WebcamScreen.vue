<template>

  <div>
    <div class="camera-wrapper">

      <div class="video-wrapper">
        <camera :resolution="{ width:4096, height: 2160 }" ref="camera" autoplay />
      </div>
      <img src="../assets/prendre-photo.png" alt="" class="web-cam-overlay">
      <div class="timer">3</div>
      <button class="take-photo-button" @click="takePhoto"></button>
      <button class="back-button" @click="$emit('back-to-choice')">Retour</button>

      <button class="yes-button" @click="$emit('validation')">✅</button>
      <button class="no-button" @click="retakePhoto">X</button>


    </div>

    <div v-if="snapshotUrl" class="mt-4">
      <img :src="snapshotUrl" alt="Snapshot" class="w-48 border rounded" />
    </div>

  </div>

</template>

<script lang="ts">

import { defineComponent, ref } from "vue";
import Camera from "simple-vue-camera";

import ResScreen from "./ResScreen.vue";

export default defineComponent({
  components: { Camera, ResScreen },
  setup() {
    const camera = ref<InstanceType<typeof Camera> | null>(null);
    const snapshotUrl = ref<string | null>(null);
    const showResScreen = ref(false);
    
    const incrementCompteur = async () => {
      try {
        const res = await fetch("http://localhost:3000/compteur/increment", {
          method: "POST",
        });
        const data = await res.json();
        return data.count;
      } catch (err) {
        console.error("Erreur lors de l'incrémentation :", err);
      }
    };
    
    const snapshot = async () => {
      if (!camera.value) return;

      const blob = await camera.value.snapshot();
      const img = await createImageBitmap(blob);

      const targetWidth = 1215;
      const targetHeight = 2160;

      const startX = Math.max(0, (img.width - targetWidth) / 2);
      const startY = Math.max(0, (img.height - targetHeight) / 2);

      const canvas = document.createElement("canvas");
      canvas.width = targetWidth;
      canvas.height = targetHeight;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;

      ctx.translate(canvas.width, 0);
      ctx.scale(-1, 1);

      ctx.drawImage(
        img,
        startX, startY, targetWidth, targetHeight,
        0, 0, targetWidth, targetHeight            
      );

      canvas.toBlob(async (croppedBlob) => {
        if (!croppedBlob) return;
        const url = URL.createObjectURL(croppedBlob);

        const image = document.createElement("img");
        image.className = "res-photo-image";
        image.src = url;
        document.querySelector("html").prepend(image);

        (document.querySelector(".yes-button") as HTMLElement).style.display = "block";
        (document.querySelector(".no-button") as HTMLElement).style.display = "block";

        const count = await incrementCompteur();

        const link = document.createElement("a");
        link.href = url;
        link.download = `photo_${count ?? 'x'}.png`; 
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        URL.revokeObjectURL(url);
      }, "image/png");

    };
    
let n = 3;
let myInterval: ReturnType<typeof setInterval>;

const takePhoto = async () => {
  n = 3;

  (document.querySelector(".take-photo-button") as HTMLElement).style.display = "none";
  (document.querySelector(".back-button") as HTMLElement).style.display = "none";

  const timerEl = document.querySelector(".timer") as HTMLElement;
  timerEl.style.display = "block";
  timerEl.innerHTML = String(n); // Start with "3"

  myInterval = setInterval(decompte, 1000);
};

function decompte() {
  n -= 1;

  const timerEl = document.querySelector(".timer") as HTMLElement;
  timerEl.innerHTML = String(n);

  if (n === 0) {
    clearInterval(myInterval);

    requestAnimationFrame(() => {
      setTimeout(() => {
        snapshot();

        setTimeout(() => {
          timerEl.style.display = "none";
          timerEl.innerHTML = "3";
        }, 300); 
      }, 0); 
    });
  }
}


const retakePhoto = async () => {
  (document.querySelector(".take-photo-button") as HTMLElement).style.display = "block";
  (document.querySelector(".back-button") as HTMLElement).style.display = "block";

  document.querySelector(".res-photo-image")?.remove();

  (document.querySelector(".yes-button") as HTMLElement).style.display = "none";
  (document.querySelector(".no-button") as HTMLElement).style.display = "none";

  const timerEl = document.querySelector(".timer") as HTMLElement;
  timerEl.innerHTML = "3";
  timerEl.style.display = "none";
};



    return {
      camera,
      retakePhoto,
      takePhoto,
      snapshot,
      snapshotUrl,
    };
  },
});


</script>

<style scoped>

.camera-wrapper {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.video-wrapper {
  object-fit: cover;
}

button {
  z-index: 20;
}

.take-photo-button {
  position: absolute;
  bottom: 10vh;
  background-color: white;
  border: solid black 5px;
  box-shadow: 0px 0px 0px 6px white;

  font-size: 2rem;

  border-radius: 50px;
  width: 100px;
  height: 100px;

  cursor: pointer;
}

.back-button {

  position: absolute;
  top: 50px;
  left: 50px;
  background-color: white;
  border: 0;
  box-shadow: 0px 10px 20px -7px #a5a5a5;
  font-size: 2rem;

  border-radius: 20px;
  width: fit-content;
  height: 80px;
  padding: 20px;
  cursor: pointer;
}

.web-cam-overlay {
  position: absolute;
  z-index: 5;
  pointer-events: none;
  }

.timer {
  display: none;
  font-family: sans-serif;
  position: absolute;
  font-size: 15rem;
  color: white;
  top: 5vh;
}

.yes-button {
  display: none;

  position: absolute;
  bottom: 10vh;
  background-color: white;
  border: solid black 5px;
  box-shadow: 0px 0px 0px 6px white;

  font-size: 2rem;

  border-radius: 50px;
  width: 100px;
  height: 100px;

  cursor: pointer;
}

.no-button {
  display: none;

  position: absolute;
  top: 4vh;
  left: 4vw;
  background-color: white;
  border: 0;

  font-size: 2rem;

  border-radius: 20px;
  width: 80px;
  height: 80px;

  cursor: pointer;
}


</style>
