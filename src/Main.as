package {
import com.agnither.paths.App;

import flash.desktop.NativeApplication;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;

[SWF(frameRate="60", width="700", height="700", backgroundColor="0xFFFFFF")]
public class Main extends Sprite {

    private var viewPort: Rectangle;

    private var _starling: Starling;

    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        Starling.multitouchEnabled = true;
        Starling.handleLostContext = false;

        _starling = new Starling(App, stage, viewPort);

        NativeApplication.nativeApplication.addEventListener(
            Event.ACTIVATE, function (e:*):void {
                _starling.start();
            }
        );

        NativeApplication.nativeApplication.addEventListener(
            Event.DEACTIVATE, function (e:*):void {
                _starling.stop();
            }
        );
    }
}
}
