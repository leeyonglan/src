package functions.startup.controller{
	import com.adobe.crypto.MD5;
	
	import core.Core;
	import core.data.ResourceLoadType;
	import core.data.load.TextLoader;
	import core.events.CoreEventDispatcher;
	import core.events.ResourceEvent;
	import core.events.ServerEvent;
	import core.global.ConfigConnect;
	import core.net.Server;
	import core.patterns.command.SimpleOrder;
	import core.patterns.observer.INotification;
	import core.runner.ResourceRunner;
	import core.runner.StateRunner;
	import core.state.StateType;
	
	import events.DataEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import functions.app.view.AppMediator;
	
	import global.GameReport;
	
	import lang.ILanguage;
	
	import manager.LoginMessageManager;
	import manager.SharedObjectManager;
	
	
	/**
	 * 文件名：CoreStartupOrder.as
	 * <p>
	 * 功能：核心框架启动命令
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-12-17
	 * <p>
	 
	 * <p>
	 *  
	 */
	public class CoreStartupOrder extends SimpleOrder {
		private var app:App;
		private var urlLoader:URLLoader = new URLLoader();
		private var textLoader:TextLoader = new TextLoader();
		
		private var configCoreXML:XML;
		private var configConnectXML:XML;
		private var farmSilverXYXML:XML;
		private var areaConfigXML:XML;
		private var configXML:XML;
		private var layoutXML:XML;
		private var clientDataXML:Object;
		private var guideXML:XML;
		
		private var loadOK:Boolean = false;
		private var loginOK:Boolean = false;
		private var createPlayerOK:Boolean = false;
		
		public function CoreStartupOrder() {
			super();
		}
		
		private function loadCoreConfigCompleteHandler(event:Event):void {
			
			this.configCoreXML = XML(urlLoader.data);		
			// 初始化核心框架
			Core.init(this.configCoreXML, this.configConnectXML, app);
			CoreEventDispatcher.addEventListener(ResourceEvent.START_FIRST_LOAD, startFirstLoad);
			CoreEventDispatcher.addEventListener(ResourceEvent.FILE_LOADED, fileLoadedHandler);
			CoreEventDispatcher.addEventListener(ResourceEvent.LOAD_COMPLETE,fileLoadCompleteHandler);
			this.startAllLoad();
		}
		private function fileLoadCompleteHandler(event:ResourceEvent):void{
			if(event.loadType==ResourceLoadType.FIRST_LOAD){
				loadGameWorldCompleteHandler();
			}
		}
		
		private function startAllLoad():void {
			//初始化登录相关的消息
			LoginMessageManager.getInstant().init();
			// 监听加载情况
			CoreEventDispatcher.addEventListener(ServerEvent.CONNECTED, onServerConnected);
			CoreEventDispatcher.addEventListener(ResourceEvent.FILE_LOADED, fileLoadedHandler);				
			// 连接服务器
			Server.connect();
			ResourceRunner.loadMusic();
		}
		
		private function loadConnectConfigCompleteHandler(event:Event):void {
			this.configConnectXML = XML(urlLoader.data);
			//初始化连接配置类
			ConfigConnect.parseXML(configConnectXML);
			urlLoader.removeEventListener(Event.COMPLETE, loadConnectConfigCompleteHandler);
			urlLoader.addEventListener(Event.COMPLETE, loadCoreConfigCompleteHandler);
			urlLoader.load(new URLRequest("config/config_core.xml?" + MD5.hash(ConfigConnect.version)));
			SharedObjectManager.getInstance().setupSharedObject("sg2");
		}
		/**
		 * 连接上服务器再进行必要的加载
		 * @param e
		 *
		 */
		private function onServerConnected(e:ServerEvent):void {
			// 游戏启动，开始进行必要的加载
			loadLoginCompleteHandler();
		}
		
		/**
		 * 登录后开始的加载
		 * @param e
		 *
		 */
		private function startFirstLoad(e:Event):void {
			ResourceRunner.startFirstLoad();
			loadLoadingCompleteHandler();
			StateRunner.switchState(StateType.LODING);
		}
		
		private function fileLoadedHandler(event:ResourceEvent):void {
			var url:String = event.url;
			//检查是否配置过 资源服务器IP
			var resourceServerIndexOf:int = url.indexOf(ConfigConnect.resourceServer);
			if (resourceServerIndexOf >= 0) {
				url = url.substring(resourceServerIndexOf + ConfigConnect.resourceServer.length);
			}
			var arr:Array = url.split("/");
			var langDict:Dictionary = new Lang().dictionary;
			Core.setLanguageDict(langDict);
			if (arr[1] == "Layout.bin") {
				// 加载完成布局文件
				event.bytes.uncompress();
				var layoutStr:String = event.bytes.readMultiByte(event.bytes.bytesAvailable, "utf-8");
				layoutXML = new XML(layoutStr);
			} else if (arr[1] == "clientdata.dat") {
				event.bytes.uncompress();
				this.clientDataXML = event.bytes.readObject();
			} else if (arr[1] == "guide.xml") {
				loadGuideCompleteHandler(event.bytes);
			}else if (arr[1] == "areaconfig.xml") {
				textLoader.loadBytes(event.bytes, loadAreaConfigCompleteHandler);
			} else if(arr[1] == "farmsilverXY.xml"){
				textLoader.loadBytes(event.bytes, loadFarmSilverConfigHandler);
			}
	}
		
		private function loadLoadingCompleteHandler():void {
			var loading:Loading= app.loading?app.loading:new Loading();
			loading["init"](app);
			// 发送加载准备通知
			CoreEventDispatcher.dispatchEvent(new DataEvent(DataEvent.LOADING_MODULE_LOADED, this, app));
		}
		
		private function loadLoginCompleteHandler():void {
			var login:Login=app.login?app.login:new Login();
			login["init"](app);
			// 发送登录准备通知
			CoreEventDispatcher.dispatchEvent(new DataEvent(DataEvent.LOGIN_MODULE_LOADED, this, app));
		}
		
		
		private function loadLanguageCompleteHandler(language:ILanguage):void {
			Core.setLanguageDict(language.dictionary);
		}
		
		private function loadFirstAssetsCompleteHandler(first:Sprite):void {
			Core.setFirstAssets(first["dictionary"]);
		}
		
		private function loadSWFResourcesCompleteHandler(swf:Sprite):void {
			ResourceRunner.addResources(swf["dictionary"]);
		}
		
		private function loadGameWorldCompleteHandler():void {
			var gameWorld:GameWorld=new GameWorld();
			gameWorld["init"](app);
			// 发送游戏主体准备通知
			CoreEventDispatcher.dispatchEvent(new DataEvent(DataEvent.GAME_WORLD_MODULE_LOADED, this, {app:app, configXML:configXML, layoutXML:layoutXML, clientDataXML:clientDataXML, guideXML:guideXML,areaConfigXML:areaConfigXML, farmConfig:farmSilverXYXML}));
			CoreEventDispatcher.dispatchEvent(new DataEvent(DataEvent.LOGIN_ENTER_GAME));
		}
		
		private function loadGuideCompleteHandler(guideStr:String):void {
			guideXML = XML(guideStr);
		}
		private function loadFarmSilverConfigHandler(str:String):void{
			farmSilverXYXML = XML(str);
		}
		private function loadAreaConfigCompleteHandler( areaConfig:String ): void {
			areaConfigXML = XML( areaConfig );
		}
		override public function execute(note:INotification):void {
			super.execute(note);
			GameReport.getGameReport().initReport(0);
			app = note.body as App;
			registerMediator(new AppMediator(app));
			// 加载框架配置文件
			// 加载服务器连接配置文件
			urlLoader.addEventListener(Event.COMPLETE, loadConnectConfigCompleteHandler);
			urlLoader.load(new URLRequest("config/config_connect.xml?" + MD5.hash(new Date().toString())));
		}
		
		
	}
}