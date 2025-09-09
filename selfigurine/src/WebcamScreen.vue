<template>
  <div>
    <div class="camera-wrapper">
      <camera :resolution="{ width: 3840, height: 1920 }" ref="camera" autoplay />
    </div>
    <button class="take-photo-button" @click="snapshot"></button>

    <!-- Show captured snapshot -->
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

      // Desired crop size
      const targetWidth = 1080;
      const targetHeight = 1920;

      // Calculate centered crop rectangle
      const startX = Math.max(0, (img.width - targetWidth) / 2);
      const startY = Math.max(0, (img.height - targetHeight) / 2);

      // Create a canvas for cropping
      const canvas = document.createElement("canvas");
      canvas.width = targetWidth;
      canvas.height = targetHeight;
      const ctx = canvas.getContext("2d");
      if (!ctx) return;

      ctx.drawImage(
        img,
        startX, startY, targetWidth, targetHeight, // source (crop area)
        0, 0, targetWidth, targetHeight            // destination
      );

      // Convert canvas back to blob
      canvas.toBlob((croppedBlob) => {
        if (!croppedBlob) return;
        const url = URL.createObjectURL(croppedBlob);

        // Trigger download
        const link = document.createElement("a");
        link.href = url;
        link.download = "snapshot-cropped.png";
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
  scale: 4.8;
}

.take-photo-button {
  position: absolute;
  z-index: 10;
  background-color: white;
  border: solid black 5px;
  box-shadow: 0px 0px 0px 6px white;

  font-size: 2rem;
  bottom: 50px;
  left: 490px;
  border-radius: 50px;
  width: 100px;
  height: 100px;
}
</style>
