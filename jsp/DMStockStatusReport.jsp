<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function Wopen(sModel)
{   
	//subWin=window.open("DMStockStatusDetailReport.jsp?PRODNO="+prod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
	subWin=window.open("DMStockStatusItemReport.jsp?MODELNO="+sModel,"subwin");  
}
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Material Loading and F/G Status</title>
</head>

<body>
<%

try {
	//取得傳入參數
	String sModelNo=request.getParameter("MODELNO");
	
	if (sModelNo==null) { sModelNo = ""; }


%>

<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> Material Loading and F/G Status</strong></font>

<%
	DecimalFormat df=new DecimalFormat(",000");
	
	if (sModelNo!=null && !sModelNo.equals("")) {
	
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
		
		//請購數
		String sRQTY = "0";		
		String sPR = "SELECT SUM(l.RQQTY) AS RQTY "+
		" FROM PSALES_FORE_APP_LN l,PSALES_FORE_APP_HD h "+
		" WHERE l.DOCNO=h.DOCNO and h.CANCEL!='Y' and h.APPROVED='Y' "+
		" and h.COUNTRY='886'"+" and l.PRJCD='"+sModelNo+"' ";
		//out.println(sPR);
		Statement stPR=con.createStatement();    
		ResultSet rsPR=stPR.executeQuery(sPR);
		if (rsPR.next()) { 
			sRQTY = rsPR.getString("RQTY");
			if (sRQTY==null || sRQTY.equals("")) { sRQTY ="0"; }
			if (Float.parseFloat(sRQTY)>0) {sRQTY = df.format(Math.round(Float.parseFloat(sRQTY)*1000));}
		}			
		rsPR.close();
		stPR.close();

		//出貨數
		String sSQTY = "0";
		String ymCurrFr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();//今天日期
		String sSP = "select ABS(sum(ILQTY)) as qty from SIH h,SIL l "+
			" WHERE h.SICUST=l.ILCUST and h.SIORD=l.ILORD and h.IHODYR=l.ILODYR and h.IHODPX=l.ILODPX and h.SIINVN=l.ILINVN  "+ 
			" and h.SFRES not in('REPAI') and (h.SICTYP not in ('12','13') or h.SICUST  in('210040')) "+             
			" and h.SIINVD <= "+ymCurrFr+" and l.ILPROD IN ("+sItem+") ";
		//out.println(sSP);
		Statement stSP=bpcscon.createStatement();    
		ResultSet rsSP=stSP.executeQuery(sSP);
		if (rsSP.next()) { 
			sSQTY = rsSP.getString("qty");
			if (sSQTY==null || sSQTY.equals("")) { sSQTY = "0"; }
			if (Float.parseFloat(sSQTY)>1000) { sSQTY = df.format(Math.round(Float.parseFloat(rsSP.getString("qty")))); }
			else { sSQTY = String.valueOf(Math.round(Float.parseFloat(sSQTY)));}
		}	
		rsSP.close();
		stSP.close();
		
		//樣品領用數
		String sSampQty = "0";
		String sSA = "SELECT SUM(TMQTY)*-1 AS TMQTY FROM TRYM WHERE TMTYPE IN ('S','SR') AND TMPROD IN ("+sItem+")";
		//out.println(sSA);
		Statement stSA=bpcscon.createStatement();    
		ResultSet rsSA=stSA.executeQuery(sSA);
		if (rsSA.next()) {
			sSampQty = rsSA.getString("TMQTY");
			if (sSampQty==null || sSampQty.equals("")) { sSampQty = "0"; }
			if (Float.parseFloat(sSampQty)>1000) { sSampQty = df.format(Math.round(Float.parseFloat(sSampQty))); } 
			else { sSampQty = String.valueOf(Math.round(Float.parseFloat(sSampQty)));}
		}
		rsSA.close();
		stSA.close();
		
		//庫存數
		String sStockQty = "0";
		String sWIPQty = "0";
		String sMaxQty = "0";
		String sMaxQty1 = "0";
		String sDate = "";
		String sql = "SELECT MAX(MDATE) AS MDATE,SUM(MSTOCKQTY) AS MSTOCKQTY,MAX(MMAXQTY) AS MMAXQTY,MAX(MMAXQTY1) AS MMAXQTY1, SUM(MWIPQTY) AS MWIPQTY "+
		" FROM MATESTOCK"+
		" WHERE MPRODNO IN ("+sItem+")";
		//out.println(sql);
		//Statement state=bpcscon.createStatement();  
		Statement state=dmcon.createStatement();    
		ResultSet rs=state.executeQuery(sql);
		boolean rs_isEmpty = !rs.next();
		boolean rs_hasData = !rs_isEmpty;
		if (rs_isEmpty) { sDate = "沒有最後一次更新紀錄"; } // end if
		else {
			sDate = rs.getString("MDATE");
			if (sDate==null || sDate.equals("")) {sDate = "沒有最後一次更新紀錄";}
			else {
				sDate = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8); 
				sStockQty = rs.getString("MSTOCKQTY"); if (sStockQty==null || sStockQty.equals("")) { sStockQty = "0"; }
				sWIPQty = rs.getString("MWIPQTY"); if (sWIPQty==null || sWIPQty.equals("")) { sWIPQty = "0"; }
				sMaxQty = rs.getString("MMAXQTY"); if (sMaxQty==null || sMaxQty.equals("")) { sMaxQty = "0"; }
				sMaxQty1 = rs.getString("MMAXQTY1"); if (sMaxQty==null || sMaxQty1.equals("")) { sMaxQty1 = "0"; }
				if (Float.parseFloat(sStockQty)>1000) { sStockQty = df.format(Math.round(Float.parseFloat(sStockQty))); } 
				else { sStockQty = String.valueOf(Math.round(Float.parseFloat(sStockQty)));}
				if (Float.parseFloat(sWIPQty)>1000) { sWIPQty = df.format(Math.round(Float.parseFloat(sWIPQty))); } 
				else { sWIPQty = String.valueOf(Math.round(Float.parseFloat(sWIPQty)));}
				if (Float.parseFloat(sMaxQty)>1000) { sMaxQty = df.format(Math.round(Float.parseFloat(sMaxQty))); } 
				else { sMaxQty = String.valueOf(Math.round(Float.parseFloat(sMaxQty)));}
				if (Float.parseFloat(sMaxQty1)>1000) { sMaxQty1 = df.format(Math.round(Float.parseFloat(sMaxQty1))); } 
				else { sMaxQty1 = String.valueOf(Math.round(Float.parseFloat(sMaxQty1)));}
			}
		}
		rs.close();
		state.close();

%>
<table border="1">
<tr bgcolor="#0072A8"><td><font color="#FFFF00" size="2" face="Arial">庫存更新日期</font></td><td><font color="#FFFF00" size="2" face="Arial"><%=sDate%></font></td></tr>
<tr><td><font color="#000000" size="2" face="Arial">請購數</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sRQTY%></font></td></tr>
<tr>
    <td height="80"><font color="#000000" size="2" face="Arial">累計出貨數</font></td>
    <td align="right"><font color="#000000" size="2" face="Arial"><%=sSQTY%></font></td></tr>
<tr><td><font color="#000000" size="2" face="Arial">樣品領用數</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sSampQty%></font></td></tr>
<tr><td><font color="#000000" size="2" face="Arial">成品庫存數</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sStockQty%></font></td></tr>
<tr><td><font color="#000000" size="2" face="Arial">未結工單數</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sWIPQty%></font></td></tr>
<tr><td><font color="#000000" size="2" face="Arial">成套材料數</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sMaxQty%></font></td></tr>
<tr><td><font color="#000000" size="2" face="Arial">成套材料數(80%)</font></td><td align="right"><font color="#000000" size="2" face="Arial"><%=sMaxQty1%></font></td></tr>
</table>
<p><a href='javaScript:Wopen("<%=sModelNo%>")'>查看明細資料</a></p>

<%

	} // end if sModelNo
} // end try

catch (Exception e) { out.println("Exception:"+e.getMessage()); }
%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>