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

function restart() {
    location.reload();
}
</script>

<template>
    <div class="res" :style="{ display: showImage ? 'flex' : 'none' }">
        <div v-if="!showImage" class="loader-case"><img src="../assets/loader.gif" alt="Chargement..." class="loader" />
        </div>
        <div v-else class="res-case"><img :src="finalImageUrl" alt="Aucun visage n'a été détecté. Veuillez réessayer." class="final-image" />
            <button class="restart-button" @click="restart">X</button>
            <button class="download-button" @click="download">Télécharger</button>
            <img src="../assets/sample-qr-code.png" alt="" class="qr-code">


        </div>


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

.restart-button {
    position: absolute;
    top: 4vh;
    left: 4vw;
    background-color: white;
    border: solid black 1px;

    font-size: 2rem;

    border-radius: 20px;
    width: 80px;
    height: 80px;

    cursor: pointer;
}

.download-button {
    position: absolute;
    top: 4vh;
    right: 4vw;
    background-color: white;
    border: solid black 1px;

    font-size: 2rem;

    border-radius: 20px;
    height: 80px;

    cursor: pointer;
}

.qr-code {
    position: absolute;
    top: 10vh;
    right: 4vw;
    background-color: white;
    border: solid black 1px;
    border-radius: 20px;
    width: 200px;

}
</style>