/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/25/13
 * Time: 12:13 PM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths {
import com.agnither.paths.model.Cell;
import com.agnither.paths.model.Game;
import com.agnither.paths.view.game.FieldView;
import com.agnither.paths.view.game.MainScreen;
import com.agnither.utils.CommonRefs;

import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;

public class GameController extends EventDispatcher {

    public static const INIT: String = "init_GameController";

    private var _stage: Stage;
    private var _refs: CommonRefs;

    private var _game: Game;
    public function get game():Game {
        return _game;
    }

    private var _view: MainScreen;

    public function GameController(stage: Stage, refs: CommonRefs) {
        _stage = stage;
        _refs = refs;
    }

    public function init():void {
        _game = new Game();

        _view = new MainScreen(_refs, this);
        _view.addEventListener(FieldView.SELECT_CELL, handleSelectCell);
        _stage.addChild(_view);

        dispatchEventWith(INIT);

        _game.init(6, 6);
    }

    private function handleSelectCell(e: Event):void {
        _game.selectCell(e.data as Cell);
    }
}
}
