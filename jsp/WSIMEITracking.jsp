<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean" %>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function btnCustomerInfo()
{ 
  subWin=window.open("subwindow/CustomerIMEISubWindow.jsp","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
</script>
<%
     //String UserID=(String)session.getAttribute("USERID");      
	 //String UserName=(String)session.getAttribute("USERNAME");    
     //String RpCenterNo=(String)session.getAttribute("USERREPCENTERNO");
     //String TOPICTYPE=request.getParameter("TOPICTYPE");
	 String UserID="";
	 String dupIMEI=request.getParameter("DUPIMEI");
	 String imeiExist=request.getParameter("IMEIEXIST");
	 String dateString="";
     String seqkey="";
     String seqno="";
     String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
	 String repCenterNo="";
	 String locale ="";
	 String sendImeiFreq ="0";
	 String agentNo ="";
	 String agentName =" ";

	 //Statement stateU=con.createStatement();
	 //ResultSet rsU=stateU.executeQuery("select USERNAME from WSUSER where USERNAME='"+UserID+"' ");
     //if (rsU.next()){ userName = rsU.getString("USERNAME"); }
	 //rsU.close();
	// stateU.close();
	
	String sql = "select REPCENTERNO, REPLOCALE from RPREPPERSON a, RPUSER b where a.USERID=b.USERID and b.WEBID='"+UserName+"' ";	
	Statement stateRepair=conREPAIR.createStatement();
	ResultSet rsRepair=stateRepair.executeQuery(sql);
	if (rsRepair.next())
	{ 
	   repCenterNo = rsRepair.getString("REPCENTERNO"); 
	   locale = rsRepair.getString("REPLOCALE"); 
	}
	else
	{
	   repCenterNo = "003";
	   locale = "886";
	}
	rsRepair.close();
	stateRepair.close();
	//out.println(sql);
	//out.println(UserName);
	//out.println(repCenterNo);
	
	String sqlU = "select WEBID from WSUSER where USERNAME = '"+UserName+"' ";	
	Statement stateU=con.createStatement();
	ResultSet rsU=stateU.executeQuery(sqlU);
	if (rsU.next())
	{ 
	  UserID = rsU.getString("WEBID"); 
	}
	rsU.close();
	stateU.close();
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer Activity IMEI Authorization Entry</title>
</head>
<body>
<%
   int rs1__numRows = 100;      //每一頁的顯示筆數
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   //boolean getDataFlag = false;
%>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
<form method="post" action="../jsp/WSIMEITrackingInsert.jsp" NAME="MYFORM">
   <table align="center" border="1" cellpadding="0" cellspacing="0" bgcolor="#CCFFCC">    
    <tr valign="baseline">             
      <td nowrap align="right" colspan="1"><strong><font color="#FF0000">IMEI號</font></strong><font color="#FF0000">:</font></td>            
      <td colspan="2"><input type="text" name="IMEI" value="" size="20" maxlength="15">&nbsp;&nbsp;<input name="button" type=button onClick="btnCustomerInfo()" value="客戶資料"></td>	
	  <td nowrap align="right"><strong>統一編號</strong>:</td>            
      <td colspan="2"><input type="text" name="UNITNO" value="" size="8" maxlength="8"></td>	
    </tr>       
	<tr valign="baseline"> 
	   <td nowrap align="right"><strong>客戶名稱</strong>:</td>            
       <td><input type="text" name="CUSTNAME" value="<%=agentName%>" size="50" maxlength="50"></td>	 
	   <td nowrap align="right"><strong>連絡電話</strong>:</td>            
       <td><input type="text" name="CONTACTTEL" value="" size="20" maxlength="20"></td>
	   <td nowrap align="right"><strong>傳真號碼</strong>:</td>            
       <td><input type="text" name="CONTACTFAX" value="" size="20" maxlength="20"></td>	 
    </tr> 
	<tr valign="baseline"> 
	   <td nowrap align="right"><strong>客戶地址</strong>:</td>            
       <td colspan="3"><input type="text" name="CUSTADDRESS" value="" size="80" maxlength="80"></td>
	   <td nowrap align="right"><strong>連絡人</strong>:</td>            
       <td colspan="1"><input type="text" name="CONTACT" value="" size="20" maxlength="20"></td>
    </tr>     
          <tr valign="baseline"> 
            <td nowrap align="right">&nbsp;</td>
            <td colspan="5"><div align="center"><input type="submit" value="確認送出">...
              <input name="重設" type="reset" value="清除重填"></div></td>
          </tr>
        </table><div align="center"><font color='#FF0000'><strong>
		<%
		     if (dupIMEI==null || dupIMEI.equals(""))
			 { out.println("請輸入15碼手機IMEI號碼");}
			 else if (dupIMEI=="Y" || dupIMEI.equals("Y"))
			 { out.println("IMEI號碼已存在系統中,請重新確認!!!");}
			 else if (dupIMEI=="N" || dupIMEI.equals("N"))
			 { 
			    if ( imeiExist=="N" || imeiExist.equals("N") )
				{  out.println("IMEI號不合法或不存在於出貨記錄中,請重新確認!!!"); }
				else if ( imeiExist=="Y" || imeiExist.equals("Y") )
			    { out.println("輸入完成,請輸入下一筆!!!"); }
			 }		
		%></strong></font></div>		
       <input type="hidden" name="CDATETIME" value=<%=strDateTime%> size="32" maxlength="14" >  
	   <input type="hidden" name="USERID" value=<%=UserID%> size="32" maxlength="20" >
	   <input type="hidden" name="REPCENTERNO" value=<%=repCenterNo%> size="3" maxlength="3" >
	   <input type="hidden" name="LOCALE" value=<%=locale%> size="3" maxlength="3" >
	   <input type="hidden" name="SENDIMEIFREQ" value=<%=sendImeiFreq%> size="5" maxlength="5" >
	   <input type="hidden" name="AGENTNO" value=<%=agentNo%> size="7" maxlength="7" >
	   
   </form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
