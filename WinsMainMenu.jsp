<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得授權==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Main</title>
<style type="text/css">
A.menu {
	color: #000000;
	text-decoration:none;
}
A.bar {
	color: #FFFF00;
	text-decoration:none;
}

</style>
</head>
<script>
function mmLoadMenus() {
<%
String sLoc = "886";
String sLan = "zh_TW";
if (roles==null) roles = "''";if (UserRoles==null) UserRoles = "";
String mm_menu = "";

try {
	String sSql = "";
	//get module
	sSql = "SELECT DISTINCT MMODULE,MDESC,MSEQ FROM MENUMODULE,MENUFUNCTION,WSPROGRAMMER "+
	" WHERE MMODULE=FMODULE AND FSHOW=1 "+
	" AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
	" ORDER BY MSEQ,MMODULE ";
	//out.println(sSql);
	Statement stMod=con.createStatement();
	ResultSet rsMod=stMod.executeQuery(sSql);
	while(rsMod.next()) {
		out.println("window.mm_menu_"+rsMod.getString("MMODULE")+" = new Menu('"+rsMod.getString("MDESC")+"',260,20,'',12,'#0000FF','#0000CC','#CCFFFF','#00CCFF','left','middle',3,0,1000,-5,7,true,true,true,0,true,true);");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".hideOnMouseOut=true;");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".bgColor='#555555';");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".menuBorder=1;");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".menuLiteBgColor='#FFFFFF';");
		out.println("mm_menu_"+rsMod.getString("MMODULE")+".menuBorderBgColor='#777777';");
	}// end while
	rsMod.close();
	stMod.close();
	// end get module
	//get function
	sSql = "SELECT DISTINCT FMODULE,FFUNCTION,FFUNCTION||'--'||FDESC AS FDESC,FADDRESS,FSEQ FROM MENUMODULE,MENUFUNCTION,WSPROGRAMMER "+
	" WHERE MMODULE=FMODULE AND FSHOW=1 "+
	" AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
	" ORDER BY FSEQ,FFUNCTION ";
	//out.println(sSql);
	Statement stFun=con.createStatement();
	ResultSet rsFun=stFun.executeQuery(sSql);
	while(rsFun.next()) {
		out.println("mm_menu_"+rsFun.getString("FMODULE")+".addMenuItem("+'"'+rsFun.getString("FDESC")+'"'+","+'"'+"location="+"'"+rsFun.getString("FADDRESS")+"'"+'"'+");");
	} // end while
	rsFun.close();
	stFun.close();
	// end get function
	//get root
	sSql = "SELECT RROOT,RDESC FROM MENUROOT ORDER BY RSEQ,RROOT ";
	//out.println(sSql);
	Statement stRoot=con.createStatement();
	ResultSet rsRoot=stRoot.executeQuery(sSql);
	while (rsRoot.next()) {
		out.println("window.mm_menu_"+rsRoot.getString("RROOT")+" = new Menu('root',260,20,'',12,'#0000FF','#0000CC','#CCFFFF','#00CCFF','left','middle',3,0,1000,-5,7,true,true,true,0,true,true);");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".hideOnMouseOut=true;");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".bgColor='#555555';");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".menuBorder=1;");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".menuLiteBgColor='#FFFFFF';");
		out.println("mm_menu_"+rsRoot.getString("RROOT")+".menuBorderBgColor='#777777';");
		//get module
		sSql = "SELECT DISTINCT MMODULE,MDESC,MSEQ FROM MENUMODULE,MENUFUNCTION,WSPROGRAMMER "+
		" WHERE MMODULE=FMODULE AND FSHOW=1 "+
		" AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN ("+roles+")"+
		" AND MROOT='"+rsRoot.getString("RROOT")+"'"+
		" ORDER BY MSEQ,MMODULE ";
		//out.println(sSql);
		stMod=con.createStatement();
		rsMod=stMod.executeQuery(sSql);
		boolean isEmpty = !rsMod.next();
		if (isEmpty) {
			out.println("mm_menu_"+rsRoot.getString("RROOT")+".addMenuItem('空');");
		} else {
			while (!isEmpty) {			
				out.println("mm_menu_"+rsRoot.getString("RROOT")+".addMenuItem(mm_menu_"+rsMod.getString("MMODULE")+");");
				isEmpty = !rsMod.next();
			} // end while
		} // end if
		rsMod.close();
		stMod.close();
		//
		mm_menu = rsRoot.getString("RROOT"); // 找一個menu來write
		//	
	} // end while root
	rsRoot.close();
	stRoot.close();
	//
	out.println("window.mm_menu_"+mm_menu+".writeMenus();");

} catch (Exception ee) {
	out.println("Exception:"+ee.getMessage());
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
}
%>


} // mmLoadMenus
</script>
<script src="mm_menu.js"></script>

