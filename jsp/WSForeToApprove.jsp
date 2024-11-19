<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
function submitCheck()
{ 
  if (document.MYFORM.ACTION.value=="--" || document.MYFORM.ACTION.value==null || document.MYFORM.ACTION.value=="")
  { 
   alert("Warring!!Before submiting this form, you must choose a proper ACTION first !!");   
   return(false);
  } 
   
  document.MYFORM.submit();   
}
function cancelPR(prno)
{   
  flag=confirm("Are you sure you want to CANCEL this PR("+prno+")?");  
  if (flag==true)
  {  
    if (document.MYFORM.COMMENT.value==null || document.MYFORM.COMMENT.value=="")
	{
	   alert("Before you cancel this PR, please state your reason at Comment field, first !!");        
	} else {
	   document.MYFORM.action="../jsp/WSCancelPRInsert.jsp?TYPE=999";
       document.MYFORM.submit();
	}    
  } 
}
function createMRC()
{ 
   document.MYFORM.action="../jsp/WSFore_MRC_Create.jsp";
   document.MYFORM.submit();
}
</script>
<%    
  String docNo=request.getParameter("DOCNO"); 
  String targetYear=""; 
  String targetMonth="";
  String createBy="",createByID="",createDate="",createTime="",nextPrcsMan="",isApproved="N",remark="",status=""; 
  String approvalMan="",approvalDate="",approvalTime="",comp="";
  String updateMan="",updateDate="",updateTime="",cancel="",cancel_PR="",is_MR_Created="";
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);  
  ResultSet rs=null;
 try
{       
   rs=statement.executeQuery("select RQYEAR,RQMONTH,CREATEDDATE,CREATEDTIME,NEXTPRCSMAN,APPROVED,USERNAME,REMARK,STATUS,CANCEL,CANCEL_PR,CREATEDBY,BUSINESSUNIT,IS_MR_CREATED from PSALES_FORE_APP_HD,WSUSER where DOCNO='"+docNo+"' and CREATEDBY=WEBID(+)"); 
   if (rs.next())                 
   {      
     targetYear=rs.getString("RQYEAR");
	 targetMonth=rs.getString("RQMONTH");
	 createBy=rs.getString("USERNAME");//申請人名字
	 createByID=rs.getString("CREATEDBY"); //申請人ID
	 createDate=rs.getString("CREATEDDATE");
	 createDate=createDate.substring(0,4)+"/"+createDate.substring(4,6)+"/"+createDate.substring(6,8);
	 createTime=rs.getString("CREATEDTIME");
	 createTime=createTime.substring(0,2)+":"+createTime.substring(2,4);
	 nextPrcsMan=rs.getString("NEXTPRCSMAN");
	 isApproved=rs.getString("APPROVED");
	 remark=rs.getString("REMARK");
	 comp=rs.getString("BUSINESSUNIT");
	 status=rs.getString("STATUS");
	 cancel=rs.getString("CANCEL"); //該PR是否已取消?Y:已取消
	 cancel_PR=rs.getString("CANCEL_PR");//取得取消此PR的文件編號
	 if (cancel==null) cancel="";
	 if (remark==null) remark="";
	 is_MR_Created=rs.getString("IS_MR_CREATED"); //該PR是否已產生物料需求Material Request?
	 if (is_MR_Created==null) is_MR_Created="";
   } 
   rs.close();     		 
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
} 
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Forecast Application Form</title>
</head>
<body>
<FORM ACTION="WSForeToProcess.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Purchase Requirement for Forecast </strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForeToApplyActHist.jsp?DOCNO=<%=docNo%>">Action History</A>
&nbsp;&nbsp;&nbsp;&nbsp;
<strong></strong><font color="#333399" face="Arial Black"></font>
<%
  //若為Admin或者文件申請人自己,則可cancel該PR
  if (!cancel.equals("Y") && status.equals("COMPLETE") && isApproved.equals("Y") && (UserRoles.indexOf("admin")>=0 || createByID.equals(userID)) )
  {
     out.println("<A title='To cancel this Purchase Requirement.' href='javaScript:cancelPR("+'"'+docNo+'"'+")'><font color='RED'><strong>Cancel PR</font></A>&nbsp;&nbsp;&nbsp;&nbsp;");	 	 
  }
  
  //若該文件還未產生物料需求Material Request,且為Admin或者物管,則可以生成Material Request 
  if (!cancel.equals("Y") && !is_MR_Created.equals("Y") && status.equals("COMPLETE") && isApproved.equals("Y") && (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("MCUser")>=0) )
  {
     out.println("<A title='To create Material Request Confirmation.' href='javaScript:createMRC()'><font color='RED'><strong>Create MRC</font></A>");
  }
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="22%" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>DOCNO:</strong></font><font color="WHITE" size=2><%=docNo%></font></td>
      <td width="23%" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>ACTION:</strong></font>
        <%     		 
