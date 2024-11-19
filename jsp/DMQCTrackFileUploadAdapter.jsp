<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>

<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>upload file - Daily Production</title>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/DMQCTrackFileUploadInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>  
<strong><font color="#004080" size="4">Daily Production  File Upload</font></strong>
<table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>Upload FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
<!--	
	<tr>
			<td ><font color="#333399" face="Arial Black"><strong>Year</strong></font> 
				<% /*
					String CurrYear = null;	     		 
					try //get year
					{       
						String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
						arrayComboBoxBean.setArrayString(a);
						CurrYear=dateBean.getYearString();
						arrayComboBoxBean.setSelection(CurrYear);
						arrayComboBoxBean.setFieldName("YEARSET");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					*/
				%>
			</td>	
			
			<td  > <font color="#330099" face="Arial Black"><strong>Month</strong></font> 
				<% /*
					String CurrMonth = null;	     		 
					try  //get month
					{       
						String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
						arrayComboBoxBean.setArrayString(b);
						CurrMonth=dateBean.getMonthString();
						arrayComboBoxBean.setSelection(CurrMonth);
						arrayComboBoxBean.setFieldName("MONTHSET");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());				
					}
					*/
				%> 
			</td>	
	
	
	</tr>
-->	
  </table>  
  <p> 
    <INPUT TYPE="submit" value="UPLOAD">
  </p>
  
	<P>轉入EXCEL檔案請依以下格式</P>
	<P>1.每個work sheet請用日期格式名命, 例yyyyMMDD</P>
	<P>2.最後一個STATION必為PACKING, 作為讀入檔案結束之依據</P>
	<P>3.B3(第2行第3列)為機種代碼</P>
	<P>4.第5列是欄名, 從第7列開始為每日每站之投入及產出數量, 每站之間要隔一行</P>
	<table border="1">
		<tr> <td> </td>  <td>A</td>        <td>B</td>        <td>C</td>        </tr>
		<tr> <td>1</td>  <td> </td>        <td> </td>        <td> </td>        </tr>
		<tr> <td>2</td>  <td> </td>        <td> </td>        <td> </td>        </tr>
		<tr> <td>3</td>  <td>機種名稱</td> <td>DB2052C</td>  <td> </td>        </tr>
		<tr> <td>4</td>  <td> </td>        <td> </td>        <td> </td>        </tr>
		<tr> <td>5</td>  <td>STATION </td> <td>IN QTY </td>  <td>OUT QTY </td> </tr>
		<tr> <td>6</td>  <td> </td>        <td> </td>  <td> </td> </tr>
		<tr> <td>7</td>  <td>D/L </td>     <td> 0</td>  <td>0 </td> </tr>
		<tr> <td>8</td>  <td> </td>        <td> </td>  <td> </td> </tr>
		<tr> <td>9</td>  <td>SDB </td>     <td> 0</td>  <td>0 </td> </tr>
	</table>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
