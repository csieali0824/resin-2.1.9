<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
function submitCheck(field)
{       
  //檢查是否選取的資料有填入相對應的DATA
  if (field.length==null)
  {
     if (field.checked==true)
	 {
	    if (document.MYFORM.elements["DUEDATE-"+field.value].value=="" || document.MYFORM.elements["DUEDATE-"+field.value].value==null || document.MYFORM.elements["QTY-"+field.value].value=="" || document.MYFORM.elements["QTY-"+field.value].value==null)
			{ 
			  alert("Before you submit, please do not let the data that you choosed be Null !!");   
			  return(false);
			}  
			
			txt1=document.MYFORM.elements["QTY-"+field.value].value;	
			txt2=document.MYFORM.elements["DUEDATE-"+field.value].value;	
			for (j=0;j<txt1.length;j++)      
			{ 
			   c=txt1.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}	
			
			for (j=0;j<txt2.length;j++)      
			{ 
			   c=txt2.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}	
	 }
  } else {
	  for (i = 0; i < field.length; i++)  
	  {	   
		if (field[i].checked == true)
		{	   		  			
			if (document.MYFORM.elements["DUEDATE-"+field[i].value].value=="" || document.MYFORM.elements["DUEDATE-"+field[i].value].value==null || document.MYFORM.elements["QTY-"+field[i].value].value=="" || document.MYFORM.elements["QTY-"+field[i].value].value==null)
			{ 
			  alert("Before you submit, please do not let the data that you choosed be Null !!");   
			  return(false);
			}  
			
			txt1=document.MYFORM.elements["QTY-"+field[i].value].value;	
			txt2=document.MYFORM.elements["DUEDATE-"+field[i].value].value;	
			for (j=0;j<txt1.length;j++)      
			{ 
			   c=txt1.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}	
			
			for (j=0;j<txt2.length;j++)      
			{ 
			   c=txt2.charAt(j);
				if ("0123456789.".indexOf(c,0)<0) 
			   {
				 alert("The data that you inputed should be numerical!!");    
				 return(false);
				}
			}							
		} //end of if =>if (field[i].checked == true)
	  } //END OF 檢查是否選取的資料有填入相對應的DATA
  }	//end of if=>field.length==null  

  var pass = "NO"; 
  if (field.length==null)
  {
     if (field.checked==true) pass="YES";
  } else {
	  for (i = 0; i < field.length; i++) 
	  {    
		if (field[i].checked == true)
		{
		  pass="YES";
		  break;
		}
	  }
  }
  
  if (pass == "NO")
  {
    alert("You can not submit while you are not choosing any one!!");
    return false;
  }
  
  document.MYFORM.submit();   
}
</script>
<%    
  String docNo=request.getParameter("DOCNO"); 
  String targetYear=""; 
  String targetMonth="";  
  
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);  
  ResultSet rs=null;
 try
{       
   rs=statement.executeQuery("select RQYEAR,RQMONTH from PSALES_FORE_APP_HD,WSUSER where DOCNO='"+docNo+"' and CREATEDBY=WEBID(+)"); 
   if (rs.next())                 
   {      
     targetYear=rs.getString("RQYEAR");
	 targetMonth=rs.getString("RQMONTH");				
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Material Request Comfirmation Form</title>
</head>
<body>
<FORM ACTION="WSFore_MRC_Insert.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Material Request Confirmation </strong></font>
<BR>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="7%" bgcolor="#0099CC"><input name="Button" type="Button" onClick='return submitCheck(this.form.CH)' value="Submit"></td>
      <td width="19%" bgcolor="#0099CC"><font color="#333399" face="Arial Black"><strong>DOCNO:</strong></font><font color="WHITE" size=2><%=docNo%></font></td>
      <td width="74%" colspan="2" bgcolor="#0099CC">
      <font color="#333399" face="Arial Black"><strong>Remark:</strong></font>
	  <input name="REMARK" type="text" size="30">	  </td>  	 
	</tr>		<FONT >	
 </table>
  <HR>
<%  
 String f_interModel="",f_extModel="",f_color="";
 String f_fcqty="0",f_rqqty="0",fcTotal="0",rqTotal="0";    
  try
  {   
   rs=statement.executeQuery("select PRJCD,b.SALESCODE,COLOR,RQQTY from PSALES_FORE_APP_LN a,PIMASTER b where trim(a.PRJCD)=trim(b.PROJECTCODE) and DOCNO='"+docNo+"'");   
   String bgColor="B0E0E6";
%>     
   <TABLE width="647">
   <TR>
     <TH width="20" BGCOLOR=BLACK><input name="checkselect" type=checkbox onClick="this.value=check(this.form.CH)" title="選取或取消選取"></TH>
     <TH width="73" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>INTER MODEL</FONT></TH>
   <TH width="71" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>EXT MODEL</FONT></TH><TH width="57" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>COLOR</FONT></TH>
   <TH width="79" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>TARGET DATE </FONT></TH>
   <TH width="74" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>Qty. of PR</FONT></TH>
   <TH width="105" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>DUE DATE</FONT></TH>
   <TH width="132" BGCOLOR=BLACK><FONT COLOR="WHITE" SIZE=1>QUANTITY</FONT></TH>
   </TR>
<%    
   while (rs.next())  
   {                  
	f_interModel=rs.getString("PRJCD");
	f_extModel=rs.getString("SALESCODE");
	f_color=rs.getString("COLOR");	
	f_rqqty=rs.getString("RQQTY");	  
%>
   <TR BGCOLOR=<%=bgColor%>>
     <TD><INPUT TYPE=checkbox NAME='CH' VALUE="<%=f_interModel%>-<%=f_color%>"></TD>
     <TD><FONT SIZE=2><input name="<%=f_interModel%>-<%=f_color%>-MODEL" type="HIDDEN" value="<%=f_interModel%>" ><%=f_interModel%></TD><TD><%=f_extModel%></TD>
	 <TD><input name="<%=f_interModel%>-<%=f_color%>-COLOR" type="HIDDEN" value="<%=f_color%>" ><%=f_color%></TD>
	 <TD><div align="center"><%=targetYear%>/<%=targetMonth%></div></TD>
     <TD><input name="<%=f_interModel%>-<%=f_color%>-RQQTY" type="HIDDEN" value="<%=f_rqqty%>" ><div align="right"><FONT ><strong><%=f_rqqty%></strong>&nbsp;(K pcs)</font></div></TD>
     <TD><input name="DUEDATE-<%=f_interModel%>-<%=f_color%>" type="text" size="6"><A href='javascript:void(0)' onclick="gfPop.fPopCalendar(document.MYFORM.elements['DUEDATE-<%=f_interModel%>-<%=f_color%>']);return false;"><img border='0' src='../image/calbtn.gif'></A></TD>
     <TD><input name="QTY-<%=f_interModel%>-<%=f_color%>" type="text" size="7" value="<%=f_rqqty%>">(K pcs)</TD></TR>
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
  <TD colspan="3">&nbsp;</TD>
  <TD BGCOLOR=#FFFFFF><div align="right"></div></TD>
  <TD BGCOLOR=#0099CC><div align="center"><FONT COLOR=WHITE>TOTAL</font></div></TD>
  <TD BGCOLOR=#0099CC><div align="right"><FONT COLOR=LIGHTYELLOW><strong><%=rqTotal%></strong></font></div></TD>
  <TD BGCOLOR=#0099CC><FONT COLOR=WHITE>K pcs</font></TD>
  <TD BGCOLOR=#0099CC>&nbsp;</TD> 
</TR>
 </TABLE>
<HR>
<!-- 表單參數 -->
<input name="DOCNO" type="HIDDEN" value="<%=docNo%>" >
<input name="TARGETYEAR" type="HIDDEN" value="<%=targetYear%>" >
<input name="TARGETMONTH" type="HIDDEN" value="<%=targetMonth%>" >
</FORM>
<iframe width=80 height=80 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
  statement.close();	
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
