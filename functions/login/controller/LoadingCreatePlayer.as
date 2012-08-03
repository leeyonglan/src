package functions.login.controller {
	import core.Core;
	import core.data.load.ByteArrayLoader;
	import core.data.load.SWFLoader;
	import core.net.Server;
	import core.patterns.command.SimpleOrder;
	import core.patterns.observer.INotification;
	import core.runner.LayerRunner;
	import core.runner.StateRunner;
	import core.state.StateType;
	
	import flash.utils.ByteArray;
	
	import global.Config;
	
	/**
	 * 文件名：LoadingCreatePlayer.as
	 * <p>
	 * 功能：
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：May 31, 2011
	 * <p>
	 * 
	 * <p>
	 *  
	 */
	public class LoadingCreatePlayer extends SimpleOrder {
		private var createPlayerByteLoader:ByteArrayLoader;
		private var createPlayerSWFLoader:SWFLoader;
		
		public function LoadingCreatePlayer() {
			super();
		}
		
		override public function execute(note:INotification):void {
			super.execute(note);
			var cp:CreatePlayer = new CreatePlayer();
			loadCreatePlayerComplete(cp);
		}
		
		private function onByteLoaderComplete(_data:ByteArray):void {
			createPlayerSWFLoader = new SWFLoader();
			createPlayerSWFLoader.loadBytes(_data, loadCreatePlayerComplete);
		}
		
		private function loadCreatePlayerComplete(cp:*):void {
			Core.app["createPlayer"] = cp;
			cp["init"](Server, createPlayerOK);
			// 将加载界面放入加载层
			LayerRunner.loginLayer.addChild(cp);
			StateRunner.switchState(StateType.LOGIN);
		}
		
		private function createPlayerOK(name:String, isMale:Boolean, isFocus:Boolean):void {
		}
	}
}