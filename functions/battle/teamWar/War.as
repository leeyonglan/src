package functions.battle.teamWar
{
	import core.events.CoreEvent;
	import core.events.CoreEventDispatcher;
	import core.runner.LanguageRunner;
	
	import data.BattleResource;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.*;
	
	import functions.battle.BattleResourceConfig;
	import functions.battle.ResourceLoadingView;
	
	import gs.TweenLite;

	[Event(name="quit",type="flash.events.Event")]
	public class War extends Sprite implements IWar
	{
		public static var instance:War;

		public static var teamWarApplicationDomain:ApplicationDomain

		/**
		 *各战线坐标
		 */
		private static const POINTS:Array=[new Point(0, 0), new Point(186, 76), new Point(327, 142), new Point(486, 218), new Point(627, 285)];

		public function War()
		{
			instance=this;
			_model=WarReportCenter.getInstance();
		}

		/**
		 * 战线列表
		 */
		public var battleFieldMap:Dictionary;

		/**
		 * 战斗开场动画
		 */
		public var start:Bitmap;

		/**
		 * 候场军队列表
		 */
		private var _armyListView:ArmyListView;
		/**
		 *战场背景
		 */
		private var _background:Sprite;

		/**
		 *战线启动计时器
		 */
		private var _battleTimer:Timer;

		/**
		 *战线的战报信息
		 */
		private var _lineRecordList:Array;

		private var _model:WarReportCenter;


		private var _report:String;
		public function set report(value:String):void
		{
			_report=value;
		}
		
		public function get report():String
		{
			return _report;
		}
		
		public function get reportView():ReportView
		{
			return _reportView;
		}

		/**
		 * 战斗中战斗单元胜负信息显示控件
		 */
		private var _reportView:ReportView;
		/**
		 * 战斗结果视图
		 */
		private var _resultView:ResultView;
		public static var _effectLayer:Sprite = new Sprite;
		

		private var busyLines:Array=[];

		/**
		 *初始化标志
		 */
		private var initialized:Boolean=false;

		/**
		 *
		 * 候场军队对外接口
		 *
		 */
		public function get armyListView():ArmyListView
		{
			return _armyListView;
		}

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
				addChild(_background);
			}
			while (_background.numChildren)
			{
				_background.removeChildAt(0);
			}
			_background.addChild(value);
		}

		/**
		 *
		 *开始战报的播放，会先启动一个 startWarMovie，在startWarMovie播完后，战线战斗逐个开启。
		 *
		 */
		public function play(report:String=null,rewardString:String = null):void
		{
			this.report=report;
			trace("组队战报："+this.report);
			if (_report == null)
			{
				return;
			}
			reset();
			_model.parseReport(_report);
			_model.rewardString = rewardString;
			loadResource();
		}
		public function replay():void
		{
			this.play(_model.report,_model.rewardString);
			_resultView.hide();
		}
		private function loadResource():void
		{
			var rList:Array = [];
			var pre:String = LanguageRunner.getLanguageText("BATTLE_PRELOAD_RESOURCES");
			if(_background==null)
			{
				rList.push({id: "backgroud", url: BattleResourceConfig.getWarMapPath(1),info:pre+LanguageRunner.getLanguageText("BATTLE_BG")});
			}
			if(!BattleResource.warUIMap.hasOwnProperty("ui/title.png"))
			{
				rList.push({id: "warui", url: BattleResourceConfig.getWaruiPath(), info:pre+LanguageRunner.getLanguageText("BATTLE_LOADINGUI")});
				rList.push({id: "battlenum", url: BattleResourceConfig.getBattleNumPath(), info:pre+LanguageRunner.getLanguageText("BATTLE_LOADINGUI")});
			}
			var soldierList:Array = WarReportCenter.getInstance().getUsedSoldierIDList();
			for each (var soldierid:String in soldierList)
			{
				var arr:Array = soldierid.split("_");
				var url:String  = BattleResourceConfig.getWarUnitPath(soldierid);
				if(!(soldierid in BattleResource.warSoldierMap))
				{
					rList.push({id: "solider_" + soldierid, url: url, info: pre+LanguageRunner.getLanguageText("BATTLE_SOILDER") + soldierid});
				}
				
				var urls:String = BattleResourceConfig.getWarUnitPath2(soldierid)
				if(!(soldierid+"_w" in BattleResource.warSoldierMap))
				{
					rList.push({id: "soliderimg_" + soldierid, url: urls, info: pre+LanguageRunner.getLanguageText("BATTLE_SOILDER") + soldierid});
				}
				//反方向
				var r:String = arr[1]==0?"1":"0";
				var rSoldierId:String = arr[0]+"_"+r;
				var rurl:String = BattleResourceConfig.getWarUnitPath2(rSoldierId);
				if(!(rSoldierId+"_w" in BattleResource.warSoldierMap))
				{
					rList.push({id: "soliderimg_" + rSoldierId, url: rurl, info: pre+LanguageRunner.getLanguageText("BATTLE_SOILDER") + soldierid});
				}
			}
			var listurl:String = BattleResourceConfig.getWarListPath();
			if(! (0 in BattleResource.warSoldierListMap))
			{
				rList.push({id: "soliderlist_0", url: listurl+'0.png', info: pre+LanguageRunner.getLanguageText("BATTLE_SOILDER") + soldierid});
			}
			if(! (1 in BattleResource.warSoldierListMap))
			{
				rList.push({id: "soliderlist_1", url: listurl+'1.png', info: pre+LanguageRunner.getLanguageText("BATTLE_SOILDER") + soldierid});
			}
			ResourceLoadingView.show(rList, onItemComplete,onAllComplete,null,onItemFailed);
		}
		
		private function onItemComplete(item:Object, content:Object, domain:ApplicationDomain):void
		{
			switch (item.id)
			{
				case 'backgroud':
					this.background=content as Bitmap;
					break;
				case 'warui':
					BattleResourceConfig.processWarResource(content as Bitmap,item.id);
					break;
				case 'battlenum':
					BattleResourceConfig.processResource(content as Bitmap,item.id);
					break;
				default:
					if ((item.id).indexOf('solider_') == 0)
					{
						var arr:Array = item.id.split("_");		
						BattleResource.addWarSoldierResource(arr[1]+"_"+arr[2],(content as Bitmap).bitmapData);
					}
					if((item.id).indexOf('soliderimg_')==0)
					{
						var arrimg:Array = item.id.split("_");
						BattleResource.addWarSoldierResource(arrimg[1]+"_"+arrimg[2]+"_w",(content as Bitmap).bitmapData);
					}
					if((item.id).indexOf('soliderlist_')==0)
					{
						var arrList:Array = item.id.split("_");
						BattleResource.addWarListResource(arrList[1],(content as Bitmap).bitmapData);
					}
			}
		}
		
		private function onAllComplete():void
		{
			if (!initialized)
			{
				init();
			}
			if(BattleResource.getWarUIBitmapDataByKey('ui/start.png'))
			{
				if(!start)
				{
					start = new Bitmap(BattleResource.getWarUIBitmapDataByKey('ui/start.png'));
				}
			}
			start.width = start.width/10;
			start.height = start.height/10;
			start.x = (this.width-(start.width))>>1;
			start.y = (this.height-(start.height))>>1;
			start.visible = true;
			this.addChild(start);
			var xpos:Number = (this.width-(start.width)*10)>>1;
			var ypos:Number = (this.height-(start.height)*10)>>1;
			TweenLite.to(start,.8,{x:xpos,y:ypos,width:start.width*10,height:start.height*10,onComplete:startPlayFinished});
		}
		
		private var failedMsgList:Array = [];
		private function onItemFailed(obj:Object,msg:String):void
		{
			var txt:TextField = new TextField();
			txt.textColor = 0xFF0000;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.text = msg +"::"+ obj.url;
			stage.addChild(txt);
			txt.x = (stage.stageWidth - txt.width)>>1;
			txt.y = failedMsgList.length==0?100:failedMsgList[failedMsgList.length-1].y+failedMsgList[failedMsgList.length-1].height;
			failedMsgList.push(txt);
		}

		public function reset():void
		{
			if(initialized==false) return;
			
			clearBattleField();
			
			_battleTimer.reset();
			_armyListView.reset();
			_reportView.reset();

			busyLines.length=0;
			currentLine = null;
			start.visible = false;
			this.updateTitle();
		}
		private var currentLine:*;
		private function battleTimerHandler(event:TimerEvent=null):void
		{
			if(_lineRecordList.length<5 && currentLine==null)
			{
				currentLine =1;
			}
			else if(currentLine==null)
			{
				currentLine = 0;
			}
			if (_lineRecordList.length == 0)
			{
				_battleTimer.reset();
				currentLine = 0;
			}
			else
			{
				var commands:Array=_lineRecordList.shift() as Array;
				battleFieldMap[currentLine].start(commands);
				busyLines.push(currentLine);
				currentLine = currentLine+1;
			}
		}

		private function clearBattleField():void
		{
			for (var key:* in battleFieldMap)
			{
				var bf:BattleLine=battleFieldMap[key] as BattleLine;
				bf.clear();
			}
		}

		private function fightEnd(event:Event=null):void
		{
			var targetLineIndex:int=(event.target as BattleLine).index;

			var index:int=busyLines.indexOf(targetLineIndex);

			busyLines.splice(index, 1);

			if (busyLines.length == 0)
			{
				_resultView.show(_model.result_report,_model.rewardString)
				_armyListView.buttonToggle();
			}
		}
		
		public function showResultDirctely():void
		{
			reset();
			_resultView.show(_model.result_report,_model.rewardString);
		}

		private function init():void
		{
			initialized=true;		
			_armyListView=new ArmyListView();
			_armyListView.title.update();
			this.updateTitle();
			_armyListView._showResult = showResultDirctely;
			_reportView=new ReportView();
			_resultView=new ResultView(this);
			_resultView.hide();
			
			_battleTimer=new Timer(WarConfig.battleFieldDeley * 1000);

			_battleTimer.addEventListener(TimerEvent.TIMER, battleTimerHandler);

			battleFieldMap=new Dictionary();
			var point:Point;
			var bf:BattleLine
			for (var i:int=4; i >= 0; i--)
			{
				bf=new BattleLine(i);
				bf.addEventListener("fightEnd", fightEnd);
				bf.addEventListener("changeArmNum",changeArmNum);
				addChild(bf);
				point=POINTS[i];
				bf.x=(i+1)*166-258;//point.x-150+(i*-10);
				bf.y=(i+1)*96+30;//point.y+60+(i*30);
				battleFieldMap[i]=bf;
			}
			
			addChild(_armyListView);
			addChild(_reportView);
			addChild(_resultView);
			addChild(_effectLayer);
		}
		private function changeArmNum(e:CoreEvent):void
		{
			var data:Object = e.data;
			_armyListView.title.updateNum(data['side']);
		}
		private function startPlayFinished(event:Event = null):void
		{
			start.visible = false;
			_lineRecordList=_model.records_Report;

			//更新军队列表
			_armyListView.attackArmyList=_model.attArmyList;
			_armyListView.defendArmyList=_model.defArmyList;

			_battleTimer.reset();
			_battleTimer.start();
			battleTimerHandler();
		}
		public function updateTitle():void
		{
			var data:Object = {'lcurrentNum':_model.attArmyList.length,'ltotalNum':_model.attArmyList.length,'rcurrentNum':_model.defArmyList.length,'rtotalNum':_model.defArmyList.length,'ltitle':_model.war_title[0],'rtitle':_model.war_title[1]};
			_armyListView.title.updateData(data);
		}
		public function quit():void
		{
			reset();		
			//此处使用冒泡，目的是让gameUI中能处理到这个退出消息。
			CoreEventDispatcher.dispatchEvent(new Event("quitGroupBattle"));
		}
	}
}
