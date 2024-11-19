<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBean,ComboBoxBean,java.util.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditGroupDb.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<form action="../jsp/UpdateGroup.jsp" method="post" name="signform" onsubmit="">
  <table  border="1" align="center">
    <tr> 
      <td width="638" height="71" background="../image/back5.gif"> 
        <p><a href="../WinsMainMenu.jsp">回首頁</a>&nbsp; &nbsp;<A HREF="../jsp/GroupShow.jsp">查詢群組記錄</A></p>
        <p><font color="#FF0000"><strong>群組維護</strong></font></p></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 
        <%
  String USERNAME="";
  String GROUPDESC="";
  String GROUPPROFILE=request.getParameter("GROUPPROFILE");
  String[] ROLENAME=request.getParameterValues("ROLENAME");
  String[] GROUPNAME=request.getParameterValues("GROUPNAME");
  String USER_NAME="";
  String ROLE_NAME="";
  //out.println("<H4>修改群組記錄</H4>");
  try
    {
	 
     if(GROUPNAME != null)
	 {
	    
	   for(int i=0; i<GROUPNAME.length ; i++)
	   {
	      Statement statement=con.createStatement();
	      Statement statement1=con.createStatement();
		  Statement statement2=con.createStatement();
		  Statement statement3=con.createStatement();
          ResultSet rs1=statement1.executeQuery("select USERNAME from Wsusergroup where GROUPNAME ='"+GROUPNAME[i]+"'");
		  //查詢人員
		  out.print("群組:"+GROUPNAME[i]+"<br>");
		  session.setAttribute("GROUPNAME",GROUPNAME[i]);  
		  while(rs1.next())
		  {
		   USERNAME = rs1.getString("USERNAME");
		   USER_NAME =  USER_NAME+","+rs1.getString("USERNAME");
		   //out.print("成員:"+USERNAME+"<br>");
		  }
		  ResultSet rs=statement.executeQuery("select GROUPDESC from WsGroup where GROUPNAME ='"+GROUPNAME[i]+"'");
		  rs.next();
		  GROUPDESC = rs.getString("GROUPDESC");
		  //out.print("說明:"+rs.getString("GROUPDESC")+"<br>");
		  
		  //ResultSet rs2=statement2.executeQuery("Select ROLENAME from  Wsgroupuserrole where GROUPUSERNAME ='"+GROUPNAME[i]+"'");
		  ResultSet rs2=statement2.executeQuery("Select ROLENAME from  WSROLEGROUP where GROUPNAME ='"+GROUPNAME[i]+"'");
		  while (rs2.next())
		  {
		  ROLE_NAME =  ROLE_NAME+","+rs2.getString("ROLENAME");
		  //out.print("角色:"+rs2.getString("ROLENAME")+"<br>");
		  }
		  //查詢角色
		  
		  ResultSet rs3=statement3.executeQuery("select GROUPPROFILE from WsGroup where GROUPNAME ='"+GROUPNAME[i]+"'");
		  rs3.next();
		  GROUPPROFILE = rs3.getString("GROUPPROFILE");
		  //out.print("群組系統基本設定:"+rs3.getString("GROUPPROFILE")+"<br>");
		  //查詢群組系統基本設定
		  statement.close();
	      statement1.close();
		  statement2.close();
		  statement3.close();
		}
	 }
   else
   {
     response.sendRedirect("../jsp/EditGroup2.jsp");
   }
 }//end of try
  	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }

%>		<br>
        群組說明: 
        <input type="text" name="GROUPDESC" value="<%= GROUPDESC %>" size="15" maxlength="60">
        <br>
        群組國別: <font size="2">
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		 	             		 
		  sSqlC = "select Unique locale as x, locale||'('||LOCALE_NAME||')' from WSLOCALE";		  
		  sWhereC= " order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (GROUPPROFILE!=null && !GROUPPROFILE.equals("--")) comboBoxBean.setSelection(GROUPPROFILE);		  		  		  
	      comboBoxBean.setFieldName("GROUPPROFILE");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><strong><font color="#FF0000">成員:</font></strong></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 
        <%
	         Statement statement=con.createStatement();
	         ResultSet rs=statement.executeQuery("select USERNAME,USERNAME from Wsuser ");
			 checkBoxBean.setChecked(USER_NAME);
             checkBoxBean.setRs(rs);
             checkBoxBean.setFieldName("USERNAME");
        	 checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
             out.println(checkBoxBean.getRsString()); 
			 statement.close();
			 rs.close();
	         %>
      </td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><strong><font color="#FF0000">角色:</font></strong></td>
    </tr>
    <tr>
      <td bgcolor="#DEF5FE"> 
        <%
	       
	         Statement statement1=con.createStatement();
	         ResultSet rs1=statement1.executeQuery("select ROLENAME,ROLENAME from Wsrole ");
			 checkBoxBean.setChecked(ROLE_NAME);
             checkBoxBean.setRs(rs1);
             checkBoxBean.setFieldName("ROLENAME");
        	 checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
             out.println(checkBoxBean.getRsString()); 
			 statement1.close();
			 rs1.close();
	         %>
      </td>
    </tr>
    <tr>
      <td><input type="submit" name="submit" value="修改"> <input type="reset" name="reset" value="清除"></td>
    </tr>
  </table>
  </form>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>



  <script language="JavaScript"> 

   function validate(){
     if (document.signform.GROUPDESC.value == "") {
	      alert("請輸入說明!");
		  return (false);
	  }else {
	      document.signform.submit();
	  }
   }
   
   
   
   function change_acton(){
	var chks = signform.USERNAME;
        var checkItems = 0;
	 for (var len = 0; len <chks.length;len++){
		if (chks[len].checked){
			checkItems++;
		}
	 }
	 var chks1 = signform.ROLENAME;
        var checkItems1 = 0;
	 for (var len1 = 0; len1 <chks1.length;len1++){
		if (chks1[len1].checked){
			checkItems1++;
		}
	 }
     if(document.signform.GROUPDESC.value == ""){
	      alert("請輸入群組說明!");
			return (false);
	 }else if ( checkItems == 0 ) {
		alert("請選擇成員!!");
	    return (false);
	 }else if ( checkItems1 == 0 ){
	     alert("請選擇角色!!");
	     return (false);  
	 }else {
	      document.signform.submit();
     }
   }

    </script>