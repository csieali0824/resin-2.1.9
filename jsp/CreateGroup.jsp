<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,PoolBean,CheckBoxBean,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateGroup.jsp</title>
</head>

<body> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
  String GROUPPROFILE=request.getParameter("GROUPPROFILE");
  try
    {
	Statement statement=con.createStatement();
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>


      <form action="CreateGroupDb.jsp" method="post" name="signform" >
  <table border="1" align="center" bordercolor="#6699CC"">
    <tr> 
      <td width="630" height="69" background="../image/back5.gif"> 
        <p><A HREF="/wins/WinsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/GroupShow.jsp">查詢群組記錄</A></p>
        <p><font color="#FF0000"><strong>新建群組</strong></font></p></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE">群組名稱: 
        <input type="text" name="GROUPNAME" size="12" maxlength="30"> <br>
        群組說明: 
        <input type="text" name="GROUPDESC" size="15" maxlength="60"> <br>
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
      <td bgcolor="#66CCFF"><font color="#FF0000"><strong>成員:</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 
        <%
	         Statement statement=con.createStatement();
	         ResultSet rs=statement.executeQuery("select USERNAME,USERNAME from Wsuser ");
             checkBoxBean.setRs(rs);
             checkBoxBean.setFieldName("USERNAME");
        	 checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
             out.println(checkBoxBean.getRsString()); 
			 rs.close();
	         %>
      </td>
    </tr>
    <tr> 
      <td bgcolor="#66CCFF"><font color="#FF0000"><strong>角色:</strong></font></td>
    </tr>
    <tr> 
      <td bgcolor="#DEF5FE"> 
        <%
	          ResultSet rs1=statement.executeQuery("select ROLENAME,ROLENAME from Wsrole ");
              checkBoxBean.setRs(rs1);
	          checkBoxBean.setFieldName("ROLENAME");
	          checkBoxBean.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBean.getRsString());
			  statement.close();
			  rs1.close();
	          %>
      </td>
    </tr>
    <tr> 
      <td><input type="submit" name="submit" value="加入" > <input name="reset" type="reset" value="清除"></td>
    </tr>
  </table>
  <tr vAlign="top" align="middle">
    <H4>&nbsp;</H4>
    <td width="383" height="311" bgcolor=#CCFFFF> <br>
      <p> <br>
        <br>
    </form>
        </p>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

  
  <script language="JavaScript"> 

   function validate(){
     if (document.signform.GROUPNAME.value == "") {
	      alert("請輸入群組名稱!");
		  return (false);
	 }else if(document.signform.GROUPDESC.value == ""){
	      alert("請輸入群組說明!");
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
	 for (var len1 = 0; len1 < chks1.length ; len1++){
		if (chks1[len1].checked){
			checkItems1++;
		}
	 }
	if (document.signform.GROUPNAME.value == "") {
	      alert("請輸入群組名稱!");
		  return (false);
	 }else if(document.signform.GROUPDESC.value == ""){
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