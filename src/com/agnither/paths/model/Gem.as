/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 21:04
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.model {
import starling.events.EventDispatcher;

public class Gem extends EventDispatcher {

    public static var FALL_SPEED: Number = 0.05;

    public static const UPDATE: String = "update_Gem";
    public static const KILL: String = "kill_Gem";

    public static var types: int = 5;

    public static function getRandom(fall: Boolean):Gem {
        return new Gem(1+Math.random()*types, fall);
    }

    private var _type: int;
    public function get type():int {
        return _type;
    }

    private var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    private var _fall: Boolean;
    public function get fall():Boolean {
        return _fall;
    }

    public function Gem(type: int, fall: Boolean) {
        _type = type;
        _fall = fall;
    }

    public function place(cell: Cell, swap: Boolean = false):void {
        _cell = cell;

        if (_cell) {
            dispatchEventWith(UPDATE, false, swap);
        } else {
            dispatchEventWith(KILL);
        }
    }
}
}
