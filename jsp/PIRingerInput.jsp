<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>Add New Ringer</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<body>
<FORM ACTION="PIRingerInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data"> 
  <font color="#0080FF" size="5"><strong>下載鈴聲資訊</strong></font><BR>
  鈴聲代碼:
<INPUT TYPE="TEXT" NAME="RINGERCODE" size=4>
  <BR>
  鈴聲名稱: 
  <INPUT TYPE="TEXT" NAME="RINGERNAME" size=40>
  <BR><BR>
  鈴聲實體檔案<BR>
  上傳檔案:<INPUT TYPE="FILE" NAME="RINGERFILE">
  <BR>
  <p> 
    <INPUT TYPE="submit" value="存檔">
  </p>
  </FORM>
</body>
</html>
