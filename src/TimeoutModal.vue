<script setup>
import { ref, watch, onMounted, onBeforeUnmount } from "vue";
import { gsap } from "gsap";

const props = defineProps({
  interface: Object,
  timer2: [Number, String]
});

let TO2;
let TO2_duration;
let n;
let m = 0;
let IT;

const barreTimer = ref(null);

function areYouStillHere() {
  TO2 = setTimeout(notHere, TO2_duration);
  IT = setInterval(decompte, 25);
}

function decompte() {
  n -= 25;
  m += 25;

  const progress = (m / TO2_duration) * 100;
  if (barreTimer.value) {
    barreTimer.value.style.width = progress + "%";
    if (progress >= 100) clearInterval(IT);
  }
}

function notHere() {
  location.reload();
}

watch(
  () => props.timer2,
  (newVal) => {
    if (newVal) {
      TO2_duration = newVal*1000;
      n = TO2_duration;
      m = 0;

      if (barreTimer.value) barreTimer.value.style.width = "0%";
      IT = setInterval(decompte, 25);
      TO2 = setTimeout(notHere, TO2_duration);
    }
  }
);

onMounted(() => {
    gsap.from(document.querySelector(".timeout-container"), {opacity:0, duration:1})
      TO2_duration = props.timer2*1000;
      n = TO2_duration;
      m = 0;

      if (barreTimer.value) barreTimer.value.style.width = "0%";
      IT = setInterval(decompte, 25);
      TO2 = setTimeout(notHere, TO2_duration);
});

onBeforeUnmount(() => {
  clearTimeout(TO2);
  clearInterval(IT);

});
</script>


<template>

    <div class="timeout-container" v-if="timer2">
        <div class="timeout">
            <h2>{{ interface[0] }} </h2></br>
            <div class="barre-timer">
                <div class="barre-timer-plein" ref="barreTimer"></div><br>
            </div>

            <button id="close-inactivity"> {{ interface[1] }}</button>

            <span class="version">{{ interface[2] }}</span>

        </div>

    </div>

</template>

<style scoped>



.version {
  position: absolute;
  bottom: 0;
  right: 0;
  font-size: 9px;
  padding: 20px;
  color: #d0d0d0;
}

.timeout-container {
    background-color: #000000af;
    position: absolute;
    z-index: 10000;
    width: 1080px;
    height: 1920px;
    display: flex;
    justify-content: center;
    align-items: center;
}

.timeout {
    position: absolute;
    z-index: 100;
    background-color: #FBF9F5;
    border-radius: 40px;
    font-size: 30px;
    display: flex;
    flex-direction: column;
    font-family: "Gotham-Book";
    text-transform: uppercase;
    gap: 80px;
    padding: 120px 120px 80px 120px;
    color: #0E0E0B;
}

.timeout h2 {
  color: #0E0E0B;
}


.timeout button {
    font-family: "Gotham-Black";
    background-color: transparent;
    border: none;
    cursor: pointer;
    font-size: 24px;
    border-radius: 40px;
    color: #FBF9F5;
    text-transform: uppercase;
    background-color: #0E0E0B;;
    padding: 30px;
}


.barre-timer {
    height: 20px;
    background: #DFDFDF;
    border-radius: 40px;
}


.barre-timer-plein {
    width: 0%;
    height: 20px;
    background: #121212;
    border-radius: 40px;
}
</style>
