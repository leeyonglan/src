package {
	
	import core.display.BitmapProxy;
	import core.global.ConfigConnect;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import net.message.MessageType;
	import net.message.custom.client2server.CreateRoleRevMessage;
	import net.message.custom.client2server.RoleRandomNameRevMessage;
	import net.message.custom.server2client.RoleRandomNameSendMessage;
	import net.message.custom.server2client.RoleTemplateSendMessage;
	
	public class CreatePlayer extends Sprite {
		
		
		//创建角色的回调函数
		public var createCallback:Function;
		
		private var bg:Bitmap;
		private var gender:uint = 0;
		private var roleName:TextField;
		private var tipIcon:Bitmap;
		private var tipText:TextField;
		private var follow:Boolean = true;
		
		private var server:*;
		private var uiMap:Dictionary;
				
		public function CreatePlayer() {
			super();
		}
		public function init(server:*, callback:Function):void {
			this.server = server;
			createCallback = callback;
			initServer();
			initResource();
		}
		
		private function initServer():void {
			//	随即生成用户名
			//server.subscribe(MessageType.GC_ROLE_RANDOM_NAME, onAutoNameResponse);
		}
		
		private function initResource():void {
			addChild( new CreatePlayerMediator( this ) );
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
		}
		
		public function getBMD(key:String):Bitmap {
			var bit:BitmapProxy = new BitmapProxy;
			bit.url = ConfigConnect.LangType+"/"+key;
			return bit as Bitmap;
		}
	}
	
}

import core.net.Server;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.ColorMatrixFilter;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;

import net.message.MessageType;
import net.message.custom.classes.CustomPetTemplateData;
import net.message.custom.client2server.CreateRoleRevMessage;
import net.message.custom.client2server.RoleRandomNameRevMessage;
import net.message.custom.client2server.RoleTemplateRevMessage;
import net.message.custom.server2client.RoleRandomNameSendMessage;
import net.message.custom.server2client.RoleTemplateSendMessage;

import utils.FilterUtil;

class ViewNational extends Sprite {
	
	private var createPlayer:CreatePlayer = null;
	private var sizeArr:Array = null;
	public function ViewNational(createPlayerMediator:CreatePlayerMediator, type:int ) {
		this.createPlayerMediator = createPlayerMediator;
		this.createPlayer = createPlayerMediator.createPlayer;
		
		this.type = type;
		
		initComponents();
		initLayout();
		initListeners();
	}
			
	private function initComponents(): void {
		
		var nat:String = null;
		if( type == 1 ) {
			nat = "wei";
			sizeArr = [393,399,273,400];
		} else if( type == 2 ) {
			nat = "shu";
			sizeArr = [254,399,315,398];
		} else if( type == 3 ) {
			nat = "wu";
			sizeArr = [368,400,207,398];
		}
		
		natName = createPlayer.getBMD("createPlayerSimple/natname_" + nat + ".png");
		natHeadBitmap = createPlayer.getBMD("createPlayerSimple/natbg_head.png");
		
		natTailBitmap = createPlayer.getBMD("createPlayerSimple/natbg_tail.png");
		redTailBitmap = createPlayer.getBMD("createPlayerSimple/redtail.png");
		
		if( type == 3 ) {
			manBitmap = createPlayer.getBMD("createPlayerSimple/avatar_" + nat + "2.png");
		} else {
			manBitmap = createPlayer.getBMD("createPlayerSimple/avatar_" + nat + "1.png");
		}
		
		if( type == 3 ) {
			womanBitmap = createPlayer.getBMD("createPlayerSimple/avatar_" + nat + "1.png");
		} else {
			womanBitmap = createPlayer.getBMD("createPlayerSimple/avatar_" + nat + "2.png");
		}
		
		infoBitmapSprite = new Sprite();
		
		infoBitmapSprite.addChild(createPlayer.getBMD("createPlayerSimple/info.png"));
		
		womanBitmapSprite.addChild(womanBitmap);
		manBitmapSprite.addChild(manBitmap);
		
		if( type == 3 ) {
			addChild( womanBitmapSprite );
			addChild( manBitmapSprite );
		} else {
			addChild( manBitmapSprite );
			addChild( womanBitmapSprite );
		}
		
		natHeadBitmapSprite.addChild( natHeadBitmap );
		addChild( natHeadBitmapSprite );
		
		addChild( redTailBitmap );
		addChild( natTailBitmap );
		
		//addChild( infoBitmapSprite );
		
	}
			
