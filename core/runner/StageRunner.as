package core.runner
{
	import core.display.components.MouseEffectiveComponent;
	import core.global.ConfigConnect;
	import core.utils.ObjectPool;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import manager.DebugManager;

	/**
	 * 文件名：StageRunner.as
	 * <p>
	 * 功能：舞台管理者，只负责保管一个舞台引用
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-26
	 * <p>
	  
	 * <p>
	 *  
	 */
	public class StageRunner
	{
		/**
		 * 整个Flash的全局舞台
		 */		
		public static var stage:Stage;
		
		public static var stageWidth:int;

		public static var stageHeight:int;
		/**
		 * 整个游戏显示层次的根节点
		 */		
		public static var root:Sprite;
		
		public function StageRunner()
		{
		}
		/**
		 * 初始化
		 * @param stage 舞台引用
		 */		
		public static function init(stage:Stage):void {
			// 设置舞台引用和根节点引用
			StageRunner.stage = stage;
			stageWidth = StageRunner.stage.stageWidth;
			stageHeight = StageRunner.stage.stageHeight;
			root = new Sprite();
			stage.addChild(root);
			
			// 注册鼠标事件，为MouseEffectiveComponent及其子类提供鼠标事件
			stage.addEventListener(MouseEvent.MOUSE_OVER, mouseEffectHandler);
			stage.addEventListener(MouseEvent.MOUSE_OUT, mouseEffectHandler);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEffectHandler);
			stage.addEventListener(MouseEvent.CLICK, mouseEffectHandler);

		}
		
		private static function mouseEffectHandler(event:*):void {
			if(event.target is InteractiveObject && InteractiveObject(event.target).mouseEnabled) {
				transferMouseEvent(event.target as DisplayObject, event);
			}
		}
		private static function transferMouseEvent(target:DisplayObject, event:*):void {
			if(target == null) return;
			if(target is MouseEffectiveComponent) {
				// 转换localX和localY属性
				var point:Point = ObjectPool.borrow(Point);
				point.x = event.stageX;
				point.y = event.stageY;
				point = target.globalToLocal(point);
				event.localX = point.x;
				event.localY = point.y;
				ObjectPool.dispose(point);
				// 转发事件
				MouseEffectiveComponent(target).mouseEffect(event);
			}
			// 递归转发事件，模拟冒泡过程
			if(event.bubbles && (!event.cancelable || !event.isDefaultPrevented())) {
				transferMouseEvent(target.parent, event);
			}
		}
	}
}