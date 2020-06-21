private class Base {
    public var x:Float;
    public var y:Float;
    public function new(x, y) {
        this.x = x;
        this.y = y;
    }
}

@:forward
@:forwardStatics
abstract Vector2(Base) to Base from Base {
    @:selfCall
    inline public function new(x:Float, y:Float) {
        this = new Base(x, y);
    }

    @:op(A * B)
    @:commutative
    inline static public function mulOp(a:Vector2, b:Float) {
        return new Vector2(a.x * b, a.y * b);
    }

    @:op(A / B)
    @:commutative
    inline static public function divOp(a:Vector2, b:Float) {
        return new Vector2(a.x / b, a.y / b);
    }

    @:op(A + B)
    inline static public function addOp(a:Vector2, b:Vector2) {
        return new Vector2(a.x + b.x, a.y + b.y);
    }

    @:op(A - B)
    inline static public function minOp(a:Vector2, b:Vector2) {
        return new Vector2(a.x - b.x, a.y - b.y);
    }

    public function getAngle() : Float{
        return Math.atan2(this.y, this.x);
    }

    public function getLength() : Float{
        return Math.sqrt(this.x * this.x + this.y * this.y);
    }

    public function getSquareLength() : Float{
        return this.x * this.x + this.y * this.y;
    }

    inline public function set(x, y) {
        this.x = x;
        this.y = y;
    }

    inline public function copyFrom(other:Vector2) {
        this.x = other.x;
        this.y = other.y;
    }

    inline public function add(other:Vector2) {
        this.x += other.x;
        this.y += other.y;
    }

    inline public function multiply(value:Float) {
        this.x *= value;
        this.y *= value;
    }

    inline public function divide(value:Float) {
        this.x /= value;
        this.y /= value;
    }

    inline public function setDifference(a:Vector2, b:Vector2) {
        this.x = a.x - b.x;
        this.y = a.y - b.y;
    }

    public function normalize() {
        var len = getLength();
        this.x /= len;
        this.y /= len;
    }

    public function clone() {
        return new Vector2(this.x, this.y);
    }

    public function getNormalized() {
        var result = clone();
        result.normalize();
        return result;
    }

    inline public function setZero() {
        this.x = 0;
        this.y = 0;
    }

    static public function dot(a:Vector2, b:Vector2) {
        return a.x * b.x + a.y * b.y;
    }

    static public function isSame(a:Vector2, b:Vector2) {
        return a.x == b.x && a.y == b.y;
    }

    static public function distance(a: Vector2, b:Vector2):Float{
        var delta = (a - b);
        return Math.sqrt(delta.x * delta.x + delta.y * delta.y);
    }
}
