package
{
	import core.display.BitmapProxy;
	import core.events.CoreEventDispatcher;
	import core.events.GameStateEvent;
	import core.global.ConfigConnect;
	import core.state.StateType;
	
	import facade.LoginContext;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import functions.login.view.LoginBox;
	
	
	/**
	 * 文件名：Login.as
	 * <p>
	 * 功能：该类为登录界面，为主游戏内容被加载前就要显示的，因此必须自己生成一个swf文件
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-17
	 * <p>
	  
	 * <p>
	 *  
	 */
	public class Login extends Sprite
	{
		public var loginBG:BitmapProxy;
		public var loginBox:LoginBox;
		
		public function Login()
		{  
			super();
			CoreEventDispatcher.addEventListener(GameStateEvent.GAME_STATE_SWITCH_IN, gameStateSwitchInHandler);
			CoreEventDispatcher.addEventListener(GameStateEvent.GAME_STATE_SWITCH_OUT, gameStateSwitchOutHandler);
		}
		public function init(app:App):void {
			app.loginContext = new LoginContext();
			app.login = this;
			
			loginBG = new BitmapProxy();
			this.addChild(loginBG);
			
			loginBox = new LoginBox();
			loginBox.alpha = 1;
			addChild(loginBox);
		}
		
		private function gameStateSwitchInHandler(event:GameStateEvent):void {
			if(event.stateType == StateType.LOGIN) {
				//loginBG.url = ConfigConnect.LangType + "";
			}
		}
		private function gameStateSwitchOutHandler(event:GameStateEvent):void {
			if(event.stateType == StateType.LOGIN) {
				loginBG.url = null;
			}
		}
		private function loadBGOKHandler(bg:MovieClip):void {
			addChildAt(bg, 0);
			bg.play();
		}
	}
}