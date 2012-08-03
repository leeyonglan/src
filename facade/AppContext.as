package facade {
	import core.patterns.Facade.Context;
	import core.patterns.Facade.IContext;
	
	import flash.utils.setTimeout;
	
	import functions.startup.controller.CoreStartupOrder;
	import global.NotificationType;
	import net.message.custom.server2client.LoginSendMessage;
	
	/**
	 * 文件名：AppContext.as
	 * <p>
	 * 功能：框架上下文，负责初始化并启动游戏框架
	 * <p>
	 * 版本：1.0.0
	 * <p>
	  
	 * <p>
	 *  
	 */
	public final class AppContext extends Context implements IContext {
		
		public function AppContext() {
			super();
		}
		
		/**
		 * 注册所有Order
		 */
		override protected function initController():void {
			super.initController();
			LoginSendMessage;	
			registerOrder(NotificationType.CORE_STARTUP,CoreStartupOrder);
		}
		
		/**
		 * 启动整个游戏框架
		 * @param app 游戏引用
		 */
		public function startup(app:App):void {
			// 此方法只发出一个框架启动通知
			//延时启动  防止在TT浏览起中 不能调用js
			setTimeout(function():void{sendNotification(NotificationType.CORE_STARTUP, app);},1);	
		}
	}
}