	private function initLayout(): void {
		
		//	缩放
		if( type == 3 ) {
			manBitmap.height = sizeArr[3] / 1.66;
			manBitmap.width = sizeArr[2] / 1.66;
			
			womanBitmap.height = sizeArr[1]/ 1.41;
			womanBitmap.width = sizeArr[0] / 1.41;
			
		} else {
			manBitmap.height = sizeArr[1] / 1.41;
			manBitmap.width = sizeArr[0] / 1.41;
			
			womanBitmap.height = sizeArr[3] / 1.66;
			womanBitmap.width = sizeArr[2] / 1.66;
		}
		
		//	位置
		if ( type == 1 ) {
			manBitmapSprite.x = manBitmapSprite.x - 15;
			manBitmapSprite.y = manBitmapSprite.y + 120;
			
			womanBitmapSprite.x = womanBitmapSprite.x + 190;
			womanBitmapSprite.y = womanBitmapSprite.y + 163;
		} else if ( type == 2 ) {
			manBitmapSprite.x = manBitmapSprite.x + 10;
			manBitmapSprite.y = manBitmapSprite.y + 120;
			
			womanBitmapSprite.x = womanBitmapSprite.x + 140;
			womanBitmapSprite.y = womanBitmapSprite.y + 163;
		} else if( type == 3 ) {
			manBitmapSprite.x = manBitmapSprite.x + 50;
			manBitmapSprite.y = manBitmapSprite.y + 163;
			 
			womanBitmapSprite.x = womanBitmapSprite.x + 90;
			womanBitmapSprite.y = womanBitmapSprite.y + 115;
		}
		
		natHeadBitmapSprite.x = natHeadBitmapSprite.x + 150;
		natHeadBitmapSprite.y = natHeadBitmapSprite.y + 35;
		
		redTailBitmap.x = redTailBitmap.x + 50;
		redTailBitmap.y = redTailBitmap.y + 340;
		
		natTailBitmap.x = natTailBitmap.x + 150;
		natTailBitmap.y = natTailBitmap.y + 340;
		
		var textField:TextField = new TextField();
		
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Verdana";
		textFormat.color = 0xFFFFFF;
		textFormat.size = 14;
		
		textField.defaultTextFormat = textFormat;
		textField.x = 50;
		textField.y = 50;
		textField.width = 130;
		textField.height = 80;
		
		//textField.text = "世界真奇妙\n世界真美好\n世界真牛逼";
		
		infoBitmapSprite.addChild( textField );
		
	}
	
	private function initListeners(): void {
		natHeadBitmapSprite.addEventListener( MouseEvent.CLICK, onClickNatHeadBitmap );
		manBitmapSprite.addEventListener( MouseEvent.CLICK, onClickManBitmap );
		womanBitmapSprite.addEventListener( MouseEvent.CLICK, onClickWomanBitmap );
	}
	
	public var SELECTTYPE_MAN:int = 1;
	public var SELECTTYPE_WOMAN:int = 2;
	
	public var selectType:int = SELECTTYPE_MAN;
	
	private function onClickNatHeadBitmap( e:MouseEvent ): void {
		createPlayerMediator.onForwardCreateUserUpdateAction( this, 1 );
			
		selectType = SELECTTYPE_MAN;
	}
	
	private function onClickManBitmap( e:MouseEvent ): void {
		createPlayerMediator.onForwardCreateUserUpdateAction( this, 2 );
			
		selectType = SELECTTYPE_MAN;
	}
	
