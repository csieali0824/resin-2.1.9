<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String primaryFlag=request.getParameter("PRIMARYFLAG");
String salesAreaNo=request.getParameter("SalesAreaNo");
String orderType=request.getParameter("orderType");
String lineNo=request.getParameter("LINENO");
String arrayLine=request.getParameter("ArrayLine");
String lineType="";
if (lineNo == null) lineNo = "";
String PROGID = request.getParameter("PROGID");
if (PROGID==null) PROGID="";
%>
<html>
<head>
<title>Page for choose Line Type List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(lineType,lineNo,arrayLine,PROGID)
{ 
	if (lineNo =="")
	{
		if (arrayLine != ""  && arrayLine != null && arrayLine != "null")
		{
			window.opener.document.MYFORM.elements["MONTH"+arrayLine+"-16"].value=lineType; 
		}
		else
		{
			window.opener.document.MYFORM.LINETYPE.value=lineType;      
		}
	}
	else
	{
		if (PROGID ==null || PROGID =="")
		{
			window.opener.document.DISPLAYREPAIR.elements["lineType"+lineNo].value=lineType;      
		}
		else
		{
			window.opener.document.MYFORM.elements["LINE_TYPE_"+lineNo].value=lineType; 
		}
	}
  	this.window.close();
}

</script>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSDRQLineTypeFind.jsp">
<%  
	int icnt =0;
	Statement statement=con.createStatement();
	try
    { 
		String sql = " select wf.LINE_TYPE_ID, vl.name as LINE_TYPE"+ 
                     " from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl "+
                     " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
                     " and vl.language = 'US' "+
					 " and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
                     " and c.SAREA_NO = '"+salesAreaNo+"' and c.ORDER_NUM='"+orderType+"')	"+				 
                     " and END_DATE_ACTIVE is NULL ";
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next())
		{
			if (icnt==0)
			{
				out.println("<TABLE>");      
				out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>LINE_TYPE_ID</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>LINE_TYPE</TH>");
				out.println("</TR>");
			}
		
			String buttonContent=null;
			String trBgColor = "";
			if (primaryFlag==rs.getString("LINE_TYPE_ID") || primaryFlag.equals(rs.getString("LINE_TYPE_ID")))				 	 
			{ 
				trBgColor = "FFCC66"; 
			}
			else 
			{ 
				trBgColor = "E3E3CF"; 
			}
			lineType = rs.getString("LINE_TYPE_ID");
			buttonContent="this.value=sendToMainWindow("+'"'+lineType+'"'+","+'"'+ lineNo+'"'+","+'"'+arrayLine+'"'+","+'"'+PROGID+'"'+")";		
			out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			out.println("<TD><FONT SIZE=2>"+rs.getString("LINE_TYPE_ID")+"</TD>");
			out.println("<TD><FONT SIZE=2>"+rs.getString("LINE_TYPE")+"</TD>");
			out.println("</TR>");	
			icnt++;
		} //end of while
		if (icnt>0)
		{
			out.println("</TABLE>");						
		}
		rs.close();       
	} 
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
	if (icnt ==1)
	{
	%>
		<script LANGUAGE="JavaScript">                        
			sendToMainWindow("<%=lineType%>","<%=lineNo%>","<%=arrayLine%>","<%=PROGID%>");                        
		</script> 	
	<%
	}	
%>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>">
<INPUT TYPE="hidden" NAME="PROGID" value="<%=PROGID%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
