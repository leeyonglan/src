package functions.battle 
{
 import flash.utils.Dictionary; 
public class BattleUIConfig{ 
public static var  _dict:Dictionary = new Dictionary;
public function BattleUIConfig()
{	
_dict['result/draw.png']=[0,0,115,48];
_dict['result/fail.png']=[0,48,116,49];
_dict['result/gvs.png']=[0,97,150,126];
_dict['result/hpbg.png']=[0,223,1017,86];
_dict['result/hpprogress.png']=[0,309,232,22];
_dict['result/result.png']=[0,331,453,395];
_dict['result/rvs.png']=[0,726,150,126];
_dict['result/star.png']=[0,852,39,41];
_dict['result/tooltipbg.png']=[0,893,289,96];
_dict['result/typebg.png']=[0,989,23,25];
_dict['result/victory.png']=[0,1014,117,49];
}
public static function getConfig(id:String):int 
{
if(!_dict.hasOwnProperty(id))
{	
return null;
}
return _dict[id];
}
}
}