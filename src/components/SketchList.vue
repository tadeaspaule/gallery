<template>
    <div class="sketch-list">
        <div v-for="(sketch,index) in sketches" :key="sketch.name" @click="$emit('selected',index)"
            class="sketch-entry" :class="{'selected': index === selectedIndex}">
            {{sketch.name}}
        </div>
    </div>
</template>

<script>
export default {
    props: {
        sketches: Array,
        selectedIndex: Number
    }
}
</script>
<style>
.sketch-list {
    padding: 5px 10px;
    text-align: right;
}
.sketch-entry {
    opacity: 0.7;
    cursor: pointer;
    padding: 4px 0px;
    font-size: 20px;
}
.selected {
    opacity: 1;
}
</style>
