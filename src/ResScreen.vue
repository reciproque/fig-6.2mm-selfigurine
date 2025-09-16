<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
    finalImageUrl: {
        type: String,
        default: ''
    }
})

const showImage = ref(false)

watch(() => props.finalImageUrl, (newVal) => {
    showImage.value = !!newVal
})
</script>

<template>
    <div class="res" :style="{ display: showImage ? 'flex' : 'none' }">
        <div v-if="!showImage" class="loader-case"><img src="../assets/loader.gif" alt="Chargement..." class="loader" />
        </div>
        <div v-else class="res-case"><img :src="finalImageUrl" alt="Image finale" class="final-image" /></div>
    </div>
</template>




<style scoped>
.res {
    display: none;
    height: 1920px;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 40px;
}

.loader {
    z-index: 20;
    width: 100px;
    height: 100px;
}

.final-image {
    max-width: 90vw;
    max-height: 90vh;
    object-fit: contain;
    border-radius: 10px;
}
</style>