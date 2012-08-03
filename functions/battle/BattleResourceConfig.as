package functions.battle
{
	import core.global.ConfigConnect;
	import core.runner.ResourceRunner;
	
	import data.BattleResource;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import functions.battle.teamWar.WarUIConfig;

	public class BattleResourceConfig
	{
		private static var tempUrl:String;
		private static var basePath:String = ResourceRunner.rootPath;
		private static var resourceCache:Dictionary=new Dictionary();
		public var onCompleteBK:Function;
		
		public static function addResurce(url:String,content:Bitmap):void
		{
			if(content==null)
			{
				return;
			}
			resourceCache[url]=content;
		}
		
		public static function hasResource(url:String):Boolean
		{
			return url in resourceCache;
		}
		public function BattleResourceConfig()
		{
			
		}
		
		public static function getI18Path():String
		{
			return basePath + "battle/" + "skillName.swf";
		}
		public static function getBattleUIPath():String
		{
			return basePath + "battle/result/" + "ui.png";
		}
		public static function getBattleNumPath():String
		{
			return basePath + "battle/result/" + "num.png";
		}
		/**
		 *
		 * 普通战斗资源路径
		 *
		 */
		public static function getBattleUnitPath(id:int):String
		{
			tempUrl=basePath + "battle/unit/" + id + ".png";
			return tempUrl;
		}
		
		public static function getBattleSkillPath(id:int):String
		{
			tempUrl=basePath + "battle/skill/" + id + ".png";
			return tempUrl;
		}
		
		public static function getBattleSpecialSkillPath(id:int):String
		{
			tempUrl=basePath + "battle/specialSkill/" + id + ".swf";
			return tempUrl;
		}
		public static function getBattleBuffEffectPath(id:int):String
		{
			tempUrl=basePath + "battle/buff/" + id + ".png";
			return tempUrl;
		}
		public static function getBattleBuffIconPath(id:int):String
		{
			tempUrl=basePath + "battle/buff/icon" + id + ".png";
			return tempUrl;
		}
		/**
		 * 通过相对的路径获得绝对路径，只限于战斗模块静态资源 
		 * @param relativePath
		 * @return 
		 * 
		 */		
		public static function getBattleResPath(relativePath:String):String
		{
			tempUrl=basePath + "battle/" +relativePath;
			return tempUrl;
		}
		/*
		 *
		 * 多人战斗资源路径
		 *
		 */
		public static function getWarUnitPath(id:String):String
		{
			var arr:Array = id.split("_");
			var side:String;
			if(arr[1]==0)
			{
				side = "l";
			}
			else if(arr[1]==1)
			{
				side = "r";
			}
			else
			{
				trace("war battle soldier id is wrong");
			}
			tempUrl=basePath + "war/unit/" + arr[0] + "/"+side+".png";
			return tempUrl;
		}
		public static function getWarUnitPath2(id:String):String
		{
			var arr:Array = id.split("_");
			var side:String;
			if(arr[1]==0)
			{
				side = "lw";
			}
			else if(arr[1]==1)
			{
				side = "rw";
			}
			else
			{
				trace("war battle soldier id is wrong");
			}
			tempUrl=basePath + "war/unit/" + arr[0] + "/"+side+".png";
			return tempUrl;
		}
		public static function getWarListPath():String
		{
			tempUrl=basePath + "war/list/";
			return tempUrl;
		}
		public static function getWarSkillPath(id:*):String
		{
			tempUrl=basePath + "war/skill/" + id + ".swf";
			return tempUrl;
		}
		
		public static function getItemPath(id:*):String
		{
			tempUrl=basePath + "item/" + id + ".png";
			return tempUrl;
		}
		
		public static function getGuildPath(id:*):String
		{
			tempUrl=basePath + "guild/" + id + ".png";
			return tempUrl;
		}
		
		public static function getMisstionMapPath(mapID:*):String
		{
			tempUrl=basePath + "map/missionMap/" + mapID + ".swf";
			return tempUrl;
		}
		
		public static function getWarMapPath(mapID:*):String
		{
			tempUrl=basePath + "map/warMap/" + mapID + ".jpg";
			return tempUrl;
		}
		public static function getWarStartMc():String
		{
			return basePath + "war/teamwarStartMovie.swf";
		}
		public static function getBattleMapPath(mapID:*):String
		{
			if(ConfigConnect.isPad()){
				tempUrl=basePath + "map/battleMap/" + mapID + "_pad.jpg";
			}
			if(ConfigConnect.isWeb()){
				tempUrl = basePath + "map/battleMap/" + mapID + "_web.jpg";
			}
			return tempUrl;
		}
		public static function getWaruiPath():String
		{
			return basePath + "war/ui/warui.png";
		}
		public static function getCommonResPath(id:*, format:String='.png'):String
		{
			tempUrl=basePath + "common/" + id + format;
			return tempUrl;
		}
		public static function processWarResource(bit:Bitmap,key:String):void
		{
			var dict:Dictionary;
			if(key == "warui")
			{
				new WarUIConfig;
				dict = WarUIConfig._dict;
			}
			for(var i:String in dict)
			{
				if(BattleResource.warUIMap[i]==null)
				{
					var rect:Rectangle = new Rectangle(dict[i][0],dict[i][1],dict[i][2],dict[i][3]);
					var bitmapdata:BitmapData = new BitmapData(dict[i][2],dict[i][3],true,0);
					bitmapdata.copyPixels(bit.bitmapData,rect,new Point(0,0));
					BattleResource.warUIMap[i] = bitmapdata;
				}
			}
			bit.bitmapData.dispose();
			bit = null;
		}
		public static function processResource(bit:Bitmap,key:String):void
		{
			var dict:Dictionary;
			if(key == "battleui")
			{
				new BattleUIConfig;
				dict = BattleUIConfig._dict;
			}
			if(key == "battlenum")
			{
				new BattleNumConfig;
				dict = BattleNumConfig._dict;
			}
			for(var i:String in dict)
			{
				if(BattleResource.loadCache[i]==null)
				{
					var rect:Rectangle = new Rectangle(dict[i][0],dict[i][1],dict[i][2],dict[i][3]);
					var bitmapdata:BitmapData = new BitmapData(dict[i][2],dict[i][3],true,0);
					bitmapdata.copyPixels(bit.bitmapData,rect,new Point(0,0));
					BattleResource.loadCache[i] = bitmapdata;
				}
			}
			bit.bitmapData.dispose();
			bit = null;
		}
	}
}