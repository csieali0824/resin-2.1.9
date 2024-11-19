<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,CheckBoxBean,ComboBoxBean,CheckBoxBeanNew" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateEmployee.jsp</title>
</head>

<body>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%   
  String USERPROFILE=request.getParameter("USERPROFILE");
  //String ROLE_NAME[] = new String[150]; 
  String GROUPNAME =request.getParameter("GROUPNAME"); 
  //String GROUPNAME[] = new String[150]; 

  %>
      <form action="CreateEmployeeDb.jsp" method="post" name="signform" onsubmit="return change_acton()">
	  
  <table  border="1" bordercolor="#6699CC" align=center>
    <tr> 
      <td width="618" height="72" background="../image/back5.gif"><p><A HREF="../WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/EmployeeShow.jsp"><font >查詢人員記錄</font></A></p>
        <p><font color="#FF0000"><strong>人員資料新增</strong></font></p></td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF0000"><strong>基本資料</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"><p>人員名稱: 
          <input type="text" name="USERNAME" size="10" maxlength="20">
          <br>
          工號 : 
          <input type="text" name="WEBID" size="6" maxlength="10">
          <br>
          電子郵件位址: 
          <input type="text" name="USERMAIL" size="25" maxlength="40">
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
          人員密碼: 
          <input type="text" name="PASSWORD" size="8" maxlength="8">
          <br>
          人員是否離職: 
          <select name="USERLOCK">
            <option selected>N</option>
            <option>Y</option>
          </select>
      </td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF3333"><strong>角色:</strong></font><font color="#FF0033">&nbsp;</font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE">
        <%
	        /*String sSql="select ROLENAME from WSROLEGROUP where GROUPNAME='"+GROUPNAME+"'";
		    // String sSql="select ROLENAME from WSROLEGROUP where GROUPNAME='"+GROUPNAME+"'";	
	
	         ResultSet rsS=statement.executeQuery(sSql);
			  int i=0; 
	          while (rsS.next())
	           {
	           i=i+1;
	           ROLE_NAME[i] = rsS.getString("ROLENAME");	  
	           }//查詢修改角色
	           rsS.close();
			   if(GROUPNAME==null)
			   {GROUPNAME="group"; }*/
	     
			 
              Statement statementq=con.createStatement();
	          ResultSet rs=statementq.executeQuery("select ROLENAME,ROLENAME from WSrole");
			  //checkBoxBeanNew.setChecked(ROLE_NAME);
              checkBoxBean.setRs(rs);
	          checkBoxBean.setFieldName("ROLENAME");
	          checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
			  statementq.close();
			  rs.close();
			
	         %>
      </td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF0033"><strong>群組名稱:</strong></font><font color="#FF3333">&nbsp;</font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 
        <%  Statement statement=con.createStatement();
	          ResultSet rs2=statement.executeQuery("select GROUPNAME,GROUPNAME from Wsgroup ");
              checkBoxBean.setRs(rs2);
	          checkBoxBean.setFieldName("GROUPNAME");
	          checkBoxBean.setColumn(3); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
			  statement.close();
			  rs2.close();
	          %>
        <br>
      </td>
    </tr>
    <tr>
      <td>
<p> 
    <input type="submit" name="submit" value="加入" >
    <input name="reset" type="reset" value="清除">
        </p></td>
    </tr>
  </table>
  
  </form>
     

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

   <script language="JavaScript" type="text/JavaScript"> 

  /*function validate(){
     if (document.signform.USERNAME.value == "") {
	      alert("請輸入人名!");
		  return (false);
	 }else if(document.signform.USERID.value == ""){
	      alert("請輸入工號!");
			return (false);
	  }else if(document.signform.PASSWORD.value == ""){
	      alert("請輸入密碼!");
			return (false);
	  }else{		
	      document.signform.submit();
	  }
   }*/
   
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
	 if(document.signform.USERNAME.value == ""){
	      alert("請輸入人員名稱!");
			return (false);
	  }
	   else if (document.signform.WEBID.value == "") 
	   {
	      alert("請輸入人員識別碼!");
		  return (false);
	  }
	  else if(document.signform.PASSWORD.value == "")
	  {
	      alert("請輸入密碼!");
			return (false);
	 }
	
	 else if ( checkItems1 == 0 ) {
		alert("請選擇角色!!");
	    return (false);
	 }else if (checkItems == 0  ){
	     alert("請選擇群組名稱!!");
	     return (false);  
	 }else {
	      document.signform.submit();
     }
   }
   

    </script>  
