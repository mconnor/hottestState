﻿
//
//
///************* created by MIKE CONNOR -  programmer@rocketnumber9.com *****************
///                            July 2007
//PhotoClass 1.0
//

import mx.utils.Delegate;

import com.mammoth.*;
import mx.transitions.Tween;
import com.robertpenner.easing.*;

class com.mammoth.PhotoClass {


	public static var borderBottom:Number;
	public static var borderTop:Number;

	public static var borderL:Number;

	public static var borderR:Number;



	public var clip:MovieClip;
	//relative path to the thumbnail folder
	public static var pathThumb:String;
	public static var pathLarge:String;
	public static var photoPreLoaderSymbol:String;

	public var phototype:String;
	//url to small photos
	public var photoURL:String;
	//url to large photos
	public var photoLargeURL:String;

	private static var thumbnailYout:Number =800;

	// x and y of the container
	public static var containerX:Number;
	public static var containerY:Number;
	// the link name of the symbol in the library
	public static var photoFrameSymbolName:String;
	//space between thumbnails
	public static var spacerX:Number;
	public static var spacerY:Number;
	//thumbnail w and h
	public static var w:Number;
	public static var h:Number;

	public static var numofRows:Number;
	public static var numofCols:Number;
	private var bigPhotoClip:MovieClip;
	private var preloaderClip:MovieClip;

	private static var  _dimAlpha:Number;
	public var intervalID:Number;
	public var btn:Button;


	//x & y positon of clip when it is in
	private var xIn:Number;
	private var yIn:Number;


	public static var xClipOffset;
	public static var yClipOffset;
	public static var bigPhotoTweenType:Function;
	public static var bigPhotoTweenTime:Number;
	public static var bigPhotoXscaleStart:Number;
	public static var bigPhotoYscaleStart:Number;
	private var xBPhotoStart:Number;
	private var yBPhotoStart:Number;

	private var lastoneOut:Boolean;

	//private var cObj:Controller;

