package functions.smallLoading.view {
	import core.global.ConfigConnect;
	import core.patterns.mediator.Mediator;
	import core.patterns.observer.INotification;
	import core.runner.LayerRunner;
	import core.runner.ResourceRunner;
	
	import flash.events.ProgressEvent;
	
	import global.NotificationType;
	
	import gs.TweenLite;
	
	import manager.LayerManager;
	
	/**
	 * 文件名：SmallLoadingMediator.as
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
	public class SmallLoadingMediator extends Mediator {
		private var current:int = 0;
		private var total:int = 0;
		private var isLoading:Boolean = false;
		private var smallLoadingView:SmallLoading;
		private var completeFunction:Function;
		private var completeParams:Array;
		private var loadResources:Array;
		
		public function SmallLoadingMediator(viewComponent:*) {
			super(viewComponent);
			this.smallLoadingView = new SmallLoading();
		}
		
		override public function configNotifications():void {
			super.configNotifications();
			this.subscribeNotification(NotificationType.START_SMALL_LOADING, onStartSmallLoading);
			this.subscribeNotification(NotificationType.SHOW_SMALL_LOADING, onShowSmallLoading);
			this.subscribeNotification(NotificationType.HIDE_SMALL_LOADING, onHideSmallLoading);
		}
		
		private function onStartSmallLoading(note:INotification):void {
			this.showSmallLoadingView();
			//要加载的资源队列
			var resources:Array = note.body as Array;
			// 完成回调函数
			var completeCallBack:Function = note.type as Function;
			// 完成回调函数的参数						
			var completeParams:Array = note.args as Array;
			
			if (resources == null || resources.length <= 0 || this.isLoading == true) {
				return ;
			}
			this.loadResources = resources;
			this.completeFunction = completeCallBack;
			this.completeParams = completeParams;
			this.isLoading = true;
			this.startLoad();
		}
		
		private function startLoad():void {
			this.showSmallLoadingView();
			total = this.loadResources.length;
			this.adjustBarWidth(1);
			this.loadeOne()
			
		}
		
		private function loadeOne():void {
			var url:String = this.loadResources.shift();
			if(url == "newWorld.swf")
			{
				url = "newWorld/world_bg.jpg";
			}
			if(url == "farm.swf")
			{
				url = "farm/300699.jpg";
			}
			if(url == "area.swf")
			{
				url = "area/map/20001.jpg";
			}
			var fileNameArray:Array = url.split("/");
			var fileName:String = fileNameArray[fileNameArray.length - 1];
			var extName:String = fileName.split(".")[1];
			switch (extName) {
				case "swf":
					ResourceRunner.getSprite(url, onFileLoadComplete, null, progressHandler);
					break;
				case "jpg":
					ResourceRunner.getBitmapData(url, onFileLoadComplete);
					break;
				case "png":
					ResourceRunner.getBitmapData(url, onFileLoadComplete);
					break;
			}
			
		}
		
		private function progressHandler(event:ProgressEvent):void {
			var prop:Number = event.bytesLoaded / event.bytesTotal;
			var _width:Number = prop * this.smallLoadingView.bar.width;
			TweenLite.to(this.smallLoadingView.barMask, 0.3, {width:_width, onUpdate:function():void {
//				smallLoadingView.highLight.x = smallLoadingView.barMask.x + smallLoadingView.barMask.width - smallLoadingView.highLight.width / 2-8;
//				smallLoadingView.highLight.y = smallLoadingView.barMask.y - 17;
			}});
		}
		
		private function adjustBarWidth(value:Number):void {
			this.smallLoadingView.barMask.width = value;
			this.smallLoadingView.highLight.x = this.smallLoadingView.barMask.x + this.smallLoadingView.barMask.width - this.smallLoadingView.highLight.width / 2;
			this.smallLoadingView.highLight.y = this.smallLoadingView.barMask.y - 17;
		}
		
		private function onFileLoadComplete(r:*):void {
			current++;
			this.adjustBarWidth(1);
			
			if (current == total) {
				if (this.completeFunction != null) {
					this.completeFunction.apply(null, this.completeParams);
				}
				this.stopLoad();
			} else {
				this.loadeOne();
			}
		}
		
		private function stopLoad():void {
			current = 0;
			total = 0;
			isLoading = false;
			this.loadResources = [];
			this.hideSmallLoadingView();
		}
		
		private function showSmallLoadingView():void {
			if (!this.viewComponent.contains(this.smallLoadingView)) {
				this.smallLoadingView.start();
				this.viewComponent.addChild(this.smallLoadingView);
			}
		}
		
		private function hideSmallLoadingView():void {
			if (this.viewComponent.contains(this.smallLoadingView)) {
				this.smallLoadingView.stop();
				this.viewComponent.removeChild(this.smallLoadingView);
			}
		}
		
		private function onShowSmallLoading(note:INotification):void {
			this.showSmallLoadingView();
			//加载时不显示引导
			LayerRunner.guideLayer.visible = false;
		}
		
		private function onHideSmallLoading(note:INotification):void {
			if (this.viewComponent.contains(this.smallLoadingView)){
				this.hideSmallLoadingView();
				//加载时不显示引导
				LayerRunner.guideLayer.visible = true;
			}
		}
	}
}