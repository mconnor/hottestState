//
//************ created by Mike Connor - programmer@rocketnumber9.org *************
//                   July 2007
//        NAVIGATION 1.1
//
import TextField.StyleSheet;
import com.mammoth.*;
import mx.utils.Delegate;
import mx.transitions.Tween;
import com.robertpenner.easing.*;
class com.mammoth.ScrollingTextBox {

	public var tf:TextField;
	private var holdTF:TextField;
	private var holdTF2:TextField;
	// text field for the nav
	private var tfNext:TextField;

	public var clip:MovieClip;

	private var scrollerClip:MovieClip;

	private var scrollCursor:MovieClip;
	private var scrollCursorOrigY:Number;

	private var scrollBar:MovieClip;

	private var tfClip:MovieClip;

	private var slideFlag:Boolean;
	private var newTextFlag:Boolean;
	private var newTextFlag2:Boolean;

	private var yOffSet:Number;
	private var topStop:Array;
	//index val of the topstop array
	private var topStopIndex:Number;

	private var bottomStop:Number;

	private var clipH:Number;
	private var oldxmouse:Number;

	//private var my_styleSheet:StyleSheet;
	//public  static var ScrollingTextBox.style_fmt:TextFormat;
	public  static var  style_fmt:TextFormat = new TextFormat();
	public  static var  hiliteColor:Number = 0xAB0022;


	private var copyString:String;
	private var nextCopyString:String;

	private var _mcNextCopy:MovieClip;

	private var nextBTcopy1:String;
	private var nextBTcopy2:String;
	private var nextBTFlag:Boolean;


	private var origYtfClip:Number;
	//private var ishtml:Boolean;

	public static var my_styleSheet:StyleSheet;

	//this.aboutMC.btCast
	function ScrollingTextBox(mc:MovieClip, ymargin:Number, w:Number, mcNexxt:MovieClip, btcopy1:String, btcopy2:String) {
		//createAboutStyle();
		topStop = new Array();
		topStopIndex = 0;
		this.clip = mc;
		clipH = this.clip._height;
		this.yOffSet = ymargin;
		bottomStop = yOffSet;

		this.tfClip = this.clip["tfMC"];

		origYtfClip = this.tfClip._y;
		slideFlag = true;

		//ishtml = bool
		newTextFlag = true;
		newTextFlag2 = true;


		//this.tf = new TextField();
		this.tf = this.tfClip.createTextField("tf", 10, 0, 0, w, 800);

setTFprops(this.tf);



	/*	tf.autoSize = "left";
		tf.embedFonts = true;
		tf.html = true;
		tf.antiAliasType = "advanced";
		tf.selectable = false;
		tf.wordWrap = true;
		tf.multiline = true;
		tf.gridFitType = "pixel";
this.tf.autoSize = "left";*/


		this.scrollerClip = this.clip["scrollbarMC"];
		this.scrollCursor = this.scrollerClip["scroller"];
		this.scrollCursorOrigY = this.scrollCursor._y;
		this.scrollBar = this.scrollerClip["bar"];

		//topStop = clipH - this.tfClip._height - yOffSet;

		trace("scrollCursor   =" + scrollCursor);

		this.scrollCursor.onPress = Delegate.create(this, scrollCopy);

		/*scrollCursor.onRollOver = function() {
		trace("++++   rollover scrollCursor ");
		};*/
		scrollCursor.onRelease = scrollCursor.onReleaseOutside = Delegate.create(this, stopScroll);
		//more than 1 set of copy
		if (mcNexxt != null) {

			this.holdTF = this.tfClip.createTextField("holdTF", 5, Stage.width, 0, w, 800);
			this.holdTF2 = this.tfClip.createTextField("holdTF", 6, Stage.width, 0, w, 800);
setTFprops(this.holdTF);
setTFprops(this.holdTF2);

			this.holdTF.setNewTextFormat(ScrollingTextBox.style_fmt);
			this.holdTF2.setNewTextFormat(ScrollingTextBox.style_fmt);


			nextBTFlag = true;
			this.nextBTcopy1 = btcopy1;
			this.nextBTcopy2 = btcopy2;
			trace("   nextBTcopy2   " + nextBTcopy2);

			//trace("   setBtnCast " + mcNexxt);
			_mcNextCopy = mcNexxt;

			this.tfNext = this._mcNextCopy.createTextField("tf", 20, 0, 0, 200, 18);
			tfNext.autoSize = "left";
			tfNext.embedFonts = true;
			tfNext.bold = true;
			tfNext.html = true;
			tfNext.antiAliasType = "advanced";
			tfNext.selectable = false;
			tfNext.wordWrap = false;
			tfNext.multiline = false;
			tfNext.gridFitType = "pixel";


			//this.tfNext.setNewTextFormat(ScrollingTextBox.style_fmt);


			//ScrollingTextBox.style_fmt.underline = true;
			ScrollingTextBox.style_fmt.color = ScrollingTextBox.hiliteColor;


			this.tfNext.htmlText = nextBTcopy1;
			this.tfNext.setTextFormat(ScrollingTextBox.style_fmt);
			ScrollingTextBox.style_fmt.underline = false;
			ScrollingTextBox.style_fmt.color = 0x000000;


			//trace("      --         this._mcNextCopy   " + this._mcNextCopy);
			//_mcNextCopy["bt"]._width = this.tfNext.textWidth;
			_mcNextCopy["bt"].onRelease = Delegate.create(this, replaceWithNextCopy);

		}
	}
	/*public static function loadStyleSheet(url:String):Void {
	my_styleSheet.onLoad = Delegate.create(this, onloadStyleSheet);
	my_styleSheet.load(url);
	}
	
	private static onloadStyleSheet():Void {
	
	}*/



