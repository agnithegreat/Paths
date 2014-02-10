/**
 * Created with IntelliJ IDEA.
 * User: agnither
 * Date: 8/25/13
 * Time: 12:05 PM
 * To change this template use File | Settings | File Templates.
 */
package com.agnither.paths.view.game {
import com.agnither.paths.GameController;
import com.agnither.paths.model.Bullet;
import com.agnither.paths.model.Drop;
import com.agnither.paths.Game;
import com.agnither.paths.model.actives.Active;
import com.agnither.paths.model.enemies.Enemy;
import com.agnither.paths.model.spells.Spell;
import com.agnither.tower.utils.SnapToGrid;
import com.agnither.paths.view.game.actives.ActiveView;
import com.agnither.paths.view.game.bullets.BulletView;
import com.agnither.paths.view.game.effects.ShakeEffect;
import com.agnither.paths.view.game.spells.SpellView;
import com.agnither.paths.view.game.enemies.EnemyView;
import com.agnither.paths.view.game.trails.TrailView;
import com.agnither.paths.view.game.wizards.WizardView;
import com.agnither.ui.AbstractView;
import com.agnither.ui.Screen;
import com.agnither.utils.CommonRefs;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.extensions.PDParticleSystem;

public class GameScreen extends Screen {

    public static const ADD_TRAIL: String = "add_trail_GameScreen";
    public static const INIT_COMPLETE: String = "init_complete_GameScreen";

    public static var towerHeight: int = 240;

    private var _game: Game;

    private var _back: Image;
    private var _trails: Sprite;
    private var _wall: Image;

    private var _under: Sprite;
    private var _container: Sprite;
    private var _over: Sprite;

    private var _mage: WizardView;

    private var _particles: Sprite;

    private var _magic: PDParticleSystem;

    public function GameScreen(refs: CommonRefs, game: Game) {
        _game = game;
        _game.addEventListener(Game.INIT, handleInit);
        _game.addEventListener(Game.ADD_ENEMY, handleAddEnemy);
        _game.addEventListener(Game.ADD_BULLET, handleAddBullet);
        _game.addEventListener(Game.ADD_SPELL, handleAddSpell);
        _game.addEventListener(Game.ADD_ACTIVE, handleAddActive);
        _game.addEventListener(Game.ADD_DROP, handleAddDrop);
        _game.addEventListener(Game.SHAKE, handleShake);
        _game.addEventListener(Game.TICK, handleTick);

        super(refs);
    }

    override protected function initialize():void {
        _back = new Image(_refs.game.getTexture("back_"+_game.level.location+".png"));
        _back.touchable = false;
        _back.pivotX = int(_back.width/2);
        _back.x = int(stage.stageWidth/2);
        addChild(_back);

        _trails = new Sprite();
        _trails.alpha = 0.999;
        _trails.touchable = false;
        addChild(_trails);

        _wall = new Image(_refs.game.getTexture("wall"+(_game.player.hp+1)+".png"));
        _wall.touchable = false;
        _wall.pivotX = _wall.width/2;
        _wall.pivotY = _wall.height;
        _wall.x = stage.stageWidth/2;
        _wall.y = SnapToGrid.height+towerHeight;
        addChild(_wall);

        _under = new Sprite();
        _under.alpha = 0.999;
        _under.touchable = false;
        addChild(_under);

        _container = new Sprite();
        _container.alpha = 0.999;
        addChild(_container);

        var WizardClass: Class = WizardView.getWizard(_game.tower.wizard);
        if (WizardClass) {
            _mage = new WizardClass(_refs, _game.tower.wizard);
            _mage.touchable = false;
            _mage.x = stage.stageWidth/2;
            _mage.y = 814;
            addChild(_mage);
        }

        _over = new Sprite();
        _over.alpha = 0.999;
        _over.touchable = false;
        addChild(_over);

        _particles = new Sprite();
        _particles.alpha = 0.999;
        _particles.touchable = false;
        addChild(_particles);

        _magic = new PDParticleSystem(_refs.main.getXml("touch_particle"), _refs.animations.getTexture("touch_texture.png"));
        _magic.alpha = 0.999;
        _magic.touchable = false;
        _particles.addChild(_magic);
        GameController.gameJuggler.add(_magic);

        addEventListener(ADD_TRAIL, handleAddTrail);

        stage.addEventListener(TouchEvent.TOUCH, handleTouch);

        dispatchEventWith(INIT_COMPLETE, true);
    }

    private function handleInit(e: Event):void {
        _wall.texture = _refs.game.getTexture("wall"+(_game.player.hp+1)+".png");
        _wall.readjustSize();
        _wall.pivotX = _wall.width/2;
        _wall.pivotY = _wall.height;
    }

    private function handleTouch(e: TouchEvent):void {
        _magic.start();
        var moved: Boolean = false;
        var l: int = e.touches.length;
        for (var i:int = 0; i < l; i++) {
            if (!moved) {
                var touch: Touch = e.touches[i];
                var loc: Point = touch.getLocation(this);
                if (touch.phase == TouchPhase.MOVED) {
                    _magic.emitterX = loc.x;
                    _magic.emitterY = loc.y;
                    moved = true;
                }
            }
        }
        if (!moved) {
            _magic.stop();
        }
    }

    private function handleAddEnemy(e: Event):void {
        var EnemyClass: Class = EnemyView.getEnemy(e.data as Enemy);
        if (EnemyClass) {
            var enemy: EnemyView = new EnemyClass(_refs, e.data as Enemy);
            enemy.addEventListener(EnemyView.DEAD, handleDeadEnemy);
            enemy.addEventListener(EnemyView.DESTROY, handleDestroyEnemy);
            switch (enemy.enemy.layer) {
                case -1:
                    _under.addChild(enemy);
                    break;
                case 0:
                    _container.addChild(enemy);
                    break;
                case 1:
                    _over.addChild(enemy);
                    break;
            }
            _particles.addChild(enemy.damage);
        }
    }

    private function handleAddBullet(e: Event):void {
        var BulletClass: Class = BulletView.getBullet(e.data as Bullet);
        if (BulletClass) {
            var bullet: BulletView = new BulletClass(_refs, e.data as Bullet);
            bullet.addEventListener(BulletView.DESTROY, handleDestroyBullet);
            _container.addChild(bullet);
        }
    }

    private function handleAddSpell(e: Event):void {
        var sp: Spell = e.data as Spell;
        var SpellClass: Class = SpellView.getSpell(sp);
        if (SpellClass && (e.data as Spell).success) {
            switch (sp.spell.layer) {
                case -1:
                    SpellClass.create(_refs, e.data as Spell, _under, handleDestroySpell);
                    break;
                case 0:
                    SpellClass.create(_refs, e.data as Spell, _container, handleDestroySpell);
                    break;
                case 1:
                    SpellClass.create(_refs, e.data as Spell, _over, handleDestroySpell);
                    break;
            }
        }
    }

    private function handleAddActive(e: Event):void {
        var ActiveClass: Class = ActiveView.getActive(e.data as Active);
        if (ActiveClass) {
            var active: ActiveView = new ActiveClass(_refs, e.data as Active);
            active.addEventListener(ActiveView.DESTROY, handleDestroyActive);
            switch (active.active.layer) {
                case -1:
                    _under.addChild(active);
                    break;
                case 0:
                    _container.addChild(active);
                    break;
                case 1:
                    _over.addChild(active);
                    break;
            }
        }
    }

    private function handleAddDrop(e: Event):void {
        var drop: DropView = new DropView(_refs, e.data as Drop);
        _container.addChild(drop);
    }

    private function handleAddTrail(e: Event):void {
        var target: AbstractView = e.target as AbstractView;
        var TrailClass: Class = TrailView.getTrail(e.data as String);
        if (TrailClass) {
            var trail: TrailView = new TrailClass(_refs);
            trail.x = target.x;
            trail.y = target.y;
            _trails.addChild(trail);
        }
    }

    private function handleShake(e: Event):void {
        ShakeEffect.createShake(this, e.data as Array);
    }

    private function handleTick(e: Event):void {
        _container.sortChildren(sortEnemies);
    }

    private function testTarget(obj: DisplayObject):DisplayObject {
        if (!obj) {
            return null;
        }
        return obj is EnemyView ? obj : testTarget(obj.parent);
    }

    private function sortEnemies(e1: DisplayObject, e2: DisplayObject):int {
        if (e1.y>e2.y) {
            return 1;
        } else if (e1.y<e2.y) {
            return -1;
        }
        var o1: EnemyView = e1 as EnemyView;
        var o2: EnemyView = e2 as EnemyView;
        if (o1 && o2) {
            if (o1.id<o2.id) {
                return 1;
            } else if (o1.id>o2.id) {
                return -1;
            }
        }
        return 0;
    }

    private function handleDeadEnemy(e: Event):void {
        var enemy: EnemyView = e.currentTarget as EnemyView;
        _under.addChild(enemy);
    }

    private function handleDestroyEnemy(e: Event):void {
        var enemy: EnemyView = e.currentTarget as EnemyView;
        enemy.destroy();
        enemy.removeFromParent(true);
    }

    private function handleDestroyBullet(e: Event):void {
        var bullet: BulletView = e.currentTarget as BulletView;
        bullet.destroy();
        bullet.removeFromParent(true);
    }

    private function handleDestroySpell(e: Event):void {
        var spell: SpellView = e.currentTarget as SpellView;
        spell.destroy();
        spell.removeFromParent(true);
    }

    private function handleDestroyActive(e: Event):void {
        var active: ActiveView = e.currentTarget as ActiveView;
        active.destroy();
        active.removeFromParent(true);
    }

    override public function destroy():void {
        super.destroy();

        _game.removeEventListener(Game.INIT, handleInit);
        _game.removeEventListener(Game.ADD_ENEMY, handleAddEnemy);
        _game.removeEventListener(Game.ADD_BULLET, handleAddBullet);
        _game.removeEventListener(Game.ADD_SPELL, handleAddSpell);
        _game.removeEventListener(Game.ADD_ACTIVE, handleAddActive);
        _game.removeEventListener(Game.ADD_DROP, handleAddDrop);
        _game.removeEventListener(Game.SHAKE, handleShake);
        _game.removeEventListener(Game.TICK, handleTick);
        _game = null;

        _back.removeFromParent(true);
        _back = null;

        _wall.removeFromParent(true);
        _wall = null;

        while (_trails.numChildren>0) {
            _trails.removeChildAt(0, true);
        }
        _trails.removeFromParent(true);
        _trails = null;

        _mage.destroy();
        removeChild(_mage, true);
        _mage = null;

        while (_under.numChildren>0) {
            view = _under.removeChildAt(0, true) as AbstractView;
            view.removeEventListeners();
            view.destroy();
        }
        _under.removeFromParent(true);
        _under = null;

        while (_container.numChildren>0) {
            var view: AbstractView = _container.removeChildAt(0, true) as AbstractView;
            view.removeEventListeners();
            view.destroy();
        }
        _container.removeFromParent(true);
        _container = null;

        GameController.gameJuggler.remove(_magic);
        _particles.removeChild(_magic, true);
        _magic = null;

        removeEventListener(ADD_TRAIL, handleAddTrail);

        stage.removeEventListener(TouchEvent.TOUCH, handleTouch);

        while (_over.numChildren>0) {
            view = _over.removeChildAt(0, true) as AbstractView;
            view.removeEventListeners();
            view.destroy();
        }
        _over.removeFromParent(true);
        _over = null;

        _particles.removeFromParent(true);
        _particles = null;
    }
}
}
