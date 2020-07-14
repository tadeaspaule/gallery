<template>
    <div class="centered-layout">
        <div class="side-outer">
            <div class="sketch-list">
                <div v-for="(sketch,index) in sketches" :key="sketch.name" @click="$emit('selected',index)"
                    class="sketch-entry" :class="{'selected': sketch === selectedSketch}">
                    {{sketch.name}}
                </div>
            </div>
        </div>
        <div id="canvas-container" />
        <div class="side-outer">
            <!-- Add author name and contact -->
            <!-- <div class="details-outer">
                <h3>{{selectedSketch.name}}</h3>
                <p>{{selectedSketch.description}}</p>
            </div> -->
        </div>
    </div>
</template>

<script>
export default {
    props: {
        sketches: Array,
        selectedSketch: Object
    }
}
</script>
<style>
.centered-layout {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
}
.side-outer {
    width: 300px;
    height: 100%;
}
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
