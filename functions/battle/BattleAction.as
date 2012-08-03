package functions.battle
{
	import core.display.AnimateBitmap;
	import core.events.CoreEvent;
	import core.runner.LanguageRunner;
	import core.view.IScene;
	import core.events.CoreEventDispatcher;
	
	import data.BattleResource;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	
	import functions.battle.BattleResourceConfig;
	import functions.battle.BattleUIView;
	import functions.guides.view.GuideMediator;

	[Event(name="quit", type="flash.events.Event")]
	public class BattleAction extends Sprite implements IBattle, IScene
	{
		public function BattleAction()
		{
			super();
			_model=BattleReportCenter.getInstance();
		}

		/**
		 *战场背景
		 */
		private var _background:Sprite;
		private var _model:BattleReportCenter;
		private var bf:BattleField;
		private var _report:String;
		
		private var _currentBgUrl:String=null;

		private var battleUI:BattleUIView;

		private var initialized:Boolean=false;
		private var battleTitleInit:Boolean = false;
		private var battleResultInit:Boolean = false;
		private var battleToolTipInit:Boolean = false;

		/**
		 * 更换战场底图背景的接口
		 * @param value
		 *
		 */
		public function set background(value:*):void
		{
			if (!_background)
			{
				_background=new Sprite();
				addChildAt(_background, 0);
			}
			while (_background.numChildren)
			{
				_background.removeChildAt(0);
			}
			if (value)
			{
				_background.addChild(value);
			}
		}

		private function init():void
		{
			initialized=true;

			bf=new BattleField();
			addChild(bf);
			bf.addEventListener("fightEnd", fightEnd);
			bf.addEventListener("changeAmount",changeAmount);

			battleUI=new BattleUIView();
			addChild(battleUI);

			battleUI.showResultDirctelyBK=function():void
			{
				bf ? bf.reset() : ''
			}
			battleUI.resultPanel._closeCallBack =replay;
			battleUI.closeBk=function():void
			{
				dispatchEvent(new Event("quit", true))
			}
		}
		
		private function changeAmount(e:CoreEvent):void
		{
			battleUI.battleTitle.updateHp(e.data);
		}
		
		private function fightEnd(e:Event):void
		{
			battleUI.showResult();
			CoreEventDispatcher.dispatchEvent(new Event(GuideMediator.CONTINUEGUIDE));
		}

		public function enter():void
		{
		}

		public function play(report:String=null, canClose:Boolean=true, hasUrl:Boolean=true):void
		{
			reset();
			
			var snd:Sound = new Sound(new URLRequest(""));
			snd.play();
			snd.close();
			
			_report=report;//'[[[[{"1":0,"2":4,"3":"4242","5":111201,"4":1,"6":200,"8":1,"7":100,"9":1020,"10":1,"21":200,"22":0}],"4242",2,[111201,121201,13120001,1412004,1512002,0,1]],[[{"1":1,"2":4,"3":"试验中坦","5":1111001,"4":3,"6":140,"8":1,"7":100,"9":1050,"10":2,"21":140,"22":0}],"“罗兹”第一步兵师",3,[1111001,121101,13110001,1411001,1511001,0,2]]],[[[[{"1":0,"2":4,"11":1}],[{"17":4,"1":1,"2":4}]],[[{"1":1,"2":4,"22":34,"11":1}],[{"16":27,"1":0,"2":4,"18":1,"21":173,"22":34,"13":0,"15":1}]]],[[[{"1":0,"2":4,"22":68,"11":1}],[{"16":21,"1":1,"2":4,"18":1,"21":119,"22":68,"13":0,"15":1}]],[[{"1":1,"2":4,"11":1}],[{"17":8,"1":0,"2":4},{"16":34,"1":1,"2":4,"21":85,"15":1}]]],[[[{"1":0,"2":4,"23":1,"22":102,"11":1}],[{"16":20,"1":1,"2":4,"18":1,"21":65,"23":1,"22":102,"13":0,"15":1}]],[[{"1":1,"2":4,"23":0,"22":0,"11":3,"12":2002,"14":2002}],[{"16":35,"1":0,"2":4,"18":1,"21":138,"23":3,"13":15,"15":1}]]],[[[{"1":0,"2":4,"23":1,"11":4}],[]],[[{"1":1,"2":4,"22":34,"11":1}],[{"16":20,"1":0,"2":4,"18":1,"21":118,"22":136,"13":0,"15":1}]]],[[[{"1":0,"2":4,"23":0,"22":0,"11":3,"12":1001,"14":1001}],[{"16":17,"1":1,"2":4,"18":1,"21":48,"13":0,"15":1},{"1":0,"2":4,"23":4}]],[[{"1":1,"2":4,"11":1}],[{"17":8,"1":0,"2":4},{"16":23,"1":1,"2":4,"21":25,"15":1}]]],[[[{"1":0,"2":4,"23":0,"11":4}],[]],[[{"1":0,"2":4,"22":34,"11":1}],[{"16":17,"1":1,"2":4,"18":1,"21":8,"22":68,"13":0,"15":1}]],[[{"1":1,"2":4,"23":1,"22":102,"11":1}],[{"16":14,"1":0,"2":4,"18":1,"21":104,"22":68,"13":0,"15":1}]]],[[[{"1":0,"2":4,"23":1,"22":102,"11":1}],[{"16":8,"1":1,"2":4,"18":1,"21":0,"22":136,"13":0,"15":1}]]]],{"0":"201106010000015646","1":3,"2":96,"3":140,"4":7,"5":"你打败了“罗兹”第一步兵师","7":1}]'
			BattleConfig.canClose=canClose;
			BattleConfig.hasUrl=hasUrl;
			
			if (!initialized)
			{
				init();
			}
			
			battleUI.resultBtn.visible = BattleConfig.canClose;

			if (_report == null)
			{
				return;
			}
			_model.parseReport(_report);
			loadResource();
		}

		private function loadResource():void
		{
			var arr:Array=[];
			var bgUrl:String=BattleResourceConfig.getBattleMapPath("1");//_model.backGroudID);
			var pre:String = LanguageRunner.getLanguageText("BATTLE_PRELOAD_RESOURCES");
			if (_currentBgUrl != bgUrl)
			{
				arr.push({id:"backgroud",url:bgUrl,info:pre+LanguageRunner.getLanguageText("BATTLE_BG")});
				background = null;
				_currentBgUrl=bgUrl;
				BattleConfig.parseConfig();
			}
			var soldierList:Array = _model.getUsedSoldierIDList();
			for each (var soldier:Array in soldierList)
			{
				var url:String  = BattleResourceConfig.getBattleUnitPath(soldier[0]);
				if(!(soldier[0]+"_"+soldier[1] in BattleResource.sodierMap))
				{
					arr.push({id:"soldierid_"+soldier[0],url:url,info:pre+LanguageRunner.getLanguageText("BATTLE_SOILDER"),side:soldier[1]});
				}
			}
			if(!BattleConfig.isBattleUIReady)
			{
				BattleConfig.isBattleUIReady = true;
				var uiUrl:String = BattleResourceConfig.getBattleUIPath();
				arr.push({id:"battleui",url:uiUrl,info:pre+LanguageRunner.getLanguageText("BATTLE_LOADINGUI")});
				var numUrl:String = BattleResourceConfig.getBattleNumPath();
				arr.push({id:"battlenum",url:numUrl,info:pre+LanguageRunner.getLanguageText("BATTLE_LOADINGUI")});
			}
			else
			{
				this.battleUI.battleTitle.updateData(_model);
			}
			
			var skillList:Array=_model.getUsedSkillEffectIDList();
			for each (var id:int in skillList)
			{
				if (!(String(id) in BattleResource.skillEffectMap))
				{
					arr.push({id:"skill_"+id,url:BattleResourceConfig.getBattleSkillPath(id),info:pre+LanguageRunner.getLanguageText("BATTLE_SKILL")})
				}
			}
			
			var specialList:Array = _model.getUsedSpecialEffectedIDList();
			for each (var sid:int in specialList)
			{
				if (!(sid in BattleResource.specialSkillEffectMap))
				{
					//arr.push({id:"special_"+sid,url:BattleResourceConfig.getBattleSpecialSkillPath(sid),info:pre+LanguageRunner.getLanguageText("BATTLE_SEPICALSKILL")})
				}
			}			
			var buffList:Array = _model.getUsedBuffIDList();
			for each (var buffId:int in buffList)
			{
				if (!(buffId in BattleResource.buffEffectMap))
				{
					arr.push({id:"buffId_"+buffId,url:BattleResourceConfig.getBattleBuffEffectPath(buffId),info:pre+LanguageRunner.getLanguageText("BATTLE_BUFF")});
				}
				if(!(buffId in BattleResource.buffIconMap))
				{
					arr.push({id:"buffIconId_"+buffId,url:BattleResourceConfig.getBattleBuffIconPath(buffId),info:pre+LanguageRunner.getLanguageText("BATTLE_BUFF")});
				}
			}
			
			if (!BattleResource.skillNameMap.hasOwnProperty('skillName/2001.png'))
			{
				//arr.push({id:"skillNameRec",url:BattleResourceConfig.getI18Path()});
			}
			ResourceLoadingView.show(arr, onItemComplete, onAllComplete,null,onItemFailed);
		}

		private function onItemComplete(item:Object, content:Object, domain:ApplicationDomain=null):void
		{
			if (item.id == "backgroud")
			{
				this.background=content as Bitmap;
			}
			else if(item.id == "battleui")
			{
				BattleResourceConfig.processResource(content as Bitmap,item.id);
				if(!battleTitleInit){
					battleTitleInit = true;
					this.battleUI.battleTitle.init();
				}
				this.battleUI.battleTitle.updateData(_model);
				if(!battleToolTipInit)
				{
					battleToolTipInit = true;
					this.bf.battleTooltip.updateBg();
				}
				if(!battleResultInit)
				{
					battleResultInit = true;
					this.battleUI.resultPanel.updateBg();
				}
			}
			else if(item.id == "battlenum")
			{
				BattleResourceConfig.processResource(content as Bitmap,item.id);
			}
			else if ((item.id).indexOf('skill_') == 0)
			{
				BattleResource.addSkillEffectResource(String(item.id).split("_")[1],content as Bitmap);
			}
			else if ((item.id).indexOf('special_') == 0)
			{
				BattleResource.specialSkillEffectMap[String(item.id).split("_")[1]]=domain.getDefinition("effect");
			}
			else if (item.id == "buffEffecct")
			{
				BattleResource.buffEffectDomain=domain;
			}
			else if (item.id == "skillNameRec")
			{
				BattleResource.addSkillNameResource(content.dictionary);
			}
			else if ((item.id).indexOf('soldierid_') == 0)
			{
				BattleResource.addSodierResource(String(item.id).split("_")[1],item.side,(content as Bitmap).bitmapData);
			}	
			else if ((item.id).indexOf('buffId_') == 0)
			{
				BattleResource.addBuffEffectResource(String(item.id).split("_")[1],content as Bitmap);
			}
			else if ((item.id).indexOf('buffIconId_') == 0)
			{
				BattleResource.addBuffIconResource(String(item.id).split("_")[1],content as Bitmap);
			}
		}
		private var failedMsgList:Array = [];
		private function onItemFailed(obj:Object,msg:String):void
		{
//			var txt:TextField = new TextField();
//			txt.textColor = 0xFF0000;
//			txt.autoSize = TextFieldAutoSize.LEFT;
//			txt.text = msg +"::"+ obj;
//			stage.addChild(txt);
//			txt.x = (stage.stageWidth - txt.width)>>1;
//			txt.y = failedMsgList.length==0?100:failedMsgList[failedMsgList.length-1].y+failedMsgList[failedMsgList.length-1].height;
//			failedMsgList.push(txt);
		}

		private function onAllComplete():void
		{
			bf.start(_model.records_Report);
		}

		private function replay():void
		{
			play(_report,true,BattleConfig.hasUrl);
			this.dispatchEvent(new Event('hideChat',true));
		}

		private function reset():void
		{
			if (bf)
			{
				bf.reset()
			}
			if (battleUI)
			{
				battleUI.reset();
			}
			while(failedMsgList.length>0)
			{
				stage.removeChild(failedMsgList.pop());
			}
		}

		/**
		 *退出战斗，清理战场。
		 *
		 */
		public function exit():void
		{
			reset();
		}
	}
}