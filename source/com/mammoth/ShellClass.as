//
//
///************* created by MIKE CONNOR -  programmer@rocketnumber9.com *****************
///                            July 2007
//

import mx.utils.Delegate;

import com.mammoth.*;
class com.mammoth.ShellClass {
	private static var _instance:ShellClass = null;
	private var configXML:XML;
	//private function ShellClass(module:String, moduleContainer:MovieClip) {
	// debug level
	// 1 = debug
	// 3 = warning
	//4 = error
	//5 = debugging off
	public static var debugLevel:Number;

	public var aboutCopy:String;
	public var soundtrackCopy:String;


	public var mainClip:MovieClip;
	public var startFrame:String;
	private var debugMC:MovieClip;

	private var degbugToggle:Boolean;

	// the frame that the ap will jump to once the config xml is loaded
	public var frameName:String;
	// text field for debugging app
	public var debugTF:TextField;
	public var reportTextField:TextField;
	public var photoList:Array;

	private  var preloader:MovieClip;
	private  var preloadBar:MovieClip;
	private  var rootClip:MovieClip;
	private  var cFrame:String;
	//private var contentMC:MovieClip;


	//private function ShellClass(mc:MovieClip, fname:String, tf:TextField) {
	private function ShellClass() {

		/*mainClip = mc;
		frameName = fname;
		photoList = new Array();
		*/

	}
	public static function getInstance(mc:MovieClip, num:Number, fname:String, mc2:MovieClip):ShellClass {
		if (ShellClass._instance == null) {
			
			//ShellClass._instance = new ShellClass(mc, fname, mc2);
			ShellClass._instance = new ShellClass();
			//ShellClass.debugLevel = num;
		}
		return ShellClass._instance;
	}
	
	
	public function init(mc:MovieClip, num:Number, fname:String, mc2:MovieClip):Void {
		ShellClass.debugLevel = num;
		mainClip = mc;
		frameName = fname;
		photoList = new Array();
	}
	
	
	/*public static function  setPreloader(st:String, x:Number, y:Number):Void {
		ShellClass.preloader = rootMC.attachMovie(st, st, rootMC.getNextHighestDepth(), {_x:x, _y:y});
		ShellClass.preloadBar = ShellClass.preloader["bar_mc"];
		preloader.onEnterFrame = Delegate.create(this, showLoading);
	}
	private static function showLoading():Void {
		var pctLoaded:Number = Math.round(ShellClass.rootMC._parent.getBytesLoaded() / ShellClass.rootMC._parent.getBytesTotal() * 100);
		ShellClass.preloadBar._xscale = pctLoaded;
		ShellClass.preloader["percentTXT"].text = pctLoaded + "%";
		trace("pctLoaded " +pctLoaded);
		if (pctLoaded >= 100) {
			delete preloader.onEnterFrame;
			ShellClass.preloader.removeMovieClip();
		}
	}*/
	
	
	
	
	
	
	
	
	
	
	
	//public function setPreloader(mc:MovieClip,mc2:MovieClip, st:String,  fname:String, x:Number, y:Number):Void {
		public function setPreloader(mc:MovieClip,mc2:MovieClip,   fname:String):Void {
		this.rootClip = mc;
		this.rootClip = mc;
		//contentMC = mc2;
		this.cFrame = fname;
		
		//this.preloader = rootClip.attachMovie(st, st, rootClip.getNextHighestDepth(), {_x:x, _y:y});
		this.preloader = mc2;
		this.preloadBar = this.preloader["bar_mc"];
		
		
		
		preloader.onEnterFrame = Delegate.create(this, showLoading);
	}
	private function showLoading():Void {
		var pctLoaded:Number = Math.round(this.rootClip.getBytesLoaded() / this.rootClip.getBytesTotal() * 100);
		this.preloadBar._xscale = pctLoaded;
		this.preloader["percentTXT"].text = pctLoaded + "%";
		trace("pctLoaded " +pctLoaded);
		if (pctLoaded >= 100) {
			//delete preloader.onEnterFrame;
//			rootClip.preloader.removeMovieClip();
			this.rootClip.gotoAndStop(cFrame);
			//this.contentMC.gotoAndStop(cFrame);
			
		}
	}
	
	
	
	
	
	
	
	
	
	
	
	
	public function loadConfig(url:String):Void {
		configXML = new XML();
		configXML.ignoreWhite = true;
		configXML.onLoad = Delegate.create(ShellClass._instance, onloadConfig);
		configXML.load(url);
	}
	function debug(msg:String, lv:Number, newCopy:Boolean):Void {
		if (lv == null) {
			lv = 1;
		}
		if (lv >= ShellClass.debugLevel) {
			if (newCopy) {
				this.debugTF.text = msg;
			} else {
				this.debugTF.text += msg;
			}
		}
	}
	public function getDebugLevel():Number {
		return ShellClass.debugLevel;
	}
	public function setDebugLevel(num:Number) {
		ShellClass.debugLevel = num;
		if (ShellClass.debugLevel == 5) {
			debugMC._visible = false;
		}
	}
	function onloadConfig(success:Boolean):Void {
		if (success) {
			var mainNode:XMLNode = configXML.firstChild.firstChild;
			//trace("mainNode " + mainNode);
			while (mainNode != null) {
				if (mainNode.nodeType == 1) {
					//trace(mainNode.nodeName + " = " + mainNode.firstChild.nodeValue);
					switch (mainNode.nodeName) {
						case "photo" :

							var photoObj:PhotoClass = new PhotoClass(mainNode.firstChild.nodeValue);

							//this.aboutCopy = mainNode.firstChild.nodeValue;

							this.photoList.push(photoObj);
							break;
							/*case "soundtrack" :
							this.soundtrackCopy = mainNode.firstChild.nodeValue;
							break;*/


						default :
							break;
					}
				}
				mainNode = mainNode.nextSibling;
			}
			this.mainClip.gotoAndStop(this.frameName);
			//trace("xml loaded");
		} else {
			//throw new KioskError("ERrrrrOR -   configXML DID NOT LOAD");
			trace("EROR -   configXML DID NOT LOAD");
		}
		mainClip.gotoAndStop(this.frameName);
	}
}