/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 09.11.13
 * Time: 0:37
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.model {

public class Chain {

    private var _cells: Vector.<Cell>;
    public function get cells():Vector.<Cell> {
        return _cells;
    }

    public function get amount():int {
        return _cells.length;
    }

    public function get type():int {
        return last ? last.type : 0;
    }

    private var _last: int;
    public function get last():Cell {
        return _last>=0 ? _cells[_last] : null;
    }
    public function get previous():Cell {
        return _last>=1 ? _cells[_last-1] : null;
    }

    private var _circuits: Array;
    public function get circuit():Boolean {
        return _circuits.length>0;
    }
    public function get lastCircuit():int {
        return _circuits.length>0 ? _circuits[_circuits.length-1] : -1;
    }

    public function Chain() {
        _cells = new <Cell>[];
        _last = -1;
        _circuits = [];
    }

    public function addCell(cell: Cell):Boolean {
        if (previous && cell == previous) {
            return false;
        }
        if (last) {
            var dx: int = Math.abs(last.x-cell.x);
            var dy: int = Math.abs(last.y-cell.y);
        }
        var repeat: int = _cells.indexOf(cell);
        if (repeat>=0) {
            var circuitIndex: int = lastCircuit>=0 ? _cells.indexOf(_cells[lastCircuit]) : -1;
            var repeatPrevious: Cell = circuitIndex>0 ? _cells[circuitIndex-1] : null;
            var repeatNext: Cell = _cells[circuitIndex+1];
            var circuitIssue: Boolean = lastCircuit>=0 && (repeatPrevious==cell || repeatNext==cell);
        }
        if (cell.type && (!type || cell.type==type && Math.abs(dx+dy)==1 && !circuitIssue)) {
            _cells.push(cell);
            _last = _cells.length-1;
            if (repeat>=0) {
                _circuits.push(_last);
            }
            return true;
        }
        return false;
    }

    public function undo():void {
        _cells.pop();
        _last = _cells.length-1;

        if (_last < lastCircuit) {
            _circuits.pop();
        }
    }

    public function destroy():void {
        while (_cells.length>0) {
            _cells.shift();
        }
        _circuits = null;
    }
}
}
