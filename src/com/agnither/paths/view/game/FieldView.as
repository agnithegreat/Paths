/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 23:35
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.view.game {
import com.agnither.paths.model.Cell;
import com.agnither.paths.model.Game;
import com.agnither.paths.model.Gem;
import com.agnither.ui.AbstractView;
import com.agnither.utils.CommonRefs;

import flash.geom.Point;

import starling.animation.Transitions;
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;

public class FieldView extends AbstractView {

    public static const SELECT_CELL: String = "select_cell_FieldView";

    public static var cellWidth: int = 100;
    public static var cellHeight: int = 100;

    private var _game: Game;

    private var _cellsContainer: Sprite;
    private var _pathsContainer: Sprite;
    private var _gemsContainer: Sprite;

    private var _rollOver: CellView;

    private var _path: PathView;

    public function FieldView(refs:CommonRefs, game: Game) {
        _game = game;
        _game.addEventListener(Game.INIT, handleInit);
        _game.addEventListener(Game.CLEAR, handleClear);

        super(refs);
    }

    override protected function initialize():void {
        _cellsContainer = new Sprite();
        _cellsContainer.x = 50;
        _cellsContainer.y = 50;
        addChild(_cellsContainer);
        _cellsContainer.addEventListener(TouchEvent.TOUCH, handleTouch);

        _pathsContainer = new Sprite();
        _pathsContainer.x = _cellsContainer.x;
        _pathsContainer.y = _cellsContainer.y;
        addChild(_pathsContainer);
        _pathsContainer.touchable = false;

        _gemsContainer = new Sprite();
        _gemsContainer.x = _cellsContainer.x;
        _gemsContainer.y = _cellsContainer.y;
        addChild(_gemsContainer);
        _gemsContainer.touchable = false;
        _gemsContainer.addEventListener(GemView.REMOVE, handleRemove);
    }

    private function handleInit(e: Event):void {
        _game.addEventListener(Game.NEW_GEM, handleNewGem);
        _game.addEventListener(Game.NEW_PATH, handleNewPath);
        _game.addEventListener(Game.UNDO_PATH, handleUndoPath);
        _game.addEventListener(Game.END_PATH, handleEndPath);

        for (var i:int = 0; i < _game.field.length; i++) {
            var cell: CellView = new CellView(_refs, _game.field[i]);
            _cellsContainer.addChild(cell);

            var gem: GemView = new GemView(_refs, _game.field[i].gem);
            _gemsContainer.addChild(gem);
        }
    }

    private function handleNewGem(e: Event):void {
        var gem: GemView = new GemView(_refs, e.data as Gem);
        _gemsContainer.addChild(gem);
    }

    private function handleNewPath(e: Event):void {
        var cell: Cell = e.data as Cell;
        if (_path) {
            _path.pathTo(new Point((cell.x+0.5) * cellWidth, (cell.y+0.5) * cellHeight));
        }

        _path = new PathView(_refs, cell);
        _pathsContainer.addChild(_path);
    }

    private function handleUndoPath(e: Event):void {
        _path.destroy();
        _path = _pathsContainer.getChildAt(_pathsContainer.numChildren-1) as PathView;
    }

    private function handleEndPath(e: Event):void {
        while (_pathsContainer.numChildren>0) {
            var path: PathView = _pathsContainer.removeChildAt(0) as PathView;
            path.destroy();
        }
        _path = null;
    }

    private function handleRemove(e: Event):void {
        var gem: GemView = e.target as GemView;
        _gemsContainer.addChild(gem);
        Starling.juggler.tween(gem, Gem.FALL_SPEED*8, {y: gem.y+cellHeight*8, transition: Transitions.EASE_IN, onComplete: gem.destroy});
    }

    private function handleTouch(e: TouchEvent):void {
        var touch: Touch = e.getTouch(stage);
        if (touch) {
            if (touch.phase == TouchPhase.MOVED) {
                var pos: Point = touch.getLocation(_cellsContainer);
                _path.pathTo(pos);
            }

            var test: DisplayObject = _cellsContainer.hitTest(touch.getLocation(_cellsContainer));
            if (test) {
                var cell: CellView = test.parent as CellView;
                if (cell) {
                    if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED && _rollOver && _rollOver != cell) {
                        _rollOver = cell;
                        dispatchEventWith(SELECT_CELL, true, _rollOver.cell);
                    }
                }
            }

            if (touch.phase == TouchPhase.ENDED) {
                dispatchEventWith(SELECT_CELL, true);
                _rollOver = null;
            }
        }
    }

    private function handleClear(e: Event):void {
        _game.removeEventListener(Game.NEW_GEM, handleNewGem);
        _game.removeEventListener(Game.NEW_PATH, handleNewPath);
        _game.removeEventListener(Game.UNDO_PATH, handleUndoPath);
        _game.removeEventListener(Game.END_PATH, handleEndPath);

        while (_cellsContainer.numChildren>0) {
            var cell: CellView = _cellsContainer.removeChildAt(0) as CellView;
            cell.destroy();
        }

        while (_pathsContainer.numChildren>0) {
            var path: PathView = _pathsContainer.removeChildAt(0) as PathView;
            path.destroy();
        }

        while (_gemsContainer.numChildren>0) {
            var gem: GemView = _gemsContainer.removeChildAt(0) as GemView;
            gem.destroy();
        }

        _rollOver = null;
    }
}
}
