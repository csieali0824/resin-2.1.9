<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean,DateBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateProgrammer.jsp</title>
</head>

<body>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
     String EDITION=null;
	 String dateString=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;
	 int maxno=0; 
	 String LINENO=request.getParameter("LINENO");  
	 String MODEL=request.getParameter("MODEL");  
	 if(MODEL==null || MODEL=="" || MODEL.equals(null))
	 {MODEL="A1"; }


  
  
 try
    {
	Statement statement=con.createStatement();
	
	 dateString=dateBean.getYearMonthDay();
     Month=dateBean.getMonthString();
     Day=dateBean.getDayString();
     Hour=dateBean.getHourMinute();
	 HourSecond=dateBean.getHourMinuteSecond();
	 TIME=dateString+HourSecond;
     EDITION=dateString+Hour;
     NEWSID=Month+Day+Hour;
	 //out.print(TIME+"<br>");
	 //out.print(EDITION+"<br>");
	 //out.print(NEWSID);
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }

%>
<form action="CreateProgrammerDb.jsp" method="post" name="signform" onsubmit="return validate()">
  <table  border="1" bordercolor="#6699CC" align="center">
    <tr>
      <td width="630" height="73" background="../image/back5.gif"> 
	  <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp">查詢程式檔案資訊</A>
        <p><font color="#FF0000"><strong>程式檔案新增</strong></font></p></td>
    </tr>
    <tr>
      <td bgcolor="#DEF5FE">
<input type="hidden" name="ROLENAME" value="admin" > <input type="hidden" name="ADDRESSDESC" value="<%= TIME %>" >
        模組:
        <select name="MODEL" onChange="setSubmit('../jsp/CreateProgrammer.jsp')">
          <option value="A1" <% if (MODEL!=null && (MODEL=="A1" || MODEL.equals("A1")) ) { out.println("SELECTED"); } %>>A1 人員群組管理 </option>
          <option value="B1" <% if (MODEL!=null && (MODEL=="B1" || MODEL.equals("B1")) ) { out.println("SELECTED"); } %>>B1 報表查詢 </option>
          <option value="C1" <% if (MODEL!=null && (MODEL=="C1" || MODEL.equals("C1")) ) { out.println("SELECTED"); } %>>C1 資料維護與管理 </option>
          <option value="D1" <% if (MODEL!=null && (MODEL=="D1" || MODEL.equals("D1")) ) { out.println("SELECTED"); } %>>D1 SALES FORECAST </option>
          <option value="E1" <% if (MODEL!=null && (MODEL=="E1" || MODEL.equals("E1")) ) { out.println("SELECTED"); } %>>E1 出貨管理 </option>
          <option value="F1" <% if (MODEL!=null && (MODEL=="F1" || MODEL.equals("F1")) ) { out.println("SELECTED"); } %>>F1 LC維護管理 </option>
          <option value="G1" <% if (MODEL!=null && (MODEL=="G1" || MODEL.equals("G1")) ) { out.println("SELECTED"); } %>>G1 產品發展平台資料查詢 </option>
          <option value="H1" <% if (MODEL!=null && (MODEL=="H1" || MODEL.equals("H1")) ) { out.println("SELECTED"); } %>>H1 產品資訊 </option>
          <option value="J1" <% if (MODEL!=null && (MODEL=="J1" || MODEL.equals("J1")) ) { out.println("SELECTED"); } %>>J1 業務員管理 </option>
          <option value="K1" <% if (MODEL!=null && (MODEL=="K1" || MODEL.equals("K1")) ) { out.println("SELECTED"); } %>>K1 RD倉管理 </option>
        </select>
        <br> 
        網址:
        <input type="text" name="ADDRESS" size="60" maxlength="60" value="/wins/jsp/檔名.jsp">
        <br>
        檔案說明: 
        <input type="text" name="PROGRAMMERNAME" size="30" maxlength="40">        
		<br><%
		//out.println(MODEL); 
 try
  {   
   Statement statement=con.createStatement(); 
   ResultSet rs=null;
   rs=statement.executeQuery("select max(LINENO) from WSPROGRAMMER where MODEL='"+MODEL+"'");
   rs.next();   
   maxno=rs.getInt(1)+1;
   statement.close();
   rs.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
        排序:
        <input type="text" name="LINENO" size="4" maxlength="3" value="<%= maxno %>">
        <font color="#0000FF" size="1" face="Arial, Helvetica, sans-serif">
        <%
 try
  {   
   Statement stmtexist=con.createStatement(); 
   ResultSet rsexist=null;
   rsexist=stmtexist.executeQuery("select  LINENO  from WSPROGRAMMER where LINENO="+maxno+" and MODEL='"+MODEL+"'order by LINENO");
   if(rsexist.next())  
   {
    out.println("此序號已存在，請重新輸入"); 
	}
   stmtexist.close();
   rsexist.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
        </font><br> <font color="#CC0000" size="2">目前已有的序號：</font> <font color="#0000FF" size="1" face="Arial, Helvetica, sans-serif"> 
        <%
 try
  {   
   Statement stmt=con.createStatement(); 
   ResultSet rssno=null;
   rssno=stmt.executeQuery("select  Distinct LINENO as LINENO  from WSPROGRAMMER WHERE MODEL='"+MODEL+"' order by LINENO");
   while(rssno.next())  
   {
    if(rssno.getString("LINENO")!=null)
	{out.println(rssno.getString("LINENO")); }
	}
   stmt.close();
   rssno.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }   
%>
        </font></td>
    </tr>
    <tr>
      <td bgcolor="#DEF5FE">
<input type="submit" name="Add" value="加入" > <input name="reset" type="reset" value="清除">
      </td>
    </tr>
  </table>
</form>
        

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

  
  <script language="JavaScript"> 

   function validate(){
     if (document.signform.ROLENAME.value == "") {
	      alert("請輸入角色名稱!");
		  return (false);
	 }else if(document.signform.ADDRESS.value == ""){
	      alert("請輸入網址!");
			return (false);
	  }else if(document.signform.ADDRESSDESC.value == ""){
	      alert("請輸入說明!");
			return (false);
	  }else if(document.signform.PROGRAMMERNAME.value == ""){
	      alert("請輸入程式檔名!");
			return (false);
	}else if(document.signform.LINENO.value == ""){
	      alert("請輸入序號!");
			return (false);

	  }else {
	      document.signform.submit();
	  }
   }
   
   function change_acton(){
	var chks = signform.USERID;
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
function setSubmit(URL)
{    
 document.signform.action=URL;
 document.signform.submit();
}
</script>

