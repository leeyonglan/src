package functions.battle.teamWar
{
 import flash.utils.Dictionary; 
public class WarUIConfig{ 
public static var  _dict:Dictionary = new Dictionary;
public function WarUIConfig()
{	
_dict['ui/start.png']=[0,0,350,100];
_dict['ui/title.png']=[0,100,520,77];
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