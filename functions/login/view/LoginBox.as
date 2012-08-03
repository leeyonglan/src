package functions.login.view {
	import core.display.components.button.ImageButton;
	import core.display.components.input.Input;
	import core.events.CoreEvent;
	import core.net.Server;
	import core.runner.LanguageRunner;
	import core.runner.PromptBoxRunner;
	import core.runner.SkinRunner;
	import core.runner.StateRunner;
	import core.state.StateType;
	import core.utils.ObjectPool;
	import core.utils.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import functions.login.model.LoginVO;
	
	import global.Config;
	import global.GameReport;
	import global.TextFormatType;
	
	import view.component.behaviors.CommonMouseEffectBehavior;
	import view.component.text.Link;
	
	/**
	 * 文件名：LoginBox.as
	 * <p>
	 * 功能：登录框体
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-18
	 * <p>
	  
	 * <p>
	 *  
	 */
	public class LoginBox extends Sprite {
		public static const START_LOGIN:String = "StartLogin";
		public static const START_HANDLOGIN:String = "StartHandLogin";
		private static const COOKIE_NAME:String = "societyguester";
		
		private var _inputUsername:Input;
		private var _inputPassword:Input;
		private var _btnLogin:ImageButton;
		private var _btnCreateUser:Link;
//		private var _checkCookie:CheckBox;
		public function LoginBox() {
			super();
			init();
//			Server.subscribe(MessageType.GC_CREATE_USER, createUserResponse);
			//监听游戏系统初始化完毕事件
//			if(Config.debug){
				
//			}
		}
		private var isInit:Boolean=false;
		private function init():void {
			if(isInit) return;
			//this.visible = false;
			
			// 设置需要组件的皮肤
			SkinRunner.setInputSkin(TextFormatType.BLACK_12);
			var mouseEffectBehavior:CommonMouseEffectBehavior = new CommonMouseEffectBehavior();
			SkinRunner.setButtonSkin(null, 2, mouseEffectBehavior);
			SkinRunner.setCheckBoxSkin("first/component/checkBox/checkBox_off.png", "first/component/checkBox/checkBox_on.png",
				mouseEffectBehavior);
			
			// 输入框
			_inputUsername = new Input(1, null, null, enterHandler);
			_inputUsername.change = checkLoginButtonEnable;
			_inputUsername.width = 153;
			_inputUsername.x = 412;
			_inputUsername.y = 241;
			addChild(_inputUsername);
			_inputUsername.background = true;
			_inputUsername.fontColor = 0x000000;
			_inputUsername.border = true;
			_inputUsername.borderColor = 0xffffff;
			_inputUsername.text = "test404";
			
			//密码框
			_inputPassword = new Input(2, null, null, enterHandler);
			_inputPassword.displayAsPassword = true;
//			_inputPassword.backgroundText = LanguageRunner.getLanguageText("INPUT_YOUR_PASSWORD");
			_inputPassword.width = 153;
			_inputPassword.x = 412;
			_inputPassword.y = 275;
			addChild(_inputPassword);
			_inputPassword.background = true;
			_inputPassword.fontColor = 0x000000;
			_inputPassword.border = true;
			_inputPassword.borderColor = 0xffffff;
			_inputPassword.text = "1";
			
			// 按钮
			_btnLogin = new ImageButton();
			_btnLogin.setImage("first/component/button/positive.png");
			_btnLogin.click = loginClickHandler;
			_btnLogin.hasHoverTip = false;
			_btnLogin.x = 443;
			_btnLogin.y = 319;
			addChild(_btnLogin);
			
			// TODO 测试开发阶段使用 按钮
			if(Config.showCreateUser){
				_btnCreateUser = new Link();
				_btnCreateUser.text = LanguageRunner.getLanguageText("NEW_USER_REGISTER");
				_btnCreateUser.link = createUserClickHandler;
				_btnCreateUser.x = 611;
				_btnCreateUser.y = 239;
				addChild(_btnCreateUser);
				_btnCreateUser.normalHTMLColor = "#ffffff";
			}
			/*
			// Cookie组件
			_checkCookie = new CheckBox();
			_checkCookie.label = LanguageRunner.getLanguageText("REMEMBER_USERNAME");
			_checkCookie.hasHoverTip = false;
			_checkCookie.x = 611;
			_checkCookie.y = 273;
			addChild(_checkCookie);
			*
			// 如果有cookie数据则将其写入用户名框中
			var cookieName:String = ExternalManager.getCookie(COOKIE_NAME);
			if (cookieName != null && cookieName != "") {
				_inputUsername.text = cookieName;
				_checkCookie.selected = true;
			} else {
				_checkCookie.selected = false;
			}
			*/
			checkLoginButtonEnable(null);
			isInit=true;
		}
		
		public function cookieLogin():void{
			//游戏初始化完成，开始进行 判断是否进行 cookie登陆
			if (ExternalInterface.available) {
				this.visible = false;
				//取得cookie  自动登陆
				var societyguester:String = ExternalInterface.call("getcookie", "societyguester");
				if (societyguester == null || societyguester == "" || societyguester == "fail") {
					societyguester = ExternalInterface.call("getcookie", "t");
				}
				
				if (societyguester != null && societyguester != "" && societyguester != "fail") {
					GameReport.getGameReport().reportGame("3000","cookieLogin");
					var loginVO:LoginVO = new LoginVO();
					loginVO.loginType = 2;
					
					loginVO.username = societyguester;
					loginVO.password = "";
					
					dispatchEvent(new CoreEvent(START_LOGIN, this, loginVO))
					StateRunner.switchState(StateType.LODING);
				} else {
					// 如果没有保存cookie，要判断是否显示自己的登陆页，还是跳转到配置的登陆页
					if(Config.showLogin){
						init();
						this.visible = true;
						StateRunner.switchState(StateType.LOGIN);
					}else{
						ExternalInterface.call('function(){location.href="'+Config.urlLogin+'?gc=lstx&url=http://"+location.host}')
					}
				}
			} else {
				//throw new Error("请在浏览器中进行游戏");				
			}
		}
		
		private function enterHandler(event:KeyboardEvent):void {
			startLogin();
		}
		private function loginClickHandler(event:*):void {
			startLogin();
		}
		private function checkLoginButtonEnable(event:Event):void {
			if (_inputUsername.text == "") {
				this._btnLogin.enabled = false;
			} else {
				this._btnLogin.enabled = true;
			}
		}
		
		
		
		//TODO
		private function createUserClickHandler(e:MouseEvent):void {
			if (StringUtil.trim(_inputUsername.text) == "") {
				PromptBoxRunner.getInstance().openLoginAlert("请输入要注册的账号");
				return ;
			}
//			var createUser:CreateUserTestRevMessage = ObjectPool.borrow(CreateUserTestRevMessage);
//			createUser.userName = _inputUsername.text;
//			Server.send(createUser);
		}
		//TODO
//		private function createUserResponse(message:CreateUserTestSendMessage):void {
//			if (message.userName == "") {
//				PromptBoxRunner.getInstance().openLoginAlert("创建失败");
//				return ;
//			}
//			PromptBoxRunner.getInstance().openLoginAlert("创建账号成功：" + message.userName);
//		}
		
		public function handLogin():void
		{
			var loginVO:LoginVO = new LoginVO();
			loginVO.loginType = 1;
			loginVO.username = _inputUsername.text;
			loginVO.password = _inputPassword.text;
			
			this.
			dispatchEvent(new CoreEvent(START_HANDLOGIN, this, loginVO));
		}
		
		public function startLogin():void {
			// 如果记录cookie则设置cookie
			/*
			if (_checkCookie.selected) {
				ExternalManager.setCookie(COOKIE_NAME, _inputUsername.text);
			} else {
				ExternalManager.setCookie(COOKIE_NAME, "");
			}
			*/
//			var mess:LoginRoleSendMessage = new LoginRoleSendMessage;
//			mess.roleId = "1";
//			CoreEventDispatcher.dispatchEvent(new ResourceEvent(ResourceEvent.START_FIRST_LOAD,this,mess.roleId));
			//TODO 先测试服务是否可连通
			// 发送登录请求
			var loginVO:LoginVO = new LoginVO();
			loginVO.loginType = 1;
			loginVO.username = _inputUsername.text;
			loginVO.password = _inputPassword.text;
			dispatchEvent(new CoreEvent(START_LOGIN, this, loginVO));
		}
	}
}