<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function Wopen(prod,tp)
{   
	//subWin=window.open("DMStockStatusDetailReport.jsp?PRODNO="+prod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
	if (tp=="SO") {
		subWin=window.open("DMStockStatusSOReport.jsp?PRODNO="+prod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
	}
	else {
		subWin=window.open("DMStockStatusDetailReport.jsp?PRODNO="+prod,"subwin");  
	}
}
</script>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Stock Status by Item</title>
</head>

<body>
<%
	//取得傳入參數
	String sModelNo=request.getParameter("MODELNO");
	if (sModelNo==null) { sModelNo = ""; }
%>
<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> Stock Status by Item</strong></font>
<table border="1">
<%
try
{
	String sDate = "";
	
	if (sModelNo!=null && !sModelNo.equals(""))
	{

		// Item String for TW
		String sItem = "";
		String sIM = "SELECT MITEM FROM PRODMODEL WHERE MPROJ='"+sModelNo+"' AND MCOUNTRY='886' ";
		Statement stIM=con.createStatement();    
		ResultSet rsIM=stIM.executeQuery(sIM);
		if (rsIM.next()) { sItem = "'" + rsIM.getString("MITEM") + "'"; }
		while (rsIM.next()) { sItem = sItem + ",'" + rsIM.getString("MITEM") + "'"; }		
		rsIM.close();
		stIM.close();
		if (sItem==null || sItem.equals("")) { sItem = "' '"; }
		//out.println(sItem);

		//String sql = "SELECT MDATE,MPRODNO,MSTOCKQTY,MMAXQTY,MMAXQTY1,IDESC||IDSCE AS DESC, MWIPQTY "+
		//" FROM MATESTOCK,IIM"+
		//" WHERE MPRODNO=IPROD AND MMODELNO='"+sModelNo+"' AND MPRODNO IN ("+sItem+")";
		String sql="SELECT MDATE,MPRODNO,MSTOCKQTY,MEXQTY AS MMAXQTY,MEXQTY1 AS MMAXQTY1,MWIPQTY  FROM MATESTOCK "+
		                 "WHERE MMODELNO='"+sModelNo+"' AND MPRODNO IN("+sItem+") ";
		//Statement state=bpcscon.createStatement(); 
		Statement state=dmcon.createStatement();   
		ResultSet rs=state.executeQuery(sql);
		boolean rs_isEmpty = !rs.next();
		boolean rs_hasData = !rs_isEmpty;
			
		if (rs_isEmpty) { sDate = "沒有最後一次更新紀錄"; } // end if
		else { sDate = rs.getString("MDATE"); sDate = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8); }
%>
<tr bgcolor="#0072A8">
	<td colspan="2"><font color="#FFFF00" size="2" face="Arial">庫存更新日期</font></td>
	<td colspan="5"><font color="#FFFF00" size="2" face="Arial"><%=sDate%></font></td>
</tr>
<tr>
	<td><font color="#000000" size="2" face="Arial">成品料號</font></td>
	<td><font color="#000000" size="2" face="Arial">品名</font></td>
	<td width="50"><font color="#000000" size="2" face="Arial">成品庫存數</font></td>
	<td width="50"><font color="#000000" size="2" face="Arial">未結工單數</font></td>
	<td width="50"><font color="#000000" size="2" face="Arial">成套材料數</font></td>
	<td width="50"><font color="#000000" size="2" face="Arial">成套材料數(80%)</font></td>
	<td width="50"><font color="#000000" size="2" face="Arial">庫存+工單+成套材料數(80%)</font></td>
</tr>
<%
		while (rs_hasData) {
		
			String sColor = "";
			if (rs.getInt("MMAXQTY")==0) {sColor="#FF0000";} else {sColor="#000000";}
			String sProd = rs.getString("MPRODNO").trim();
%>
<tr>
	<td><div align='left'><font color="<%=sColor%>" size="2" face="Arial"><%=sProd%></font></div></td>
	<td><div align='left'><font color="<%=sColor%>" size="2" face="Arial">
	<%
	   PreparedStatement ptItem =bpcscon.prepareStatement("SELECT IDESC||IDSCE AS DESC FROM IIM WHERE  IID='IM' AND IPROD='"+sProd+"' ");
	   ResultSet rsItem = ptItem.executeQuery();
	   if (rsItem.next())
	      {
		    String sItemDesc =rsItem.getString("DESC");
			out.print(sItemDesc);
		  }
	   ptItem.close();
	   rsItem.close();	  
	%>
	</font></div></td>
	<td><div align='right'><font color="<%=sColor%>" size="2" face="Arial"><%=rs.getString("MSTOCKQTY")%></font></div></td>
	<td><div align='right'><font color="<%=sColor%>" size="2" face="Arial"><A HREF="../jsp/DMStockStatusSOReport.jsp?PRODNO=<%=sProd%>"><%=rs.getString("MWIPQTY")%></A></font></div></td>
	<td><div align='right'><font color="<%=sColor%>" size="2" face="Arial"><%=rs.getString("MMAXQTY")%></font></div></td>
	<td><div align='right'><font color="<%=sColor%>" size="2" face="Arial"><a href="../jsp/DMStockStatusDetailReport.jsp?PRODNO=<%=sProd%>"><%=rs.getString("MMAXQTY1")%></a></font><font color="<%=sColor%>" size="2" face="Arial"></font></div></td>
	<td><div align='right'><font color="<%=sColor%>" size="2" face="Arial"><%=rs.getInt("MSTOCKQTY")+rs.getInt("MWIPQTY")+rs.getInt("MMAXQTY1")%></font></div></td>
</tr>

<%			
			rs_isEmpty = !rs.next();
			rs_hasData = !rs_isEmpty;
		}  // end while
		
		rs.close();
		state.close();
		
	} // end if sModelNo

%>
<%
} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }
%>


</table>


<font color="#FF0000" size=-2 face='Arial' >註一:庫存材料最大可產出套數計算方式=(主倉庫存數量+P/O暫收數量-工單未發料數量)/BOM標準用量</font>
<br><font color="#FF0000" size=-2 face='Arial' >註二:庫存材料80%成套數計算方式為依庫存材料可產出套數遞增排序,扣除前20%材料項目後取最小可產出套數</font>
<br><font color="#FF0000" size=-2 face='Arial' >註三:庫存材料最大可產出套數為零表示缺料</font>
<br><font color="#FF0000" size=-2 face='Arial' >註四:包材料不在計算範圍內</font>

</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
