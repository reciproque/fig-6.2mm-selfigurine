<script setup>
const props = defineProps({
  selectedFig: Number
})
const emit = defineEmits(["update:selectedFig"])

function select(n) {
  emit("update:selectedFig", n)
  console.log("Fig choisie :", n)
}
</script>

<template>
  <h1>Choix image</h1>
  <div class="grille-choix">
    <div class="choix" @click="select(1)">
      <img src="/assets/images/figurines/fig1.jpg" alt="">
    </div>
    <div class="choix" @click="select(2)">
      <img src="/assets/images/figurines/fig2.jpg" alt="">
    </div>
    <div class="choix" @click="select(3)">
      <img src="/assets/images/figurines/fig3.jpg" alt="">
    </div>
    <div class="choix" @click="select(4)">
      <img src="/assets/images/figurines/fig4.jpg" alt="">
    </div>
  </div>
</template>


<style scoped>
h1 {
  text-align: center;
}

.grille-choix {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 20px;
  justify-content: center;
  align-items: center;
}

.choix {
  display: flex;
  justify-content: center;
  align-items: center;
  background: #f9f9f9;
  /* petit fond clair pour mieux voir */
  border-radius: 12px;
  padding: 10px;
}

.grille-choix img {
  width: 300px;
  height: 600px;
  /* impose une taille identique */
  object-fit: cover;
  /* rogne et garde le ratio sans déformation */
  cursor: pointer;
}
</style>
