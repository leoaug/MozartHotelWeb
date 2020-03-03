<%@taglib prefix="s" uri="/struts-tags"%>


<div style="visibility: hidden; display:none;"><a
	href=http://www.milonic.com/menuproperties.php>http://www.milonic.com/menuproperties.php</a>
</div>

<script language="javascript" type="text/javascript">
fixMozillaZIndex=true; //Fixes Z-Index problem  with Mozilla browsers but causes odd scrolling problem, toggle to see if it helps
_menuCloseDelay=500;
_menuOpenDelay=150;
_subOffsetTop=0;
_subOffsetLeft=0;



with(submenuStyle=new mm_style()){
bgimage="imagens/menu/clxp_backPrata.gif";
bordercolor="#808080";
borderstyle="solid";
borderwidth=1;
fontfamily="Verdana, Tahoma, Arial";
fontsize="70%";
fontstyle="normal";
fontweight="normal";
offcolor="#000000";
oncolor="#000000";
onsubimage="imagens/menu/clxp_whitearrow.gif";
outfilter="fade(duration=0.5)";
overbgimage="imagens/menu/clxp_back_onPrata.gif";
overfilter="Fade(duration=0.2);Alpha(opacity=90);Shadow(color=#939393', Direction=145, Strength=4)";
padding=7;
subimage="imagens/menu/clxp_blackarrow.gif";
subimagepadding=4;
menubgcolor="#ffffff";
}
</script>

<script language="javaScript">
<s:property value="#session.USER_SESSION.usuarioEJB.getPrintMenu(#session.ID_PROGRAMA_LIST)" />
</script>

<script language="javaScript">
drawMenus();
</script>

<script language="javaScript">

function openmenu(url){
    window.location='<%=session.getAttribute("URL_BASE")%>'+url;
}
</script>