	private function onClickWomanBitmap( e:MouseEvent ): void {
		createPlayerMediator.onForwardCreateUserUpdateAction( this, 3 );
		
		selectType = SELECTTYPE_WOMAN;
	}
	
	public function updateModel( model:ViewNationalModel ): void {
		var bwfilterList:Array = [];
		var colorfilterList:Array = [];
		
		colorfilterList.push( FilterUtil.getColorMatrixFilter() );
		
		if( natName.parent != null ) {
			natName.parent.removeChild( natName );
		}
		
		if( model.selected == ViewNationalModel.SELECTED_TYPE_MAN ) {
			//	选中男
			natName.x = natTailBitmap.x + 20;
			natName.y = natTailBitmap.y + 20;
			
			natTailBitmap.visible = true;
			natHeadBitmapSprite.visible = false;
			redTailBitmap.visible = true;
			
			bwfilterList.push( new ColorMatrixFilter(bwMatrix) );
			
			manBitmap.filters = colorfilterList;
			womanBitmap.filters = bwfilterList;
			
			infoBitmapSprite.x = 100;
			//infoBitmapSprite.visible = true;
			
		} else if( model.selected == ViewNationalModel.SELECTED_TYPE_WOMAN ) {
			//	选中女
			
			natName.x = natTailBitmap.x + 20;
			natName.y = natTailBitmap.y + 20;
			
			natTailBitmap.visible = true;
			natHeadBitmapSprite.visible = false;
			redTailBitmap.visible = true;
			
			bwfilterList.push( new ColorMatrixFilter(bwMatrix) );
			
			manBitmap.filters = bwfilterList;
			womanBitmap.filters = colorfilterList;
			
			if( type == 3 ) {
				infoBitmapSprite.x = 150;
			} else {
				infoBitmapSprite.x = 200;
			}
			
			//infoBitmapSprite.visible = true;
		} else if( model.selected == ViewNationalModel.SELECTED_TYPE_NO ) {
			//	没有选中
			
			natName.x = natHeadBitmapSprite.x + 20;
			natName.y = natHeadBitmapSprite.y + 20;
			
			natHeadBitmapSprite.visible = true;
			natTailBitmap.visible = false;
			redTailBitmap.visible = false;
			
			bwfilterList.push( new ColorMatrixFilter(bwMatrix) );
			
			womanBitmap.filters = bwfilterList;
			manBitmap.filters = bwfilterList;
			
			infoBitmapSprite.visible = false;
		}
		
		addChild( natName );
	}
	
	
	private static var rLum:Number = 0.2225;
	private static var gLum:Number = 0.7169;
	private static var bLum:Number = 0.0606;
	
	private static var bwMatrix:Array = [
		rLum, gLum, bLum, 0, 0,
		rLum, gLum, bLum, 0, 0,
		rLum, gLum, bLum, 0, 0,
		0, 0, 0, 1, 0
	];  
	
	//	//////////////////////////
	//	变量表
	//	//////////////////////////
	
	private var natHeadBitmapSprite:Sprite = new Sprite();
	
	private var womanBitmapSprite:Sprite = new Sprite();
	
	private var manBitmapSprite:Sprite = new Sprite();
	
	//	首部的国家标记
	private var natHeadBitmap:Bitmap  = null;
	//	尾部的国家标记
	private var natTailBitmap:Bitmap  = null;
	//	尾部的红色标记
	private var redTailBitmap:Bitmap  = null;
	//	男的图片
	private var manBitmap:Bitmap  = null;
	//	女的图片
	private var womanBitmap:Bitmap  = null;
	//	介绍信息
	private var infoBitmapSprite:Sprite  = null;
	//	国家的名字
	private var natName:Bitmap  = null;
	//
	public var type:int = 0;
	//
	public var createPlayerMediator:CreatePlayerMediator = null;
	
