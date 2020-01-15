persistantMC._y = -800;

import com.mammoth.*;
import mx.transitions.Tween;
import com.robertpenner.easing.*;

var shellObj:ShellClass = ShellClass.getInstance();
shellObj.init(this, 3, "poster");

//shellObj.setPreloader("preloader", 440,362);

shellObj.setDebugLevel(3);
shellObj.loadConfig("config.xml");
PhotoClass.pathThumb = "photos/";
PhotoClass.pathLarge = "photosLarge/";

//x and y of the 
//PhotoClass.containerX = 154;
PhotoClass.containerX = 16;
PhotoClass.containerY = 174;
//PhotoClass.spacerX = 50;
//PhotoClass.spacerY = 14;

PhotoClass.spacerX = 16;
PhotoClass.spacerY = 20;

//
//PhotoClass.w = 133;
//PhotoClass.h = 91;

PhotoClass.w = 213;
PhotoClass.h = 146;

//library symbol that is big photo preloader
PhotoClass.photoPreLoaderSymbol = "photoLoadingMC";
PhotoClass.numofRows = 3;
PhotoClass.numofCols = 4;
PhotoClass.dimAlpha=75;

//PhotoClass.xClipOffset= 106;
//PhotoClass.yClipOffset= 72;
PhotoClass.xClipOffset= 50;
PhotoClass.yClipOffset= 32;
PhotoClass.bigPhotoTweenType  = Quad.easeInOut;
PhotoClass.bigPhotoTweenTime = .5;
PhotoClass.bigPhotoXscaleStart = 30;
PhotoClass.bigPhotoYscaleStart = 30;

PhotoClass.borderBottom =8;
PhotoClass.borderTop=8;
PhotoClass. borderL=8;
PhotoClass.borderR=8;
PhotoClass.photoFrameSymbolName = "photoFrame";
stop();