	private function scrollCopy():Void {
		trace("                   scroll copy");
		this.scrollCursor.startDrag(false,0,0,0,this.scrollBar._height - scrollCursor._height);

		//if (slideFlag) {
		tfClip.onEnterFrame = Delegate.create(this, slideCopy);
		//}
	}
	private function stopScroll():Void {
		trace("stopScroll " + tfClip._height);
		this.scrollCursor.stopDrag();
		killSlide();
	}
	private function slideCopy():Void {
		//slideFlag = false;
		trace("topStop[topStopIndex] " + topStop[topStopIndex]);
		trace("topStopIndex] " + topStopIndex);

		var scrollPercetage:Number = (scrollCursor._y / (scrollBar._height - scrollCursor._height));
		var targetRange:Number = bottomStop - topStop[topStopIndex];
		var targetY:Number = topStop[topStopIndex] + (targetRange * (1 - scrollPercetage));

		//ease it into that position
		this.tfClip._y = Math.floor(this.tfClip._y - (this.tfClip._y - targetY) / 10);

	}
	private function killSlide():Void {
		delete this.tfClip.onEnterFrame;
	}
	public function addText(st:String, hyperlinkBool:Boolean, lastcopy:Boolean):Void {

		if (hyperlinkBool) {
			//trace("  hyper link " + st);
			ScrollingTextBox.style_fmt.color = ScrollingTextBox.hiliteColor;
			//ScrollingTextBox.style_fmt.underline = true;
			this.tf.setNewTextFormat(ScrollingTextBox.style_fmt);

		} else {
			ScrollingTextBox.style_fmt.color = 0x000000;
			ScrollingTextBox.style_fmt.underline = false;

			this.tf.setNewTextFormat(ScrollingTextBox.style_fmt);

		}
		//trace(st);
		if (newTextFlag) {
			newTextFlag = false;
			//copyString = st;
			this.tf.htmlText = st;

		} else {
			//copyString += st;
			this.tf.htmlText += st;
		}
		if (lastcopy) {
			//insertCopy(copyString);
			//this.tf.htmlText = copyString;
			////HACK
			holdTF.htmlText = this.tf.htmlText;
			trace("            this.tf.textHeight " + this.tf.textHeight);
			trace("            this.tfClip._height " + this.tfClip._height);

			
			trace("  clipH   "   +clipH);
			//topStop = clipH - this.tfClip._height - yOffSet;
			topStop.push(clipH - this.tf.textHeight - yOffSet);
			trace("topStop  " + topStop[topStop.length -1]);

			/*if (this.tfClip._height < clipH) {
			scrollCursor.onPress = null;
			}*/
		}
		//trace("clipH "+ clipH);                           
		//trace("this.tfClip._height "+this.tfClip._height);
	}
	/*private function insertCopy(st:String):Void {
	reset();
	this.tf.htmlText = st;
	
	trace("            this.tf.textHeight " + this.tf.textHeight);
	topStop = clipH - this.tfClip._height - yOffSet;
	if (this.tfClip._height < clipH) {
	scrollCursor.onPress = null;
	}
	}*/
	/*public function nextCopy(st:String):Void {
	if (newTextFlag2) {
	newTextFlag2 = false;
	nextCopyString = st;
	} else {
	nextCopyString += st;
	}
	}
	*/


