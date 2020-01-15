//
//************ created by Mike Connor - programmer@rocketnumber9.org *************
//                   July 2007
//        controller 1.1
//


import mx.utils.Delegate;
import mx.transitions.Tween;
import com.robertpenner.easing.*;
import com.mammoth.*;
import flash.external.*;
class com.mammoth.Controller {




	private var posterYin:Number;
	private var persistantClipOrigY:Number;
	private var posterExitY:Number;
	//public var inTransition:Boolean;
	// buttron that launches the burst
	public var burstBt:Button;
	//private var bursturl:String;

	public var dateBt:Button;
	public var soundtrackBt:Button;

	//private var dateUrl:String;



	private static var _instance:Controller = null;
	//interval id 
	private var photoId:Number;
	public var mainClip:MovieClip;
	private var _posterClip:MovieClip;
	private var _logoClip:MovieClip;
	public var currentframe:String;
	public var nextframe:String;
	private var _currentMC:MovieClip;
	private var mcorigY:Number;

	private var currScrollObj:ScrollingTextBox;

	//ratings clip
	private var _ratingClip:MovieClip;
	private var ratingYin:Number;


	//private var _btnNextCopy:Button;
	//private var ratingClipYin:Number;


	//
	private var _soundtrackBGclip:MovieClip;

	private var _persistantClip:MovieClip;
	public var maskClip:MovieClip;
	private var _shellObj:ShellClass;
	//holds all content of photos sections
	public var photosMainClip:MovieClip;
	// holds the thumbnails
	public var photoContainer:MovieClip;

	public var sectionTweenType:Function;
	public var sectionTweenTime:Number;
	public var posterTweenTime:Number;
	public var photoDimClip:MovieClip;
	public var navArray:Array;
	public var currentPhotoObj:PhotoClass;
	// the 'available aug...' clip in the poster
	public var posterAvailableClip:MovieClip;

	private var videoMC:MovieClip;

	public var lastNav:Navigation;

	public var photoSelected:Boolean;

