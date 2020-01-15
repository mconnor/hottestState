//
//************ created by Mike Connor - programmer@rocketnumber9.org *************
//                   July 2007
//        NAVIGATION 1.1
//

import com.mammoth.*;
import mx.utils.Delegate;
import mx.transitions.Tween;
import com.robertpenner.easing.*;
class com.mammoth.Navigation {



	// the final pos of the nav when it's 'on'


	/*public static var inX:Number;
	public static var inY:Number;
	public static var scaleUPx:Number;
	public static var scaleUPy:Number;


	public static var navCont:MovieClip;*/


	public var origX:Number;
	public var origY:Number;

	public var clip:MovieClip;

	public var btn:Button;
	
	private var jumpfame:String;

/*	private var tweenNavX:Tween;
	private var tweenNavY:Tween;
	private var tweenNavXscale:Tween;
	private var tweenNavYscale:Tween;*/
	public var focusFlag:Boolean;
	private static var _tweenTime:Number;
	public var lastOne:Boolean;
	private var cObj:Controller;

	function Navigation(mc:MovieClip, st:String) {
		
		
		this.cObj = Controller.getInstance();
		this.jumpfame = st;
		this.clip = mc;
		this.btn = this.clip["bt"];
		this.origX = this.clip._x;
		this.origY = this.clip._y;

		/*tweenNavX.stop();
		tweenNavY.stop();
		tweenNavXscale.stop();
		tweenNavYscale.stop();*/
		focusFlag = false;
		cObj.navArray.push(this);
		this.btn.onRelease = Delegate.create(this, goframe);
		if (st== "poster2") this.btn.enabled = false;
		
	}
	
	
	private function goframe():Void {
		
		cObj.lastNav = this;
		//cObj.inTransition = false;
		cObj.enableAllNavigation(false);
		//this.btn.enabled = false;
		cObj.goNextSection(this.jumpfame);
	}
	
	
	
	
	
	/*public function bringtoFocus():Void {
	trace("       bringtoFocus");
	focusFlag = true;
	tweenNavX = new Tween(this.clip, "_x", Quad.easeOut, origX, Navigation.inX, Navigation.tweenTime, true);
	tweenNavY = new Tween(this.clip, "_y", Quad.easeOut, origY, Navigation.inY, Navigation.tweenTime, true);
	tweenNavXscale = new Tween(this.clip, "_xscale", Quad.easeOut, 100, Navigation.scaleUPx, Navigation.tweenTime, true);
	tweenNavYscale = new Tween(this.clip, "_yscale", Quad.easeOut, 100, Navigation.scaleUPy, Navigation.tweenTime, true);
	
	}
	public function leaveFocus():Void {
	trace("leaveFocus");
	focusFlag = false;
	tweenNavX = new Tween(this.clip, "_x", Quad.easeOut, Navigation.inX, origX, Navigation.tweenTime, true);
	 tweenNavY = new Tween(this.clip, "_y", Quad.easeOut, Navigation.inY, origY, Navigation.tweenTime, true);
	 tweenNavXscale = new Tween(this.clip, "_xscale", Quad.easeOut,   Navigation.scaleUPx, 100, Navigation.tweenTime, true);
	 tweenNavYscale = new Tween(this.clip, "_yscale", Quad.easeOut,   Navigation.scaleUPy, 100, Navigation.tweenTime, true);
	}
	public static function set tweenTime(t:Number) {
	_tweenTime = t;
	}
	public static function get tweenTime():Number {
	if (_tweenTime == null) {
	_tweenTime = .25;
	}
	return _tweenTime;
	}*/
}