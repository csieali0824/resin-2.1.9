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
<title>upload file - Top 3 Defect</title>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/DMTop3DefectFileUploadInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">

<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>  
<strong><font color="#004080" size="4">Top3 Defect File Upload</font></strong>
<table width="70%" border="1">
    <tr> 
		<td width="27%">   </td>
		<td width="23%"><div align="right"><font color="#004080"><strong>      Upload FILE</strong></font></div></td>
		<td width="50%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE"></font>
		</td>
    </tr>
	<tr>
			<td width="27%">選擇更新年/月</td>
			
			<td width="23%" ><font color="#333399" face="Arial Black"><strong>Year</strong></font> 
				<%
					
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
					
				%>
			</td>	
			
			<td  > <font color="#330099" face="Arial Black"><strong>Month</strong></font> 
				<%
					
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
					
				%> 
			</td>	
	
	
	</tr>
	
	
  </table>  
  <p>
    <input name="submit" type="submit" value="UPLOAD">
</p>
  <P>轉入EXCEL檔案請依以下格式, 並將要轉入之Work Sheet置於第一個位置, 如果同一檔案有多個Work Sheet</P>
  <table border="1" >
	  <tr bgcolor="#66CCFF">
		  <td>DATE(MM/DD)</td>    <td>LINE</td>    <td>MODEL</td>   <td>STATION</td>   <td>Defect Qty</td>   <td>Defect Rate</td>
		  <td>不良現象</td>   <td>原因分析</td>    <td>短期對策</td>    <td>PIC</td>  <td>STATUS</td>
	  </tr>

	  <tr>
		  <td>7/1</td>    <td>FPCBA</td>    <td>2054</td>   <td>FPCB</td>   <td>999</td>   <td>99.99%</td>
		  <td>No Display</td>   <td>J302 短路</td>    <td>注意此料的吃焊狀況,IPQC將持續追縱</td>    <td>PD 王貞慧</td>  <td>On Going</td>
	  </tr>

  </table>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
