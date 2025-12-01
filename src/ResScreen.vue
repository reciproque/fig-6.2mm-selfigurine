<script setup>
import { ref, watch } from 'vue'

const props = defineProps({
    finalImageUrl: {
        type: String,
        default: ''
    },
    interface: {
        type: Object
    }
})

const showImage = ref(false)
const path = ref("final/final_1.png")
const timestampRef = ref('')
const canGenerateQRCode = ref(true);

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
        <div class="loading-screen" v-if="!showImage">
            <h3>{{ interface[0] }}</h3>
            <h3>{{ interface[1] }}</h3>
            <div class="loading-shape"></div>
        </div>

        <div class="res-final" v-else>
            <img :src="finalImageUrl" :alt="interface[2]" class="final-image" />
            <button class="download-button" @click="uploadToFtp" :disabled='!canGenerateQRCode'>{{ canGenerateQRCode ? interface[3] :  interface[4] }} <img
                    src="../assets/download.png" alt=""></button>
            <button class="restart-button" @click="restart"><img src="/assets/close.png"
                    alt="">{{ interface[4] }}</button>

            <div v-if="!canGenerateQRCode" class="qr-wrapper">
                <span>{{ interface[5] }}</span>
                <img :src="'../backend/qrcodes/' + timestampRef + '.png'" alt=""
                    class="qr-code">
            </div>



        </div>


    </div>
</template>

<style scoped>
h3 {
    font-family: 'Gotham-Book';
    font-weight: 400;
    color: #fff;
    text-align: center;
    text-transform: uppercase;
}

.res {
    display: flex;
    height: 1920px;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}


.loading-screen {
    display: flex;
    justify-content: center;
    align-items: center;
    flex-direction: column;
}

.loading-shape {
    position: absolute;
    bottom: -20vh;
    width: 1341.2px;
    height: 942px;
    background-image: url('/assets/SHAPE.png');
    animation: defilement 20s infinite linear;
    background-repeat: repeat-x;
}

@keyframes defilement {
    0% {
        opacity: 1;
        background-position: 1380px 0;
    }

    50% {
        opacity: 0.2;
    }


    100% {
        opacity: 1;

        background-position: 0px 0;
    }

}

.loader {
    z-index: 20;
    width: 100px;
    height: 100px;
}

.final-image {
    max-width: 800px;
    max-height: 1720px;
    margin-bottom: 260px;
    border-radius: 24px;

}

.res-final {
    display: flex;
    justify-content: center;
    align-items: center;
}

.restart-button {
    position: absolute;
    bottom: 80px;
    border: 0;
    border-radius: 100px;

    cursor: pointer;

    width: fit-content;
    height: 56px;

    padding: 24px 32px 24px 24px;

    color: #ffc759;
    text-transform: uppercase;
    border: solid 1px #ffc759;
    background-color: #0e0e0b;

    display: flex;
    justify-content: center;
    align-items: center;

    font-size: 18px;
}

.download-button {
    position: absolute;
    bottom: 240px;
    border: 0;
    border-radius: 100px;

    cursor: pointer;

    width: fit-content;
    height: 56px;

    padding: 24px 32px 24px 24px;

    color: #0e0e0b;
    text-transform: uppercase;
    border: solid 1px #ffc759;
    background-color: #ffc759;

    display: flex;
    justify-content: center;
    align-items: center;

    font-size: 18px;

    transform: scale(1.5);

}

.back-button img {
    height: 18px;
    vertical-align: middle;
    margin-right: 12px;
}

.download-button img {
    max-width: 20px;
    margin-left: 15px;
    vertical-align: middle;
}

.download-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.qr-code {
    width: 160px;
}

.download-button img {
    vertical-align: middle;
    width: 50px;
}

.qr-wrapper {
    position: absolute;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    background-color: #ffc759;
    width: 640px;
    border-radius: 0  0  24px 24px;
    padding: 40px 80px;
    bottom: 205px;
    gap: 25px;

}

.qr-wrapper span {
    vertical-align: middle;
    font-size: 26px;
    width: 440px;

}
</style>