<%@ page language="java" import="java.sql.*"%>
<html>
<head>
<title>IQC Inspection Lot Process Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="array2DimQCProcessBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}
function submitCheck(ms1,ms2,ms3)
{  
       
  return(true);  
}
function setSubmit1(URL)
{ //alert(); 
  document.DISPLAYREPAIR.action=URL;
  document.DISPLAYREPAIR.submit();    
}
function setSubmit2(URL)
{ 
  var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  document.DISPLAYREPAIR.submit();    
}

</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<%
   String inspLotNo=request.getParameter("INSPLOTNO");
   //String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   String lineNo=request.getParameter("LINENO");
   //String pcAcceptDate=request.getParameter("PCACPDATE"); 
   String actionID = request.getParameter("ACTIONID");   
   String remark = request.getParameter("REMARK");   
   String line_No=request.getParameter("LINE_NO");
   String recUserID=request.getParameter("RECUSERID");
   String statusID=request.getParameter("STATUSID");
   
   if (lineNo==null) { lineNo="";}
   //if (pcAcceptDate==null) { pcAcceptDate="";}
   if (remark==null) { remark=""; }
   
   
   
%>
<body>
<%@ include file="/jsp/include/TSIQCDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作)' ACTION="../jsp/TSIQCInspectLotMProcess.jsp?INSPLOT_NO=<%=inspLotNo%>" METHOD="post">
  <!--=============以下區段為取得維修基本資料==========-->
<%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%>
<!--=================================-->
<HR>
<table cellSpacing="0" bordercolordark="#99CCFF" cellPadding="1" width="97%" align="center" bordercolorlight="#FFEEFF"  border="1">
    <tr bgcolor="#99CCFF"> 
    <td colspan="3"><font size="2" color="#000066">
      內容明細
      : <BR>
    <!--%
	  try
      {   
	    String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	array2DArrangedFactoryBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' ");	
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	  
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   String b[][]=new String[rowLength+1][7]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#99CCFF'  cellPadding='1' width='100%' align='center' borderColorLight='#ffEEff' border='1'>");
	   out.println("<tr>");
	   out.println("<td>");	  
	   out.println("<font size='2'>Line</font></td><td><font size='2'>Ordered Item</font></td><td><font size='2'>Item Description</font></td><td><font size='2'>Qty</font></td><td><font size='2'>UOM</font></td><td><font size='2'>Request Date</font></td><td><font size='2'>Remark</font></td>");    
	   int k=0;
	   
	   String sqlEst = "";
	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可指派任一廠區交期
	   { sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' order by LINE_NO"; }
	   else {   
	          sqlEst = "select LINE_NO, ITEM_SEGMENT1,ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE, REMARK, ASSIGN_MANUFACT,FTACPDATE,PCACPDATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' order by LINE_NO"; 
			}
	   
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   {//out.println("0"); 
	    out.print("<TR>");		
		out.println("<TD><font size='2'>");
		out.println(rs.getString("LINE_NO")+"</font></TD><TD><font size='2'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font size='2'>"+rs.getString("ITEM_DESCRIPTION")+"</font></TD><TD><font size='2'>"+rs.getString("QUANTITY")+"</font></TD><TD><font size='2'>"+rs.getString("UOM")+"</font></TD><TD><font size='2'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD><TD><font size='2'>"+rs.getString("REMARK")+"</font></TD></TR>");
		 
		 b[k][0]=rs.getString("LINE_NO");b[k][1]=rs.getString("ITEM_SEGMENT1");b[k][2]=rs.getString("QUANTITY");b[k][3]=rs.getString("UOM");b[k][4]=rs.getString("REQUEST_DATE");b[k][5]=rs.getString("REMARK");b[k][6]=rs.getString("PCACPDATE");		 
		 array2DArrangedFactoryBean.setArray2DString(b);
		 k++;
	   }    	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  
	         
	
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (lineNo !=null && pcAcceptDate!=null)
	    {
	      String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set PCACPDATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
	      PreparedStatement pstmt=con.prepareStatement(sql);  
          pstmt.setString(1,pcAcceptDate+dateBean.getHourMinuteSecond());  // 工廠交期安排
		  pstmt.executeUpdate(); 
          pstmt.close();
        }  
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	     String a[][]=array2DArrangedFactoryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		       
		 }	//enf of a!=null if		
		
    %--> </font>      
  </tr>       
</table>
<table cellSpacing="0" bordercolordark="#66CCCC" cellPadding="1" width="97%" align="center" bordercolorlight="#CDFFFF" border="1">       
  <tr bgcolor="#99CCFF"> 
      <td colspan="3"><font size="2">處理備註: 
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 ></font>           
     </td>
    </tr>          
</table>
<BR>
<% // 管理員才看得到強制改狀態或重新給定單據Owner的功能
  if (UserRoles.indexOf("admin")>=0)
  {

%> 
<table cellSpacing="0" bordercolordark="#99CCFF" cellPadding="1" width="97%" align="center" bordercolorlight="#FFEEFF"  border="1">
<tr>
 <td colspan="4">
   <font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
    <strong>RFQ Document Status and Create Owner Maintain</strong></font>
 </td>
</tr>
<tr>
  <td width="17%">
	<div align="left">
	<font color="#006666" size="2"><strong>狀態</strong></font>
	</div>
  </td>
  <td width="27%">   
	 <%
		       try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select STATUSID, '('||STATUSID||')'||STATUSNAME||'-'||STATUSDESC as STATUS "+
			                        "from ORADDMAN.TSWFSTATUS "+
			                        "where STATUSID <> '006' "+																  
								     "order by STATUSID "; 		  
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
	<td width="21%">
		   <div align="left">
		   <font color="#006666" size="2"><strong>開單人員</strong></font>
		   </div>
	   </td>
	   <td width="35%">	   
		  <%
		       try
               { // 動態去取開單人員資訊 						  
	               Statement statePerson=con.createStatement();
                   ResultSet rsPerson=null;				      									  
				   String sqlPerson = "select USERID, USERID||'('||USERNAME||')' as USERNAME "+
			                        "from ORADDMAN.TSRECPERSON "+
			                        "where USERID >= '001' "+																  
								     "order by USERID "; 		  
                   rsPerson=statePerson.executeQuery(sqlPerson);
				   comboBoxBean.setRs(rsPerson);
		           comboBoxBean.setSelection(recUserID);
	               comboBoxBean.setFieldName("RECUSERID");					     
                   out.println(comboBoxBean.getRsString());				
					           
				    statePerson.close();		  		  
		            rsPerson.close();
	            } //end of try		 
                catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	      %>	   
	</td>   
  </tr>
  <tr>
    <td colspan="4"><input type="submit" name="submit" value="Save"><input type="reset" name="reset" value="Cancel"></td>
  </tr>
</table>
<%
  } // End of if (UserRoles.indexOf("admin")>=0// 管理員才看得到新增附件功能)
%>
<!-- 表單參數 --> 
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
