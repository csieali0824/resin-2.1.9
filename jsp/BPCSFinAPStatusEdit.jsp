<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BPCS應付帳款付款狀態修改</title>
</head>
<script language="JavaScript"> 
   function validate(){
     if (document.signform.STATUS.value == "" ) {
	      alert("付款狀態不可為空白!");
		  return (false);
	  } else if (document.signform.STATUS.value !="R") {
	          alert("狀態只能修改為R(己付款,不下轉到資金)!!")
		      return(false);
		  } else {
	          document.signform.submit();
	      }
   }
</script>

<body>
<p><font color="#0080C0" size="5">BPCS應付帳款付款狀態修改</font><A HREF="/wins/WinsMainMenu.jsp">回首頁</A></p>
<%
      String serial=request.getParameter("SERIAL");
	  String STATUS;
%>
<%
    try 
	   {
	      String sql="select AMHVND,VNDNAM,AMHTDA,AMHCUR,AMHPAM,AMHREF,AMHSUB,AMHSTS,AMHCPC,h.SERIALCOLUMN as SERIAL from AMH h,AVM v where h.serialcolumn='"+serial+"' ";
		  PreparedStatement pt=ifxTestCon.prepareStatement(sql);
		  //PreparedStatement pt=ifxDbtelcon.prepareStatement(sql);
		  ResultSet rs=pt.executeQuery();
		  rs.next();
		  out.println("廠商代碼 : "+rs.getString("AMHVND")+"<br>");
		  out.println("廠商名稱 : "+rs.getString("VNDNAM")+"<br>");
		  out.println("傳票號碼 : "+rs.getString("AMHCPC")+"<br>");
		  out.println("開  票  日 : "+rs.getString("AMHTDA")+"<br>");
		  out.println("幣        別 : "+rs.getString("AMHCUR")+"<br>");
		  out.println("金        額 : "+rs.getString("AMHPAM")+"<br>");
		  out.println("開票序號 : "+rs.getString("AMHREF")+"<br>");
		  out.println("開票序號 : "+rs.getString("AMHSUB")+"<br>");
		 // 		  out.println(status=rs.getString("AMHSTS");
		  STATUS=rs.getString("AMHSTS");
		  rs.close();
		  pt.close();
	   } //end of try
	catch (Exception e){
		 out.println("Exception:"+e.getMessage());
	   }
%>
<form action="../jsp/BPCSFinAPStatusUpdate.jsp?SERIAL=<%=serial%>" method="post" name="signform" onsubmit="return validate()">
  <p> 開票狀態 : 
    <input type="text" name="STATUS" maxlength="1">
  </p>
    <input type="submit" name="submit" value="修改"> <input type="reset" name="reset" value="清除">
</form>
</body>

</html>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
<!--%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%-->
