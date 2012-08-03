package functions.game.controller {
	import core.patterns.command.MacroOrder;
	import core.patterns.observer.INotification;
	import core.runner.StateRunner;
	import core.state.StateType;
	
	import enterbattle.controller.EnterBattleInitOrder;
	import enterbattle.controller.EnterGroupBattleInitOrder;
	
	import functions.announcement.controller.AnnouncementInitOrder;
	import functions.area.controller.AreaInitOrder;
	import functions.chat.controller.ChatInitOrder;
	import functions.city.controller.CityInitOrder;
	import functions.corps.controller.CorpsInitOrder;
	import functions.district.controller.DistrictInitOrder;
	import functions.envelope.controller.EnvelopeInitOrder;
	import functions.faceButton.controller.FaceButtonInitOrder;
	import functions.farm.controller.FarmInitOrder;
	import functions.generals.controller.GeneralsInitOrder;
	import functions.global.controller.GlobalSettingInitOrder;
	import functions.guides.controller.GuideInitOrder;
	import functions.human.controller.HumanInitOrder;
	import functions.item.controller.ItemInitOrder;
	import functions.maincity.controller.MainCityInitOrder;
	import functions.newEquip.controller.EquipInitOrder;
	import functions.newworld.controller.WorldInitOrder;
	import functions.panel.controller.PanelInitOrder;
	import functions.power.controller.PowerInitOrder;
	import functions.promptText.controller.PromptTextInitOrder;
	import functions.quest.controller.QuestInitOrder;
	import functions.rank.controller.RankInitOrder;
	import functions.role.controller.RoleInitOrder;
	import functions.server.controller.ServerInitOrder;
	import functions.smallLoading.controller.SmallLoadingInitOrder;
	import functions.switchShowInfo.controller.SwitchShowInfoInitOrder;
	import functions.team.controller.TeamInitOrder;
	import functions.technology.controller.TechnologyInitOrder;
	
	import manager.Managers;
	
	/**
	 * 文件名：GameInitOrder.as
	 * <p>
	 * 功能：GameWorld开始初始化的命令
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-12-20
	 * <p>
	  
	 * <p>
	 *  
	 */
	public class GameInitOrder extends MacroOrder {
		
		public function GameInitOrder() {
			super();
		}
		
		override protected function initMacroOrder():void {
			super.initMacroOrder();
			// 服务器类初始化命令
			addSubOrder(ServerInitOrder);
			// 面板系统初始化命令
			addSubOrder(PanelInitOrder);
			// 进入战斗系统初始化命令
			addSubOrder(EnterBattleInitOrder);
			//	组队战斗军团战
			addSubOrder( TeamInitOrder );
			//进入团战系统初始化命令
			addSubOrder(EnterGroupBattleInitOrder);
			// 城市系统初始化命令
			addSubOrder(CityInitOrder);
			// 时间系统初始化命令
			addSubOrder(WorldInitOrder);
			// 界面按钮系统初始化命令
			addSubOrder(FaceButtonInitOrder);
			// 人物系统初始化命令
			addSubOrder(RoleInitOrder);
			// 道具系统初始化命令
			addSubOrder(ItemInitOrder);
			// 装备系统初始化命令
			addSubOrder(EquipInitOrder);
			
			// 聊天系统初始化命令
			addSubOrder(ChatInitOrder);
			// 地区系统初始化命令
			addSubOrder(AreaInitOrder);
			// 农田系统初始化命令
			addSubOrder(FarmInitOrder);
			// 关卡系统初始化命令
			addSubOrder(PowerInitOrder);
			// 全局配置初始化命令
			addSubOrder(GlobalSettingInitOrder);
			// 弹出浮动文字初始化命令
			addSubOrder(PromptTextInitOrder);
			// 切换场景显示信息初始化命令
			addSubOrder(SwitchShowInfoInitOrder);
			// 弹出小loading条的初始化命令
			addSubOrder(SmallLoadingInitOrder);
			addSubOrder(RankInitOrder);
			//			//公告系统初始化命令
			addSubOrder(AnnouncementInitOrder);

			//	主城面板
			addSubOrder(MainCityInitOrder);
			//	武将面板
			addSubOrder(GeneralsInitOrder);
			//	区域
			addSubOrder(DistrictInitOrder);
			//科技与征兵
			addSubOrder(TechnologyInitOrder);	
			//	任务
			addSubOrder( QuestInitOrder );
			//	军团
			addSubOrder( CorpsInitOrder );		
			addSubOrder( HumanInitOrder );		
			//小信封
			addSubOrder(EnvelopeInitOrder);		
			//			// 新手引导
			addSubOrder(GuideInitOrder);
		}
		
		override protected function executeAfterSubOrders(note:INotification):void {
			super.executeAfterSubOrders(note);
			//初始化完毕 进入游戏
			StateRunner.switchState(StateType.GAME_WORLD);
			Managers.secondLoadManager.init();
			//开始二次加载
			//ResourceRunner.startSecondLoad();
		}
		
	}
}