	private function Controller(mc:MovieClip, maskmc:MovieClip) {
		photoSelected = false;
		posterExitY = 532;
		posterYin = 0;
		navArray = new Array();
		mainClip = mc;
		currentframe = "poster";
		this.maskClip = maskmc;
		//trace("this.maskClip   " + this.maskClip);

		sectionTweenType = Cubic.easeInOut;
		sectionTweenTime = .75;
		posterTweenTime = 2;
		_shellObj = ShellClass.getInstance();
		createPhotoClip();

	}
	public static function getInstance(mc:MovieClip, maskmc:MovieClip):Controller {

		if (_instance == null) {
			_instance = new Controller(mc, maskmc);

		}
		return _instance;
	}
	private function createPhotoClip():Void {
		//trace("  createPhotoClip ");


		this.photosMainClip = this.mainClip.createEmptyMovieClip("photoDimClip", this.mainClip.getNextHighestDepth());
		photoContainer = photosMainClip.createEmptyMovieClip("photoContainer", photosMainClip.getNextHighestDepth(), {_x:PhotoClass.containerX, _y:PhotoClass.containerY});

		photoDimClip = photosMainClip.createEmptyMovieClip("photoDimClip", 99, {_x:-62, _y:0});
		photoDimClip.attachMovie("photoDimMC","photoDimMC",1);
		/*var photoDimClipMask:MovieClip = this.maskClip.duplicateMovieClip("photoContainerMask", photosMainClip.getNextHighestDepth(), {x:this.maskClip._x, y:this.maskClip._y});
		photoDimClip.setMask(photoDimClipMask);*/
		photoDimClip._visible = false;



		//var photoContainerMask:MovieClip = this.maskClip.duplicateMovieClip("photoContainerMask", photosMainClip.getNextHighestDepth(), {x:this.maskClip._x, y:this.maskClip._y});
		var photoContainerMask:MovieClip = this.mainClip.attachMovie("photoMaskMovieClip", "photoMaskMovieClip", this.mainClip.getNextHighestDepth());
		photoContainerMask._x = 7;
		trace("photoContainerMask._x" + photoContainerMask._x);
		photosMainClip.setMask(photoContainerMask);
		photoContainer._visible = false;
		photoContainer._x = PhotoClass.containerX;
		photoContainer._y = PhotoClass.containerY;
		var photoObjCount:Number = 0;

		while (photoObjCount < _shellObj.photoList.length) {
			for (var rowCount:Number = 0; rowCount < PhotoClass.numofRows; rowCount++) {
				for (var colCount:Number = 0; colCount < PhotoClass.numofCols; colCount++) {
					var mc:MovieClip = _shellObj.photoList[photoObjCount].addPhoto(photoContainer, photoObjCount);
					//mc._x = colCount * (PhotoClass.w + PhotoClass.spacerX);
					//mc._y = rowCount * (PhotoClass.h + PhotoClass.spacerY);



					var xIn:Number = colCount * (PhotoClass.w + PhotoClass.spacerX);
					var yIn:Number = rowCount * (PhotoClass.h + PhotoClass.spacerY);



					_shellObj.photoList[photoObjCount].place(xIn,yIn);

					photoObjCount++;
				}
				colCount = 0;
			}
		}

	}
	public function dimThumbnails():Void {
		this.photoDimClip._visible = true;
		var dimAlphaTween = new Tween(this.photoDimClip, "_alpha", Quad.easeOut, 0, PhotoClass.dimAlpha, 1, true);
	}
	public function dimThumbnailsOut():Void {
		//this.photoDimClip._visible = true;
		var dimAlphaTween = new Tween(this.photoDimClip, "_alpha", Quad.easeOut, PhotoClass.dimAlpha, 0, 1, true);
	}
	public function set posterClip(mc:MovieClip) {
		_posterClip = mc;
		//var posterTween:Tween = new Tween(_posterClip, "_y", Quad.easeOut, -_posterClip._height, 0, 2, true);

		currentMC = _posterClip;


		//var posterTween:Tween = new Tween(_posterClip, "_alpha", Quad.easeOut, 0, 100, sectionTweenTime, true);


		//posterTween.onMotionFinished = Delegate.create(this, bringinLogo);



		/*var ct:Object = {rb:181, gb:65, bb:40};
		var rt:Object = {rb:0, gb:0, bb:0};
		var colTween = new ColorTransformTween(_posterClip, ct, rt, 4, true);*/


	}
	public function get posterClip():MovieClip {
		return _posterClip;
	}
	public function set logoClip(mc:MovieClip) {
		_logoClip = mc;
		_logoClip._alpha = 0;
	}
	public function get logoClip():MovieClip {
		return _logoClip;
	}
	private function bringinLogo():Void {
		var alphaTween:Tween = new Tween(_logoClip, "_alpha", Quad.easeOut, 0, 100, sectionTweenTime, true);
		var logoxTween:Tween = new Tween(_logoClip, "_xscale", sectionTweenType, 96, 100, 3, true);
		var logoyTween:Tween = new Tween(_logoClip, "_yscale", sectionTweenType, 96, 100, 3, true);
		_logoClip._alpha = 100;
	}
	public function goNextSection(nframe:String):Void {

		this.dateBt.enabled = false;
		this.burstBt.enabled = false;
		this.soundtrackBt.enabled = false;



		this.nextframe = nframe;
		if (currentframe == "photos") {
			if (this.photoSelected) {
				this.currentPhotoObj.killBigPhoto();
			}
		}
		switch (true) {
			case (currentframe == "poster") :
				//animateRrating(false);
				var posterYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, mcorigY, posterExitY, sectionTweenTime, true);


				//posterYout = posterClip._y;
				var alphaTween:Tween = new Tween(posterAvailableClip, "_alpha", sectionTweenType, 100, 0, 1, true);
				posterYTween.onMotionFinished = Delegate.create(this, jumptoNextFrame);
				break;
			case (currentframe == "poster2") :
				//animateRrating(false);
				trace("currentMC._y " + currentMC._y);
				trace("tween poster to " + (currentMC._y - posterYin));



				var posterYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, currentMC._y, posterExitY, sectionTweenTime, true);
				var alphaTween:Tween = new Tween(posterAvailableClip, "_alpha", sectionTweenType, 100, 0, 1, true);

				posterYTween.onMotionFinished = Delegate.create(this, jumptoNextFrame);


				break;




				/*case (currentframe == "poster" || "poster2") :
				//animateRrating(false);
				var alphaTween:Tween = new Tween(posterAvailableClip, "_alpha", sectionTweenType, 100, 0, 1, true);
				var posterYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, currentMC._y, posterExitY, sectionTweenTime, true);
				posterYTween.onMotionFinished = Delegate.create(this, jumptoNextFrame);
				break;*/


			case (currentframe == "photos") :

				var len:Number = _shellObj.photoList.length;

				var lastone:Boolean = false;
				//for (var i:Number = 0; i < len; i++) {
				//var len:Number = _shellObj.photoList.length;

