<template>
    <div class="details-outer">
        <h3>{{sketch.name}}</h3>
        <p>{{sketch.description}}</p>
    </div>
</template>

<script>
export default {
    props: {
        sketch: Object
    }
}
</script>
<style>
.details-outer {

}
</style>
