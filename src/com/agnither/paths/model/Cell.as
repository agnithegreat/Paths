/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 21:30
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.model {
import flash.geom.Point;

import starling.events.EventDispatcher;

public class Cell extends EventDispatcher {

    public static const UPDATE: String = "update_Slot";

    private var _position: Point;
    public function get position():Point {
        return _position;
    }

    public function get x():int {
        return _position.x;
    }

    public function get y():int {
        return _position.y;
    }

    private var _gem: Gem;
    public function get gem():Gem {
        return _gem;
    }

    public function get type():int {
        return _gem ? _gem.type : 0;
    }

    public function Cell(x: int, y: int) {
        _position = new Point(x, y);
    }

    public function setGem(gem: Gem, swap: Boolean = false):void {
        _gem = gem;
        if (_gem) {
            _gem.place(this, swap);
        }

        update();
    }

    public function swap(cell: Cell):void {
        var tempGem: Gem = cell.gem;
        cell.setGem(_gem, true);
        setGem(tempGem, true);
    }

    public function clear():void {
        if (_gem) {
            _gem.place(null);
        }
        _gem = null;

        update();
    }

    public function update():void {
        dispatchEventWith(UPDATE);
    }
}
}
