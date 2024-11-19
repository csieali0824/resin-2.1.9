<!-- modify by Peggy 20150416,特定客戶指定特定line type-->
<!-- modify by Peggy 20150721,TSCE 訂單類型異動,shipping method & ssd要清除重算-->
<!-- modify by Peggy 20160706,TSCA 訂單類型異動,shipping method & ssd要清除重算-->
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
String MANUFACTORY_NO = request.getParameter("MANUFACTORY");
String lineNo=request.getParameter("LINENO");
String arrayLine=request.getParameter("ArrayLine");
String orderNum = "",lineType="";
if (lineNo == null) lineNo = "";
String PROGID=request.getParameter("PROGID");  //add by Peggy 20130605
if (PROGID==null) PROGID="";
String customerid = request.getParameter("CUSTOMERID"); //add by Peggy 20150416
if (customerid==null) customerid="0";
%>
<html>
<head>
<title>Page for choose Order Type List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(orderType,lineType,lineNo,arrayLine,PROGID)
{ 
	if (lineNo =="")
	{
		if (arrayLine != "" && arrayLine != null && arrayLine != "null")
		{
			window.opener.document.MYFORM.elements["MONTH"+arrayLine+"-15"].value=orderType; 
			window.opener.document.MYFORM.elements["MONTH"+arrayLine+"-16"].value=lineType; 
			//tsce 訂單類型異動,shipping method & ssd要清除重算,add by Peggy 20150721
			//if (window.opener.document.MYFORM.SALESAREANO.value=="001")
			if (window.opener.document.MYFORM.SALESAREANO.value=="001" || window.opener.document.MYFORM.SALESAREANO.value=="008") //add by Peggy 20160706
			{
				window.opener.document.MYFORM.elements["MONTH"+arrayLine+"-6"].value=""; 
				window.opener.document.MYFORM.elements["MONTH"+arrayLine+"-7"].value=""; 
			}
		}
		else
		{	
			window.opener.document.MYFORM.LINEODRTYPE.value=orderType;      
			window.opener.document.MYFORM.LINETYPE.value=lineType;    
		}
		//add by Peggy 20121030
		if (window.opener.document.MYFORM.SALESAREANO.value=="001" ||  window.opener.document.MYFORM.SALESAREANO.value=="004" ||  window.opener.document.MYFORM.SALESAREANO.value=="008") //add TSCR by Peggy 20131219 
		{
			if (window.opener.document.MYFORM.FOBPOINT.value.substring(0,3)=="FOB" && orderType=="1141")
			{
				window.opener.document.MYFORM.LINEFOB.value="FOB TAIWAN";
			}
			else if (window.opener.document.MYFORM.FOBPOINT.value=="FCA I-LAN" || window.opener.document.MYFORM.FOBPOINT.value=="FCA YANGXIN XIAN" || window.opener.document.MYFORM.FOBPOINT.value=="FCA TIANJIN")
			{
				if (orderType=="1141")
				{
					window.opener.document.MYFORM.LINEFOB.value="FCA I-LAN";
				}
				else if (orderType=="1156")
				{
					window.opener.document.MYFORM.LINEFOB.value="FCA YANGXIN XIAN";
				}
				else if (orderType=="1142")
				{
					window.opener.document.MYFORM.LINEFOB.value="FCA TIANJIN";
				}
				else
				{
					window.opener.document.MYFORM.LINEFOB.value="";
				}
			}			
			else
			{
				window.opener.document.MYFORM.LINEFOB.value=window.opener.document.MYFORM.FOBPOINT.value;
			}
			//tsce 訂單類型異動,shipping method & ssd要清除重算,add by Peggy 20150721
			//if (window.opener.document.MYFORM.SALESAREANO.value=="001")
			if (window.opener.document.MYFORM.SALESAREANO.value=="001" || window.opener.document.MYFORM.SALESAREANO.value=="008") //add by Peggy 20160706
			{
				window.opener.document.MYFORM.SHIPPINGMETHOD.value="";
				window.opener.document.MYFORM.REQUESTDATE.value="";
			}
		}
		//add by Peggy 20190628
		else if (window.opener.document.MYFORM.SALESAREANO.value=="002")
		{
			if (window.opener.document.MYFORM.CUSTOMERNO.value=="25071")
			{
				if (orderType=="1141")
				{
					window.opener.document.MYFORM.SHIPPINGMETHOD.value="UPS EXPRESS";
				}
				else
				{
					window.opener.document.MYFORM.SHIPPINGMETHOD.value="TRUCK";
				}
			}
		}
	}
	else
	{
		if (PROGID==null || PROGID=="")
		{
			window.opener.document.DISPLAYREPAIR.elements["odrType"+lineNo].value=orderType;      
			window.opener.document.DISPLAYREPAIR.elements["lineType"+lineNo].value=lineType;      
		}
		else
		{
			window.opener.document.MYFORM.elements["ORDER_TYPE_"+lineNo].value=orderType;      
			window.opener.document.MYFORM.elements["LINE_TYPE_"+lineNo].value=lineType;      
		}
	}
  	this.window.close();
}

