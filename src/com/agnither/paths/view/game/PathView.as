/**
 * Created by agnither on 08.02.14.
 */
package com.agnither.paths.view.game {
import com.agnither.paths.model.Cell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Point;

import starling.display.Image;

public class PathView extends AbstractView {

    private var _start: Cell;

    private var _path: Image;

    public function PathView(refs:CommonRefs, start: Cell) {
        _start = start;

        super(refs);
    }

    override protected function initialize():void {
        _path = new Image(_refs.assets.getTexture("path"+_start.gem.type));
        _path.pivotY = _path.height/2;
        addChild(_path);

        _path.x = (_start.x+0.5) * FieldView.cellWidth;
        _path.y = (_start.y+0.5) * FieldView.cellHeight;
    }

    public function pathTo(point: Point):void {
        _path.rotation = 0;
        var dx: int = point.x - _path.x;
        var dy: int = point.y - _path.y;
        var angle: Number = Math.atan2(dy, dx);
        _path.width = Math.sqrt(dx*dx+dy*dy);
        _path.rotation = angle;
    }

    override public function destroy():void {
        super.destroy();

        _start = null;

        _path.removeFromParent(true);
        _path = null;

        removeFromParent(true);
    }
}
}
