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
 
 //String description=request.getParameter("DESCRIPTION");
 String searchString=request.getParameter("SEARCHSTRING");
 try
 {
   if (searchString==null)
   {     
	 searchString="%"; 
   } 
    else {  //out.println("NULL input");
	     }
	//out.println("invItem="+invItem+"<BR>");
	//out.println("itemDesc="+itemDesc+"<BR>");
	//out.println("searchString="+searchString+"<BR>");
	
	//  CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	//  cs1.setString(1,"41");
	//  cs1.execute();
      //out.println("Procedure : Execute Success !!! ");
    //  cs1.close();
   
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
function sendToMainWindow(primaryFlag)
{ 
  window.opener.document.MYFORM.FOBPOINT.value=primaryFlag;      
  this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSSHPFOBPointFind.jsp">
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
	    String sql = "select a.FOB_CODE, a.FOB "+
		             "from OE_FOBS_ACTIVE_V a "+
		             "where (a.FOB_CODE like '"+searchString+"%' or a.FOB like '"+searchString+"%') ";
					 //"and TO_CHAR(a.END_DATE_ACTIVE,'YYYYMMDD') >='"+dateBean.getYearMonthDay()+"'  ";
						 
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
		 //description=rs.getString("DESCRIPTION");
		 
		 if (primaryFlag==rs.getString("FOB_CODE") || primaryFlag.equals(rs.getString("FOB_CODE")))				 	 
		 { trBgColor = "FFCC66"; }
		 else { trBgColor = "E3E3CF"; }
		 buttonContent="this.value=sendToMainWindow("+'"'+fobPoint+'"'+")";		
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
<INPUT TYPE="hidden" NAME="PRIMARYFLAG" SIZE=10 value="<%=primaryFlag%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
