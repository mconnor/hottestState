﻿


import mx.events.EventDispatcher;
import mx.utils.Delegate;
import mx.transitions.Tween;
import com.robertpenner.easing.*;
class com.mammoth.ColorTransformTween {
	var startObject:Object;
	var endObject:Object;
	var mc:MovieClip;
	var seconds:Number;
	var interval;
	var numTweensRunning:Number = 0;
	// mixins from EventDispatcher
	var addEventListener:Function;
	var dispatchEvent:Function;
	function ColorTransformTween(mc:MovieClip, startObject:Object, endObject:Object, seconds:Number, startNow:Boolean) {
		EventDispatcher.initialize(this);
		setStartingObject(startObject);
		setEndingObject(endObject);
		this.mc = mc;
		this.seconds = seconds;
		if (startNow) {
			doTween(seconds);
		}
	}
	function setColor(startOrEnd:String, r:Number, g:Number, b:Number, a:Number, useHex:Boolean) {
		if (startOrEnd.toLowerCase() != "start" && startOrEnd.toLowerCase() != "end") {
			throw "Invalid startOrEnd param sent to setColor";
		}
		var o:Object = new Object();
		if (useHex) {
			o.rb = r;
			o.gb = g;
			o.bb = b;
			o.ab = a;
		} else {
			o.ra = r;
			o.ga = g;
			o.ba = b;
			o.aa = a;
		}
		if (startOrEnd.toLowerCase() == "start") {
			setStartingObject(o);
		} else {
			setEndingObject(o);
		}
	}
	function setStartingObject(o:Object) {
		startObject = o;
	}
	function setEndingObject(o:Object) {
		endObject = o;
	}
	function doTween(seconds:Number) {
		//var controlObj:Controller = Controller.getInstance();
//		controlObj.btNext.enabled = false;

		var ct:Object = new Object();
		for (var i in startObject) {
			var tween:Tween = new Tween(ct, i, null, startObject[i], endObject[i], seconds, true);
			numTweensRunning++;
			tween.addListener(this);
		}
		interval = setInterval(applyColor, 10, this, mc, ct, seconds, getTimer());
	}
	function onMotionFinished(item) {

		numTweensRunning--;

		if (numTweensRunning == 0) {
			this.dispatchEvent({type:'ColorTransformTween Done'});
			/*// added by mikec
			var controlObj:Controller = Controller.getInstance();
			controlObj.btNext.enabled = true;
			controlObj.btMain.enabled = true;
*/
		}
		delete item;
	}
	function applyColor(owner:Object, targetClip:MovieClip, obj:Object, time:Number, startTime:Number) {

		var c:Color = new Color(targetClip);
		c.setTransform(obj);
		var now = getTimer();
		if (startTime + time * 1000 <= now) {
			clearInterval(owner.interval);
		}
	}

}