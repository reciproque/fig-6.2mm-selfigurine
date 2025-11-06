<script setup>
import { ref, watch } from 'vue'

// TODO: texts from json!! import.+ getText


const props = defineProps({
    finalImageUrl: {
        type: String,
        default: ''
    }
})

//TODO : add language as prop

const showImage = ref(false)
const path = ref("final/final_1.png")
const timestampRef = ref('')
const canGenerateQRCode =  ref(true);

watch(() => props.finalImageUrl, (newVal) => {
    showImage.value = !!newVal
    path.value = props.finalImageUrl;
    const now = new Date();
    const pad = (n) => n.toString().padStart(2, '0');
    const timestamp = `${now.getFullYear()}${pad(now.getMonth() + 1)}${pad(now.getDate())}-${pad(now.getHours())}${pad(now.getMinutes())}${pad(now.getSeconds())}`;
    timestampRef.value = timestamp;
})

function restart() {
    location.reload();
}

const uploadToFtp = async () => {


    const body = {
        imagePath: path.value,
        imageTimestamp: timestampRef.value
    };

    const res = await fetch("http://localhost:3000/upload", {
        method: 'POST',
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body)
    });


    const data = await res.json();
    canGenerateQRCode.value = false;
};

</script>

<template>
    <div class="res">
        <div v-if="!showImage"><img src="../assets/loader.gif" alt="Chargement..." class="loader" />
        </div>

        <!-- TODO: texts from json!! -->
        <div v-else>
            <img :src="finalImageUrl" alt="Aucun visage n'a été détecté. Veuillez réessayer." class="final-image" />
            <button class="restart-button" @click="restart">Recommencer</button>
            <button class="download-button" @click="uploadToFtp" :disabled='!canGenerateQRCode'><img src="../assets/download-logo.png" alt="">Générer
                un QRCode</button>

            <img v-if="!canGenerateQRCode" :src="'../backend/qrcodes/' + timestampRef + '.png'" alt="" class="qr-code">

        </div>


    </div>
</template>

<style scoped>
.res {
    display: flex;
    height: 1920px;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}

.loader {
    z-index: 20;
    width: 100px;
    height: 100px;
}

.final-image {
    max-width: 1080px;
    max-height: 1920px;
}

.restart-button {
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

.download-button {
    position: absolute;
    top: 50px;
    right: 50px;
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

.download-button:disabled {
    opacity: 0.5;
    cursor:not-allowed;
}
.qr-code {
    position: absolute;
    right: 50px;
    top: 150px;
    background-color: white;
    border-radius: 20px;
    width: 300px;
    box-shadow: 0px 10px 20px -7px #a5a5a5;


}

.download-button img {
    vertical-align: middle;
    width: 50px;
}


</style>