</script>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSDRQOrderTypeFind.jsp">
<%  
	int icnt =0;
	Statement statement=con.createStatement();
	try
    { 
		String sql = " SELECT DISTINCT  A.ORDER_NUM,A.DESCRIPTION ,A.OTYPE_ID"+
		             //",a.DEFAULT_ORDER_LINE_TYPE"+
					 " ,nvl((select TO_CHAR(LINE_TYPE_ID) LINE_TYPE_ID from oraddman.tsc_cust_line_type x where x.CUSTOMER_ID='"+customerid+"' and NVL(x.ACTIVE_FLAG,'N')='A' AND x.ORDER_TYPE=A.ORDER_NUM),a.DEFAULT_ORDER_LINE_TYPE) DEFAULT_ORDER_LINE_TYPE"+//add by Peggy 20150416
					 " FROM ORADDMAN.TSAREA_ORDERCLS  A ,ORADDMAN.TSPROD_ORDERTYPE B "+
					 " WHERE A.ACTIVE ='Y' "+
					 " AND A.ORDER_NUM = B.ORDER_NUM "+
					 " and A.SAREA_NO = '"+salesAreaNo+"' "+
					 " AND B.MANUFACTORY_NO = '"+MANUFACTORY_NO+"' "+
					 " order by 2  ";
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next())
		{
			if (icnt==0)
			{
				out.println("<TABLE>");      
				out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>ORDER NUMBER</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>DESCRIPTION</TH>");
				out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>OTYPE_ID</TH>");
				out.println("</TR>");
			}
		
			String buttonContent=null;
			String trBgColor = "";
			if (primaryFlag==rs.getString("ORDER_NUM") || primaryFlag.equals(rs.getString("ORDER_NUM")))				 	 
			{ 
				trBgColor = "FFCC66"; 
			}
			else 
			{ 
				trBgColor = "E3E3CF"; 
			}
			orderNum = rs.getString("ORDER_NUM");
			lineType = rs.getString("DEFAULT_ORDER_LINE_TYPE");
			
			buttonContent="this.value=sendToMainWindow("+'"'+orderNum+'"'+","+'"'+lineType+'"'+","+'"'+lineNo+'"'+","+'"'+arrayLine+'"'+","+'"'+PROGID+'"'+")";		
			out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			//out.println("' onClick='"+buttonContent+"'></TD>");		
			out.println("' onClick='"+buttonContent+"'></TD>");		
			out.println("<TD><FONT SIZE=2>"+rs.getString("ORDER_NUM")+"</TD>");
			out.println("<TD><FONT SIZE=2>"+rs.getString("DESCRIPTION")+"</TD>");
			out.println("<TD><FONT SIZE=2>"+rs.getString("OTYPE_ID")+"</TD>");
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
			sendToMainWindow("<%=orderNum%>","<%=lineType%>","<%=lineNo%>","<%=arrayLine%>","<%=PROGID%>");                        
		</script> 	
	<%
	}
%>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >
<INPUT TYPE="hidden" NAME="PROGID" value="<%=PROGID%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
