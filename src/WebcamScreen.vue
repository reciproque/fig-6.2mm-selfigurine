<template>

  <div>
    <div class="camera-wrapper">

      <div class="video-wrapper">
        <camera :resolution="{ width:4096, height: 2160 }" ref="camera" autoplay />
      </div>
      <img src="../assets/ellipse.png" alt="" class="web-cam-overlay">
      <div class="timer">3</div>
      <button class="take-photo-button" @click="takePhoto"><img src="/assets/shoot.png" alt=""></button>
      <button class="back-button" @click="$emit('back-to-choice')"><img src="/assets/close.png" alt="">{{ interface[0] }}</button>

      <button class="yes-button" @click="$emit('validation')">{{ interface[1] }}</button>
      <button class="no-button" @click="retakePhoto"><img src="/assets/replay.png" alt="">{{ interface[2] }}</button>
      
      <div v-if="clic" class="shutter inverted"></div>


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
  props: {
    interface: {
      type: Object,
      required: false
    }
  },
  setup() {
    const camera = ref<InstanceType<typeof Camera> | null>(null);
    const snapshotUrl = ref<string | null>(null);
    const clic = ref(false)
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

        (document.querySelector(".yes-button") as HTMLElement).style.display = "flex";
        (document.querySelector(".no-button") as HTMLElement).style.display = "flex";

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
  timerEl.style.display = "flex";
  timerEl.innerHTML = String(n); // Start with "3"

  myInterval = setInterval(decompte, 1000);
};

function decompte() {
  n -= 1;

  const timerEl = document.querySelector(".timer") as HTMLElement;
  timerEl.innerHTML = String(n);

  if (n === 0) {
    clearInterval(myInterval);
    clic.value = true;

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
  (document.querySelector(".take-photo-button") as HTMLElement).style.display = "flex";
  (document.querySelector(".back-button") as HTMLElement).style.display = "flex";

  document.querySelector(".res-photo-image")?.remove();

  clic.value = false;

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
      clic
    };
  },
});


</script>

<style scoped>

.shutter {
  width: 100vw;
  height: 100vh;
  background: #0e0e0e;
  position: absolute;
  z-index: 1000;
  mask-image:
    url("assets/circle.svg"),
    linear-gradient(#000 0 0);
  mask-repeat: no-repeat, no-repeat;
  mask-position: center, center;
  mask-size: 10000px, 100%;
  mask-composite: exclude;
  -webkit-mask-composite: xor;
  pointer-events: none;
}

.shutter.inverted {
  animation: shutter-anim 1s;
}

@keyframes shutter-anim {
  0% {
    mask-size: 10000px, 100%;
  }
  40% {
    mask-size: 0px, 100%;
  }
  60% {
    mask-size: 0px, 100%;
  }
  100% {
    mask-size: 10000px, 100%;
  }
}


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
  bottom: 280px;
  background: none;
  border: none;
  cursor: pointer;
}

.back-button {
  position: absolute;
  bottom: 80px;
  border: 0;
  border-radius: 100px;

  cursor: pointer;

  width: fit-content;
  height: 56px;

  padding: 24px 32px 24px 24px ;

  color: #ffc759;
  text-transform: uppercase;
  border: solid 1px #ffc759;
  background-color: #0e0e0b;

  display: flex;
  justify-content: center;
  align-items: center;

  font-size: 18px;
}

.back-button img {
  height: 18px;
  vertical-align: middle;
  margin-right: 12px;
}

.web-cam-overlay {
  width: 800px;
  position: absolute;
  z-index: 5;
  pointer-events: none;
  top: 380px;
  }

.timer {
  font-family: sans-serif;
  position: absolute;
  font-size: 68px;
  color: white;
  bottom: 280px;
  display: block;
  z-index: 2000;
  background-color: #f5f2f2;
  width: 100px;
  height: 100px;
  border-radius: 100px;
  text-align: center;
  padding: 10px;
  color: #0e0e0b;
  display: none;
  justify-content: center;
  align-items: center;

}

.yes-button {
  display: none;
  position: absolute;
  bottom: 280px;
  border: 0;
  border-radius: 100px;

  cursor: pointer;

  width: fit-content;
  height: 56px;

  padding: 24px 32px 24px 24px ;

  color: #0e0e0b;
  text-transform: uppercase;
  border: solid 1px #ffc759;
  background-color: #ffc759;

  justify-content: center;
  align-items: center;

  font-size: 18px;

  transform: scale(1.5);
}

.no-button {
  position: absolute;
  bottom: 80px;
  border: 0;
  border-radius: 100px;

  cursor: pointer;

  width: fit-content;
  height: 56px;

  padding: 24px 32px 24px 24px ;

  color: #ffc759;
  text-transform: uppercase;
  border: solid 1px #ffc759;
  background-color: #0e0e0b;

  display: none;
  justify-content: center;
  align-items: center;

  font-size: 18px;
}

.no-button img {
  height: 18px;
  vertical-align: middle;
  margin-right: 12px;
}


</style>
