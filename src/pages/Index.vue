<template>
    <q-page class="index-outer">
        <CenteredLayout v-if="style === 'centered'"
            :selectedSketch="sketches[selected]" :sketches="sketches" @selected="selectedSketch" />
    </q-page>
</template>

<script>
/* eslint-disable */
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
                    name: 'Twisty',
                    script: function (p5) {
                        var rads = 0;
                        var m = true;
                        var spd = 5.0;
                        var w; var h; var r = 100;
                        var squish = 0.5;
                        var q = p5.PI / 4;
                        var yGap = 200; var y1; var y2;
                        var cols = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]]

                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.background(255);
                            h = p5.height; w = p5.width;
                            y1 = yGap; y2 = p5.height - yGap;
                            p5.frameRate(20);
                            for (var i = 0; i < 4; i++) {
                                for (var j = 0; j < 3; j++) cols[i][j] = p5.random(80,255);
                            }
                        }

                        p5.draw = _ => {
                            p5.background(255);
                            drawBox();
                            var s = (spd + 5 * p5.abs(rads)) * 0.004;
                            if (m) rads += s;
                            else rads -= s;
                            if (m && rads > q*2) m = !m;
                            else if (!m && rads < -q*2) m = !m;
                        }

                        var drawQuad = (qRads) => {
                            var i = Math.round(qRads / (p5.PI/2)) % 4;
                            p5.fill(cols[i][0],cols[i][1],cols[i][2]);
                            p5.stroke(0);
                            p5.quad(
                                w/2+r*p5.cos(qRads+rads),
                                y1+squish*r*p5.sin(qRads+rads),
                                w/2+r*p5.cos(qRads+rads+q*2),
                                y1+squish*r*p5.sin(qRads+rads+q*2),
                                w/2+r*p5.cos(qRads+q*2),
                                y2+squish*r*p5.sin(qRads+q*2),
                                w/2+r*p5.cos(qRads),
                                y2+squish*r*p5.sin(qRads)
                            );
                        }

                        var redPoint = (pRads,radius) => {
                            p5.fill(255,0,0);
                            p5.noStroke();
                            p5.ellipse(w/2+radius*p5.cos(pRads),h/2+radius*squish*p5.sin(pRads),5,5);
                        }

                        var drawBox = () => {
                            p5.stroke(0);
                            p5.noFill();
                            var prad = r*1.5;
                            p5.ellipse(w/2,h/2,prad*2,prad*2*squish);
                            redPoint(p5.PI*1.5+rads,prad);
                            redPoint((rads > 0 ? p5.PI : 0) +rads,prad); 
                            var off = rads > 0 ? 0 : p5.PI/2;
                            // draw back quad
                            drawQuad(p5.PI+off);
                            // draw side quads
                            drawQuad(p5.PI*1.5+off);
                            drawQuad(p5.PI*0.5+off);
                            // draw front quad
                            drawQuad(0+off);
                            // draw top
                            // draw front point arc
                            p5.noFill();
                            p5.stroke(0);
                            p5.arc(w/2,h/2,prad*2,prad*2*squish,0,p5.PI);
                            // draw front red points
                            redPoint(p5.PI*0.5+rads,prad);
                            redPoint((rads > 0 ? 0 : p5.PI) +rads,prad); 
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
                            p5.strokeWeight(4)
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
                            p5.background(255)
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
                                    if (points[i] >= space - 8) growing[i] = false
                                    if (points[i] <= minw) growing[i] = true
                                }
                            }
                        }
                    }
                },
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
                        var padding = 200
                        var i = 0

                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.background(255)
                            p5.noStroke()
                            p5.fill(255)
                            p5.frameRate(30)
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
                    name: 'Orbit Music',
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
                            p5.background(255)
                            p5.stroke(0)
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
                            p5.background(255)
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
                    name: 'Orbit Poly',
                    script: function (p5) {
                        var n = 6
                        var planets = []
                        var moons = []
                        var polys = []
                        var polyOffsets = []
                        var polySpeeds = []
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
                            p5.background(255)
                            p5.stroke(0)
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
                                polys.push(p5.floor(p5.random(3, 9)))
                                polyOffsets.push(p5.random(p5.PI))
                                polySpeeds.push(p5.random(-0.02, 0.02))
                            }
                        }
                        p5.draw = _ => {
                            p5.background(255)
                            for (var i = 0; i < n; i++) {
                                var d = p5.dist(300, 300, moons[i].x, moons[i].y)
                                p5.beginShape()
                                for (var deg = 0; deg < 360; deg += (360 / polys[i])) {
                                    p5.vertex(300 + d * p5.cos(p5.radians(deg) + polyOffsets[i]), 300 + d * p5.sin(p5.radians(deg) + polyOffsets[i]))
                                }
                                p5.vertex(300 + d * p5.cos(polyOffsets[i]), 300 + d * p5.sin(polyOffsets[i]))
                                p5.endShape()
                                p5.move(planets[i])
                                p5.move(moons[i])
                                polyOffsets[i] = (polyOffsets[i] + polySpeeds[i]) % (p5.PI * 2)
                            }
                        }
                    }
                },
                {
                    name: 'not like clockwork',
                    script: function (p5) {
                        var n = 6
                        var planets = []
                        var moons = []
                        var cogs = []
                        p5.move = (x) => {
                            x.x = x.orbitAround.x + x.r * p5.cos(x.rads)
                            x.y = x.orbitAround.y + x.r * p5.sin(x.rads)
                            x.rads += x.orbitSpeed
                            if (x.rads > 6.3) x.rads -= p5.PI * 2
                        }
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.frameRate(30)
                            p5.background(255)
                            p5.noFill()
                            p5.strokeWeight(3)
                            n = p5.floor(p5.random(3, 7))
                            var r = p5.random(50, 200)
                            for (var i = 0; i < n; i++) {
                                var p = {
                                    x: 0,
                                    y: 0,
                                    orbitSpeed: p5.random(0.03, 0.2),
                                    r: p5.random(40, 120),
                                    rads: p5.random(0, 6.28),
                                    orbitAround: { x: 300, y: 300 }
                                }
                                var m = {
                                    x: 0,
                                    y: 0,
                                    orbitSpeed: p5.random(0.03, 0.2),
                                    r: p5.random(30, 145),
                                    rads: p5.random(0, 6.28),
                                    orbitAround: p
                                }
                                p5.move(p)
                                p5.move(m)
                                planets.push(p)
                                moons.push(m)
                                var red = p5.random(0, 256)
                                var green = p5.random(0, 256)
                                var blue = p5.random(0, 256)
                                // while (red + green + blue < 300 || red + green + blue > 750) {
                                //     red = p5.random(0, 256)
                                //     green = p5.random(0, 256)
                                //     blue = p5.random(0, 256)
                                // }
                                cogs.push({
                                    radius: r,
                                    x: p5.random(r, 600 - r),
                                    y: p5.random(r, 600 - r),
                                    offset: p5.random(2),
                                    mult: p5.random(1) < 0.5 ? 1 : -1,
                                    teeth: p5.floor(p5.random(5, 20)),
                                    teethHeight: r * p5.random(0.1, 0.25),
                                    r: red,
                                    g: green,
                                    b: blue
                                })
                            }
                        }
                        p5.draw = _ => {
                            p5.background(255)
                            for (var i = 0; i < n; i++) {
                                var d = p5.dist(300, 300, moons[i].x, moons[i].y)
                                p5.move(planets[i])
                                p5.move(moons[i])
                                p5.stroke(cogs[i].r, cogs[i].g, cogs[i].b)
                                var part = (p5.PI * 2) / cogs[i].teeth
                                var smallerRadius = (cogs[i].radius - cogs[i].teethHeight)
                                for (var rads = 0; rads < p5.PI * 2; rads += part) {
                                    var rads1 = rads + cogs[i].offset * cogs[i].mult
                                    var rads2 = rads1 + part / 2
                                    var rads3 = rads2 + part / 2
                                    p5.arc(cogs[i].x, cogs[i].y, cogs[i].radius * 2, cogs[i].radius * 2, rads1, rads2)
                                    p5.line(
                                        cogs[i].x + cogs[i].radius * p5.cos(rads2),
                                        cogs[i].y + cogs[i].radius * p5.sin(rads2),
                                        cogs[i].x + smallerRadius * p5.cos(rads2),
                                        cogs[i].y + smallerRadius * p5.sin(rads2)
                                    )
                                    p5.arc(cogs[i].x, cogs[i].y, smallerRadius * 2, smallerRadius * 2, rads2, rads2 + part / 2)
                                    p5.line(
                                        cogs[i].x + smallerRadius * p5.cos(rads3),
                                        cogs[i].y + smallerRadius * p5.sin(rads3),
                                        cogs[i].x + cogs[i].radius * p5.cos(rads3),
                                        cogs[i].y + cogs[i].radius * p5.sin(rads3)
                                    )
                                }
                                cogs[i].offset += p5.pow(0.004 * (600 / d), 1.2)
                                if (cogs[i].offset > 7) cogs[i].offset -= p5.PI * 2
                            }
                        }
                    }
                },
                {
                    name: 'trickle down',
                    script: function (p5) {
                        var stage = 0
                        var x = 200
                        var y = 0
                        p5.startNew = _ => {
                            stage = 0
                            var r = p5.random(50, 256)
                            var g = p5.random(50, 256)
                            var b = p5.random(50, 256)
                            while (r + g + b > 650 || r + g + b < 200) {
                                r = p5.random(50, 256)
                                g = p5.random(50, 256)
                                b = p5.random(50, 256)
                            }
                            p5.stroke(r, g, b)
                            y = 0
                            x += p5.random(30, 100)
                            if (x > 600) x -= 600
                        }
                        p5.setup = _ => {
                            var canvas = p5.createCanvas(600, 600)
                            canvas.parent('canvas-container')
                            p5.background(255)
                            p5.strokeWeight(2)
                            p5.frameRate(30)
                            p5.startNew()
                        }
                        p5.draw = _ => {
                            if (stage === 0 || stage === 2) {
                                // going down
                                var y2 = y + p5.random(5, 15)
                                p5.line(x, y, x, y2)
                                y = y2
                            } else if (stage === 1) {
                                // going right
                                var x2 = x + p5.random(30, 80)
                                p5.line(x, y, x2, y)
                                x = x2
                            } else if (stage === 3) {
                                // going left
                                var x3 = x - p5.random(30, 80)
                                p5.line(x, y, x3, y)
                                x = x3
                            }
                            stage = (stage + 1) % 4
                            if (y > 600) p5.startNew()
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
