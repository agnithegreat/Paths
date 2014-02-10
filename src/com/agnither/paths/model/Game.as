/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 21:03
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.model {
import starling.events.EventDispatcher;

public class Game extends EventDispatcher {

    public static const INIT: String = "init_Game";
    public static const NEW_GEM: String = "new_gem_Game";
    public static const NEW_PATH: String = "new_path_Game";
    public static const UNDO_PATH: String = "undo_path_Game";
    public static const END_PATH: String = "end_path_Game";
    public static const CLEAR: String = "clear_Game";

    private var _width: int;
    private var _height: int;

    private var _fieldObj: Object;
    private var _field: Vector.<Cell>;
    public function get field():Vector.<Cell> {
        return _field;
    }

    private var _chain: Chain;

    private var _init: Boolean;

    public function Game() {
    }

    public function init(width: int, height: int):void {
        _width = width;
        _height = height;

        createField();
        refillGems();

        dispatchEventWith(INIT);
        _init = true;
    }

    public function selectCell(cell: Cell):void {
        if (!cell) {
            process();
            return;
        }

        if (!_chain) {
            _chain = new Chain();
        }
        if (_chain.previous == cell) {
            _chain.undo();
            dispatchEventWith(UNDO_PATH);
            return;
        }
        if (!_chain.addCell(cell)) {
            return;
        }
        dispatchEventWith(NEW_PATH, false, cell);
    }

    public function clear():void {
        _init = false;

        dispatchEventWith(CLEAR);

        _fieldObj = null;

        while (_field.length>0) {
            var cell: Cell = _field.pop();
            cell.clear();
        }
        _field = null;
    }

    private function createField():void {
        _field = new <Cell>[];
        _fieldObj = {};
        for (var j:int = 0; j < _height; j++) {
            for (var i:int = 0; i < _width; i++) {
                var slot: Cell = new Cell(i, j);
                _field.push(slot);
                _fieldObj[i+"."+j] = slot;
            }
        }
    }

    private function refillGems():void {
        if (!_field) {
            return;
        }

        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                var cell: Cell = getCell(i, (_height-1)-j);
                if (!cell.gem) {
                    var gem: Gem = Gem.getRandom(_init);
                    cell.setGem(gem);
                    dispatchEventWith(NEW_GEM, false, gem);
                }
            }
        }
    }

    private function fallGems():void {
        if (!_field) {
            return;
        }

        for (var i:int = 0; i < _width; i++) {
            for (var j:int = 0; j < _height; j++) {
                var cell: Cell = getCell(i, (_height-1)-j);
                var upper: Cell = cell;
                if (!cell.gem) {
                    while (upper && !upper.gem) {
                        upper = getCell(upper.x, upper.y-1);
                    }
                    if (upper) {
                        cell.swap(upper);
                    }
                }
            }
        }
    }

    private function removeAll(type: int = 0):void {
        var l: int = _field.length;
        for (var i:int = 0; i < l; i++) {
            var cell:Cell = _field[i];
            if (type==0 || cell.type == type) {
                cell.clear();
            }
        }
    }

    private function process():void {
        if (_chain.amount >= 2) {
            if (_chain.circuit) {
                removeAll(_chain.type);
            } else {
                var l: int = _chain.amount;
                for (var i:int = 0; i < l; i++) {
                    _chain.cells[i].clear();
                }
            }

            fallGems();
            refillGems();
        }
        _chain.destroy();
        _chain = null;
        dispatchEventWith(END_PATH);
    }

    private function getCell(x: int, y: int):Cell {
        return _fieldObj[x+"."+y];
    }
}
}
