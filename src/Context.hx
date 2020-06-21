class Context {
    public var agents:Array<Agent> = [];
    public var width = 32;
    public var height = 32;
    public var tileSize:Float = 32;

    private var world:Array<Int>;
    private var graph:astar.Graph;


    public function new() {
        world = new Array<Int>();

        for(i in 0...width * height) { world.push(0); }

        var costs = [ 0 => astar.Graph.DefaultCosts, ];
        graph = new astar.Graph(width, height, EightWayObstructed);
        graph.setWorld(world);
        graph.setCosts(costs);
    }

    public function createAgent():Agent {
        var agent = new Agent();
        agents.push(agent);
        return agent;
    }

    public function setTile(x:Int, y:Int, value:Int) {
        world[y*width+x] = value;
    }

    inline private function getTileX(worldX:Float):Int {
        return Std.int(worldX/tileSize);
    }

    inline private function getTileY(worldY:Float):Int {
        return Std.int(worldY/tileSize);
    }

    inline public function getWorldPosition(point):Vector2 {
        return new Vector2((point.x+0.5) * tileSize, (point.y+0.5) * tileSize);
    }

    public function update() {
        for(agent in agents) {
            var tileX = getTileX(agent.position.x);
            var tileY = getTileY(agent.position.y);
            agent.pathResult = graph.solve(tileX, tileY, getTileX(agent.target.x), getTileY(agent.target.y));
        }
    }
}
