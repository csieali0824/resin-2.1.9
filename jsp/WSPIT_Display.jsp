<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript"> 
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PIT QueryAll Form</title>
</head>
<body>
<%
String ticketNo=request.getParameter("TICKETNO");   
String dateString=dateBean.getYearMonthDay();
%>
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>產品問題追蹤</strong></font> &nbsp;&nbsp;&nbsp;&nbsp; <A HREF="/wins/WinsMainMenu.jsp">HOME</A> 
  <%           
Statement statement=con.createStatement();
ResultSet rs=null;	   
  
String mFunc="",sFunc="",v_version="",v_level="",phnmn="",pbbt=""; 
String product="",model="",object="",source="",country="";
String assignto="",duedate="",status="",sim="",network="",comparison="",location="",resolveddate="";
String remark="",correctaction="",faultreason="",result="",validateddate="",validation="",username="";
  
try
{   
	String sql="select p.PHNMN,p.PBBT,p.PRODUCT,p.MODEL,o.NAME as object,s.NAME as source,MFUNCTION,f.NAME as sFunc,p.T_VERSION,S_LEVEL,LOCALE_ENG_NAME,P.ASSIGNTO,P.DUEDATE,P.STATUS,P.ISP_SIM,P.ISP_NETWORK,P.FAULTREASON,P.CORRECTACTION,P.RESOLVEDDATE,P.VALIDATION,P.VALIDATEDDATE,P.RESULT,P.REMARK,P.COMPARISON,P.LOCATION,P.REMARK,P.resolveddate,P.correctaction,P.faultreason,p.result,W.USERNAME from PIT_MASTER p,PIT_FUNCTION f,PIT_SOURCE s,PIT_OBJECT o,PIT_VERSION v,WSLOCALE l,WSUSER w";	
	String sqlWhere=" where p.ASSIGNTO=W.WEBID(+) and p.SFUNCTION=f.CODE and p.T_SOURCE=s.SOURCEID and p.T_OBJECT=o.OBJECTID and p.T_VERSION=v.T_VERSION and v.COUNTRY=l.LOCALE and p.TICKETNO='"+ticketNo+"'"; 		 		
	sql=sql+sqlWhere;
	rs=statement.executeQuery(sql);			
	if (rs.next()) //main if			 	    				
	{	   
	   mFunc=rs.getString("MFUNCTION");
	   sFunc=rs.getString("SFUNC");
	   v_version=rs.getString("T_VERSION");
	   v_level=rs.getString("S_LEVEL");
	   phnmn=rs.getString("PHNMN");	   
	   pbbt=rs.getString("PBBT");	   
	   product=rs.getString("PRODUCT");
	   model=rs.getString("MODEL");
	   object=rs.getString("object");
	   source=rs.getString("source");
	   country=rs.getString("LOCALE_ENG_NAME");
	   assignto=rs.getString("ASSIGNTO");
       duedate=rs.getString("DUEDATE");
	   status=rs.getString("STATUS");
	   sim=rs.getString("ISP_SIM");
	   network=rs.getString("ISP_NETWORK");
	   comparison=rs.getString("COMPARISON");
	   location=rs.getString("LOCATION");
	   result=rs.getString("result");
	   remark=rs.getString("remark");
	   resolveddate=rs.getString("resolveddate");
	   faultreason=rs.getString("faultreason");
	   correctaction=rs.getString("correctaction");
	   validation=rs.getString("validation");
	   validateddate=rs.getString("validateddate");
	   username=rs.getString("username");
    } //end of if => rs.next() 	
	rs.close();      	
} //end of try
catch (Exception ee)
{
    %>
	  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
	<%  
    out.println("Exception:"+ee.getMessage());		  
}	
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>PRODUCT:</strong><font color="#000000"><%=product%></font></font>
          </td>
      <td height="23" bordercolor="#FFFFFF">
        <p><font color="#330099" face="Arial Black" size="2"><strong>MODEL:</strong><font color="#000000"><%=model%></font></font>          
      </td>
      <td><font color="#330099" face="Arial Black" size="2"><strong>OBJECT:</strong><font color="#000000"><%=object%></font></font> 
      </td>
      <td><font color="#333399" face="Arial Black" size="2"><strong>VERSION:</strong><font color="#000000"><%=v_version%></font></font> 
      </td>
    </tr>
    <tr bgcolor="#D0FFFF">
      <td width="15%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>SOURCE:</strong><font color="#000000"><%=source%></font></font> 
     </td> 
      <td width="15%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>COUNTRY:</strong></font><font color="#000000" face="Arial Black" size="2"><%=country%></font>      </td>
      <td width="14%"><font color="#330099" face="Arial Black" size="2"><strong>S.LEVEL:</strong><font color="#000000"><%=v_level%></font></font></td>
      <td width="25%"><font color="#330099" face="Arial Black" size="2"><strong>PROBABILITY:</strong><font color="#000000"><%=pbbt%> % </font></font></td>
    </tr>	
	<tr bgcolor="#D0FFFF">
      <td width="15%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>STATUS:</strong><font color="#000000"><%=status%></font></font> 
     </td> 
      <td width="15%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>ASSIGN 
        TO :</strong></font><font color="#000000" face="Arial Black" size="2"><%=assignto%></font>      </td>
      <td width="14%"><font color="#330099" face="Arial Black" size="2"><strong>DUEDATE:</strong><font color="#000000"><%=duedate%></font></font></td>
      <td width="25%"><font color="#330099" face="Arial Black" size="2"><strong>LOCATION:</strong><font color="#000000"> 
        <%=location%>
        </font></font></td>
    </tr>
    <tr bgcolor="#D0FFFF"> 
      <td width="15%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>FUNCTION:</strong></font><font size="2"> 
        <%=mFunc%>
        -
        <%=sFunc%>
        </font> </td> 
      <td width="15%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>SIM 
        :</strong></font><font color="#000000" face="Arial Black" size="2"><%=sim%></font>      </td>
      <td width="14%"><font color="#330099" face="Arial Black" size="2"><strong>NETWORK:</strong><font color="#000000"><%=network%></font></font></td>
      <td width="25%"><font color="#330099" face="Arial Black" size="2"><strong>COMPARISON:</strong><font color="#000000"> 
        <%=comparison%>
        </font></font></td>
    </tr>
    <tr bgcolor="#D0FFFF"> 
      <td colspan=3 bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>REMARK:</strong></font><font size="2"> 
        <%=remark%>
        </font> </td> 
	  <td><font color="#330099" face="Arial Black" size="2"><strong>RESULT:</strong><font color="#000000"> 
        <%=result%>
        </font></font></td>
      </tr>

  </table>
	<HR>
  <TABLE width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">	
	<TR bgcolor="#CCFFFF">
	  <TH width="12%"><font size="2">ASSIGN TO</font></TH>	
	  <TH width="29%"><font size="2">Phenomenon</font></TH>
	  <TH width="22%"><font size="2">FaultReason</font></TH>	 
	  <TH width="24%"><font size="2">CorrectAction</font></TH>	
	  <TH width="13%"><font size="2">Resolve Date</font></TH>
	  </TR> 
	  <TR bgcolor="#FFFFFF">
	  <TD height="70"><font size="2"><%=username%></font></TD>	 
	  <TD><font size="2"><%=phnmn%></font></TD>
	  <TD><font color="#330099" face="Arial Black" size="2"><font color="#000000">
        <%=faultreason%>
        </font></font></TD>	 
	  <TD><font color="#330099" face="Arial Black" size="2"><font color="#000000">
        <%=correctaction%>
        </font></font></TD>	 
	  <TD><font color="#330099" face="Arial Black" size="2"><font color="#000000">
        <%=resolveddate%>
        </font></font></TD>
	  </TR> 
  </TABLE>
  <HR>
  <TABLE width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">	
	<TR bgcolor="#CCFFFF">
	  <TH width="63%"><font size="2">Validation</font></TH>
	  <TH width="37%"><font size="2">Vaildate Date</font></TH>	 
	  </TR> 
	  <TR bgcolor="#FFFFFF">

	  <TD height="44"><font size="2"><%=validation%></font></TD>
	  <TD><font color="#330099" face="Arial Black" size="2"><font color="#000000">
        <%=validateddate%>
        </font></font></TD>	 
	  </TR> 
  </TABLE>

<iframe width=80 height=80 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
 statement.close();  
%>
<!--=============以⽿段為?放???毿=========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
