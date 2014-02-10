/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 13:06
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.utils.CommonRefs;

import starling.display.BlendMode;
import starling.display.Image;

public class Screen extends AbstractView {

    public static const OPEN: String = "open_Screen";
    public static const CLOSE: String = "close_Screen";

    public function Screen(refs: CommonRefs) {
        super(refs);
    }
}
}
