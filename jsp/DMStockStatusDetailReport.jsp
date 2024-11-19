<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Stock Status Detail</title>
</head>

<body>
<%
	//取得傳入參數
	String sProdNo=request.getParameter("PRODNO");

%>

<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sProdNo%> Stock Status Detail</strong></font>
<table border="1">
<%
try
{

	String sDate = "";
	if (sProdNo!=null && !sProdNo.equals(""))
	{
		//Statement state=bpcscon.createStatement();
		Statement state=dmcon.createStatement();
		
		int iCnt = 0;
		double dRec = 0;
		ResultSet rs1=state.executeQuery("SELECT COUNT(*) AS CNT FROM MATESTOCKDTL WHERE MDPRODNO='"+sProdNo+"'"+" AND mdclas='EX' ");
		if (rs1.next())
		{
			iCnt = rs1.getInt("CNT"); 
			if (iCnt>0) {dRec = iCnt * 0.2;}
		}
		rs1.close();
		//out.println(fRec);
		
		//2005.01.12 cherry update 
		//String sql = "SELECT MDDATE,MDCHLDNO,MDREQ,MDSTOCKQTY,MDINSQTY,MDWIPQTY,MDMAXQTY,IDESC||IDSCE AS DESC FROM MATESTOCKDTL,IIM"+
		//" WHERE MDCHLDNO=IPROD AND MDPRODNO='"+sProdNo+"'"+
		//" ORDER BY MDMAXQTY";
		String sql = "SELECT MDDATE,MDCHLDNO,MDREQ,MDSTOCKQTY,MDINSQTY,MDWIPQTY,MDMAXQTY FROM MATESTOCKDTL"+
		" WHERE  MDPRODNO='"+sProdNo+"'"+" AND mdclas='EX' "+
		" ORDER BY MDMAXQTY";
		//out.println(sql);		    
		ResultSet rs=state.executeQuery(sql);
		boolean rs_isEmpty = !rs.next();
		boolean rs_hasData = !rs_isEmpty;
			
		if (rs_isEmpty) { sDate = "沒有最後一次更新紀錄"; } // end if
		else { sDate = rs.getString("MDDATE"); sDate = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8); }

%>
<tr bgcolor="#0072A8">
	<td><font color="#FFFF00" size="2" face="Arial">更新日期</font></td>
	<td colspan="7"><font color="#FFFF00" size="2" face="Arial"><%=sDate%></font></td>
</tr>
<tr>
	<td><font color="#000000" size="2" face="Arial">項次</font></td>
	<td><font color="#000000" size="2" face="Arial">料號</font></td>
	<td><font color="#000000" size="2" face="Arial">品名</font></td>
	<td><font color="#000000" size="2" face="Arial">標準用量</font></td>
	<td><font color="#000000" size="2" face="Arial">庫存數量</font></td>
	<td><font color="#000000" size="2" face="Arial">暫收數量</font></td>
	<td><font color="#000000" size="2" face="Arial">工單未發料數量</font></td>
	<td><font color="#000000" size="2" face="Arial">可產出套數</font></td>
</tr>


<%
		int n = 1;
		while (rs_hasData)
		{

%>
<% String sColor = ""; if (n<=dRec) {sColor = "FFFFFF";} else {sColor="FFFF99";} %>
<% String sFontColor = ""; if (rs.getInt("MDMAXQTY")<=0) {sFontColor="#FF0000";} else {sFontColor="#000000";} %>
<tr bgcolor="<%=sColor%>">
	<td><div align='left'><font color="<%=sFontColor%>" size="2" face="Arial"><%=n%></font></div></td>
	<td><div align='left'><font color="<%=sFontColor%>" size="2" face="Arial"><%=rs.getString("MDCHLDNO")%></font></div></td>
	<td><div align='left'><font color="#<%=sFontColor%>" size="2" face="Arial">
	<%
	    PreparedStatement ptItem =bpcscon.prepareStatement("SELECT IDESC||IDSCE AS DESC FROM IIM WHERE  IID='IM' AND IPROD='"+rs.getString("MDCHLDNO")+"' ");
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
	<td><div align='right'><font color="<%=sFontColor%>" size="2" face="Arial"><%=rs.getString("MDREQ")%></font></div></td>
	<td><div align='right'><font color="<%=sFontColor%>" size="2" face="Arial"><%=rs.getString("MDSTOCKQTY")%></font></div></td>
	<td><div align='right'><font color="<%=sFontColor%>" size="2" face="Arial"><%=rs.getString("MDINSQTY")%></font></div></td>
	<td><div align='right'><font color="<%=sFontColor%>" size="2" face="Arial"><%=rs.getString("MDWIPQTY")%></font></div></td>
	<td><div align='right'><font color="<%=sFontColor%>" size="2" face="Arial"><%=rs.getString("MDMAXQTY")%></font></div></td>
</tr>




<%
			n++;
			rs_isEmpty = !rs.next();
			rs_hasData = !rs_isEmpty;
		}  // end while
		rs.close();
		state.close();
	} // end if


} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }

%>
</table>
<font color="#FF0000" size=-2 face='Arial' >註一:可產出套數計算方式=(主倉庫存數量+P/O暫收數量-工單未發料數量)/BOM標準用量, 若可產出套數小於或等於零則以紅色字體表示</font>
<br><font color="#FF0000" size=-2 face='Arial' >註二:工單未發料數量小於零(需求小於投入,即超損耗)時不列入最大可產出套數計算</font>

</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