				for (var i:Number = len - 1; i >= 0; i--) {
					if (i == 0) {
						lastone = true;

					}
					//_shellObj.photoList[i].clip;                       
					//_shellObj.photoList[i].bringInthumbnail(800);

					_shellObj.photoList[i].intervalID = setInterval(this, "triggerPhotoOut", 100 * (len - i), i, lastone);

				}
				//renableButtons();
				break;

			default :
				var posterYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, mcorigY, 764.0, sectionTweenTime, true);
				posterYTween.onMotionFinished = Delegate.create(this, jumptoNextFrame);
				trace("currentframe  " + currentframe);
				if (currentframe == "soundtrack") {
					var soundtrackBGyTween:Tween = new Tween(_soundtrackBGclip, "_y", sectionTweenType, 0, -soundtrackBGclip._height, sectionTweenTime, true);
				}
				break;
		}
		/*if (currentframe == "poster") {
		var posterYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, mcorigY, posterExitY, sectionTweenTime, true);
		var alphaTween:Tween = new Tween(posterAvailableClip, "_alpha", sectionTweenType, 100, 0, 1, true);
		posterYTween.onMotionFinished = Delegate.create(this, jumptoNextFrame);
		} else {
		var posterYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, mcorigY, 764.0, sectionTweenTime, true);
		posterYTween.onMotionFinished = Delegate.create(this, jumptoNextFrame);
		trace("currentframe  " + currentframe);
		if (currentframe == "soundtrack") {
		var soundtrackBGyTween:Tween = new Tween(_soundtrackBGclip, "_y", sectionTweenType, 0, -soundtrackBGclip._height, sectionTweenTime, true);
		}
		}*/
	}
	public function jumptoNextFrame():Void {
		currentMC._visible = false;
		if (currentframe != "poster") {
			currentMC._y = mcorigY;
		}
		//currentMC._y = mcorigY;                                                      
		//trace("jumptoNextFrame  " + this.nextframe);
		this.mainClip.gotoAndStop(this.nextframe);
		this.currentframe = this.nextframe;
	}
	public function set currentMC(mc:MovieClip):Void {
		_currentMC = mc;
		mcorigY = _currentMC._y;
		currentMC._visible = true;
		if (currentframe != "poster" && currentframe != "poster2") {
			if (currentframe == "photos") {
				var len:Number = _shellObj.photoList.length - 1;
				var lastone:Boolean;
				for (var i:Number = len; i >= 0; i--) {
					if (i == len) {
						lastone = true;

					} else {
						lastone = false;
					}
					_shellObj.photoList[i].intervalID = setInterval(this, "triggerPhotoIn", 100 * i, i, lastone);
				}
			} else {
				var currentMCYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, 800, mcorigY, sectionTweenTime, true);


				currentMCYTween.onMotionFinished = Delegate.create(this, renableButtons);



			}
			/*if (currentframe == "trailer") {
			currentMCYTween.onMotionFinished = Delegate.create(this, loadvideoSymbol);
			}*/
		} else {
			if (currentframe == "poster2") {

				//trace("         poster2  frame -------- " + _currentMC + " tween from  " + mcorigY + " to  " + posterYin);
				//
				//trace("_currentMC._visible " + _currentMC._visible);
				//trace("_currentMC._alpha " + _currentMC._alpha);


				var currentMCYTween:Tween = new Tween(_currentMC, "_y", sectionTweenType, mcorigY, posterYin, sectionTweenTime, true);

				//animateRrating(true);
				tweenPosterCopy();
				currentMCYTween.onMotionFinished = Delegate.create(this, renableButtons);

				this.dateBt.enabled = true;
				this.burstBt.enabled = true;
				this.soundtrackBt.enabled = true;

			} else {

				firstRratingAnimation();
			}
		}
	}
	private function triggerPhotoIn(i:Number, bool:Boolean):Void {
		clearInterval(_shellObj.photoList[i].intervalID);
		_shellObj.photoList[i].bringInthumbnail(bool);
		if (bool) {
			trace(" i  bool =  " + i + "  " + _shellObj.photoList[i].photoURL);
		}


	}
	private function triggerPhotoOut(i:Number, bool:Boolean):Void {

		_shellObj.photoList[i].bringOutthumbnail(bool);
		clearInterval(_shellObj.photoList[i].intervalID);

		/*if (bool) {
		jumptoNextFrame();
		}*/
	}
	public function renableButtons():Void {
		trace("renableButtons");
		enableAllNavigation(true);
	}
	private function loadvideoSymbol():Void {
		this.videoMC = _currentMC.attachMovie("vid", "vid", 10);
	}
	public function get currentMC():MovieClip {
		return _currentMC;
	}
	public function set persistantClip(mc:MovieClip):Void {

		_persistantClip = mc;

		persistantClipOrigY = mc._y;
		var posterYTween:Tween = new Tween(_persistantClip, "_y", sectionTweenType, persistantClipOrigY, 0, posterTweenTime, true);

		posterYTween.onMotionFinished = Delegate.create(this, tweenPosterCopy);
		trace("persistantClipOrigY   " + persistantClipOrigY);
	}
	private function tweenPosterCopy():Void {
		trace("tweenPosterCopy");
		var alphaTween:Tween = new Tween(posterAvailableClip, "_alpha", sectionTweenType, 0, 100, 1, true);
		//posterYin = posterClip._y;
		trace("posterYin   " + posterYin);

	}
	public function get persistantClip():MovieClip {
		return _persistantClip;
	}
	public function set soundtrackBGclip(mc:MovieClip):Void {
		_soundtrackBGclip = mc;
		var soundtrackBGyTween:Tween = new Tween(_soundtrackBGclip, "_y", sectionTweenType, -soundtrackBGclip._height, 0, sectionTweenTime, true);
	}
	public function get soundtrackBGclip():MovieClip {
		return _soundtrackBGclip;
	}
	public function set ratingClip(mc:MovieClip):Void {
		_ratingClip = mc;
		ratingYin = mc._y;
	}
	public function get ratingsClip():MovieClip {
		return _ratingClip;
	}
	public function disableOtherThumbnails():Void {
		trace("disableOtherThumbnails");
		var len:Number = _shellObj.photoList.length - 1;
		for (var i:Number = len; i >= 0; i--) {
			//if (_shellObj.photoList[i] != photoObj) {
			_shellObj.photoList[i].btn.enabled = false;

			//}
		}
	}
	public function enableOtherThumbnails():Void {
		var len:Number = _shellObj.photoList.length - 1;
		for (var i:Number = len; i >= 0; i--) {
			//if (_shellObj.photoList[i] != photoObj) {
			_shellObj.photoList[i].btn.enabled = true;

			//}
		}
	}
	public function enableAllNavigation(bool:Boolean):Void {
		var len:Number = this.navArray.length - 1;
		for (var i:Number = len; i >= 0; i--) {
			if (this.navArray[i] != this.lastNav || bool == false) {


				this.navArray[i].btn.enabled = bool;

			}
		}
	}
	public function setBurstLink():Void {
		//bursturl = zurl;
		this.burstBt.onRelease = Delegate.create(this, launchBustUrl);
	}
	public function setDateLink():Void {
		//dateUrl = zurl;
		this.dateBt.onRelease = Delegate.create(this, launchDateUrl);
	}
	private function launchDateUrl():Void {
		//this.mainClip.getURL(bursturl,"_blank");
		trace("    date urls");
		ExternalInterface.call("jsPlayDates");
	}
	private function launchBustUrl():Void {
		//this.mainClip.getURL(bursturl,"_blank");
		ExternalInterface.call("jsburst");
	}
	/*private function animateRrating(showBool:Boolean):Void {
	if (!showBool) {
	var ratingYTween:Tween = new Tween(_ratingClip, "_y", sectionTweenType, ratingYin, ratingYin + 90, sectionTweenTime, true);
	} else {
	var ratingYTween:Tween = new Tween(_ratingClip, "_y", sectionTweenType, ratingYin + 90, ratingYin, sectionTweenTime, true);
	}
	
	}*/
	private function firstRratingAnimation():Void {
		trace("firstRratingAnimation");
		var ratingYTween:Tween = new Tween(_ratingClip, "_y", sectionTweenType, 0, ratingYin, posterTweenTime, true);
	}
	/*public function setBtnCast(bt:Button, scrollObj:ScrollingTextBox):Void {
	trace("   setBtnCast " + bt);
	_btnNextCopy = bt;
	this._btnNextCopy["mc"]["txt"].setTextFormat(ScrollingTextBox.style_fmt);
	currScrollObj = scrollObj;
	_btnNextCopy.onRelease = Delegate.create(this,replaceCopy);
	
	}*/
	/*private function replaceCopy():Void {
	trace("                       replace copy");
	currScrollObj.replaceWithNextCopy();
	}*/


}//