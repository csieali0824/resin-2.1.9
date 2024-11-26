<%@ page contentType="text/html; charset=utf-8"  language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit2(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function workflowDetailQuery(notificationID)
{     
  subWin=window.open("../jsp/OracleWorkflowNotificationAccess.jsp?NOTIFID="+notificationID,"subwin");  
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
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
<title>Oracle Workflow Notification Transfer</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%

String sSql = "";

String sWhere = "";

String sOrder = "";


String colorStr = "";

String notificationID=request.getParameter("NOTIFYID");

String organizationId=request.getParameter("ORGANIZATION_ID");

  String transName=request.getParameter("TRANSNAME");
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  String sqlDtl = "";

  if (organizationId==null || organizationId.equals("")) { organizationId="49"; }
  
     // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
  //  

%>
<% /* 建立本頁面資料庫連線  */ %>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">    
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<FORM ACTION="../jsp/OracleWorkflowNotifyTransferSubmit.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial"></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>Workflow Notification API Transfer</strong></font>
  <A href="/oradds/jsp/OracleWorkflowNotificationQuery.jsp">Workflow Notification Query</A>
<%
 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

   sSql = "SELECT NOTIFICATION_ID, FROM_USER,ORIGINAL_RECIPIENT, "+
          " MESSAGE_TYPE, SUBJECT, BEGIN_DATE from APPLSYS.WF_NOTIFICATIONS ";	   		 
   sWhere =  "where STATUS = 'OPEN' ";		  
   sOrder = "order by BEGIN_DATE";
   
   if (notificationID==null || notificationID.equals("--") || notificationID.equals("")) {sWhere=sWhere+"0";}
   else {sWhere=sWhere+" and NOTIFICATION_ID = '"+notificationID+"'"; }    
 
   sOrder = "order by BEGIN_DATE";
  
   sSql = sSql + sWhere+ sOrder;  
  //out.println("sSqlCNT="+sSqlCNT);  
   Statement statementTC=con.createStatement();
   ResultSet rsTC=statementTC.executeQuery(sSql);
   if (rsTC.next())
   {
%> 
  <table cellSpacing='0' bordercolordark='#D8DEA9'  cellPadding='1' width='45%' align='left' borderColorLight='#ffffff' border='1'>     	 	 
	 <tr>
	    <td width="14%" colspan="1" nowrap><font color="#006666"><strong>Notification ID</strong></font></td> 
		<td width="47%" colspan="1">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
		   <%
		    
		         try
                 {   
		            if (notificationID!=null) out.println(notificationID);
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		     	 
		   %>   
		   </div>
		   <input name="NOTIFYID" type="HIDDEN" value="<%=notificationID%>" >
		   <input name="NOTIFYTYPE" type="HIDDEN" value="<%="transfer"%>" >
		</td> 
		<td width="14%" colspan="1" nowrap><font color="#006666"><strong>原單據處理人員</strong></font></td> 
		<td width="47%" colspan="1">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>		   
		   <%=rsTC.getString("ORIGINAL_RECIPIENT")%>   
		   </div><input name="ORIGNAME" type="HIDDEN" value="<%=rsTC.getString("ORIGINAL_RECIPIENT")%>" >
		</td> 
	 </tr>	  
     <tr>	    
	   <td nowrap colspan="1">
	      <font color="#006666"><strong>轉單據接收人員</strong></font>
	   </td>
	   <td nowrap colspan="3">
        <%
		   // REQAPPRV, OEOH , POAPPRV
		   
		         try
                 {   
		           Statement stateTrans=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = "select NAME, NAME||'('||DISPLAY_NAME||')' "+
			                          "from APPLSYS.WF_LOCAL_ROLES ";
			       String whereOType = "where STATUS ='ACTIVE' and ORIG_SYSTEM='PER' and NOTIFICATION_PREFERENCE='QUERY' ";								  
				   String orderType = "order by NAME ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType + orderType;
				   //out.println(sqlOrgInf);
                   rs=stateTrans.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(transName);
	               comboBoxBean.setFieldName("TRANSNAME");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rs.close();   
					stateTrans.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		      
		   %>  
    </td>  	
   </tr>
   <tr>	    
	   <td nowrap colspan="1">
	      <font color="#006666"><strong>轉單據處理說明</strong></font>
	   </td>
	   <td nowrap colspan="3">
         <textarea name="TRANSCOMMENT" cols="80" rows="3"></textarea>
       </td>  	
   </tr>
   <tr>
    <td colspan="4">
		    <INPUT type="submit" align="middle"  value='<jsp:getProperty name="rPH" property="pgSave"/>'> 			 
	</td>
   </tr>
  </table>  
  <% 
    } // End of if (rsTC.next())  
	rsTC.close();
    statementTC.close(); 
  %>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>


