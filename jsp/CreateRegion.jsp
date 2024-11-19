<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean,CheckBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池================-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--==============================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateREGION.jsp</title>
</head>

<body  background="../image/b01.jpg"> 
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<%
    String REGION=request.getParameter("REGION");
	

  try
    {
	Statement statement=con.createStatement();
	 statement.close();
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>
      <form action="CreateRegionDb.jsp" method="post" name="signform" onsubmit="return getNum()">
REGION:<input type="text" name="REGION"  value="<% if(REGION!=null){
                                                                   out.print(REGION);
                                                                    } 
																	else{
																	out.print("");
																	} %>" size="20" maxlength="30"><br>
選擇洲別:<%
		      Statement statement=con.createStatement();
	          ResultSet rs=statement.executeQuery("select CONTINENT,CONTINENT_NAME from WsCONTINENT ");
			  comboBoxBean.setRs(rs);
			  comboBoxBean.setSelection("01");
	          comboBoxBean.setFieldName("CONTINENT");
              out.println(comboBoxBean.getRsString());
			  statement.close();
			  rs.close();
	          %><br>    
	
     <input type="submit" name="submit" value="new" >
     <input name="reset" type="reset" value="rest"><br>
        <a href="../jsp/System.jsp">回上一頁</a>
</form>
     
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>



   <script language="JavaScript"> 

   function getNum(){
     if (document.signform.REGION.value == "") {
	      alert("請輸入REGION!");
		  return (false);
          }else{		
	      document.signform.submit();
	       }
	  }
   
   </script>