	public function nextCopy(st:String, hyperlinkBool:Boolean, lastcopy:Boolean):Void {

		if (hyperlinkBool) {
			trace("  hyper link " + st);
			ScrollingTextBox.style_fmt.color = ScrollingTextBox.hiliteColor;
			//ScrollingTextBox.style_fmt.underline = true;
			this.holdTF2.setNewTextFormat(ScrollingTextBox.style_fmt);

		} else {
			ScrollingTextBox.style_fmt.underline = false;
			ScrollingTextBox.style_fmt.color = 0x000000;
			this.holdTF2.setNewTextFormat(ScrollingTextBox.style_fmt);

		}
		//trace(st);
		if (newTextFlag2) {
			newTextFlag2 = false;
			//copyString = st;
			this.holdTF2.htmlText = st;

		} else {
			//copyString += st;
			this.holdTF2.htmlText += st;
		}
		if (lastcopy) {
			trace("  clipH   "   +clipH);
			topStop.push(clipH - this.holdTF2.textHeight - yOffSet);
			trace("lastcopy topStop  " + topStop[topStop.length -1]);
		}
	}

	public function replaceWithNextCopy():Void {
		reset();
		if (nextBTFlag) {
			//insertCopy(nextCopyString);
			this.tf.htmlText = this.holdTF2.htmlText;
			this.tfNext.htmlText = nextBTcopy2;

			topStopIndex = 1;
			trace("set topStopIndex =" + topStopIndex);
		} else {
			topStopIndex = 0;
			trace("set topStopIndex =" + topStopIndex);
			//insertCopy(copyString);
			this.tf.htmlText = this.holdTF.htmlText;
			this.tfNext.htmlText = nextBTcopy1;
		}
		//ScrollingTextBox.style_fmt.underline = true;
		ScrollingTextBox.style_fmt.color = ScrollingTextBox.hiliteColor;

		this.tfNext.setTextFormat(ScrollingTextBox.style_fmt);
		ScrollingTextBox.style_fmt.underline = false;
		ScrollingTextBox.style_fmt.color = 0x000000;



		nextBTFlag = !nextBTFlag;

		_mcNextCopy["bt"]._width = this.tfNext.textWidth;

	}
	public function reset():Void {
		this.tfClip._y = origYtfClip;
		this.scrollCursor.stopDrag();
		this.scrollCursor._y = this.scrollCursorOrigY;
	}
	
	private function setTFprops(tfield:TextField):Void {
			tfield.autoSize = "left";
		tfield.embedFonts = true;
		tfield.html = true;
		tfield.antiAliasType = "advanced";
		tfield.selectable = false;
		tfield.wordWrap = true;
		tfield.multiline = true;
		tfield.gridFitType = "pixel";
tfield.autoSize = "left";
		
	}
	/*public function enableScroller():Void {
	if (this.tfClip._height < clipH) {
	//scrollCursor.onPress = null;
	}
	}*/

	/*private function createAboutStyle():Void {
	var styleObj:Object = new Object();
	styleObj.color = "#000000";
	styleObj.fontWeight = "bold";
	my_styleSheet.setStyle("emphasized",styleObj);
	}
	*/


}