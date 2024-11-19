<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,java.util.*" %>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<title>上傳XML及資料轉出頁面</title>
<style type="text/css">
<!--
.tborder {
	border: 1px solid #999999;
	font-family: "Courier New", "Courier", "mono";
}
-->
</style>
<style type="text/css">
<!--
.btn {
	font-family: "Courier New", "Courier", "mono";
	font-size: 9pt;
	background-color: #77BCDD;
}
-->
</style>
<style type="text/css">
<!--
.style1 {
	font-size: 18px;
	font-weight: bold;
}
-->
</style>

<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
  //alert(document.DISPLAYREPAIR.CHKFLAG.length); 
    //chkFlag="TURE";   
 //var linkURL = "#action";
 //alert(URL);
  document.form1.action=URL;
  document.form1.submit(); 
}
//function setSubmit2(URL)
//{  
  //alert(document.DISPLAYREPAIR.CHKFLAG.length); 
    //chkFlag="TURE";   
 //var linkURL = "#action";
 // alert("******顯示訂單資訊******");
 // document.form1.action=URL;
 // document.form1.submit(); /
//}
function setUpload(URL)
{  
  //alert(document.DISPLAYREPAIR.CHKFLAG.length); 
    //chkFlag="TURE";   
 //var linkURL = "#action";
 //alert(URL);
  document.form1.action=URL;
  document.form1.submit(); 
}

function setSubmit2(URL)
{    
  //alert("******顯示訂單資訊******");
  subWin=window.open(URL,"subwin");  
} 

</script>
<%
	String rootPath = application.getRealPath("/jsp/upload_Exl");
	String dirLabel = "Upload";
	ArrayList fileList = new ArrayList();
	String fname ="";
	dateBeans.setAdjDate(-29);
	String search_date= dateBeans.getYearMonthDay();
	String file_date = "";
	
	File fp = new File(rootPath);
	String[] list = fp.list();
	
	for(int i=0; i<list.length;i++){
		File inFp = new File(rootPath + File.separator + list[i]);
		file_date = (new Timestamp(inFp.lastModified())).toString().substring(0,10).replace("-","");
		if (inFp.getName().startsWith("D4002_") && (file_date.compareTo(search_date)>=0)) //add by Peggy 20110629
		{
			HashMap fileProp = new HashMap();
			fileProp.put("fn",list[i]);
			fileProp.put("fsize",new Long(inFp.length()));
			fileProp.put("ctime",new Long(inFp.lastModified()));
			fileList.add(fileProp);
		}
	}
%>

</head>

<body>

<BR>

<BR>
<p align="center">
<p align="center" class="style1"><font face="Verdana, Arial, Helvetica, sans-serif">TSC EXL Upload Program and List </font></p>
</p>
<form action="" name="form1" method="post" enctype="multipart/form-data">
 <%@ include file="TscJapanHead.jsp"%>

  <TABLE width="70%" height="84" border="0" align="center" cellpadding="0" cellspacing="1" class="tborder">
    <tr bgcolor="#E6FFE6"> 
      <td height="30" colspan="6"> <div align="CENTER"> 
          <input type="file" name="file">
          <input name="Submit" type="submit" class="btn" onclick ='setUpload("TscJapanExlRfqUploadCheck.jsp")' value="Upload">
        <font size='2'><A HREF="../jsp/samplefiles/D4-002_SampleFile.xls">Download Sample File</A></font></div></td>
    </tr>
	<tr> 
      <td width="5%" height="23" bgcolor="#77BCDD"> <div align="center">No.</div></td>
      <td width="19%" bgcolor="#77BCDD"> <div align="center">File Name</div></td>
      <td width="4%" bgcolor="#77BCDD">&nbsp;</td>
      <td width="21%" bgcolor="#77BCDD"> <div align="center">Size</div></td>
      <td width="24%" bgcolor="#77BCDD"> <div align="center">Date</div></td>
      <td width="27%" bgcolor="#77BCDD"><div align="center">insert to DB </div></td>
	</tr>
    <%
  	for(int i=0; i<fileList.size(); i++){
		String color = (i%2 == 0)?"#E0E0E0":"#EEEEEE";
		HashMap p = (HashMap)fileList.get(i);
		if( ((String)p.get("fn")).equals("TscJapanExlRfqUpload.jsp") || ((String)p.get("fn")).equals("TscJapanExlRfqUpload.jsp"))
		{
			continue;
		}
		 
  %>
    <tr> 
      <td height="27" bgcolor="<%=color%>"> 
        <div align="center"><%=(i+1)%></div></td>
      <td bgcolor="<%=color%>" > 
 		<%=p.get("fn")%> 
      </td>
      <td bgcolor="<%=color%>" ></td>
      <td bgcolor="<%=color%>" > 
        <div align="center"><%=p.get("fsize")%></div></td>
      <td bgcolor="<%=color%>" > 
        <div align="center"><%=new Timestamp( ((Long)p.get("ctime")).longValue() )%></div></td>
      <td bgcolor="<%=color%>" ><div align="center">
        <input type="submit" name="Submit2" value="insert" onclick ='setSubmit("TscJapanExlRfqUploadCheck.jsp?fileName=<%=p.get("fn")%>")'>
      </div></td>
    </tr>
    <%
  	}
  %>
  </table>
</form>
<div align="left"></div>
</body>
</html>
