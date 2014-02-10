/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 13:06
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.utils.CommonRefs;

public class Popup extends AbstractView {

    public static const OPEN: String = "open_Popup";
    public static const CLOSE: String = "close_Popup";

    private var _darkened: Boolean;
    public function get darkened():Boolean {
        return _darkened;
    }

    public function Popup(refs: CommonRefs, darkened: Boolean = true) {
        _darkened = darkened;
        super(refs);
    }

    override protected function open():void {
        dispatchEventWith(OPEN);
    }

    override public function destroy():void {
        super.destroy();
    }
}
}
