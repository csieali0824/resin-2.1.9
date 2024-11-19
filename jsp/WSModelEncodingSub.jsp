<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>產品編碼子系統</title>
<script language="JavaScript" src="mm_menu.js"></script>
<style type="text/css">
<!--
.style1 {color: #FFFFFF}
.style2 {
	color: #000099;
	font-weight: bold;
	font-family: "標楷體";
}
-->
</style>
</head>

  <jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<STYLE type=text/css>
A:link {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:active {
	TEXT-DECORATION: none
}
A:visited {
	TEXT-DECORATION: none;
	color: #1878C2;
}
A:hover {
	COLOR: #3333FF; TEXT-DECORATION: none
}
td {
	font-size: 12px;
}
.tab {
	background-image:  url(../image/bd.jpg);
	background-repeat: no-repeat;
}
</STYLE>
<script language="JavaScript">
function mmLoadMenus() 
{
    if (window.mm_menu_0618145003_0) return;
  window.mm_menu_0618145003_0 = new Menu("root",180,18,"",12,"#3366FF","#FF0000","#E4F1FA","#66CCFF","left","middle",3,0,500,-5,7,true,true,true,0,true,true);
  <%   		
  try
  {
    String MODEL_C1 = "G0";
	Statement statement=con.createStatement();
    //String sql = "select ADDRESS,PROGRAMMERNAME from WSPROGRAMMER WHERE ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') AND  MODEL='"+MODEL_D1+"' order by Lineno"; 
    //out.println(sql);   
    //ResultSet rs_D1=statement.executeQuery("select ADDRESS,PROGRAMMERNAME from WSPROGRAMMER WHERE ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') AND  MODEL='"+MODEL_D1+"' order by Lineno");
	String sSql = "SELECT DISTINCT  FADDRESS as ADDRESS,FFUNCTION||'--'||FDESC AS PROGRAMMERNAME  FROM MENUMODULE,MENUFUNCTION,WSPROGRAMMER "+
	                    " WHERE MMODULE=FMODULE AND FSHOW=1 AND  substr(FFUNCTION,0,5)= 'C1-S1'  "+
	                   " AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"')"+
	                  " ORDER BY FFUNCTION||'--'||FDESC ";
   //out.println(sSql);
   ResultSet rs_C1=statement.executeQuery(sSql);					  
    //2005/06/10 ResultSet rs_C1=statement.executeQuery("select ADDRESS,PROGRAMMERNAME from WSPROGRAMMER WHERE ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') AND  MODEL='"+MODEL_C1+"' order by Lineno");
	String right_link="";
	String ADDRESS_C1="";
	String PROGRAMMERNAME_C1="";
    rsBean.setRs(rs_C1);
    while(rs_C1.next())
    {
      	 ADDRESS_C1 = rs_C1.getString("ADDRESS");
		 PROGRAMMERNAME_C1 = rs_C1.getString("PROGRAMMERNAME");
		//out.println("<font size=-1><a href="+ ADDRESS_D1 +">"+PROGRAMMERNAME_D1+"</a><br>");
	    //right_link=right_link+"<option "+"value=\""+ ADDRESS_D1 +"\">"+PROGRAMMERNAME_D1+"</option>\n";
		//out.println("<font size=-1><a href="+ ADDRESS_D1 +">"+PROGRAMMERNAME_D1+"</a><br>");
		out.println("mm_menu_0618145003_0.addMenuItem(\""+PROGRAMMERNAME_C1+"\",\"location='"+ADDRESS_C1+"'\");");
	}
	//out.println(ADDRESS_D1);
	//out.println(PROGRAMMERNAME_D1);
	statement.close();
	rs_C1.close();
  } //end of try
  catch (Exception e)
  {
    out.println("Exception:"+e.getMessage());
  } 
%>	
   //mm_menu_0128134123_0.addMenuItem("新增維修案件","location='#'");
   mm_menu_0618145003_0.hideOnMouseOut=true;
   mm_menu_0618145003_0.bgColor='#555555';
   mm_menu_0618145003_0.menuBorder=1;
   mm_menu_0618145003_0.menuLiteBgColor='#FFFFFF';
   mm_menu_0618145003_0.menuBorderBgColor='#777777';


  window.mm_menu_0618132225_0 = new Menu("root",180,18,"",12,"#3366FF","#FF0000","#E4F1FA","#66CCFF","left","middle",3,0,500,-5,7,true,true,true,0,true,true);
  <%   		
  try
  {
    String MODEL_D1 = "G1";
	Statement statement=con.createStatement();
    //String sql = "select ADDRESS,PROGRAMMERNAME from WSPROGRAMMER WHERE ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') AND  MODEL='"+MODEL_D1+"' order by Lineno"; 
    //out.println(sql);       
	String sSql = "SELECT DISTINCT  FADDRESS as ADDRESS,FFUNCTION||'--'||FDESC AS PROGRAMMERNAME  FROM MENUMODULE,MENUFUNCTION,WSPROGRAMMER "+
	                    " WHERE MMODULE=FMODULE AND FSHOW=1 AND  substr(FFUNCTION,0,5)= 'C2-S1'  "+
	                   " AND FFUNCTION=ADDRESSDESC"+" AND ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"')"+
	                  " ORDER BY FFUNCTION||'--'||FDESC ";
    // 2005/06/10 ResultSet rs_D1=statement.executeQuery("select ADDRESS,PROGRAMMERNAME from WSPROGRAMMER WHERE ROLENAME IN (select ROLENAME from WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') AND  MODEL='"+MODEL_D1+"' order by Lineno");
	ResultSet rs_D1=statement.executeQuery(sSql);
	String right_link="";
	String ADDRESS_D1="";
	String PROGRAMMERNAME_D1="";
    rsBean.setRs(rs_D1);
    while(rs_D1.next())
    {
      	 ADDRESS_D1 = rs_D1.getString("ADDRESS");
		 PROGRAMMERNAME_D1 = rs_D1.getString("PROGRAMMERNAME");
		//out.println("<font size=-1><a href="+ ADDRESS_D1 +">"+PROGRAMMERNAME_D1+"</a><br>");
	    //right_link=right_link+"<option "+"value=\""+ ADDRESS_D1 +"\">"+PROGRAMMERNAME_D1+"</option>\n";
		//out.println("<font size=-1><a href="+ ADDRESS_D1 +">"+PROGRAMMERNAME_D1+"</a><br>");
		out.println("mm_menu_0618132225_0.addMenuItem(\""+PROGRAMMERNAME_D1+"\",\"location='"+ADDRESS_D1+"'\");");
	}
	//out.println(ADDRESS_D1);
	//out.println(PROGRAMMERNAME_D1);
	statement.close();
	rs_D1.close();
  } //end of try
  catch (Exception e)
  {
    out.println("Exception:"+e.getMessage());
  } 
%>	
   //mm_menu_0128134123_0.addMenuItem("新增維修案件","location='#'");
   mm_menu_0618132225_0.hideOnMouseOut=true;
   mm_menu_0618132225_0.bgColor='#555555';
   mm_menu_0618132225_0.menuBorder=1;
   mm_menu_0618132225_0.menuLiteBgColor='#FFFFFF';
   mm_menu_0618132225_0.menuBorderBgColor='#777777';

   mm_menu_0618132225_0.writeMenus();
} // mmLoadMenus()
</script>
<script language="JavaScript" src="../wins/mm_menu.js"></script>
</head>
<body topmargin="0" class="tab">
<script language="JavaScript1.2">mmLoadMenus();</script>
  <%
  String USERROLES=(String)session.getAttribute("USERROLES");  
  //String UserName=(String)session.getAttribute("USERNAME"); 
  %>
 <table width="77%" height="30" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" >
  <tr>
    <td width="25%" align="left" bgcolor="#FFFFFF" colspan="3"><div align="center" class="style2"><font size="+2">產品編碼系統</font></div></td>
  </tr> 
 </table>
 <table width="77%" height="30" border="1" align="center" cellpadding="0" cellspacing="0" bgcolor="#93CCF8" class="tab">  
  <tr>
    <td width="25%" align="left" bgcolor="#E4F1FA"><font color="#FFFFFF"><div align="center">
      <span class="style1"> 
      <a href="#" name="link5" id="link3" onMouseOver="MM_showMenu(window.mm_menu_0618145003_0,0,13,null,'link5')" onMouseOut="MM_startTimeout();" >產品編碼輸入</a></span></div>
    
    </font></td>
    <td width="25%" align="left" bgcolor="#E4F1FA"><div align="center">
      <span class="style1"> 
      <a href="#" name="link2" id="link1" onMouseOver="MM_showMenu(window.mm_menu_0618132225_0,0,13,null,'link2')" onMouseOut="MM_startTimeout();" >基本資料查詢與新增</a></span></div></td>
    <td width="25%" align="left" bgcolor="#E4F1FA"><font color="#FFFFFF"><div align="center"><A HREF="../WinsMainMenu.jsp">首頁</A></div></font></td>	
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
