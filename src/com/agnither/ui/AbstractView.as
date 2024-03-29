/**
 * Created with IntelliJ IDEA.
 * User: virich
 * Date: 05.06.13
 * Time: 14:46
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.ui {
import com.agnither.utils.CommonRefs;

import starling.display.Sprite;
import starling.events.Event;

public class AbstractView extends Sprite {

    protected var _refs: CommonRefs;

    public function AbstractView(refs: CommonRefs) {
        _refs = refs;

        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
        addEventListener(Event.REMOVED_FROM_STAGE, handleRemoved);
    }

    protected function initialize():void {
    }

    protected function open():void {
    }

    protected function close():void {
    }

    private function handleAddedToStage(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);

        initialize();
    }

    private function handleAdded(event: Event):void {
        removeEventListener(Event.ADDED_TO_STAGE, handleAdded);
        open();
    }

    private function handleRemoved(event: Event):void {
        addEventListener(Event.ADDED_TO_STAGE, handleAdded);
        close();
    }

    public function destroy():void {
        _refs = null;
    }
}
}