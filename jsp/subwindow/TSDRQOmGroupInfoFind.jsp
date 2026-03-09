<%@ page language="java" import="java.sql.*"%>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============�H�U�Ϭq�����o�s����==========-->
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
 String group_ID=request.getParameter("GROUP_ID");
 String group_Name=request.getParameter("GROUP_NAME");
 String searchString=request.getParameter("SEARCHSTRING");
 try
 {
   if (searchString==null)
   {     	  
	 if (group_ID!=null && !group_ID.equals("")) searchString=group_ID;
	 else if (group_Name!=null && !group_Name.equals("")) searchString=group_Name;
	 else { searchString="%"; }
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
<title>Page for choose Sales Group</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(group_ID,group_Name)
{
  window.opener.document.MYFORM.OMGROUPID.value=group_ID; 
  window.opener.document.MYFORM.OMGROUPNAME.value=group_Name;
  //window.opener.document.location.reload();
  this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQOmGroupInfoFind.jsp" NAME=CUSTFORM>
  <font size="-1">
  <jsp:getProperty name="rPH" property="pgRegion"/><jsp:getProperty name="rPH" property="pgCode"/>
  <jsp:getProperty name="rPH" property="pgOR"/>
  <jsp:getProperty name="rPH" property="pgSalesArea"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgSalesArea"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
  <%  
      int queryCount = 0;
      Statement statement=con.createStatement();
	  try
      { 
	    //if (searchString=="")
	    if (searchString!="" && searchString!=null) 
	    {  	
	      //out.println("1");
		  String sql = "";
		  String where =""; 
		  String order =	"";		        
	      sql = "select GROUP_ID, GROUP_NAME "+
                "  from APPS.TSC_OM_GROUP ";
	      where = " where (GROUP_ID = '" + searchString + "' or GROUP_NAME like '" + searchString.toUpperCase() + "%') ";															  
	      order = " order by GROUP_ID "; 
					  
		  String sqlCNT = "select count(DISTINCT GROUP_ID) from APPS.TSC_OM_GROUP " + where;  
		  ResultSet rsCNT = statement.executeQuery(sqlCNT);
		  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
          rsCNT.close();
  		  sql = sql + where + order;
          ResultSet rs=statement.executeQuery(sql);
	      ResultSetMetaData md=rs.getMetaData();
          int colCount=md.getColumnCount();
          String colLabel[]=new String[colCount+1];        
          out.println("<TABLE>");      
          out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
          for (int i=1;i<=colCount;i++) // ����ܲĤ@����, �G for �� 2�}�l
          {
             colLabel[i]=md.getColumnLabel(i);
             out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
          } //end of for 
          out.println("</TR>");
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {		
		 group_ID=rs.getString("GROUP_ID");
		 group_Name=rs.getString("GROUP_NAME");
		 out.println("<input type='hidden' name='GROUP_ID' value='"+group_ID+"' >");
		 out.println("<input type='hidden' name='GROUP_NAME' value='"+group_Name+"' >");
		 
		 if (group_ID==null) { trBgColor = "E3E3CF"; }
		 else if (group_ID==rs.getString("GROUP_ID") || group_ID.equals(rs.getString("GROUP_ID")))				 	 
		 { trBgColor = "FFCC66"; }
		 else { trBgColor = "E3E3CF"; }
		 buttonContent="this.value=sendToMainWindow("+'"'+group_ID+'"'+","+'"'+group_Name+'"'+")";		
         out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 out.println("' onClick='"+buttonContent+"'></TD>");		
         for (int i=1;i<=colCount;i++) // ����ܲĤ@����, �G for �� 2�}�l
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
          out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	   }//end of while
	   
	    if (queryCount==1) //�Y���쪺�d�߼� == 1
	    {
	     //out.println("queryCount="+queryCount);
	     %>
		    <script LANGUAGE="JavaScript">		
			    //window.opener.document.location.reload();
				window.opener.document.MYFORM.OMGROUPID.value = document.CUSTFORM.OMGROUPID.value;
				window.opener.document.MYFORM.OMGROUPNAME.value = document.CUSTFORM.OMGROUPNAME.value; 
				this.window.close(); 
            </script>
		 <%
	    }
	   
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
	  statement.close();
     %>
  <BR>
<!--%���Ѽ�%-->
<INPUT TYPE="hidden" NAME="GROUP_ID" SIZE=10 value="<%=group_ID%>" >
<INPUT TYPE="hidden" NAME="GROUP_NAME" SIZE=30 value="<%=group_Name%>" >
</FORM>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
