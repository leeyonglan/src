var firefoxUrl = "http://s1.l.mop.com/install_flash_player_firefox.exe";
var ieUrl = "http://s1.l.mop.com/install_flash_player_ax.exe";
var reportUrlPrefix="http://tj.mop.com/game.html";
var notice1 =  "<center><br><br><br><br><font color='#ffffff'>乱世天下提示<br><br>您的Flash Player版本过低，为了更好的体验我们的服务，请更新版本(ver:10.0.32.18)。</font><br/><br/><a href='"
var notice2 = "'><font color='#ffffff'>(点击这里更新Flash播放器插件)</font></a><br/><br/><font color='#ffffff'>安装Flash播放器完毕后,请关闭浏览器后，再重新打开浏览器体验游戏!(如果安装失败，请重启电脑后再安装播放器)</font></center>"
var notice3 = "加入收藏夹失败，请使用Ctrl+D进行添加。";
function initNavBar(){
	$("top").innerHTML=
//		'<a href="javascript:void(0);" onClick="redirect(\'urlCharge\')" >充值</a>' +
		'<a href="javascript:void(0);" onClick="redirect(\'urlHome\')" >官网</a>' +
		'<a href="javascript:void(0);" onClick="redirect(\'urlBBS\')" >论坛</a>' +
//		'<a href="javascript:void(0);" onClick="redirect(\'urlHelp\')" >帮助</a>' +
		'<a href="javascript:void(0);" onClick="addBookmark()" >收藏</a>' ;
	
}

var alerts={
  "0":"该功能尚未开放",
  "1":"请进入游戏后使用次功能",
  "2":""
}