	//	魏
	public static const TYPE_WEI:int = 1;
	//	蜀
	public static const TYPE_SHU:int = 2;
	//	吴
	public static const TYPE_WU:int = 3;
}

class ViewNationalModel {
	public function ViewNationalModel() {
	}
	
	public var selected:int = 3;
	
	public static const SELECTED_TYPE_MAN:int = 1;	//	男
	public static const SELECTED_TYPE_WOMAN:int = 2;	//	女
	public static const SELECTED_TYPE_NO:int = 3;	//	没选中
	
	public var manId:int = 0;
	public var womanId:int = 0; 
	
}

class CreatePlayerMediator extends Sprite {
	
	//
	public var createPlayer:CreatePlayer = null;
	//	背景图片
	private var backgroundImage:Bitmap = null;
	
	//	按钮
	private var createButton:ButtonCreateUser = null;
	//	输入框
	private var createTextField:TextField = null;
	//	输入框背景图
	private var createTextBackgroundImage:Bitmap = null;
	//	随机姓名的筛子
	private var randomButtonImage:Sprite = null;
	
	//	魏	
	private var weiViewNationalModel:ViewNationalModel = new ViewNationalModel();
	//	蜀
	private var shuViewNationalModel:ViewNationalModel = new ViewNationalModel();
	//	吴
	private var wuViewNationalModel:ViewNationalModel = new ViewNationalModel();
	
	//	魏	显示对象
	private var weiViewNational:ViewNational = null;
	//	蜀	显示对象
	private var shuViewNational:ViewNational = null;
	//	吴	显示对象
	private var wuViewNational:ViewNational = null;
	//	
	private var usernameBitmap:Bitmap = null;
	
	public function CreatePlayerMediator( createPlayer:CreatePlayer ) {
		this.createPlayer = createPlayer;
		
		//	初始化绑定
		initBind();
		//	请求随机
	
		//	
		Server.send( new RoleTemplateRevMessage() );
		//	
		Server.send( new RoleRandomNameRevMessage() );
		
		//	初始化组件
		initComponents();
		//	初始化布局
		initLayout();
		//	
		initListener();
		
		weiViewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_MAN;
		viewNational = weiViewNational;
		this.currentViewNationalModel = weiViewNationalModel;
		//	
		updateView();
		
	}
	
	public function initBind():void {
		Server.subscribe( MessageType.GC_ROLE_RANDOM_NAME, onRoleRandomNameSendMessageForword );
		Server.subscribe( MessageType.GC_ROLE_TEMPLATE, onRoleTemplateSendMessageAction );
	}
	
	//	转发到 Mediator 的 RoleRandomNameSendMessage 包.
	public function onRoleRandomNameSendMessageForword( message:RoleRandomNameSendMessage ):void {
		createTextField.text = message.name;
	}
	
	public function onRoleTemplateSendMessageAction( message:RoleTemplateSendMessage ): void {
		
		//可选各角色模板信息
		var customPetTemplateDataList:Vector.<CustomPetTemplateData> = message.templates;
	
		var i:int = 0;
		
		for( i = 0; i < customPetTemplateDataList.length; i++ ) {
			if( customPetTemplateDataList[i].alliance == 1 ) {
				//	魏
				if( customPetTemplateDataList[i].sex == 1 ) {
					//	男
					weiViewNationalModel.manId = customPetTemplateDataList[i].id;
				} else if( customPetTemplateDataList[i].sex == 2 ) {
					//	女
					weiViewNationalModel.womanId = customPetTemplateDataList[i].id;
				}
			} else if( customPetTemplateDataList[i].alliance == 2 ) {
				//	蜀
				if( customPetTemplateDataList[i].sex == 1 ) {
					//	男
					shuViewNationalModel.manId = customPetTemplateDataList[i].id;
				} else if( customPetTemplateDataList[i].sex == 2 ) {
					//	女
					shuViewNationalModel.womanId = customPetTemplateDataList[i].id;
				}
			} else if( customPetTemplateDataList[i].alliance == 4 ) {
				//	吴
				if( customPetTemplateDataList[i].sex == 1 ) {
					//	男
					wuViewNationalModel.manId = customPetTemplateDataList[i].id;
				} else if( customPetTemplateDataList[i].sex == 2 ) {
					//	女
					wuViewNationalModel.womanId = customPetTemplateDataList[i].id;
				}
			}
		}
		
	}
			
