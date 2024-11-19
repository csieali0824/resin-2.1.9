<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,java.util.*,CheckBoxBeanNew,ComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditRegionDb.jsp</title>
</head>

<body background="../image/b01.jpg"> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%

  String REGION=request.getParameter("REGION");
  //String[] LOCALE_NAMEA;
  //String    bbuffSize = null ;
  String LOCALE_NAMEA[] = new String[150]; 
  
  int i=0; 
  try
    {
	Statement statement=con.createStatement();
	  String sql2="select LOCALE from WsREGION WHERE REGION='"+REGION+"'";	
	  ResultSet rs2=statement.executeQuery(sql2);
	  while (rs2.next())
	  {
	   i=i+1;
	    LOCALE_NAMEA[i] = rs2.getString("LOCALE");
	    //out.print("地區:"+rs2.getString("LOCALE")+"<br>");
	  }//查詢修改地區
	
	  out.print("<hr>");
	  rs2.close();
	   statement.close();
    }//end of try
	
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>

      <form action="EditRegionDb2.jsp" method="post" name="signform" onsubmit="return getNum()">
      	<input type="hidden" name="REGION" value="<%= REGION %>" >

	  
	  COUNTRY:<%
	          Statement statement=con.createStatement();
	          ResultSet rs1=statement.executeQuery("select X.LOCALE,Y.LOCALE_ENG_NAME from WsREGION X , WsLOCALE Y Where X.REGION='"+REGION+"' and X.LOCALE=Y.LOCALE ");
			  checkBoxBeanNew.setChecked(LOCALE_NAMEA);
              checkBoxBeanNew.setRs(rs1);
	          checkBoxBeanNew.setFieldName("LOCALE");
	          checkBoxBeanNew.setColumn(5); //傳參數給bean以回傳checkBox的列數
              out.println(checkBoxBeanNew.getRsString());
			  statement.close();
			  rs1.close();
	          %><br> 
			  
			  
			  <%
			  out.print("REGION:"+REGION+"<br>");
			  out.print("選擇洲別:");
		      Statement statement1=con.createStatement();
	          ResultSet rs2=statement1.executeQuery("select CONTINENT,CONTINENT_NAME from WsCONTINENT ");
			  comboBoxBean.setRs(rs2);
			  comboBoxBean.setSelection("01");
	          comboBoxBean.setFieldName("CONTINENT");
              out.println(comboBoxBean.getRsString());
			  statement1.close();
			  rs2.close();
	          %><br> 
	
     <input type="submit" name="submit" value="EDIT" >
</form>
     
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

  <script language="JavaScript"> 

   function getNum(){
     var sel="";
     sel = document.signform.LOCALE.selectedIndex;
	 if (sel==0){
	  alert("請選擇陸地名稱!!");
	    return (false);
	 }
	 else{
	   document.signform.submit();
	 }
   }
    </script>
