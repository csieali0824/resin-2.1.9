<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxAllBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function change_acton(URL)
{   
 //alert(URL); 
 document.signform.action=URL;
 document.signform.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ProgrammerEdit.jsp</title>
</head>

<body>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<!--%<form action="../jsp/UpdateProgrammer.jsp" method="post" name="signform"  onsubmit="return change_acton()"> %-->
<form action="../jsp/UpdateProgrammer.jsp" method="post" name="signform" >
  <table  border="1" align="center">
    <tr>
      <td width="606" height="72" background="../image/back5.gif"> 
        <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammer.jsp">查詢所有角色記錄</A><br>
		<%
  String ADDRESSDESC=request.getParameter("ADDRESSDESC");
  String ADDRESS="";
  String PROGRAMMERNAME=request.getParameter("PROGRAMMERNAME");
  String LINENO="";
  String ROLENAME="";
  String MODEL=request.getParameter("MODEL");
  
  String ADDRESSDESC_="";
  String LINENO_="";
  String ADDRESS_=request.getParameter("ADDRESS_");
  String ROLENAME_=""; 
  String model="";
  String PROGRAMMERNAME_=""; 
 //out.print(UserRoles);
String s1="";
String s2="";
  try
    {
	Statement statement=con.createStatement();
	ResultSet rs=null; 
    rs=statement.executeQuery("select * from WSPROGRAMMER WHERE  ADDRESSDESC='"+ADDRESSDESC+"'");
    rsBean.setRs(rs);
   
   if(rs.next())
   { 
     ROLENAME_=rs.getString("ROLENAME");
	 ADDRESS_=rs.getString("ADDRESS");	 
     model=rs.getString("MODEL");
	 PROGRAMMERNAME_=rs.getString("PROGRAMMERNAME");
	 LINENO_=rs.getString("LINENO");   
      rs.close();
	  statement.close();
	
     }//end of if

   }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
<br>
        <strong><font color="#FF0000" size="3">角色對應檔記錄維護</font></strong> </td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 
        <input type="hidden" name="ADDRESSDESC" value="<%= ADDRESSDESC %>" >
          角色名稱: 
          <% 
		 //
		 //String ROLENAME="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		 
		  sSql = "select ROLENAME,ROLENAME from wsROLE ";
		  sWhere = "where rolename!='admin' ";
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(ROLENAME_);
	      comboBoxAllBean.setFieldName("ROLENAME");	   
          out.println(comboBoxAllBean.getRsString());
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %><br>
        模組： 
        <select name="MODEL" onChange="change_acton('../jsp/ProgrammerEdit.jsp')">
          <option value="A1" <% if (MODEL!=null && (MODEL=="A1" || MODEL.equals("A1"))  ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="A1" || model.equals("A1"))) { out.println("SELECTED"); }%>>A1 
          人員管理 </option>
          <option value="B1" <% if (MODEL!=null && (MODEL=="B1" || MODEL.equals("B1"))  ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="B1" || model.equals("B1"))) { out.println("SELECTED"); }%>>B1 
          報表查詢 </option>
          <option value="C1" <% if (MODEL!=null && (MODEL=="C1" || MODEL.equals("C1")) ) { out.println("SELECTED"); }   else if(MODEL==null  &&  (model=="C1" || model.equals("C1"))) { out.println("SELECTED"); }%> >C1 
          資料維護與管理 </option>
          <option value="D1" <% if (MODEL!=null && (MODEL=="D1" || MODEL.equals("D1"))  ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="D1" || model.equals("D1"))) { out.println("SELECTED"); }%>>D1 
          SALES FORECAST </option>
          <option value="E1" <% if (MODEL!=null && (MODEL=="E1" || MODEL.equals("E1"))  ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="E1" || model.equals("E1"))) { out.println("SELECTED"); }%>>E1 
          出貨管理 </option>
          <option value="F1" <% if (MODEL!=null && (MODEL=="F1" || MODEL.equals("F1")) ) { out.println("SELECTED"); }  else if(MODEL==null  &&  (model=="F1" || model.equals("F1"))) { out.println("SELECTED"); }%>>F1 
          LC維護管理 </option>
          <option value="G1" <% if (MODEL!=null && (MODEL=="G1" || MODEL.equals("G1"))  ) { out.println("SELECTED");} else if(MODEL==null  &&  (model=="G1" || model.equals("G1"))) { out.println("SELECTED"); } %>>G1 
          產品發展平台資料查詢 </option>
          <option value="H1" <% if (MODEL!=null && (MODEL=="H1" || MODEL.equals("H1"))  ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="H1" || model.equals("H1"))) { out.println("SELECTED"); }%>>H1 
          產品資訊 </option>
          <option value="J1" <% if (MODEL!=null && (MODEL=="J1" || MODEL.equals("J1"))  ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="J1" || model.equals("J1"))) { out.println("SELECTED"); }%> >J1 
          業務員管理 </option>
          <option value="K1" <% if (MODEL!=null && (MODEL=="K1" || MODEL.equals("K1")) ) { out.println("SELECTED"); } else if(MODEL==null  &&  (model=="K1" || model.equals("K1"))) { out.println("SELECTED"); }%>>K1 
          RD倉管理 </option>
        </select>
        <br>
        程式名稱： 
        <%
		      Statement statement=con.createStatement();
			  String sSql=""; 
			   if(MODEL==null)
			   { sSql="select Unique PROGRAMMERNAME as x , PROGRAMMERNAME from wsprogrammer where ROLENAME='admin' AND  MODEL='"+model+"'"; 			  }
			  else
			  { sSql="select Unique PROGRAMMERNAME as x , PROGRAMMERNAME from wsprogrammer where ROLENAME='admin' AND  MODEL='"+MODEL+"'"; 			  }
			  //out.println(sSql); 
			ResultSet rs=statement.executeQuery(sSql);
		  out.println("<select NAME='PROGRAMMERNAME' onChange='change_acton("+'"'+"../jsp/ProgrammerEdit.jsp"+'"'+")'>");
          out.println("<OPTION>--");     
          while (rs.next())
          {            
            s1=(String)rs.getString(1); 
            s2=(String)rs.getString(2); 
		
           if (s1.equals(PROGRAMMERNAME_))
		   {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            }
		   else if (s1.equals(PROGRAMMERNAME)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            } 	    
           } //end of while            
		   out.println("</select>"); 
		   //out.println(programmername); 
		  if (PROGRAMMERNAME!=null && !PROGRAMMERNAME.equals("--"))
		  {
		   rs=statement.executeQuery("SELECT address FROM wsprogrammer where PROGRAMMERNAME='"+PROGRAMMERNAME+"'");
		   if (rs.next()) 
		   {ADDRESS_=rs.getString("address");
		    //model=rs.getString("model");
			//out.println(ADDRESS_); 
		   }
		  }
		   rs.close();    
		  statement.close();  
	          %>
        <br>
        網址: 
		<%=ADDRESS_%>
		
      </td>
    </tr>
    <tr>
      <td><!--%<input  type="submit" name="submit" value="確定"> %-->
	        <input  type="submit" name="Confirm" value="確定">
          <input type="hidden" name="ADDRESS_" value="<%= ADDRESS_ %>" >
	  </td>
    </tr>
  </table>
  <br>
</form>
<HR>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>