	public function randomButtonListener( e:MouseEvent ): void {	//	ok
		//	改名字
		var message:RoleRandomNameRevMessage = new RoleRandomNameRevMessage();
		Server.send( message );
	}
	
	public function createButtonLinstener( e:MouseEvent ): void {
		var message:CreateRoleRevMessage = new CreateRoleRevMessage();
		
		message.name = createTextField.text;
		message.tradeType = 0;
		
		if( currentViewNationalModel == this.wuViewNationalModel ) {
			if( currentViewNationalModel.selected == ViewNationalModel.SELECTED_TYPE_MAN ) {
				message.templateId = currentViewNationalModel.womanId;
		
			} else if( currentViewNationalModel.selected == ViewNationalModel.SELECTED_TYPE_WOMAN ) {
				message.templateId = currentViewNationalModel.manId;
			}
		} else if (currentViewNationalModel == this.weiViewNationalModel) {
			if( currentViewNationalModel.selected == ViewNationalModel.SELECTED_TYPE_MAN ) {			
				message.templateId = currentViewNationalModel.manId;
			} else if( currentViewNationalModel.selected == ViewNationalModel.SELECTED_TYPE_WOMAN ) {
				message.templateId = currentViewNationalModel.womanId;
			}
		} else {		
			if( currentViewNationalModel != null ) {
				if( currentViewNationalModel.selected == ViewNationalModel.SELECTED_TYPE_MAN ) {
					message.templateId = currentViewNationalModel.manId;
				} else if( currentViewNationalModel.selected == ViewNationalModel.SELECTED_TYPE_WOMAN ) {
					message.templateId = currentViewNationalModel.womanId;
				}
			}
			
		}
		
		Server.send( message );
	}
	
	private var viewNational:ViewNational = null;
	private var currentViewNationalModel:ViewNationalModel = null
		
	public function onForwardCreateUserUpdateAction( viewNational:ViewNational, type:int ): void {
			
		this.viewNational = viewNational;
		
		weiViewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_NO;
		shuViewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_NO;
		wuViewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_NO;
		
		var viewNationalModel:ViewNationalModel = null;
		
		if( viewNational == weiViewNational ) {
			viewNationalModel = weiViewNationalModel;
		}
		
		if( viewNational == shuViewNational ) {
			viewNationalModel = shuViewNationalModel;
		}
		
		if( viewNational == wuViewNational ) {
			viewNationalModel = wuViewNationalModel;
		}
		
		currentViewNationalModel = viewNationalModel;
		
		if( type == 1 ) {
			//	头部国家
			viewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_MAN;
		} else if( type == 2 ) {
			//	男
			viewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_MAN;
		} else if( type == 3 ) {
			//	女
			viewNationalModel.selected = ViewNationalModel.SELECTED_TYPE_WOMAN;
		}
		
		updateView();
	}
	
	private function initComponents(): void {
		backgroundImage = createPlayer.getBMD("createPlayerSimple/background.jpg");
		createTextBackgroundImage = createPlayer.getBMD("createPlayerSimple/textfield.png");
		
		createButton = new ButtonCreateUser( 
			"createPlayerSimple/button_over.png", 
			"createPlayerSimple/button_down.png"
		);
		
		randomButtonImage = new Sprite();
		randomButtonImage.addChild(createPlayer.getBMD("createPlayerSimple/random.png"));
		
		//	
		weiViewNational = new ViewNational(this, ViewNational.TYPE_WEI);
		//	
		shuViewNational = new ViewNational(this, ViewNational.TYPE_SHU);
		//	
		wuViewNational = new ViewNational(this, ViewNational.TYPE_WU);
		
		createTextField = new TextField();
		createTextField.type = TextFieldType.INPUT;
		createTextField.maxChars = 4;
		
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Verdana";
		textFormat.color = 0xFFFFFF;
		textFormat.size = 12;
		
		createTextField.defaultTextFormat = textFormat;
		addChild(createTextField);
		
		usernameBitmap = createPlayer.getBMD("createPlayerSimple/username.png");
		
	}
		
