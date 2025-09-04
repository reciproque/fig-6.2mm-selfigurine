<script lang="ts">
import { defineComponent } from "vue";
import { ref } from 'vue';
import Camera from "simple-vue-camera";

export default defineComponent({
    setup() {
        const camera = ref<InstanceType<typeof Camera>>();

        const snapshot = async () => {
            const blob = await camera.value?.snapshot();

            const url = URL.createObjectURL(blob);
        }

        return {
            camera,
            snapshot
        }
    }
});

</script>

<template>
      <div class="camera-wrapper"><camera :resolution="{ width: 1920, height: 1080 }" autoplay>
            <button @click="snapshot">Create snapshot</button>
    </camera></div>

  <h1>Choix image</h1>
  <div class="grille-choix">
    <div class="choix"><img src="/assets/images/figurines/fig1.jpg" alt=""></div>
    <div class="choix"><img src="/assets/images/figurines/fig2.jpg" alt=""></div>
    <div class="choix"><img src="/assets/images/figurines/fig3.jpg" alt=""></div>
    <div class="choix"><img src="/assets/images/figurines/fig4.jpg" alt=""></div>
  </div>
  
</template>

<style scoped>
.camera-wrapper {
  width: 100%;
}

.grille-choix {
  display: grid;
  grid-template-columns: 200px 200px;
  gap: 20px;
}
.grille-choix img {
  width: 200px;
  
  cursor: pointer;
}
.choix {
  padding: 50px;
}
</style>
