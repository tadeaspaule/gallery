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
                    name: 'Wormhole',
                    script: function (p5) {
                        var n = 20
                        var r = 160
                        var cx = 300
                        var cy = 300
                        var c2x = 350
                        var c2y = 350
                        var col = [255, 0, 0]
                        var col2 = [0, 0, 255]
                        var padding = 160
                        var i = 0

                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.background(0)
                            p5.noStroke()
                            p5.fill(255)
                            p5.frameRate(20)
                        }
                        p5.movecenter = _ => {
                            if (cx === c2x) c2x = p5.floor(p5.random(padding, 600 - padding))
                            else if (cx > c2x) cx--
                            else cx++
                            if (cy === c2y) c2y = p5.floor(p5.random(padding, 600 - padding))
                            else if (cy > c2y) cy--
                            else cy++
                        }
                        p5.changefill = _ => {
                            for (var j = 0; j < 3; j++) {
                                if (col[j] === col2[j]) col2[j] = p5.floor(p5.random(256))
                                else if (col[j] > col2[j]) col[j]--
                                else col[j]++
                            }
                        }
                        p5.draw = _ => {
                            var rads1 = (p5.PI * 2) * (i / n)
                            var rads2 = (p5.PI * 2) * ((i + 1) / n)
                            var p1x = cx + r * p5.cos(rads1)
                            var p1y = cy + r * p5.sin(rads1)
                            var p2x = cx + r * p5.cos(rads2)
                            var p2y = cy + r * p5.sin(rads2)
                            var p3x = cx + r * 1.2 * p5.cos((rads1 + rads2) / 2)
                            var p3y = cy + r * 1.2 * p5.sin((rads1 + rads2) / 2)
                            p5.fill(col[0], col[1], col[2])
                            p5.triangle(p1x, p1y, p2x, p2y, p3x, p3y)
                            i = (i + 1) % n
                            p5.movecenter()
                            p5.changefill()
                        }
                    }
                },
                {
                    name: 'Grid',
                    script: function (p5) {
                        var n = 10
                        var points = []
                        var spds = []
                        var growing = []
                        var minw = 10
                        var gap = 50
                        var space = 0

                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.stroke(255, 0, 0)
                            p5.strokeWeight(5)
                            p5.frameRate(30)
                            p5.noFill()
                            for (var i = 0; i < n * n; i++) {
                                points.push(30)
                                growing.push(p5.random(2) < 1)
                                spds.push(p5.random(0, 3))
                            }
                            space = (p5.width - gap * 2) / n
                        }
                        p5.draw = _ => {
                            p5.background(0)
                            for (var y = 0; y < n; y++) {
                                for (var x = 0; x < n; x++) {
                                    var centerx = gap + space * x + space / 2
                                    var centery = gap + space * y + space / 2
                                    p5.beginShape()
                                    var i = y * n + x
                                    var w = points[i]
                                    p5.vertex(centerx - w, centery)
                                    p5.vertex(centerx, centery - w)
                                    p5.vertex(centerx + w, centery)
                                    p5.vertex(centerx, centery + w)
                                    p5.vertex(centerx - w, centery)
                                    p5.endShape()
                                    if (x + 1 < n) {
                                        var wright = points[y * n + x + 1]
                                        p5.line(centerx + w, centery, centerx + space - wright, centery)
                                    }
                                    if (y + 1 < n) {
                                        var wbot = points[y * n + x + n]
                                        p5.line(centerx, centery + w, centerx, centery + space - wbot)
                                    }
                                    points[i] += spds[i] * (growing[i] ? 1 : -1)
                                    if (points[i] >= space - 5) growing[i] = false
                                    if (points[i] <= minw) growing[i] = true
                                }
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
                },
                {
                    name: 'Squeezr',
                    script: function (p5) {
                        var n = 4
                        var planets = []
                        var moons = []
                        // var growing = true
                        var factor = 1
                        // var factorSpd = 0.01
                        p5.move = (x) => {
                            x.x = x.orbitAround.x + x.r * p5.cos(x.rads)
                            x.y = x.orbitAround.y + x.r * p5.sin(x.rads) * factor
                            x.rads += x.orbitSpeed
                            if (x.rads > 6.3) x.rads -= p5.PI * 2
                        }
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(20)
                            p5.background(0)
                            p5.stroke(255)
                            for (var i = 0; i < n; i++) {
                                var p = {
                                    x: 0,
                                    y: 0,
                                    orbitSpeed: p5.random(0.03, 0.2),
                                    r: p5.random(30, 100),
                                    rads: p5.random(0, 6.28),
                                    orbitAround: { x: 300, y: 300 }
                                }
                                var m = {
                                    x: 0,
                                    y: 0,
                                    orbitSpeed: p5.random(0.03, 0.2),
                                    r: p5.random(60, 150),
                                    rads: p5.random(0, 6.28),
                                    orbitAround: p
                                }
                                p5.move(p)
                                p5.move(m)
                                planets.push(p)
                                moons.push(m)
                            }
                            for (var j = 0; j < n / 2; j++) {
                                moons[j].partner = moons[j + n / 2]
                            }
                        }
                        p5.draw = _ => {
                            // p5.background(0)
                            // if (growing) factor += factorSpd
                            // else factor -= factorSpd
                            // if (factor >= 1) growing = false
                            // else if (factor <= 0.6) growing = true
                            planets.forEach(p => p5.move(p))
                            moons.forEach(m => {
                                if (m.partner) p5.line(m.x, m.y, m.partner.x, m.partner.y)
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
