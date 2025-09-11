<template>

  <div>
    <div class="camera-wrapper">

      <div class="video-wrapper">
        <camera :resolution="{ width: 1920*2, height: 1080*2 }" ref="camera" autoplay />
      </div>
      <img src="../assets/prendre-photo.png" alt="" class="web-cam-overlay">
      <button class="take-photo-button" @click="snapshot"></button>
      <button class="back-button" @click="$emit('back-to-choice')"><</button>
    </div>

    <div v-if="snapshotUrl" class="mt-4">
      <img :src="snapshotUrl" alt="Snapshot" class="w-48 border rounded" />
    </div>
  </div>

</template>

<script lang="ts">

import { defineComponent, ref } from "vue";
import Camera from "simple-vue-camera";

export default defineComponent({
  components: { Camera },
  setup() {
    const camera = ref<InstanceType<typeof Camera> | null>(null);
    const snapshotUrl = ref<string | null>(null);

    const snapshot = async () => {
      if (!camera.value) return;

      const blob = await camera.value.snapshot();
      const img = await createImageBitmap(blob);

      const targetWidth = 1080;
      const targetHeight = 1920;

      // TODO : regarder pourquoi semble déformé (fenêtre pas vraiment 1080x1920 ou canvas ?)
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

        const link = document.createElement("a");
        link.href = url;
        link.download = "photo.png";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);

        URL.revokeObjectURL(url);
      }, "image/png");
    };

    return {
      camera,
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

.take-photo-button {
  position: absolute;
  bottom: 8vh;
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
    z-index: 10;
    pointer-events: none;
  }

</style>
