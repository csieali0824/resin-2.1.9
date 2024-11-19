<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>INVTempWindows.jsp</title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckInputBoxBean" %>
</head>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckInputBoxBean" scope="session" class="ArrayCheckInputBoxBean"/>
<body>

	<%
	
	String [][] chooseFeatures_=arrayCheckInputBoxBean.getArray2DContent();
	//String chooseFeature=request.getParameter("CHOOSEFEATURE"); 
	String item = "";
	String qty = "";
	//String whs = "";
	//String loc = "";		
	
 try
 {       
	  
  if (chooseFeatures_!=null && chooseFeatures_.length>0)
  {  //out.println("Step1:"); 
    for (int i=0;i<chooseFeatures_.length;i++)
    { //out.println("Step2:");  
	 String whs=request.getParameter("WHS"+i);
	 String loc=request.getParameter("LOC"+i);	 
	 item=chooseFeatures_[i][0];
	 qty=chooseFeatures_[i][1];
	 //whs=chooseFeatures_[i][2];
	 //loc=chooseFeatures_[i][3];
	 out.println("Process OK!! <BR><BR><BR> Item:"+item+"<BR>Qty:"+qty+"<BR>Whs:"+whs+"<BR>Loc:"+loc+"<BR><BR><BR>");	 
    } //end of for
  }
  //out.println("Process OK!! <BR><BR><BR> Item:"+item+"<BR>Qty:"+qty+"<BR>Whs:"+whs+"<BR>Loc:"+loc+"<BR><BR><BR>");
  //out.println("<A HREF=../INVRecPage.jsp>入庫單處理<BR><BR></A><A HREF=/wins/WinsMainMenu.jsp>HOME</A>");  
  out.println("<A HREF=../subwindow/AddMaterialSubWindow.jsp>回上頁<BR><BR></A>");     
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>



</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
