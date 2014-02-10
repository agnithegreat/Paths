/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.06.13
 * Time: 10:26
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.utils {
import starling.utils.AssetManager;

public class CommonRefs {

    private var _assets: AssetManager;
    public function get assets():AssetManager {
        return _assets;
    }

    public function CommonRefs(assets: AssetManager) {
        _assets = assets;
    }
}
}
