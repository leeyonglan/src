package
{
	import core.global.ConfigConnect;
	import core.patterns.Facade.IContext;
	import core.runner.LayerRunner;
	import facade.AppContext;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.StageOrientationEvent;
	import flash.system.Capabilities;
	import flash.net.URLRequest;
	
	/**
	 * <p>
	 * 功能：游戏基本主体，负责初始化框架和游戏
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * <p>
	 *  
	 */
	[SWF(width="1024", height="768", frameRate="24", backgroundColor="#000000")]
	public class App extends Sprite
	{
		public var loginContext:IContext;
		public var loadingContext:IContext;
		public var gameWorldContext:IContext;
		public var battleContext:IContext;
		
		public var login:*;
		public var loading:*;
		public var createPlayer:*;
		public var createPlayerComplex:*;
		public var gameWorld:*;
		public var battle:*;
		public var groupBattle:*;
		public var campaignBattle:*;
		private var gameLogo:Loader;
		
		private var loadingMc:MovieClip;
		
		public static const VERSION:String = "0.1";	
		public function App() {
			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE,orientationChangeHandler);
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING,orientationChangingHandler);
			//开始初始化游戏
			new AppContext().startup(this);
		}	
		public function showLogo():void {
			gameLogo = new Loader();
			
			gameLogo.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			gameLogo.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			gameLogo.load(new URLRequest(ConfigConnect.logoPath));
		}		
		private function onComplete(e:Event):void {
			
			if (gameLogo != null) {
				LayerRunner.tipLayer.addChild(gameLogo);
				gameLogo.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
				gameLogo.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
				loadingMc = gameLogo.content as MovieClip;
				if(loadingMc != null){
					loadingMc.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
			}		
		}
		
		private function onError(e:IOErrorEvent):void {
			gameLogo.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			gameLogo.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			gameLogo = null;
		}
		
		private function onEnterFrame(e:Event):void {
			
			if (loadingMc.totalFrames == loadingMc.currentFrame) {
				ConfigConnect.LogoTime --;
				
				if (ConfigConnect.LogoTime == 0) {
					stop();
				}
			}
		}		
		private function stop():void {
			loadingMc.stop();
			
			loadingMc.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if(gameLogo != null){
				gameLogo.parent.removeChild(gameLogo);
			}
			gameLogo = null;
			loadingMc = null;
		}
		private function orientationChangingHandler(event:StageOrientationEvent):void{
			//			for each(var key:String in OrientationsList){
			//				if(event.afterOrientation == key){
			//					event.preventDefault();
			//					break;
			//				}
			//			}
			if(event.afterOrientation == StageOrientation.DEFAULT || event.afterOrientation == StageOrientation.UPSIDE_DOWN ){
				event.preventDefault();
			}
		}
		
		private function orientationChangeHandler(event:StageOrientationEvent):void{
			if(event.afterOrientation == StageOrientation.DEFAULT || event.afterOrientation == StageOrientation.UPSIDE_DOWN ){
				stage.setOrientation(StageOrientation.ROTATED_LEFT);
			}
			trace(event.afterOrientation,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			//			if(OrientationsList.length<1 && event.afterOrientation == StageOrientation.DEFAULT){
			//				if(Capabilities.screenResolutionX>Capabilities.screenResolutionY){
			//					OrientationsList.push(StageOrientation.ROTATED_LEFT,StageOrientation.ROTATED_RIGHT);
			//				}else{
			//					OrientationsList.push(StageOrientation.DEFAULT,StageOrientation.UPSIDE_DOWN);
			//				}
			//			}
			
		}
	}
}