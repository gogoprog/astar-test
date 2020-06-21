package;

import js.Browser;

class Main {
    var width:Int;
    var height:Int;
    var tileSize:Int = 32;

    var context2d:js.html.CanvasRenderingContext2D;
    var context:Context;

    public function new() {
        width = Browser.window.innerWidth;
        height = Browser.window.innerHeight;
        var canvas:js.html.CanvasElement = cast js.Browser.document.getElementsByTagName("canvas")[0];
        canvas.style.width = width + "px";
        canvas.style.height = height + "px";
        canvas.width = width;
        canvas.height = height;
        context2d = canvas.getContext("2d");
        context = new Context();
        var agent = context.createAgent();
        agent.position.set(256 + 16, 256 + 16);
        js.Browser.window.oncontextmenu = function(event) {
            event.preventDefault();
            return false;
        }
        js.Browser.window.onmousemove = js.Browser.window.onmousedown = function(event) {
            var mx = event.clientX;
            var my = event.clientY;

            if(event.buttons == 1) {
                for(agent in context.agents) {
                    agent.target.set(mx, my);
                }

                event.preventDefault();
            }

            if(event.buttons == 2) {
                var x = Std.int(mx/tileSize);
                var y = Std.int(my/tileSize);
                context.setTile(x, y, 1);
            }

            return false;
        }
        update(0);
    }

    function update(time:Float) {
        context.update();
        context2d.fillStyle  = "#888";
        context2d.fillRect(0, 0, width, height);
        drawGrid();
        context2d.fillStyle  = "blue";
        context2d.strokeStyle = "#fff";
        var radius = 16;

        for(agent in context.agents) {
            context2d.fillStyle  = "blue";
            drawCircle(agent.position.x, agent.position.y, radius);
            context2d.fillStyle  = "grey";
            drawCircle(agent.position.x, agent.position.y, radius * 0.7);
            context2d.strokeStyle = "lightgreen";

            if(agent.pathResult != null) {
                var path = agent.pathResult.path;

                if(path != null && path.length > 1) {
                    for(i in 0...path.length - 1) {
                        var from = context.getWorldPosition(path[i]);
                        var to = context.getWorldPosition(path[i + 1]);
                        drawLine(from.x, from.y, to.x, to.y);
                    }
                }
            }
        }

        js.Browser.window.requestAnimationFrame(update);
    }

    inline function drawTile(x, y) {
        context2d.fillRect(x*tileSize, y*tileSize, tileSize, tileSize);
    }

    inline function drawLine(a, b, c, d) {
        context2d.beginPath();
        context2d.moveTo(a, b);
        context2d.lineTo(c, d);
        context2d.stroke();
    }

    inline function drawCircle(x, y, r) {
        context2d.beginPath();
        context2d.arc(x, y, r, 0, 2 * Math.PI);
        context2d.fill();
    }

    inline function drawGrid() {
        var world = @:privateAccess context.world;
        context2d.fillStyle = "#833";

        for(y in 0...context.height) {
            for(x in 0...context.width) {
                if(world[y * context.width + x] != 0) {
                    drawTile(x, y);
                }
            }
        }

        context2d.lineWidth = 1;
        context2d.strokeStyle = "#aaa";

        for(i in 0...32) {
            drawLine(0, i * context.tileSize, width, i * context.tileSize);
            drawLine(i * context.tileSize, 0, i * context.tileSize, height);
        }
    }

    static function main() {
        new Main();
    }
}
