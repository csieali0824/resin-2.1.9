<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<script language="JavaScript" type="text/JavaScript"> 
function setSubmit2(URL)
{          
   if (document.MYFORM.ACTION.value=="--") //如果沒有選取任何動作,則不能submit
   {
       alert("Please select a proper ACTION first!!");   
       return(false);
   }
  
   if (document.MYFORM.ACTION.value=="009") //如果action是close,則必須檢查remark欄位是否有輸入資料
   {	  
		 if (document.MYFORM.elements["VALIDATION-"+document.MYFORM.CH.value].value=="" || document.MYFORM.elements["VALIDATION-"+document.MYFORM.CH.value].value==null)
		 { 
		   alert("Before you want to VERIFY , please do not let the VALIDATION be Null !!");   
		   return(false);
		 }	
		 if (document.MYFORM.elements["RESULT-"+document.MYFORM.CH.value].value=="--")
		 { 
		   alert("Before you want to VERIFY , please do not let the RESULT be -- !!");   
		   return(false);
		 }	            		
    }	   

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>PIT VERIFY Form</title>
</head>
<body>
<%
String ticketNo=request.getParameter("TICKETNO");   
String dateString=dateBean.getYearMonthDay();
%>
<FORM ACTION="WSPIT_Process.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>產品問題追蹤(<%=ticketNo%>)-驗證中</strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>  
<%           
Statement statement=con.createStatement();
ResultSet rs=null;	   
  
String mFunc="",sFunc="",v_version="",v_level="",phnmn="",pbbt="",faultReason="",correctAction=""; 
String product="",model="",object="",source="",country="";

String resultArray[]={"OK","NG"};
arrayComboBoxBean.setArrayString(resultArray);		      
arrayComboBoxBean.setOnChangeJS("");	
  
try
{   
	String sql="select p.PHNMN,p.PBBT,p.PRODUCT,p.MODEL,o.NAME as object,s.NAME as source,MFUNCTION,f.NAME as sFunc,p.T_VERSION,S_LEVEL,LOCALE_ENG_NAME,FAULTREASON,CORRECTACTION from PIT_MASTER p,PIT_FUNCTION f,PIT_SOURCE s,PIT_OBJECT o,PIT_VERSION v,WSLOCALE l";	
	String sqlWhere=" where p.SFUNCTION=f.CODE and p.T_SOURCE=s.SOURCEID and p.T_OBJECT=o.OBJECTID and p.T_VERSION=v.T_VERSION and v.COUNTRY=l.LOCALE and p.TICKETNO='"+ticketNo+"'"; 		 		
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
	   faultReason=rs.getString("FAULTREASON");
	   correctAction=rs.getString("CORRECTACTION");
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
      <td bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>PRODUCT:<font color="#000000"><%=product%></font></strong></font>
      </td>
      <td height="23" bordercolor="#FFFFFF">
        <p><font color="#330099" face="Arial Black" size="2"><strong>MODEL:<font color="#000000"><%=model%></font></strong></font>          
      </td>
      <td><font color="#330099" face="Arial Black" size="2"><strong>OBJECT:<font color="#000000"><%=object%></font></strong></font> 
      </td>
      <td><font color="#333399" face="Arial Black" size="2"><strong>VERSION:<font color="#000000"><%=v_version%></font></strong></font> 
      </td>
    </tr>
    <tr bgcolor="#D0FFFF">
      <td width="15%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black" size="2"><strong>SOURCE:<font color="#000000"><%=source%></font></strong></font> 
     </td> 
      <td width="15%" height="23" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black" size="2"><strong>COUNTRY:</strong></font><font color="#000000" face="Arial Black" size="2"><strong><%=country%></strong></font>      </td>
      <td width="14%"><font color="#330099" face="Arial Black" size="2"><strong>S.Level:<font color="#000000"><%=v_level%></font></strong></font></td>
      <td width="25%"></td>
    </tr>	
  </table>
	<HR>
	<table width="100%" border="1">
      <tr bordercolor="#0099FF" bgcolor="#99FFFF">
        <td width="23%">ACTION: 
        <%      
	  try
      {     	         
	      String sql="SELECT w.ACTIONID,a.ACTIONNAME FROM WSWORKFLOW w,WSWFACTION a WHERE w.ACTIONID=a.ACTIONID and FORMID='PIT' AND TYPENO='001' AND FROMSTATUSID='103'";		  	  
          rs=statement.executeQuery(sql);			  	 	    			
	      comboBoxBean.setRs(rs);	  
		  comboBoxBean.setFontSize(11); 		  	 
		  comboBoxBean.setOnChangeJS(""); 
	      comboBoxBean.setFieldName("ACTION");	   
          out.println(comboBoxBean.getRsString());	      	           
		  rs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></td>
        <td width="32%">RESULT:
        <%
	       arrayComboBoxBean.setFieldName("RESULT-"+ticketNo);
	       out.println(arrayComboBoxBean.getArrayString());
	  %></td>
        <td width="45%"><INPUT TYPE="button"  value="<-Submit" onClick='setSubmit2("WSPIT_Process.jsp")' ></td>
      </tr>
    </table>
	<HR>
	<TABLE width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">	
	<TR bgcolor="#CCFFFF">
	  <TH width="12%"><font size="2">Function</font></TH>	
	  <TH width="29%"><font size="2">Phenomenon</font></TH>
	  <TH width="7%"><font size="2">Probability</font></TH>	 
	  <TH width="26%"><font size="2">Reason of Fault </font></TH>
	  <TH width="26%"><font size="2">Correct Action</font></TH>
	  <TH width="26%"><font size="2">Validation</font></TH>
	  </TR> 
	  <TR bgcolor="#FFFFFF">
	  <TD><font size="2"><%=mFunc%>-<%=sFunc%></font></TD>	 
	  <TD><font size="2"><%=phnmn%></font></TD>
	  <TD><div align="center"><font size="2"><%=pbbt%>%</font></div></TD>	 
	  <TD><font size="2"><%=faultReason%>
	  </font></TD>
	  <TD><font size="2"><%=correctAction%></font></TD>
	  <TD><font size="2">
	    <textarea name="VALIDATION-<%=ticketNo%>"  cols="30" rows="4" ></textarea>
	  </font></TD>
	  </TR> 
  </TABLE>
 <!-- 表單參數 -->  
    <input name="OBJECTNAME" type="HIDDEN" value="">	
	<input name="SOURCENAME" type="HIDDEN" value="">		
	<input name="FROMSTATUS" type="HIDDEN" value="103">		
	<input name="FORMID" type="HIDDEN" value="PIT">
	<input name="TYPENO" type="HIDDEN" value="001">
	<input name="CH" type="HIDDEN" value="<%=ticketNo%>">
</FORM>
</body>
<%
 statement.close();  
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
