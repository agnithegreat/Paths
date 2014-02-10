/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/23/13
 * Time: 11:17 PM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths {
import com.agnither.utils.CommonRefs;

import flash.filesystem.File;

import starling.display.Sprite;
import starling.events.Event;
import starling.utils.AssetManager;

public class App extends Sprite {

    private var _refs: CommonRefs;

    private var _controller: GameController;

    public function App() {
        addEventListener(Event.ADDED_TO_STAGE, start);
    }

    public function start(e: Event = null):void {
        removeEventListener(Event.ADDED_TO_STAGE, start);

        var dir: File = File.applicationDirectory;

        var assets: AssetManager = new AssetManager();
        assets.enqueue(
            dir.resolvePath("textures")
        )
        assets.loadQueue(handleProgress);

        _refs = new CommonRefs(assets);
    }

    private function handleProgress(value: Number):void {
        if (value == 1) {
            init();
        }
    }

    private function init():void {
        _controller = new GameController(stage, _refs);
        _controller.init();
    }
}
}
