/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 23:47
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.view.game {
import com.agnither.paths.model.Cell;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import starling.display.Image;

public class CellView extends AbstractView {

    private var _cell: Cell;
    public function get cell():Cell {
        return _cell;
    }

    private var _image: Image;

    public function CellView(refs:CommonRefs, cell: Cell) {
        _cell = cell;

        super(refs);
    }

    override protected function initialize():void {
        _image = new Image(_refs.assets.getTexture("cell"));
        addChild(_image);

        x = _cell.x * FieldView.cellWidth;
        y = _cell.y * FieldView.cellHeight;
    }

    override public function destroy():void {
        super.destroy();

        _cell = null;

        removeChild(_image, true);
        _image = null;

        removeFromParent(true);
    }
}
}
