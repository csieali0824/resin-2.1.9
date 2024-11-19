<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBean,ComboBoxBean,ArrayListCheckBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,CheckBoxBeanNew" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EmployeeEdit.jsp</title>
</head>

<body>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="page" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<form action="EmployeeUpdate.jsp" method="post" name="signform" onsubmit="return change_acton()">

  <table   border="1" bordercolor="#6699CC" align=center>
    <tr> 
      <td width="628" height="73" background="../image/back5.gif"> 
        <%
  String USERNAME=request.getParameter("USERNAME");
  String WEBID="";
  String USERMAIL="";
  String USERPROFILE="";
  String PASSWORD="";
  String USERLOCK="";
  String GROUPNAME="";
  String ROLENAME="";
  String GROUP_NAME="";
  //String ROLE_NAME="";
  String ROLE_NAME[] = new String[150]; 
  
  out.println("<H4>修改人員記錄"+USERNAME+"</H4>");
  //out.println("人員工號:"+USERID+"<br>");
  int i=0; 
  try
    {
	Statement statement9=con.createStatement();
    ResultSet rs9=statement9.executeQuery("select USERNAME from WSUser WHERE USERNAME='"+USERNAME+"'");
    rsBean.setRs(rs9);
   
   if(rs9.next())
   {
	if (USERNAME != null)
	{	   
	  Statement statement=con.createStatement();
      String sql="select * from WSUser where USERNAME='"+USERNAME+"'";	
      ResultSet rs=statement.executeQuery(sql);
	  rs.next();
     WEBID=rs.getString("WEBID");
	 //USERNAME=rs.getString("USERNAME");
     USERMAIL=rs.getString("USERMAIL");
	 USERPROFILE=rs.getString("USERPROFILE");
	 PASSWORD=rs.getString("PASSWORD");   
	 USERLOCK=rs.getString("LOCKFLAG");   

	  
	  String sql1="select GROUPNAME from WSusergroup where USERNAME='"+USERNAME+"'";	
	  ResultSet rs1=statement.executeQuery(sql1);
	  
	  while(rs1.next())
	  {	     	    	    
		 GROUP_NAME =  GROUP_NAME+","+rs1.getString("GROUPNAME");
		 //抓出資料篩給變數,在while迴圈裡用逗號分開
		 //out.print("群組:"+rs1.getString("GROUPNAME")+"<br>");		
	  }
	  //查詢修改群組	  	  	  	  	  	  
	  
      String sql2="select ROLENAME from WSgroupuserrole where GROUPUSERNAME='"+USERNAME+"'";	
	  ResultSet rs2=statement.executeQuery(sql2);
	  while (rs2.next())
	  {
	  i=i+1;
	  ROLE_NAME[i] = rs2.getString("ROLENAME");
	  //抓出資料篩給變數,在while迴圈裡用逗號分開
	  //out.print("角色:"+rs2.getString("ROLENAME")+"<br>");
	  }//查詢修改角色
	   rs.close();
	  rs1.close();
	  rs2.close();		
	} //end of if	    
   }//end of if        
	else
	{
	   response.sendRedirect("../jsp/EmployeeEdit.jsp");
	}
   }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
<br>
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/EmployeeShow.jsp">查詢人員記錄</A></td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF0000"><strong>基本資料</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> <p> 
          <input type="hidden" name="USERNAME" value="<%= USERNAME %>" >
          工號: 
          <input type="text" name="WEBID" value="<%= WEBID %>" size="6" maxlength="10">
          <br>
          電子郵件位址: 
          <input type="text" name="USERMAIL" value="<%= USERMAIL %>" size="25" maxlength="40">
          <br>
          國別 : <font size="2">
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
		  if (USERPROFILE!=null && !USERPROFILE.equals("--")) comboBoxBean.setSelection(USERPROFILE);		  		  		  
	      comboBoxBean.setFieldName("USERPROFILE");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
          </font> <br>
          密碼: 
          <input type="text" name="PASSWORD" value="<%= PASSWORD %>" size="8" maxlength="8">
          <br>
          人員是否離職: <font size="2"> 
          <select name="USERLOCK" onChange="setSubmit('../jsp/EmployeeEdit.jsp')">
            <option value="N" <% if (USERLOCK!=null && (USERLOCK=="N" || USERLOCK.equals("N")) ) { out.println("SELECTED"); } %>>N</option>
            <option value="Y" <% if (USERLOCK!=null && (USERLOCK=="Y" || USERLOCK.equals("Y")) ) { out.println("SELECTED"); } %>>Y</option>
          </select>
          </font> </td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF3333"><strong>角色:</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> <%
	         /*Statement statementq=con.createStatement();
	         ResultSet rs=statementq.executeQuery("select ROLENAME,ROLENAME from WSrole ");
			 arrayListCheckBoxBean.setChecked(ROLE_NAME);//變數篩入checkbox裡產生預設勾選
             arrayListCheckBoxBean.setRs(rs);//執行SQL
             arrayListCheckBoxBean.setFieldName("ROLENAME");
        	 arrayListCheckBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
             out.println(arrayListCheckBoxBean.getRsString()); 
			 rs.close();*/
			 
              Statement statementq=con.createStatement();
	          ResultSet rs=statementq.executeQuery("select ROLENAME,ROLENAME from WSrole");
			  checkBoxBeanNew.setChecked(ROLE_NAME);
              checkBoxBeanNew.setRs(rs);
	          checkBoxBeanNew.setFieldName("ROLENAME");
	          checkBoxBeanNew.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBeanNew.getRsString());
			  statementq.close();
			  rs.close();
			
	         %> </td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF0033"><strong>群組名稱:</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> <%
              Statement statement=con.createStatement();
	          ResultSet rsq=statement.executeQuery("select GROUPNAME,GROUPNAME from WSgroup ");
			  checkBoxBean.setChecked(GROUP_NAME);//變數篩入checkbox裡產生預設勾選
              checkBoxBean.setRs(rsq);//執行SQL
	          checkBoxBean.setFieldName("GROUPNAME");
	          checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
			  rsq.close();
	          %> </td>
    </tr>
    <tr>
      <td>
<input type="submit" name="submit" value="確定">
<input type="reset" name="reset" value="清除">
      </td>
    </tr>
  </table>
  <br>

</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

  <script language="JavaScript" type="text/JavaScript"> 

   function validate(){
     if (document.signform.USERNAME.value == "") {
	      alert("請輸入人名!");
		  return (false);
	 }else {
	      document.signform.submit();
	  }
   }

   function change_acton(){
	var chks = signform.GROUPNAME;
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
	 if (document.signform.USERNAME.value == "") {
	      alert("請輸人員名稱!");
		  return (false);  
	 }else if (document.signform.PASSWORD.value == "") {
	      alert("請輸人員密碼!");
		  return (false);  
	 }else if( checkItems == 0 ) {
		alert("請選擇群組名稱!!");
	    return (false);
	 }else if ( checkItems1 == 0 ){
	     alert("請選擇角色!!");
	     return (false);  
	 }else {
	      document.signform.submit();
     }
   }
   
   
     </script>
