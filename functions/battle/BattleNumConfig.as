package functions.battle 
{
 import flash.utils.Dictionary; 
public class BattleNumConfig{ 
public static var  _dict:Dictionary = new Dictionary;
public function BattleNumConfig()
{	
_dict['result/g0.png']=[0,0,18,18];
_dict['result/g1.png']=[18,0,12,18];
_dict['result/g2.png']=[30,0,18,18];
_dict['result/g3.png']=[48,0,18,18];
_dict['result/g4.png']=[66,0,17,18];
_dict['result/g5.png']=[83,0,18,18];
_dict['result/g6.png']=[101,0,16,18];
_dict['result/g7.png']=[117,0,18,18];
_dict['result/g8.png']=[135,0,18,18];
_dict['result/g9.png']=[153,0,17,18];
_dict['result/plus.png']=[170,0,13,12];
_dict['result/r0.png']=[183,0,18,18];
_dict['result/r1.png']=[201,0,12,18];
_dict['result/r2.png']=[213,0,18,18];
_dict['result/r3.png']=[231,0,18,18];
_dict['result/r4.png']=[249,0,17,18];
_dict['result/r5.png']=[266,0,18,18];
_dict['result/r6.png']=[284,0,16,18];
_dict['result/r7.png']=[300,0,18,18];
_dict['result/r8.png']=[318,0,18,18];
_dict['result/r9.png']=[336,0,17,18];
_dict['result/sub.png']=[353,0,13,4];
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