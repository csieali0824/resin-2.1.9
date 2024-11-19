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
if (primaryFlag==null) primaryFlag="";
//String description=request.getParameter("DESCRIPTION");
String searchString=request.getParameter("SEARCHSTRING");
String FuncName=request.getParameter("FUNC");  //add by Peggy 20120215
String FTYPE=request.getParameter("FTYPE");    //add by Peggy 20120329
if (FTYPE == null) FTYPE = "";
if (FuncName==null) FuncName="D1007";          //add by Peggy 20120215
String lineNo = request.getParameter("LINENO");
if (lineNo==null) lineNo="";
try
{
	if (searchString==null)
   	{     
		searchString="%"; 
   	} 
    else 
	{  
		//out.println("NULL input");
	}
} 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}   
%>
<html>
<head>
<title>Page for choose FOB List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(primaryFlag,fType,lineNo)
{ 
	if (document.SITEFORM.FUNC.value =="D1001" || document.SITEFORM.FUNC.value =="D1009")
	{
		if (fType == "HEADER")
		{
			window.opener.document.MYFORM.FOBPOINT.value=primaryFlag;      
		}
		else if (fType == "LINE")
		{
			window.opener.document.MYFORM.REQUESTDATE.value=""; //清除SSD,add by Peggy 20210217
			window.opener.document.MYFORM.LINEFOB.value=primaryFlag;      
		}
		else
		{
			window.opener.document.MYFORM.elements["MONTH"+fType+"-17"].value=primaryFlag;
		}
	}
	else if (document.SITEFORM.FUNC.value =="D9002" || document.SITEFORM.FUNC.value =="D11001") //add by Peggy 20140103
	{
		if (fType == "HEADER")
		{		
			window.opener.document.MYFORM.FOB.value = primaryFlag;
		}
		else if (fType == "LINE")
		{
			window.opener.document.MYFORM.elements["LINE_FOB_"+lineNo].value = primaryFlag;
		}
	}
	else if (document.SITEFORM.FUNC.value =="D4010") //add by Peggy 20140123
	{
		window.opener.document.form1.action="../jsp/Tsc1211SpecialCustConfirm.jsp?KeyID="+window.opener.document.form1.KeyID.value+"&FOB="+primaryFlag;
		window.opener.document.form1.submit(); 
	}
	else
	{
		if (fType != "" && fType != null && fType != "null")
		{
			window.opener.document.DISPLAYREPAIR.elements["FOB"+fType].value=primaryFlag;   
		}
		else
		{
			window.opener.document.DISPLAYREPAIR.FOBPOINT.value=primaryFlag;      
		}
		
	}
  	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQFOBPointFind.jsp" NAME=SITEFORM>
<font size="-1"><jsp:getProperty name="rPH" property="pgFOB"/><jsp:getProperty name="rPH" property="pgName"/>: 
	<input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  	</font> 
  	<INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  	-----<jsp:getProperty name="rPH" property="pgFOB"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  	<BR>
<%  
	Statement statement=con.createStatement();
	try
    { 
		if (searchString!="" && searchString!=null) 
		{  	    
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
		
	    	String sql = "select a.FOB_CODE, a.FOB "+
		             "from OE_FOBS_ACTIVE_V a "+
		             "where (a.FOB_CODE like '"+searchString+"%' or a.FOB like '"+searchString+"%') order by a.fob_code";
        	ResultSet rs=statement.executeQuery(sql);
			//out.println("sql="+sql);       		
	    	ResultSetMetaData md=rs.getMetaData();
        	int colCount=md.getColumnCount();
        	String colLabel[]=new String[colCount+1];        
        	out.println("<TABLE>");      
        	out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        	for (int i=1;i<=colCount;i++) // 
       	 	{
         		colLabel[i]=md.getColumnLabel(i);
         		out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        	} //end of for 
        	out.println("</TR>");
			String fobPoint=null;
        	String buttonContent=null;
			String trBgColor = "";
        	while (rs.next())
        	{
		 		//primaryFlag=rs.getString("TERM_ID");
		 		fobPoint=rs.getString("FOB_CODE");
		 		if (primaryFlag==rs.getString("FOB_CODE") || primaryFlag.equals(rs.getString("FOB_CODE")))				 	 
		 		{ 
					trBgColor = "FFCC66"; 
				}
		 		else 
				{ 
					trBgColor = "E3E3CF"; 
				}
				
		 		buttonContent="this.value=sendToMainWindow("+'"'+fobPoint+'"'+","+'"'+FTYPE+'"'+","+'"'+lineNo+'"'+")";		
         		out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 		out.println("' onClick='"+buttonContent+"'></TD>");		
         		for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         		{
          			String s=(String)rs.getString(i);
          			out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         		} //end of for
          		out.println("</TR>");	
        	} //end of while
        	out.println("</TABLE>");						
        	rs.close(); 
			
			String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
			PreparedStatement pstmt2=con.prepareStatement(sql2);
			pstmt2.executeUpdate(); 
			pstmt2.close();			 
			      
	   	}//end of while
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
    %>
<BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" value="<%=primaryFlag%>" >
<INPUT TYPE="hidden" NAME="FUNC" value="<%=FuncName%>">
<INPUT TYPE="hidden" NAME="FTYPE"  value="<%=FTYPE%>">
<INPUT TYPE="hidden" NAME="LINENO" value="<%=lineNo%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