<body>
<script>mmLoadMenus();</script>
<%//=UserName%>
<%//=UserRoles%>
<%//=roles%>
<%//=flag%>
<table width="770" align="center">
<!-- 上半部 -->
<tr>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
	<td colspan="2" width="700" height="100%" background="image/top-bd.jpg"><img src="image/top.jpg" width="720" height="83"></td>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>

</tr>
<tr>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
	<td colspan="2" width="100%" bgcolor="#0F67AE">
		<table width="240">
			<tr>
				<%
				
				if(flag.equals("ok")) { // 表示是用NOTES的認證
				} else { // 表示是用本系統自己的認證
				%>
				<td width="70" align="center"><font size="-1" face="Arial" color="#FFFFFF"><a href="./jsp/EditEmployeeUser1.jsp" class="bar">修改密碼</a></font></td>
				<td width="4"><img src="image/line.gif" border="0" width="3" height="20"></td>
				<%
				} // end if
				%>
				<td width="70" align="center"><font size="-1" face="Arial" color="#FFFFFF"><a href="./jsp/logout.jsp" class="bar">登出</a></font></td>
				<td></td>
			</tr>
		</table>
	</td>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
</tr>
<!-- 下半部 -->
<tr>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
	<!-- 左半部 -->
	<td width="30%" valign="top">
		<table width="100%">
		<%
		String sSql = "";
		sSql = "SELECT RROOT,RDESC FROM MENUROOT ORDER BY RSEQ,RROOT ";
		Statement stRoot=con.createStatement();
		ResultSet rsRoot=stRoot.executeQuery(sSql);
		while (rsRoot.next()) {
		%>
			<tr>
				<td>
				<font size="-1" face="Arial">
				<a href="#" name="link<%=rsRoot.getString("RROOT")%>" id="link<%=rsRoot.getString("RROOT")%>" class="menu" onMouseOver="MM_showMenu(window.mm_menu_<%=rsRoot.getString("RROOT")%>,90,0,null,'link<%=rsRoot.getString("RROOT")%>')" onMouseOut="MM_startTimeout()"><%=rsRoot.getString("RDESC")%><img src="./arrows.gif" width="20" height="9" border="0"></a>
				</font>
				</td>
			</tr>
			<tr><td><img src="./image/line-2.gif" width="220" height="4" hspace="5"></td></tr>
		<%
		} // end while
		rsRoot.close();
		stRoot.close();
		%>
		</table>
	</td>
	<!-- 右半部 -->
	<td width="70%" background="image/bd.jpg">
		<table width="100%" height="340">
			<tr><td colspan="2"><font face="Arial" size="-1" color="#3399FF">帳戶<%=UserName%>已登入(<%=roles%>)</font></td></tr>
			<tr><td colspan="2"><font face="Arial" size="-1" color="#FF6600">其他系統連結</font></td>
			</tr>
			<tr><td colspan="2"></td></tr>
			<tr><td width="10"></td><td><a href="http://repairapp.dbtel.com.tw/repair"><img src="image/s-tool-link.gif" border="0"></a></td></tr>
			<tr><td colspan="2" ></td></tr>
			<tr><td width="10"></td><td><a href="http://speed.dbtel.com.tw/jetspeed"><img src="image/s-info-k.gif" border="0"></a></td></tr>
			<tr><td colspan="2" height="200"></td></tr>
		</table>
	</td>
	<td width="35"><img src="image/spacer.gif" border="0" width="35" height="20"></td>
</tr>
</table>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>