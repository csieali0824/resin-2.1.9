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
String lineNo=request.getParameter("LINENO");
if (lineNo==null) lineNo="";
%>
<html>
<head>
<title>Page for choose Plant Code List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(plant,lineNo)
{ 
	if (lineNo != null && lineNo != "")
	{
		window.opener.document.MYFORM.elements["PLANTCODE_"+lineNo].value=plant;
	}
	else
	{
		window.opener.document.MYFORM.PLANTCODE.value=plant;      
	}
  	this.window.close();
}

</script>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSDRQPlantCodeFind.jsp">
<%  
	Statement statement=con.createStatement();
	try
    { 
		String sql = "select MANUFACTORY_NO as PRODMANUFACTORY, MANUFACTORY_NO||'  '||MANUFACTORY_NAME MANUFACTORY_NAME "+
						"from ORADDMAN.TSPROD_MANUFACTORY "+
						"where MANUFACTORY_NO > 0 "+																  
						 "order by MANUFACTORY_NO "; 
        ResultSet rs=statement.executeQuery(sql);
		int icnt =0;
		while (rs.next())
		{
			if (icnt==0)
			{
				out.println("<TABLE>");      
				out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>PRODMANUFACTORY</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>MANUFACTORY_NAME</TH>");
				out.println("</TR>");
			}
		
			String buttonContent=null;
			String trBgColor = "";
			if (primaryFlag==rs.getString("PRODMANUFACTORY") || primaryFlag.equals(rs.getString("PRODMANUFACTORY")))				 	 
			{ 
				trBgColor = "FFCC66"; 
			}
			else 
			{ 
				trBgColor = "E3E3CF"; 
			}
			buttonContent="this.value=sendToMainWindow("+'"'+rs.getString("PRODMANUFACTORY")+'"'+","+'"'+lineNo+'"'+")";		
			out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			out.println("<TD><FONT SIZE=2>"+rs.getString("PRODMANUFACTORY")+"</TD>");
			out.println("<TD><FONT SIZE=2>"+rs.getString("MANUFACTORY_NAME")+"</TD>");
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
%>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >
<INPUT TYPE="hidden" NAME="LINENO" value="<%=lineNo%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
