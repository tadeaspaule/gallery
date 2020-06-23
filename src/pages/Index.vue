<template>
    <q-page class="index-outer">
        <CenteredLayout v-if="style === 'centered'"
            :selectedSketch="sketches[selected]" :sketches="sketches" @selected="selectedSketch" />
    </q-page>
</template>

<script>
import P5 from 'p5'
import CenteredLayout from '../gallery-layouts/CenteredLayout.vue'
export default {
    name: 'PageIndex',
    components: {
        CenteredLayout
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
            style: 'centered',
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
                        var bars = []
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(20)
                            p5.noStroke()
                        }
                        p5.draw = _ => {
                            p5.background(0)
                            var x = 0
                            var y = 0
                            var goingRight = true
                            var reachedTop = false
                            bars.forEach(b => {
                                p5.fill(b.r, b.g, b.b)
                                y += b.h
                                if (y > 700) reachedTop = true
                                p5.rect(goingRight ? x : x - b.w, 600 - y, b.w, y)
                                if (goingRight) x += b.w
                                else x -= b.w
                                if (x > 600 || x < 0) goingRight = !goingRight
                            })
                            if (reachedTop) {
                                bars = []
                                p5.background(0)
                            }
                            bars.push({
                                h: p5.random(5, 40),
                                w: p5.random(20, 60),
                                r: p5.random(255),
                                g: p5.random(255),
                                b: p5.random(255)
                            })
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
                },
                {
                    name: 'Orbit Orbit',
                    script: function (p5) {
                        var n = 6
                        var planets = []
                        var moons = []
                        p5.move = (x) => {
                            x.x = x.orbitAround.x + x.r * p5.cos(x.rads)
                            x.y = x.orbitAround.y + x.r * p5.sin(x.rads)
                            x.rads += x.orbitSpeed
                            if (x.rads > 6.3) x.rads -= p5.PI * 2
                        }
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(20)
                            p5.background(0)
                            p5.stroke(255)
                            p5.noFill()
                            for (var i = 0; i < n; i++) {
                                var p = {
                                    x: 0,
                                    y: 0,
                                    orbitSpeed: p5.random(0.03, 0.2),
                                    r: p5.random(30, 250),
                                    rads: p5.random(0, 6.28),
                                    orbitAround: { x: 300, y: 300 }
                                }
                                var m = {
                                    x: 0,
                                    y: 0,
                                    orbitSpeed: p5.random(0.03, 0.2),
                                    r: p5.random(10, 45),
                                    rads: p5.random(0, 6.28),
                                    orbitAround: p
                                }
                                p5.move(p)
                                p5.move(m)
                                planets.push(p)
                                moons.push(m)
                            }
                        }
                        p5.draw = _ => {
                            p5.background(0)
                            planets.forEach(p => p5.move(p))
                            moons.forEach(m => {
                                var d = p5.dist(300, 300, m.x, m.y)
                                p5.ellipse(300, 300, d * 2, d * 2)
                                p5.move(m)
                            })
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
#canvas-container {
    width: 600px;
    height: 600px;
    background: black;
    margin: 0px 10px;
}
.index-outer {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;
}
</style>
