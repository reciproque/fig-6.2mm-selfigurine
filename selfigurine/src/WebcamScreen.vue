<template>

  <div>
    <div class="camera-wrapper">

      <div class="video-wrapper">
        <camera :resolution="{ width: 1920*2, height: 1080*2 }" ref="camera" autoplay />
      </div>
      <img src="../assets/prendre-photo.png" alt="" class="web-cam-overlay">
      <div class="timer">3</div>
      <button class="take-photo-button" @click="takePhoto"></button>
      <button class="back-button" @click="$emit('back-to-choice')"><</button>

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
    
    const snapshot = async () => {
      if (!camera.value) return;

      const blob = await camera.value.snapshot();
      const img = await createImageBitmap(blob);

      const targetWidth = 1080;
      const targetHeight = 1920;

      const startX = Math.max(0, (img.width - targetWidth) / 2);
      const startY = Math.max(0, (img.height - targetHeight) / 2);

      const canvas = document.createElement("canvas");
      canvas.width = targetWidth;
      canvas.height = targetHeight;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;

      ctx.drawImage(
        img,
        startX, startY, targetWidth, targetHeight,
        0, 0, targetWidth, targetHeight            
      );

      canvas.toBlob((croppedBlob) => {
        if (!croppedBlob) return;
        const url = URL.createObjectURL(croppedBlob);
        console.log(url);
        const image = document.createElement("img");
        image.className = "res-photo-image";
        image.src =  url;
        document.querySelector("html").prepend(image);

        document.querySelector(".yes-button").style.display = "block";
        document.querySelector(".no-button").style.display = "block";

        const link = document.createElement("a");
        link.href = url;
        link.download = "photo.png";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        URL.revokeObjectURL(url);
      }, "image/png");

      document.querySelector(".timer").style.display = "none";
      // document.querySelector(".take-photo-button").style.display = "block";
      // document.querySelector(".back-button").style.display = "block";

    };
    
    let n = 3;
    let myInterval = setInterval(decompte, 1000);
    clearInterval(myInterval);


    const takePhoto = async()=> {
      document.querySelector(".take-photo-button").style.display = "none";
      document.querySelector(".back-button").style.display = "none";

      console.log("takephoto");
      document.querySelector(".timer").style.display = "block";
      setTimeout(snapshot, 3000);
      myInterval = setInterval(decompte, 1000);

    }

    const retakePhoto = async()=> {
      document.querySelector(".take-photo-button").style.display = "block";
      document.querySelector(".back-button").style.display = "block";
      document.querySelector(".res-photo-image").remove();

      document.querySelector(".yes-button").style.display = "none";
      document.querySelector(".no-button").style.display = "none";
    }


    function decompte() {
      if (n == 0) {
        n = 3;
        document.querySelector(".timer").innerHTML = String(3);
        clearInterval(myInterval);
        return
      }
        n -= 1;
        document.querySelector(".timer").innerHTML = String(n);
    }


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