try
{   
   if ( !isApproved.equals("Y") && nextPrcsMan.equals(userID) && status.equals("IN_PROGRESS"))
   {      
     String a[]={"AGREE","REJECT"};	
	 arrayComboBoxBean.setArrayString(a);  
   } else {
     String a[]={""};	
	 arrayComboBoxBean.setArrayString(a);
   }         		 
   arrayComboBoxBean.setFieldName("ACTION");	             		    	
   out.println(arrayComboBoxBean.getArrayString());		
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
%>
        <input name="Button" type="Button" onClick='submitCheck()' value="Submit"></td>
      <td width="55%" colspan="2" bgcolor="#0099CC">
      <font color="#333399" face="Arial Black"><strong>Comment:</strong></font>
	  <input name="COMMENT" type="text" size="40">	  </td>  	 
	</tr>		<FONT >	
 </table>
  <HR>
<%
  if (cancel.equals("Y") )
  {
    out.println("<TABLE><TR><TD BGCOLOR='RED'><A HREF='WSCancelPRApprove.jsp?DOCNO="+cancel_PR+"'><FONT size=4 COLOR='WHITE'><STRONG>THIS PR HAS BEEN CANCELED!!</STRONG></FONT></A></TD></TR></TABLE>");
  } 
%>
<%  
 String f_interModel="",f_extModel="",f_color="";
 String f_fcqty="0",f_rqqty="0",fcTotal="0",rqTotal="0";    
  try
  {   
   rs=statement.executeQuery("select PRJCD,b.SALESCODE,COLOR,RQQTY,FCQTY from PSALES_FORE_APP_LN a,PIMASTER b where trim(a.PRJCD)=trim(b.PROJECTCODE) and DOCNO='"+docNo+"'");   
   String bgColor="B0E0E6";
%>     
   <TABLE width="608">
   <TR><TH width="126" BGCOLOR=BLACK><FONT COLOR="WHITE">INTER MODEL</FONT></TH>
   <TH width="122" BGCOLOR=BLACK><FONT COLOR="WHITE">EXT MODEL</FONT></TH><TH width="102" BGCOLOR=BLACK><FONT COLOR="WHITE">COLOR</FONT></TH><TH width="64" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>FORECAST</FONT></TH>
   <TH width="78" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>REQUIREMENT</FONT></TH>
   <TH width="88" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>UNIT</FONT></TH></TR>
<%    
   while (rs.next())  
   {                  
	f_interModel=rs.getString("PRJCD");
	f_extModel=rs.getString("SALESCODE");
	f_color=rs.getString("COLOR");
	f_fcqty=rs.getString("FCQTY");
	f_rqqty=rs.getString("RQQTY");	  
%>
   <TR BGCOLOR=<%=bgColor%>><TD><FONT SIZE=2><%=f_interModel%></TD><TD><%=f_extModel%></TD><TD><%=f_color%></TD><TD><div align="center"><%=f_fcqty%></div></TD>
     <TD><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=f_rqqty%></strong></FONT></div></TD>
     <TD><font color="#FF0000" SIZE=3>K pcs</font></TD></TR>
<%	  
	fcTotal=String.valueOf(Float.parseFloat(fcTotal)+Float.parseFloat(f_fcqty));	
	rqTotal=String.valueOf(Float.parseFloat(rqTotal)+Float.parseFloat(f_rqqty));
	
    if (bgColor.equals("B0E0E6")) //間隔列顏色改換
    {
      bgColor="ADD8E6";
    } else {
      bgColor="B0E0E6";	  
    }           		             
   } //end of rs.next() while    
   rs.close();      
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
<TR>
  <TD colspan="2"><font color="#FF0000"><strong>Target Date:<%=targetYear%>/<%=targetMonth%></strong></font><font color="#FF0000">&nbsp;</font></TD>
  <TD BGCOLOR=#0099CC><div align="right"><FONT COLOR=WHITE>TOTAL</font></div></TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=WHITE><%=fcTotal%></font></div></TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=LIGHTYELLOW><strong><%=rqTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC><font color="#FF0000" SIZE=3>K pcs</font></TD> 
</TR>
<TR bgcolor="#FFFFCC">
  <TD colspan="8"><div align="left"><strong>REMARK:</strong><%=remark%></div></TD></TR>           
 </TABLE>
<HR>
<table width="62%" border="1" bordercolordark="#999999">
     <tr bgcolor="#0099CC">
       <td><strong><font color="#FFFFFF">核准</font></strong></td>
       <td><strong><font color="#FFFFFF">部門主管</font></strong></td>
       <td><strong><font color="#FFFFFF">經辦</font></strong></td>
     </tr>
<TR> 
       <td width="100"><FONT SIZE=2>
<%     		 
try
{   
   if (isApproved.equals("Y"))
   {      
      rs=statement.executeQuery("select USERNAME,ACT_DATE,ACT_TIME from PSALES_FORE_APP_HIST,WSUSER where DOCNO='"+docNo+"' and WHO=WEBID order by ACT_DATE DESC ,ACT_TIME DESC"); 	  
      if (rs.next())                 
      {  	  
	     approvalMan=rs.getString("USERNAME");
		 approvalDate=rs.getString("ACT_DATE");
		 approvalTime=rs.getString("ACT_TIME");	 
		 approvalDate=approvalDate.substring(0,4)+"/"+approvalDate.substring(4,6)+"/"+approvalDate.substring(6,8);	 
	     approvalTime=approvalTime.substring(0,2)+":"+approvalTime.substring(2,4);    
      } 
      rs.close();      	         
   }        		                 		    	   		
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
%>
<%=approvalMan%><BR><%=approvalDate%>-<%=approvalTime%>
</FONT>
</td>
<td width="220"><FONT SIZE=2>
<%     		 
try
{      
   rs=statement.executeQuery("select USERNAME,ACT_DATE,ACT_TIME from PSALES_FORE_APP_HIST,WSUSER where DOCNO='"+docNo+"' and WHO=WEBID order by ACT_DATE DESC ,ACT_TIME DESC"); 	  
   if (rs.next())                 
   {  	  
	  if (isApproved.equals("Y")) //若已核准則最後一人為核准人故先skip
      {
	    rs.next();
	  }	     
	  rs.previous();
   }	  
   while (rs.next())
   {
	  updateMan=rs.getString("USERNAME");
	  updateDate=rs.getString("ACT_DATE");
	  updateTime=rs.getString("ACT_TIME");	 
	  updateDate=updateDate.substring(0,4)+"/"+updateDate.substring(4,6)+"/"+updateDate.substring(6,8);	 
	  updateTime=updateTime.substring(0,2)+":"+updateTime.substring(2,4);  
	  out.println("<font size=2>"+updateMan+"&nbsp;&nbsp;"+updateDate+"-"+updateTime+"</font><BR>");  
    } 
    rs.close();
                       		                 		    	   		
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
%>
      </FONT></td>
       <td width="100"><font size=2><%=createBy%><BR><%=createDate%>-<%=createTime%></font></td>
    </tr>
  </table>
<!-- 表單參數 --> 
<input name="DOCNO" type="HIDDEN" value="<%=docNo%>" >
<input name="COMP" type="HIDDEN" value="<%=comp%>" >  
</FORM>
</body>
<%
  statement.close();	
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
