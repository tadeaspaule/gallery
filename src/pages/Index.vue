<template>
    <q-page class="index-outer">
        <div class="side-outer">
            <SketchList :sketches="sketches" :selectedIndex="selected" @selected="selectedSketch"/>
        </div>
        <div id="canvas-container" />
        <div class="side-outer">
            <!-- Add author name and contact -->
            <SketchDetails :sketch="sketches[selected]" />
        </div>
    </q-page>
</template>

<script>
import P5 from 'p5'
import SketchList from 'components/SketchList.vue'
import SketchDetails from 'components/SketchDetails.vue'
export default {
    name: 'PageIndex',
    components: {
        SketchList,
        SketchDetails
    },
    methods: {
        selectedSketch (val) {
            this.selected = val
            this.buildCanvas()
        },
        buildCanvas () {
            // wipe any previous canvas that might've been there
            const container = document.getElementById('canvas-container')
            while (container.firstChild) {
                container.removeChild(container.lastChild)
            }
            // instantiate the new one
            new P5(this.sketches[this.selected].script)
        }
    },
    data () {
        return {
            selected: 0,
            sketches: [
                {
                    name: 'Ball of Ball',
                    script: function (p5) {
                        var x = 50
                        var grow = true
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(30)
                        }
                        p5.draw = _ => {
                            p5.background(0)
                            p5.ellipse(300, 300, x, x)
                            if (grow) x += 1
                            else x -= 1
                            if (x > 200) grow = false
                            if (x < 50) grow = true
                        }
                    }
                },
                {
                    name: 'Divide',
                    script: function (p5) {
                        var x = 50
                        var grow = true
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(30)
                        }
                        p5.draw = _ => {
                            p5.background(0)
                            p5.ellipse(300, 300, x, x)
                            if (grow) x += 1
                            else x -= 1
                            if (x > 200) grow = false
                            if (x < 50) grow = true
                        }
                    }
                },
                {
                    name: 'Serep Trus',
                    script: function (p5) {
                        var step = 20
                        var x = step
                        var y = step
                        var w = 600 - step * 2
                        var r = 0
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(20)
                            p5.background(0)
                            p5.stroke(255)
                            p5.noFill()
                        }
                        p5.draw = _ => {
                            p5.rect(x, y, w, w)
                            // var r = p5.floor(p5.random(4))
                            if (r === 1) x += step
                            else if (r === 2) {
                                x += step
                                y += step
                            } else if (r === 3) y += step
                            r = (r + 1) % 2
                            w -= step
                            if (w <= step) {
                                x = step
                                y = step
                                w = 600 - step * 2
                                p5.background(0)
                            }
                        }
                    }
                }
            ]
        }
    },
    mounted () {
        this.buildCanvas()
    }
}
</script>
<style>
* {
    font-family: 'Roboto Mono', monospace;
}
.index-outer {
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
}
.side-outer {
    width: 300px;
    height: 100%;
}
#canvas-container {
    width: 600px;
    height: 600px;
    background: black;
    margin: 0px 10px;
}
</style>