	function PhotoClass(st:String) {



		photoURL = PhotoClass.pathThumb + st;

		photoLargeURL = PhotoClass.pathLarge + st;


	}
	public function addPhoto(container:MovieClip, i:Number):MovieClip {
		//trace(container + "  addPhoto " + i);


		this.clip = container.attachMovie(PhotoClass.photoFrameSymbolName, PhotoClass.photoFrameSymbolName + i, container.getNextHighestDepth());
		this.clip["photoMC"].loadMovie(this.photoURL);

		this.btn = this.clip["bt"];
		this.btn.onRelease = Delegate.create(this, clickThumbnail);
		this.clip._visible = false;
		return this.clip;

	}
	public static function set dimAlpha(k:Number):Void {
		if (k >= 0 && k <= 100) {
			_dimAlpha = k;
		}
	}
	public static function get dimAlpha():Number {

		if (_dimAlpha == null) {
			_dimAlpha = 50;
		}

		return _dimAlpha;
	}
	public function place(x1:Number, y1:Number):Void {
		this.clip._x = x1;
		this.clip._y = y1;
		this.xIn = x1;
		this.yIn = y1;

	}
	private function clickThumbnail():Void {
		var cObj:Controller = Controller.getInstance();
		cObj.currentPhotoObj = this;
		cObj.photoSelected = true;
		cObj.disableOtherThumbnails();
		cObj.dimThumbnails();

		var midX = Math.floor(cObj.photoContainer._width / 2);
		var midY = Math.floor(cObj.photoContainer._height / 2);
		// load preloader into the main clip
		//this.preloaderClip = cObj.photosMainClip.attachMovie(PhotoClass.photoPreLoaderSymbol, PhotoClass.photoPreLoaderSymbol, cObj.photosMainClip.getNextHighestDepth(), {_x:midX, _y:midY});

		//this.preloaderClip = this.clip.attachMovie(PhotoClass.photoPreLoaderSymbol, PhotoClass.photoPreLoaderSymbol, this.clip.getNextHighestDepth(), {_x:Math.floor(PhotoClass.xClipOffset + this.clip._width / 2), _y:Math.floor(PhotoClass.yClipOffset + this.clip._height / 2 - 10)});
		this.preloaderClip = this.clip.attachMovie(PhotoClass.photoPreLoaderSymbol, PhotoClass.photoPreLoaderSymbol, this.clip.getNextHighestDepth(), {_x:150, _y:100});



		this.bigPhotoClip = cObj.photosMainClip.createEmptyMovieClip("bigPhotoClip", cObj.photosMainClip.getNextHighestDepth());

		//this.bigPhotoClip = cObj.photoContainer.createEmptyMovieClip("bigPhotoClip", cObj.photoContainer.getNextHighestDepth());




		//load large photo
		var mclListener:Object = new Object();
		mclListener.onLoadInit = Delegate.create(this, centerPhoto);
		var image_mcl:MovieClipLoader = new MovieClipLoader();
		image_mcl.addListener(mclListener);
		image_mcl.loadClip(this.photoLargeURL,this.bigPhotoClip);
	}
	private function centerPhoto():Void {
		this.preloaderClip.removeMovieClip();


		var cObj:Controller = Controller.getInstance();
		//this.bigPhotoClip._x = Math.floor((cObj.photosMainClip._width / 2) - (this.bigPhotoClip._width / 2));
		var x2:Number = Math.floor((cObj.photosMainClip._width / 2) - (this.bigPhotoClip._width / 2) - 22);
		//var bottomYLogo:Number = 142;


		var bottomYLogo:Number = 110;


		//this.bigPhotoClip._y = Math.floor(bottomYLogo + ((cObj.photosMainClip._height - bottomYLogo) / 2) - (this.bigPhotoClip._height / 2));
		var y2:Number = Math.floor(bottomYLogo + ((cObj.photosMainClip._height - bottomYLogo) / 2) - (this.bigPhotoClip._height / 2));

		///PhotoClass.containerX
		//this.bigPhotoClip._x = this.clip._x + PhotoClass.xClipOffset +  PhotoClass.containerX;
		//this.bigPhotoClip._y = this.clip._y + PhotoClass.yClipOffset +  PhotoClass.containerY;

		//xBPhotoStart = this.clip._x + PhotoClass.xClipOffset + PhotoClass.containerX + PhotoClass.borderTop;
		//yBPhotoStart = this.clip._y + PhotoClass.yClipOffset + PhotoClass.containerY + PhotoClass.borderL;
		xBPhotoStart = this.clip._x + PhotoClass.xClipOffset + PhotoClass.containerX - 2;
		yBPhotoStart = this.clip._y + PhotoClass.yClipOffset + PhotoClass.containerY + 2;


		/*bigPhotoClip._width = this.clip._width;
		bigPhotoClip._height = this.clip._height;*/

		bigPhotoClip._width = PhotoClass.w - (PhotoClass.borderL + PhotoClass.borderR);
		bigPhotoClip._height = PhotoClass.h - (PhotoClass.borderTop + PhotoClass.borderBottom);
		PhotoClass.bigPhotoXscaleStart = bigPhotoClip._xscale;
		PhotoClass.bigPhotoYscaleStart = bigPhotoClip._yscale;

		var xscaleTween:Tween = new Tween(bigPhotoClip, "_xscale", PhotoClass.bigPhotoTweenType, PhotoClass.bigPhotoXscaleStart, 100, PhotoClass.bigPhotoTweenTime, true);
		var yscaleTween:Tween = new Tween(bigPhotoClip, "_yscale", PhotoClass.bigPhotoTweenType, PhotoClass.bigPhotoYscaleStart, 100, PhotoClass.bigPhotoTweenTime, true);
		var xTween:Tween = new Tween(bigPhotoClip, "_x", PhotoClass.bigPhotoTweenType, xBPhotoStart, x2, PhotoClass.bigPhotoTweenTime, true);
		var yTween:Tween = new Tween(bigPhotoClip, "_y", PhotoClass.bigPhotoTweenType, yBPhotoStart, y2, PhotoClass.bigPhotoTweenTime, true);
		
		//var xAlpha:Tween = new Tween(bigPhotoClip, "_alpha", PhotoClass.bigPhotoTweenType, 25, 100, PhotoClass.bigPhotoTweenTime*.8, true);
		
		
		
		bigPhotoClip._x = xBPhotoStart;
		bigPhotoClip._y = yBPhotoStart;

		this.bigPhotoClip.onRelease = Delegate.create(this, killBigPhoto);

	}
	public function killBigPhoto():Void {

		var xscaleTween:Tween = new Tween(bigPhotoClip, "_xscale", PhotoClass.bigPhotoTweenType, 100, PhotoClass.bigPhotoXscaleStart, PhotoClass.bigPhotoTweenTime, true);
		var yscaleTween:Tween = new Tween(bigPhotoClip, "_yscale", PhotoClass.bigPhotoTweenType, 100, PhotoClass.bigPhotoYscaleStart, PhotoClass.bigPhotoTweenTime, true);

		var xTween:Tween = new Tween(bigPhotoClip, "_x", PhotoClass.bigPhotoTweenType, bigPhotoClip._x, xBPhotoStart, PhotoClass.bigPhotoTweenTime, true);
		var yTween:Tween = new Tween(bigPhotoClip, "_y", PhotoClass.bigPhotoTweenType, bigPhotoClip._y, yBPhotoStart, PhotoClass.bigPhotoTweenTime, true);
		//var xAlpha:Tween = new Tween(bigPhotoClip, "_alpha", PhotoClass.bigPhotoTweenType, 100, 25, PhotoClass.bigPhotoTweenTime*.8, true);
		
		xTween.onMotionFinished = Delegate.create(this, removephoto);

		trace("killBigPhoto bigPhotoClip" + this.bigPhotoClip);

		//this.bigPhotoClip.removeMovieClip();

		var cObj:Controller = Controller.getInstance();
		cObj.dimThumbnailsOut();
		cObj.photoSelected = false;
	}
	private function removephoto():Void {
		this.bigPhotoClip.removeMovieClip();
		var cObj:Controller = Controller.getInstance();
		cObj.enableOtherThumbnails(this);
	}
	public function bringInthumbnail(bool):Void {


		var tweenIn:Tween = new Tween(this.clip, "_y", Cubic.easeInOut, PhotoClass.thumbnailYout, this.yIn, .75, true);
		this.clip._visible = true;
		if (bool) {
			tweenIn.onMotionFinished = Delegate.create(this, navEnable);
		}

	}
	private function navEnable():Void {
		trace("bringInthumbnail renableButtons");
		var cObj:Controller = Controller.getInstance();
		cObj.renableButtons();
	}
	public function bringOutthumbnail(bool:Boolean):Void {
		var tweenIn:Tween = new Tween(this.clip, "_y", Cubic.easeInOut, this.yIn, PhotoClass.thumbnailYout, .75, true);
		if (bool) {
			lastoneOut = true;
		}
		tweenIn.onMotionFinished = Delegate.create(this, visOff);




	}
	private function visOff():Void {
		//this.clip._visible = false;
		var cObj:Controller = Controller.getInstance();
		if (lastoneOut) {
			cObj.jumptoNextFrame();
		}
	}

}