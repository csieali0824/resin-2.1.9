<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Switch CharacterSet==========-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="PageHeaderBean,QueryAllBean" %>
<jsp:useBean id="pageHeader" scope="session" class="PageHeaderBean"/>
<jsp:useBean id="queryAllBean" scope="page" class="QueryAllBean"/>
<script language="JavaScript" type="text/JavaScript">
function showImg(pc,wv)
{   
  subWin=window.open("ShowImgNew.jsp?PROJECTCODE="+pc+"&WHICHVIEW="+wv,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function searchPI() 
{   
  location.href="../jsp/PIQueryAll.jsp?SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&PIC_OPTION="+document.MYFORM.elements["PIC_OPTION"].checked;
}
</script>
<%
 int maxrow=0;//查詢資料總筆數 
 String searchString=request.getParameter("SEARCHSTRING"); 
 String scrollRow=request.getParameter("SCROLLROW");  
 String picOption=request.getParameter("PIC_OPTION");  
 if (picOption==null ||  picOption.equals("true"))
 {
   picOption="CHECKED";  
 } else {
    picOption="";
 }
 
%>
<html>
<head>
<title>Query All Data of Product Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM NAME="MYFORM" >
<font color="#0080FF" size="4"><strong><jsp:getProperty name="pageHeader" property="pgTitleName"/></strong></font>
<table width="95%">
  <tr>
      <td width="50%" height="24">
	  <%	    
	    if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("pi_editor")>=0)
		{
    	  out.println("<A HREF='PIInputPage.jsp'>New Product Information</A>&nbsp;&nbsp;&nbsp;&nbsp;");
		}  
	  %>
        <A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;
        <input type="checkbox" name="PIC_OPTION" value="YES" <%=picOption%>>
        <font color="RED">PIC 
        Only!!</font> </td>
	  
    <td width="50%"><strong><font color="#400040" size="2">Model No.:</font></strong> 
      <INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
      <input name="search" type=button onClick="searchPI()" value="<-SEARCH"></td>
  </tr>
</table>
<%   
 try
 {
   Statement statement=con.createStatement();
   String sqlString=null;
   if (picOption.equals("CHECKED"))
   {
     sqlString="select unique a.PROJECTCODE,SALESCODE,substr(LAUNCHDATE,1,4)||'/'||substr(LAUNCHDATE,5,2)||'/'||substr(LAUNCHDATE,7,2),LENGTH||'x'||WIDTH||'x'||HEIGHT,WEIGHT,BANDMODE,RINGTONECODE,CAMERA,DESIGNHOUSE,SYSTEMMODE from PIMASTER a,PIIMAGE b";
   } else {
     sqlString="select unique PROJECTCODE,SALESCODE,substr(LAUNCHDATE,1,4)||'/'||substr(LAUNCHDATE,5,2)||'/'||substr(LAUNCHDATE,7,2),LENGTH||'x'||WIDTH||'x'||HEIGHT,WEIGHT,BANDMODE,RINGTONECODE,CAMERA,DESIGNHOUSE,SYSTEMMODE from PIMASTER";
   }     	    
   
   if (picOption.equals("CHECKED"))
   {
     if (searchString!=null && searchString!="" && !searchString.equals(""))
     {
       sqlString=sqlString+" where a.PROJECTCODE=b.PROJECTCODE and a.PROJECTCODE like '"+searchString+"%' or a.SALESCODE like '"+searchString+"%'";
     } else {  
       sqlString=sqlString+" where a.PROJECTCODE=b.PROJECTCODE";
	 }  
   } else {
     if (searchString!=null && searchString!="" && !searchString.equals(""))
     {
       sqlString=sqlString+" where PROJECTCODE like '"+searchString+"%' or SALESCODE like '"+searchString+"%'";
     }    
   }      
   sqlString=sqlString+" order by PROJECTCODE";
   
   ResultSet rs=statement.executeQuery(sqlString);        
   ResultSetMetaData md=rs.getMetaData();
   int colCount=md.getColumnCount();
   
   out.println("<TABLE BGCOLOR=BLACK BORDER=0>");   
   out.println("<TR BGCOLOR=c71585><TH><font color=white>Picture</TH><TH><font color=white>Model No.</TH><TH><font color=white>Sales Code</TH><TH><font color=white>Launch Date</TH><TH><font color=white>Size(mm)</TH><TH><font color=white>Weight(g)</FONT></TH><TH><font color=white>Band</FONT></TH><TH><font color=white>Ringtone</FONT></TH><TH><font color=white>Camera</FONT></TH><TH><font color=white>Design House</FONT></TH><TH><font color=white>System Mode</FONT></TH><TH><font color=white>Connectivity</FONT></TH></TR>");
   String projectCode="";
   String projectCodeTemp="";
   
   while (rs.next())
   {
     projectCode=rs.getString("PROJECTCODE");	
     //to get the comm data
	  Statement statement2=con.createStatement();
      ResultSet rs2=statement2.executeQuery("select COMMNAME from PIPRODCOMM where PROJECTCODE='"+projectCode+"'");        	  
      queryAllBean.setRs(rs2);
    //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	
	 if (projectCode.substring(projectCode.length()-1,projectCode.length()).equals("+")) 
	 {
	    projectCodeTemp=projectCode.substring(0,projectCode.length()-1)+"plus";
		
	} else {        
	    projectCodeTemp=projectCode;
		
	}	
    out.println("<TR BGCOLOR=WHITE>");
	out.println("<TD align=center><A href='javaScript:showImg("+'"'+projectCodeTemp+'"'+","+'"'+"IMGFRONTVIEW"+'"'+")'><img src='ShowImgNew.jsp?PROJECTCODE="+projectCodeTemp+"&WHICHVIEW=IMGFRONTVIEW' width='27' height='45'></TD>");	
	out.println("<TD><A HREF='PIDataDisplayPage.jsp?PROJECTCODE="+projectCodeTemp+"'>"+projectCode+"</A></TD>");
     for (int i=2;i<=colCount;i++)
     {
       String s=(String)rs.getString(i);	  
       out.println("<TD align=center><FONT SIZE=2>"+s+"</TD>");
      } //end of for	    
	  out.println("<TD><FONT SIZE=2>"+queryAllBean.getRsTextString()+"</TD>");
      out.println("</TR>");
	  
	  statement2.close();
	  rs2.close();
    } //end of while
   
   out.println("</TABLE>");
   
   rs.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
