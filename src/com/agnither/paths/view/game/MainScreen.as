/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 08.11.13
 * Time: 22:17
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.view.game {
import com.agnither.paths.GameController;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

public class MainScreen extends Screen {

    private var _controller: GameController;

    private var _field: FieldView;

    public function MainScreen(refs: CommonRefs, controller: GameController) {
        _controller = controller;

        super(refs);
    }

    override protected function initialize():void {
        _field = new FieldView(_refs, _controller.game);
        addChild(_field);
    }
}
}