	private function initLayout(): void {
		
		this.addChild( backgroundImage );
		
		weiViewNational.y = weiViewNational.y + 25;
		weiViewNational.x = weiViewNational.x + 20;
		this.addChild( weiViewNational );
		
		shuViewNational.y = shuViewNational.y + 60;
		shuViewNational.x = shuViewNational.x + 350;
		this.addChild( shuViewNational );
		
		wuViewNational.y = wuViewNational.y + 25;
		wuViewNational.x = wuViewNational.x + 650;
		this.addChild( wuViewNational );
		
		createButton.x = 460;
		createButton.y = 510;
		this.addChild( createButton );
		
		createTextBackgroundImage.x = 415;
		createTextBackgroundImage.y = 475;
		this.addChild( createTextBackgroundImage );
		
		createTextField.x = createTextBackgroundImage.x + 10;
		createTextField.y = createTextBackgroundImage.y + 2;
		
		createTextField.width = 221 - 24;
		createTextField.height = 24;
		
		this.addChild( createTextField );
		
		usernameBitmap.x = createTextField.x - 79- 10;
		usernameBitmap.y = createTextField.y - 10;
		addChild( usernameBitmap );
		
		randomButtonImage.x = createTextBackgroundImage.x + createTextField.width;
		randomButtonImage.y = createTextBackgroundImage.y;
		
		this.addChild( randomButtonImage );
	}
	
	private function initListener(): void {
		randomButtonImage.addEventListener( MouseEvent.CLICK, randomButtonListener );
		createButton.addEventListener( MouseEvent.CLICK, createButtonLinstener );
	}

	private function updateView(): void {
		weiViewNational.updateModel( weiViewNationalModel );
		shuViewNational.updateModel( shuViewNationalModel );
		wuViewNational.updateModel( wuViewNationalModel );
	}
	
}

import core.display.BitmapProxy;
import core.display.components.button.Button;
import core.display.components.button.ImageButton;
import core.display.components.image.Image;
import core.runner.LanguageRunner;
import core.utils.DisplayUtil;
import core.global.ConfigConnect;
import functions.createuser.view.ButtonCreateUser;
import flash.display.BitmapData;
import core.display.components.text.CoreTextField;

class ButtonCreateUser extends Button {
	
	//	
	private var overImage:BitmapProxy = null;
	//	
	private var downImage:BitmapProxy = null;
	private var btnText:CoreTextField = null;
	public function ButtonCreateUser( button_over:String, button_down:String ) {
		
		this.mouseChildren = false;
		overImage = new BitmapProxy();
		downImage = new BitmapProxy();
		btnText = new CoreTextField();
		btnText.text = "开始游戏";
		btnText.x = (115-btnText.textWidth)>>1;
		btnText.y = (30-btnText.textHeight)>>1;
		this.downImage.visible = false;
		
		overImage.url = ConfigConnect.LangType+"/"+button_over;
		downImage.url = ConfigConnect.LangType+"/"+button_down;
		
		this.addChild(overImage);
		this.addChild(downImage);
		this.addChild(btnText);
		this.downImage.visible = false;
		
	}
	
	//	悬浮
	override protected function onOverIn():void {
		// 等待子类完善
		this.overImage.visible = true;
		this.downImage.visible = false;
	}
	
	//	按下
	override protected function onDownIn():void {
		this.overImage.visible = false;
		this.downImage.visible = true;
	}
	
}
