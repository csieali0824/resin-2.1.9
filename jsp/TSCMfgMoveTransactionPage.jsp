<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="oracle.sql.*,oracle.jdbc.driver.*,java.math.BigDecimal.*,ComboBoxBean,DateBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>WIP Move Transaction page</title>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	  gfPop.fHideCal();
	
}
function setDelErr(URL,wipEntityId,runCardNo)
{
	document.MYFORM.action=URL+"?WIP_ENTITY_ID="+wipEntityId+"&RUNCARD_NO="+runCardNo+"&DELERRIFACE=D";
    document.MYFORM.submit();
}
function setlInvReserv(URL,wipEntityId,runCardNo)
{
    document.MYFORM.action=URL+"?WIP_ENTITY_ID="+wipEntityId+"&RUNCARD_NO="+runCardNo+"&RESERVATION=Y";
    document.MYFORM.submit();
}
function setlLotInsert(URL,wipEntityId,runCardNo)
{
    document.MYFORM.action=URL+"?WIP_ENTITY_ID="+wipEntityId+"&RUNCARD_NO="+runCardNo+"&INSERTLOT=Y";
    document.MYFORM.submit();
}
function setRunCardFind(URL,wipEntityId,runCardNo)
{
    document.MYFORM.action=URL+"?WIP_ENTITY_ID="+wipEntityId+"&RUNCARD_NO="+runCardNo;
    document.MYFORM.submit();
}
function setMOFind(marketType,oeOrderNo)
{ //alert("marketType="+marketType);
  subWin=window.open("../jsp/subwindow/TSMfgMOAdmFind.jsp?MARKETTYPE="+marketType+"&OEORDERNO="+oeOrderNo,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes"); 
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
<style type="text/css">
<!--
.style1 {
	font-family: Georgia;
	color: #336600;
}
.style3 {color: #CC6600}
.style4 {
	color: #993300;
	font-size: 14px;
	font-weight: bold;
}
.style5 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
}
.style6 {
	color: #336633;
	font-weight: bold;
}
-->
</style>
</head>

<%
    out.println("<A HREF='../ORADDSMainMenu.jsp'>");%><font size="2">回首頁</font><%out.println("</A>");
	out.println("&nbsp;&nbsp;<A HREF='../jsp/TSCMfgMovePending.jsp'>");%><font size="2">管理員Pending Move處理</font><%out.println("</A>");
	
    String woNo=request.getParameter("WO_NO");   //工單號
    String wipEntityId=request.getParameter("WIP_ENTITY_ID");  //工單ID
    String runCardNo=request.getParameter("RUNCARD_NO");       //流程卡號
    String fndUserName=request.getParameter("FNDUSERNAME"); 
    String opSeqNum=request.getParameter("OP_SEQ"); 
    String transID=request.getParameter("TRANSID"); 
	String woType=request.getParameter("WOTYPE");
	String oeHeaderId=request.getParameter("OEHEADERID");
	String oeOrderNo=request.getParameter("OEORDERNO");
	String orderLineId=request.getParameter("OELINEID");
	String lotInsValid=request.getParameter("VALIDATE");
	
	String organizationId=request.getParameter("MARKETTYPE");
	
	String invItemId=request.getParameter("INVITEMID");
	String invItem=request.getParameter("INVITEM");
	String lotOrganId=request.getParameter("ORGANIZATION_ID");
	String lotNumber=request.getParameter("LOT_NUMBER");
	String lotTransOrganId=request.getParameter("TRANS_ORGAN_ID");
	String lotWipEntity=request.getParameter("LOTWIPENTITY");
	
	String User_ID=request.getParameter("USER_ID");
	
	String transDate=request.getParameter("TRANSDATE");
	
	if (transDate==null || transDate.equals("")) transDate=dateBean.getYearMonthDay();
	
	String statusID=request.getParameter("STATUSID");
	
	String woStatus="";	
	
	
	if (lotInsValid==null || lotInsValid.equals("null")) lotInsValid = "N"; // 預設不為新增 LotNumber模式
	
	if ((woNo==null || woNo.equals("")) && wipEntityId!=null)
	{
	    String sqlWo = " select a.WIP_ENTITY_NAME, decode(b.STATUS_TYPE, 1,'Unreleased', 3, 'Released', 4, 'Complete',6,'On Hold',b.STATUS_TYPE) from WIP_ENTITIES a, WIP_DISCRETE_JOBS b "+
		               " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and a.WIP_ENTITY_ID = "+wipEntityId+" ";
	    Statement stateWo=con.createStatement(); 
	    ResultSet rsWo=stateWo.executeQuery(sqlWo);
		if (rsWo.next())
		{
		   woNo = rsWo.getString("WIP_ENTITY_NAME");
		   woStatus=rsWo.getString(2);
		}
		rsWo.close();
		stateWo.close();  
	}
           if (wipEntityId==null && woNo!=null)
	       {
		       String sqlWo = " select a.WIP_ENTITY_ID, decode(b.STATUS_TYPE, 1,'Unreleased', 3, 'Released', 4, 'Complete',6,'On Hold',b.STATUS_TYPE) from WIP_ENTITIES a, WIP_DISCRETE_JOBS b "+
		                      " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and a.WIP_ENTITY_NAME = '"+woNo+"' ";
	           Statement stateWo=con.createStatement(); 
	           ResultSet rsWo=stateWo.executeQuery(sqlWo);
		       if (rsWo.next())
		       {
		        wipEntityId = rsWo.getString("WIP_ENTITY_ID");
		        woStatus=rsWo.getString(2);
		       }
		       rsWo.close();
		       stateWo.close(); 
		   } 
		          if (runCardNo!=null && !runCardNo.equals(""))
		          {
				     String sqlWo = " select a.WIP_ENTITY_NAME, decode(b.STATUS_TYPE, 1,'Unreleased', 3, 'Released', 4, 'Complete',6,'On Hold',b.STATUS_TYPE), "+
					                "        a.WIP_ENTITY_ID "+
					                " from WIP_ENTITIES a, WIP_DISCRETE_JOBS b, "+
									"      YEW_RUNCARD_ALL c "+
		                            " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									"   and a.WIP_ENTITY_ID = c.WIP_ENTITY_ID "+ 
									"   and c.RUNCARD_NO = '"+runCardNo+"' ";
	                 Statement stateWo=con.createStatement(); 
	                 ResultSet rsWo=stateWo.executeQuery(sqlWo);
		             if (rsWo.next())
		             {
		               woNo = rsWo.getString("WIP_ENTITY_NAME");
		               woStatus=rsWo.getString(2);
					   wipEntityId = rsWo.getString("WIP_ENTITY_ID");
		             }
		             rsWo.close();
		             stateWo.close(); 
				  }
				  
				  
  if (lotInsValid.equals("Y"))
  {   // 針對傳入的新增批號內容作驗證,並得到驗證原因_起
  
  
  }	  // 針對傳入的新增批號內容作驗證,並得到驗證原因_迄   

%>

<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<form name="MYFORM" action="../jsp/TSCMfgMoveTransactionIFace.jsp" method="post"> 
<%
    String sqlWipOp = " select ORGANIZATION_ID, OPERATION_SEQ_NUM, QUANTITY_IN_QUEUE, QUANTITY_RUNNING, QUANTITY_WAITING_TO_MOVE, QUANTITY_REJECTED, QUANTITY_SCRAPPED, QUANTITY_COMPLETED "+
                      " from WIP_OPERATIONS "+
					  " where WIP_ENTITY_ID = "+wipEntityId+" order by OPERATION_SEQ_NUM ";
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sqlWipOp);
%>
<table>
  <tr>
    <td valign="top"><span class="style6">Work Order (<%=woNo%>) Operations</span>
      <table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="90%" bordercolorlight="#FFFFFF" border="0">
  <tr bgcolor="#B1C08F">
     <td nowrap><span class="style1">Seq</span></td>
     <td nowrap><span class="style1">In<BR>Queue</span></td><td nowrap><span class="style1">Running</span></td><td nowrap><span class="style1">To Move</span></td><td nowrap><span class="style1">Rejected</span></td><td nowrap><span class="style1">Scrapped</span></td><td nowrap><span class="style1">Completed</span></td>
  </tr>
  <%
       while (rs.next())
	   {
	    //opSeqNum = rs.getString("OPERATION_SEQ_NUM");
		organizationId=rs.getString("ORGANIZATION_ID");
  %>
  <tr bgcolor="#B0B87E">
    <td><a href="../jsp/TSCMfgMoveTransactionPage.jsp?WIP_ENTITY_ID=<%=wipEntityId%>&RUNCARD_NO=<%=runCardNo%>&OP_SEQ=<%=rs.getString("OPERATION_SEQ_NUM")%>"><%=rs.getString("OPERATION_SEQ_NUM")%></a></td>
	<td><%=rs.getString("QUANTITY_IN_QUEUE")%></td>
	<td><%=rs.getString("QUANTITY_RUNNING")%></td>
	<td><%=rs.getString("QUANTITY_WAITING_TO_MOVE")%></td>
	<td><%=rs.getString("QUANTITY_REJECTED")%></td>
	<td><%=rs.getString("QUANTITY_SCRAPPED")%></td>
	<td><%=rs.getString("QUANTITY_COMPLETED")%></td>
  </tr>
  <%
       } // End of while
	   rs.close();
	   statement.close();
  %>
  <tr bgcolor="#B1C08F">
    <td colspan="7"><span class="style1">Work Order Status : </span><strong><font color="#FFFF00"><em><%=woStatus%></em></font></strong></td>
  </tr>
</table>  </td>
  <td valign="top">  
  <span class="style6">Run Card Wip Tracking</span>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="50%" bordercolorlight="#FFFFFF" border="0">
  <tr bgcolor="#B1C08F">
     <td nowrap>Runcard No.</td><td nowrap>Runcard<BR>Q'ty</td><td nowrap>Inv Item</td><td nowrap>RC OP Seq</td><td nowrap>In Queue</td><td nowrap>To Move</td><td nowrap>Scrap</td><td nowrap>OSP PO Num</td><td nowrap>Status Id</td><td nowrap>Status</td>
  </tr>
   <%
        
     String sqlWipRC = " select a.*, b.WORKORDER_TYPE  "+
                          " from YEW_RUNCARD_ALL a, YEW_WORKORDER_ALL b "+
					      " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
						  "   and a.WIP_ENTITY_ID = "+wipEntityId+" order by a.RUNCARD_NO ";
	 Statement stateWipRC=con.createStatement(); 
	 ResultSet rsWipRC=stateWipRC.executeQuery(sqlWipRC);   
     while (rsWipRC.next())
	 {
	  woType = rsWipRC.getString("WORKORDER_TYPE"); // 取得此工令類型(切割、前段、後段、重工或工程實驗)
	  
	  if (woType==null || woType.equals(""))  woType="0";  
	  
	  //out.println("woType="+woType);
   %>
  <tr bgcolor="#B0B87E">
     <td nowrap><%=rsWipRC.getString("RUNCARD_NO")%></td>
	 <td nowrap><%=rsWipRC.getString("RUNCARD_QTY")%></td>
	 <td nowrap><%=rsWipRC.getString("INV_ITEM")%></td>
	 <td nowrap><%=rsWipRC.getString("OPERATION_SEQ_NUM")%></td>
	 <td nowrap><%=rsWipRC.getString("QTY_IN_QUEUE")%></td>
	 <td nowrap><%=rsWipRC.getString("QTY_IN_TOMOVE")%></td>
	 <td nowrap><%=rsWipRC.getString("QTY_IN_SCRAP")%></td>
	 <td nowrap>
	     <%
		        String rcvHistLog = "";
		        String sqlRCV = " select TRANSACTION_TYPE ||"+" '&nbsp;' "+" || QUANTITY ||"+" '&nbsp;' "+" || UNIT_OF_MEASURE || "+" '&nbsp;' "+" || PRIMARY_QUANTITY || "+" '&nbsp;' "+" || PRIMARY_UNIT_OF_MEASURE "+
                                " from RCV_TRANSACTIONS a, PO_HEADERS_ALL b "+
					            " where a.PO_HEADER_ID = b.PO_HEADER_ID and b.SEGMENT1= "+rsWipRC.getString("OSP_PO_NUM")+" ";
	            Statement stateRCV=con.createStatement(); 
	            ResultSet rsRCV=stateRCV.executeQuery(sqlRCV);
				while (rsRCV.next())
				{
				    rcvHistLog = rcvHistLog + rsRCV.getString(1)+"<BR>";  
				}
				rsRCV.close();
				stateRCV.close();
				
				if (rcvHistLog==null || rcvHistLog=="" || rcvHistLog.equals("")) rcvHistLog = "N/A<BR>";
		 %>
	     <font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("<%=rcvHistLog%>")'>
	     <% 
				//out.println("rcvHistLog="+rcvHistLog);				
		        out.println(rsWipRC.getString("OSP_PO_NUM"));
		 
		 %></a></strong></font>
	   </td>
	 <td nowrap><%=rsWipRC.getString("STATUSID")%></td>
	 <td nowrap><%=rsWipRC.getString("STATUS")%></td> 
  </tr>
  <%  
     } // End of while (rsWipRC.next())
	 rsWipRC.close();
	 stateWipRC.close();
  %>
</table>
 </td>
 </tr>
 </table>
<hr>
<span class="style4">Run Card (<%=runCardNo%>) Traveled History</span>
<%
    String sqlRCMTxn = "select * from WIP_MOVE_TRANSACTIONS ";
	String whereRCMTxn = "where WIP_ENTITY_ID = "+wipEntityId+" and ATTRIBUTE2 = '"+runCardNo+"' ";
	String orderRCMTxn = " order by FM_OPERATION_SEQ_NUM ";
	if (opSeqNum==null || opSeqNum.equals("")) { whereRCMTxn = whereRCMTxn + " "; }
	else if (opSeqNum!=null && !opSeqNum.equals(""))
	     {
	        whereRCMTxn = whereRCMTxn + "and FM_OPERATION_SEQ_NUM = '"+opSeqNum+"' ";
	     }		 
	sqlRCMTxn = sqlRCMTxn + whereRCMTxn + orderRCMTxn;
	//out.println(sqlRCMTxn);	 
	Statement stateRCMTxn=con.createStatement(); 
	ResultSet rsRCMTxn=stateRCMTxn.executeQuery(sqlRCMTxn);	
	if (rsRCMTxn!=null)
	{
%>
<input type="text" name="RUNCARDCH" value="" size="12"><input type="button" name="FIND" value="Find" onClick='setRunCardFind("../jsp/TSCMfgMoveTransactionPage.jsp",this.form.WIP_ENTITY_ID.value,this.form.RUNCARDCH.value)'>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="37%" bordercolorlight="#FFFFFF" border="0">
<tr bgcolor="#CCCC99">
    <td nowrap><span class="style3">FM_OPERATION_SEQ_NUM</span></td>
    <td nowrap><span class="style3">TO_OPERATION_SEQ_NUM</span></td><td nowrap><span class="style3">TRANSACTION_QUANTITY</span></td><td nowrap><span class="style3">TRANSACTION_UOM</span></td><td nowrap><span class="style3">TO_INTRAOPERATION_STEP_TYPE</span></td><td nowrap><span class="style3">TRANSACTION_DATE</span></td>
</tr>
  <%
       while (rsRCMTxn.next())
	   {
  %>
<tr bgcolor="#CCCC99">
   <td nowrap><a href="../jsp/TSCMfgMoveTransactionPage.jsp?WIP_ENTITY_ID=<%=wipEntityId%>&RUNCARD_NO=<%=runCardNo%>&OP_SEQ=<%=rsRCMTxn.getString("FM_OPERATION_SEQ_NUM")%>"><%=rsRCMTxn.getString("FM_OPERATION_SEQ_NUM")%></a></td>
   <td nowrap><%=rsRCMTxn.getString("TO_OPERATION_SEQ_NUM")%></td>
   <td nowrap><%=rsRCMTxn.getString("TRANSACTION_QUANTITY")%></td>
   <td nowrap><%=rsRCMTxn.getString("TRANSACTION_UOM")%></td>
   <td nowrap><%=rsRCMTxn.getString("TO_INTRAOPERATION_STEP_TYPE")%></td>
   <td nowrap><%=rsRCMTxn.getString("TRANSACTION_DATE")%></td>
</tr>
<%
       } // End of while (rsRCMTxn.next())
	   rsRCMTxn.close();
	   stateRCMTxn.close();   
%>
</table>
<%
   } // End of if (rsRCMTxn!=null)
%>
<BR>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="60%" bordercolorlight="#FFFFFF"  border="0">
  <tr bgcolor="#CCCC99">
    <td colspan="2"><span class="style5">Administrator Move Transaction Interface</span></td>
  </tr>
  <tr bgcolor="#CCCC99">
   <td>WO No :<input name="WO_NO" type="text" value='<%=woNo%>' size="12"> </td><td> RunCard No.:<input name="RUNCARD_NO" type="text" value='<%=runCardNo%>' size="12">
   </td>
  </tr>
  <tr bgcolor="#CCCC99"><td nowrap>FM_INTRAOPERATION_STEP_TYPE :</td><td nowrap><input name="FMINTOPSTYPE" type="text" value='1' size="10"><BR>1=<font color="#993333">Queue</font>, 2=<font color="#993333">RUN</font>, 3=<font color="#993333">TO_MOVE</font>, 5=<font color="#993333">SCRAP</font>
      </td>
  </tr>
  <tr bgcolor="#CCCC99"><td>From Operation Seq No. :</td>
       <td>
	      <%
		           Statement stateOPFm=con.createStatement();
                   ResultSet rsOPFm=null;	
			       String sqlOPFm = " select OPERATION_SEQ_NUM,OPERATION_SEQ_NUM||'('||DESCRIPTION||')' from WIP_OPERATIONS ";
			       String whereOPFm = " where WIP_ENTITY_ID="+wipEntityId+" order by OPERATION_SEQ_NUM ";				   
				   sqlOPFm = sqlOPFm + whereOPFm;
				   //out.println(sqlOrgInf);
                   rsOPFm=stateOPFm.executeQuery(sqlOPFm);
		           comboBoxBean.setRs(rsOPFm);
		           //comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("FMOPERSEQNO");	   
                   out.println(comboBoxBean.getRsString());
		           rsOPFm.close();   
				   stateOPFm.close();
		  %>
       </td>
  </tr>
  <tr bgcolor="#CCCC99"><td nowrap>TO_INTRAOPERATION_STEP_TYPE :</td><td nowrap><input name="TOINTOPSTYPE" type="text" value='' size="10"><BR>1=<font color="#993333">Queue</font>, 2=<font color="#993333">RUN</font>, 3=<font color="#993333">TO_MOVE</font>, 5=<font color="#993333">SCRAP</font>
      </td>
  </tr>  
  <tr bgcolor="#CCCC99"><td>To Operation Seq No. :</td>
       <td>
	      <%
		           Statement stateOPTo=con.createStatement();
                   ResultSet rsOPTo=null;	
			       String sqlOPTo = " select OPERATION_SEQ_NUM,OPERATION_SEQ_NUM||'('||DESCRIPTION||')' from WIP_OPERATIONS ";
			       String whereOPTo = " where WIP_ENTITY_ID="+wipEntityId+" order by OPERATION_SEQ_NUM ";				   
				   sqlOPTo = sqlOPTo + whereOPTo;
				   //out.println(sqlOrgInf);
                   rsOPTo=stateOPTo.executeQuery(sqlOPTo);
		           comboBoxBean.setRs(rsOPTo);
		           //comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("TOOPERSEQNO");	   
                   out.println(comboBoxBean.getRsString());
		           rsOPTo.close();   
				   stateOPTo.close();
		  %>
       </td>
  </tr>
  <tr bgcolor="#CCCC99">
     <td>
     Transaction Q'ty :</td><td><input name="TRANSQTY" type="text" value='' size="10">
	 </td>
   </tr>   
   <tr bgcolor="#CCCC99">
     <td>
     Transaction Uom :</td><td><input name="TRANSUOM" type="text" value='KPC' size="5">
	 </td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td>
     異動交易人員 :</td><td>
	   <%
	      try
                 {  
				   //-----取USER_ID  
		           Statement stateOP=con.createStatement();
                   ResultSet rsOP=null;	
			       String sqlOP = "  select DISTINCT b.USER_ID, upper(a.USERNAME) || '(' || c.LAST_NAME || c.FIRST_NAME || ')' as USER_NAME "+
				                  "    from ORADDMAN.WSUSER a, FND_USER b, PER_PEOPLE_F c  ";
			       String whereOP = " where upper(a.USERNAME) = upper(b.USER_NAME) and b.EMPLOYEE_ID = c.PERSON_ID(+) ";			
				   
				   String orderOP = " order by 2 ";  				   
				   sqlOP = sqlOP + whereOP + orderOP;
				   //out.println(sqlOP);
                   rsOP=stateOP.executeQuery(sqlOP);
				   
		           comboBoxBean.setRs(rsOP);
		           comboBoxBean.setSelection(User_ID);
	               comboBoxBean.setFieldName("USER_ID");	   
                   out.println(comboBoxBean.getRsString());
		           rsOP.close();   
				   stateOP.close();  
	             } //end of try		 
                 catch (Exception e) 
				 { 
				   out.println("Exception:"+e.getMessage());
				 }
	   %>
	 </td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td>
     異動交易日期 :</td><td><input name="TRANSDATE" tabindex="11" type="text" size="8" value="<%=transDate%>" readonly>
       <a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.MYFORM.TRANSDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></a></td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td>更新後流程卡狀態 :</td>
	  <td>
	    <%
		       try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select UNIQUE a.STATUSID, '('||a.STATUSID||')'||a.STATUSNAME||'-'||a.STATUSDESC as STATUS "+
			                        "from ORADDMAN.TSWFSTATUS a, ORADDMAN.TSWORKFLOW b "+
			                        "where a.STATUSID = b.FROMSTATUSID "+
									"  and b.FORMID = 'WO' and a.STATUSID not in ('040','060') "+																  
								     "order by a.STATUSID "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxBean.setRs(rsGetP);
		           comboBoxBean.setSelection(statusID);
	               comboBoxBean.setFieldName("STATUSID");					     
                   out.println(comboBoxBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	            } //end of try		 
                catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	  %>	
	  </td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td>
     市場類型 :</td><td><input name="MARKETTYPE" type="text" value='<%=organizationId%>' size="5" readonly>
	 </td>
   </tr>      
   <tr bgcolor="#CCCC99">
     <td>工令類型 :<BR>
       (如需執行完工入庫需給定如下特定條件)</td>
     <td><input name="WOTYPE" type="text" value='<%=woType%>' size="5"> 1=<font color="#993333">切割</font>,2=<font color="#993333">前段</font>,3=<font color="#993333">後段</font>
	 </td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td>
       後段生產MO訂單號 :</td><td><input name="OEORDERNO" type="text" value='' size="15">&nbsp;<input type="button" name="CHMO" value="..." onClick='setMOFind(this.form.MARKETTYPE.value,this.form.OEORDERNO.value)'>
       &nbsp;Line ID :
       <input name="OELINEID" type="text" value='' size="8">
	 </td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td>
     後段外購工令批號 :</td><td><input name="LOT_NO" type="text" value='' size="15">
	 </td>
   </tr>
   <tr bgcolor="#CCCC99">
     <td colspan="2">
        <input name="OK" type="submit"  value='送出' >&nbsp;&nbsp;
		<input name="DEL" type="button" value="刪除已處理異常卡號" onClick='setDelErr("../jsp/TSCMfgMoveTransactionIFace.jsp","<%=wipEntityId%>","<%=runCardNo%>")'>
	 </td>
   </tr>
</table>
<BR>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="80%" bordercolorlight="#FFFFFF"  border="0">
<tr bgcolor="#CCCC99">
  <td colspan="5"><span class="style5">批號新增(僅寫入MTL_LOT_NUMBERS)_APIs</span></td>  
  <td><input name="CHKLOT" type="button" value="新增" onClick='setlLotInsert("../jsp/TSCMfgMoveTransactionIFace.jsp","<%=wipEntityId%>","<%=runCardNo%>")'></td>
</tr>
<tr bgcolor="#CCCC99">
  <td nowrap>p_inventory_item_id(料號)</td><td>p_organization_id</td><td nowrap>p_lot_number(批號)</td><td>p_transaction_source_id</td><td>p_primary_quantity</td><td>p_transfer_organization_id</td>
</tr>
<tr bgcolor="#CCCC99">
  <td nowrap><input type="hidden" value="" name="INV_ITEM_ID" size="15"><input type="text" value="" name="INV_ITEM" size="18"></td>
  <td><input type="text" value="" name="ORGANIZATION_ID" size="5"></td>
  <td><input type="text" value="" name="LOT_NUMBER" size="15"></td>
  <td nowrap><input type="text" value="" name="LOTWIPENTITY" size="10">工令號</td>
  <td><input type="text" value="" name="PRIMARY_TRANSQTY" size="8">數量</td>
  <td><input type="text" value="" name="TRANS_ORGAN_ID" size="5" readonly></td>
</tr>
</table>
<BR>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="60%" bordercolorlight="#FFFFFF"  border="0">
<tr bgcolor="#CCCC99">
  <td colspan="6"><span class="style5">庫存保留(Inventory Reservation)_APIs</span></td>  
  <td><input name="CHKLOT" type="button" value="新增" onClick='setlInvReserv("../jsp/TSCMfgMoveTransactionIFace.jsp","<%=wipEntityId%>","<%=runCardNo%>")'></td>
</tr>
<tr bgcolor="#CCCC99">
  <td>Organization_Id</td><td>Requirement_Date</td><td>Inventory_Item</td><td>Reservation Q'ty</td><td>Reservation_UOM</td><td>Order Number</td><td>Order Line Id</td>
</tr>
<tr bgcolor="#CCCC99">
  <td><input type="text" value="" name="RES_ORGAN_ID" size="5"></td>
  <td nowrap><input type="text" value="" name="RES_DATE" size="8">yyyymmdd</td>
  <td><input type="text" value="" name="RES_INVITEM" size="8"></td>
  <td><input type="text" value="" name="RES_QTY" size="8"></td>
  <td><input type="text" value="" name="RES_LOT" size="8"></td>
  <td><input type="text" value="" name="RES_OEHDRID" size="8"></td>
  <td><input type="text" value="" name="RES_OELINEID" size="5"></td>
</tr>
<%
   if (woType.equals("0")) out.println("工令尚未執行生成於Oracle!!!");

   // 取 Reservation 資訊
   if (woType.equals("3"))  // 後段工令可查詢Reservation
   {
          int elemSqlType = OracleTypes.NUMBER;
		  int elemMaxLen = 0;
		  int maxOutLen = 10;
          String msgData = "";
		/*  
                 OracleCallableStatement csOra = (OracleCallableStatement)con.prepareCall("{call INV_RESERVATION_PUB.query_reservation(?,?,?,?,?,?,?,?,?,?,?,?)}");			 
	             csOra.setInt(1,1);                //    p_api_version_number	
				 csOra.setString(2,"T");           //    p_init_msg_lst fnd_api.g_false = "TRUE"					 			 
	             csOra.registerOutParameter(3, Types.VARCHAR);  //回傳 x_return_status
				 csOra.registerOutParameter(4, Types.INTEGER);  //回傳 x_msg_count
				 csOra.registerOutParameter(5, Types.VARCHAR);  //x_msg_data	
				 csOra.setPlsqlIndexTable(6, 1, values, maxLen, currentLen, elemSqlType, elemMaxLen); // p_query_input	
				 csOra.setString(7,"F");                // p_lock_records DEFAULT fnd_api.g_false
				 csOra.setInt(8,1);                     // p_sort_by_req_date
				 csOra.setInt(9,1);                     // p_cancel_order_mode
				 csOra.registerIndexTableOutParameter(10, maxOutLen, elemSqlType, elemMaxLen); // x_mtl_reservation_tbl						
	             csOra.execute();
                 out.println("Procedure : Execute Success !!! ");	             
				 devStatus = csOra.getString(3);   // 回傳 x_returnStatus
				 devMessage = csOra.getInt(4);     // 回傳 x_errorMsg
				 msgData = csOra.getInt(5);        // 回傳 x_msg_data
				 Datum[] outvalues = csOra.getOraclePlsqlIndexTable(10); 
				 // print the elements 
                 for (int i=0; i<outvalues.length; i++) 
                 out.println (outvalues[i].intValue());                  
                 csOra.close();
		 */
%>
<tr>
</tr>
<%
   } // End of if (woType.equals("3"))
%>
</table>
<input name="WIP_ENTITY_ID" type="hidden" value="<%=wipEntityId%>">
<input name="OEHEADERID" type="hidden" value="<%=oeHeaderId%>">
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
