<!-- 20150422 Peggy,修正price抓法,加入四捨五入至小數位之參數-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,jxl.*,jxl.Workbook.*,jxl.write.*,jxl.format.*,java.lang.Math.*"%>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<%@ page import="DateBean" %> 
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSCE Distribution Price Upload</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	if (document.form1.FREIGHTTERM.value == null || document.form1.FREIGHTTERM.value == ""  || document.form1.FREIGHTTERM.value == "--")
	{
		alert("Please choose incoterms.");
		document.form1.FREIGHTTERM.focus();
		return false;
	}
	if (document.form1.CURRENCYCODE.value == null || document.form1.CURRENCYCODE.value == "" || document.form1.CURRENCYCODE.value == "--")
	{
		alert("Please choose currency.");
		document.form1.CURRENCYCODE.focus();
		return false;
	}
	if (document.form1.PRICETYPE.value == null || document.form1.PRICETYPE.value == "" || document.form1.PRICETYPE.value == "--")
	{
		alert("Please choose price type.");
		document.form1.PRICETYPE.focus();
		return false;
	}	
	if (document.form1.REVISIONNO.value == null || document.form1.REVISIONNO.value == "")
	{
		alert("Please entry revision.");
		document.form1.REVISIONNO.focus();
		return false;
	}	
	if (document.form1.VALIDFROM.value == null || document.form1.VALIDFROM.value == "")
	{
		alert("Please entry valid from.");
		document.form1.VALIDFROM.focus();
		return false;
	}	
	//if (document.form1.VALIDTO.value == null || document.form1.VALIDTO.value == "")
	//{
	//	alert("Please entry valid to.");
	//	document.form1.VALIDTO.focus();
	//	return false;
	//}
	if ((document.form1.VALIDTO.value != null && document.form1.VALIDTO.value != "") && eval(document.form1.VALIDFROM.value)>=eval(document.form1.VALIDTO.value))
	{
		alert("The valid to date must be granter than valid from date");
		document.form1.VALIDTO.focus();
		return false;	
	}	
	//if (document.form1.PRICEROUNDTO.value == null || document.form1.PRICEROUNDTO.value == "" || document.form1.PRICEROUNDTO.value == "--"||eval(document.form1.PRICEROUNDTO.value)<=0)
	//{
	//	alert("Please Input Price Round To");
	//	document.form1.PRICEROUNDTO.focus();
	//	return false;
	//}
	if (document.form1.UPLOADFILE.value == "")
	{
		alert("Please Choose Upload File");
		document.form1.UPLOADFILE.focus();
		return false;		
	}
	var filename = document.form1.UPLOADFILE.value;
	filename = filename.substr(filename.length-4);
	if (filename.toUpperCase() != ".XLS")
	{
		alert('上傳檔案必須為office 2003 excel檔!');
		document.form1.UPLOADFILE.focus();
		return false;	
	}
    document.form1.UPLOAD.disabled=true;
	//document.form1.action=URL+"?func=S"+"&FREIGHTTERM="+document.form1.FREIGHTTERM.value+"&CURRENCYCODE="+document.form1.CURRENCYCODE.value+"&PRICEROUNDTO="+document.form1.PRICEROUNDTO.value;
	document.form1.action=URL+"?func=S"+"&FREIGHTTERM="+document.form1.FREIGHTTERM.value+"&CURRENCYCODE="+document.form1.CURRENCYCODE.value+"&PRICETYPE="+document.form1.PRICETYPE.value+"&REVISIONNO="+document.form1.REVISIONNO.value+"&VALIDFROM="+document.form1.VALIDFROM.value+"&VALIDTO="+document.form1.VALIDTO.value;
	document.form1.submit(); 

}
</script>
</head>
<%
String strFunc =request.getParameter("func");
if (strFunc==null) strFunc="U";
String freightTerm=request.getParameter("FREIGHTTERM");
if (freightTerm==null) freightTerm="";
String currencyCode=request.getParameter("CURRENCYCODE");
if (currencyCode==null) currencyCode="";
String PRICETYPE=request.getParameter("PRICETYPE");
if (PRICETYPE==null) PRICETYPE="";
String REVISIONNO=request.getParameter("REVISIONNO");
if (REVISIONNO==null) REVISIONNO="";
String VALIDFROM=request.getParameter("VALIDFROM");
if (VALIDFROM==null) VALIDFROM="";
String VALIDTO=request.getParameter("VALIDTO");
if (VALIDTO==null) VALIDTO="";  
//String priceRoundTo=request.getParameter("PRICEROUNDTO");
//if (priceRoundTo==null) priceRoundTo="0";
  
int upload_cnt =0;
String errMsg="", sql="";
String sTscPartNo="", sPrice="",v_version_l="",v_version_p="",v_err_msg="";

if (strFunc.equals("S"))
{
	try
	{
		//檢查起訖日期
		sql = " SELECT DISTINCT 1 AS SEQ,VERSION_NO,TO_CHAR(START_DATE,'YYYYMMDD') START_DATE,TO_CHAR(END_DATE,'YYYYMMDD') END_DATE "+
		      " FROM TSCE_DISTRIBUTION_PRICE a WHERE FREIGHT_TERM=? AND CURRENCY_CODE=? AND PRICE_TYPE=? AND FLOOR(VERSION_NO)=FLOOR(?) AND VERSION_NO in (SELECT max(VERSION_NO) from TSCE_DISTRIBUTION_PRICE b WHERE FREIGHT_TERM=? AND CURRENCY_CODE=? AND PRICE_TYPE=? AND VERSION_NO <?)"+ 
              " UNION ALL"+
              " SELECT DISTINCT 2 AS SEQ,VERSION_NO,TO_CHAR(START_DATE,'YYYYMMDD') START_DATE,TO_CHAR(END_DATE,'YYYYMMDD') END_DATE "+
			  " FROM TSCE_DISTRIBUTION_PRICE a WHERE FREIGHT_TERM=? AND CURRENCY_CODE=? AND PRICE_TYPE=? AND FLOOR(VERSION_NO)=FLOOR(?) AND VERSION_NO in (SELECT max(VERSION_NO) from TSCE_DISTRIBUTION_PRICE b WHERE FREIGHT_TERM=? AND CURRENCY_CODE=? AND PRICE_TYPE=? AND VERSION_NO >?)"; 
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,freightTerm);
		statement.setString(2,currencyCode);
		statement.setString(3,PRICETYPE);
		statement.setString(4,REVISIONNO);
		statement.setString(5,freightTerm);
		statement.setString(6,currencyCode);
		statement.setString(7,PRICETYPE);
		statement.setString(8,REVISIONNO);
		statement.setString(9,freightTerm);
		statement.setString(10,currencyCode);
		statement.setString(11,PRICETYPE);
		statement.setString(12,REVISIONNO);
		statement.setString(13,freightTerm);
		statement.setString(14,currencyCode);
		statement.setString(15,PRICETYPE);
		statement.setString(16,REVISIONNO);		
		ResultSet rs=statement.executeQuery();
		while(rs.next())
		{
			if (rs.getInt(1)==1)
			{
				if (Long.parseLong(rs.getString(3))>=Long.parseLong(VALIDFROM))
				{
					v_err_msg=v_err_msg+"起始日"+VALIDFROM+"不可小於等於"+rs.getString(2)+"版的起始日"+rs.getString(3);
				}
				else
				{
					v_version_p=rs.getString(2);
				}
			}
			else if (rs.getInt(1)==2)
			{
				if (Long.parseLong(rs.getString(4))<=Long.parseLong(VALIDTO))
				{
					v_err_msg=v_err_msg+"結束日"+VALIDTO+"不可大於等於"+rs.getString(2)+"版的結束日"+rs.getString(3);
				}
				else
				{
					v_version_l=rs.getString(2);
				}			
			}	
		}
		rs.close();
		statement.close();
		if (!v_err_msg.equals(""))
		{
			throw new Exception(v_err_msg);
		}
	
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String sqld = "DELETE FROM TSCE_DISTRIBUTION_PRICE WHERE FREIGHT_TERM='"+freightTerm+"' AND CURRENCY_CODE='"+currencyCode+"' AND PRICE_TYPE='"+PRICETYPE+"' AND VERSION_NO="+REVISIONNO+" ";
      	PreparedStatement seqstmtd=con.prepareStatement(sqld);
      	seqstmtd.executeUpdate();
      	seqstmtd.close();

	  	String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D10-001-"+strDateTime+"-"+uploadFile_name;
	  	upload_file.saveAs(uploadFilePath); 
	  	InputStream is = new FileInputStream(uploadFilePath); 			
	  	jxl.Workbook wb = Workbook.getWorkbook(is);  

	  	//for (int j = 0; j < 1; j++)  //資料已合併成一個SHEET,modify by Peggy 20190123
	  	//{
			jxl.Sheet sht = wb.getSheet(0);
			for (int i = 3; i < sht.getRows(); i++) 
			{
				errMsg ="";
				//TSC PART NO
				jxl.Cell wcTscPartNo = sht.getCell(1, i);          
				sTscPartNo = (wcTscPartNo.getContents()).trim();
				if (sTscPartNo == null) sTscPartNo= "";

				//Price
				jxl.Cell wcPrice = sht.getCell(2, i);  //20210107 PRICE位置變動 by Peggy
				//modify by Peggy 20150422
				if (wcPrice.getType() == CellType.NUMBER) 
				{
					sPrice = ""+((NumberCell) wcPrice).getValue();
				} 
				else sPrice = (wcPrice.getContents()).trim();
				if (sPrice == null) sPrice = "0";
				//sPrice = (new java.math.BigDecimal(sPrice).setScale(Integer.parseInt(priceRoundTo), java.math.BigDecimal.ROUND_HALF_UP)).toString();
			
				if (sTscPartNo.equals(""))
				{
					errMsg += "TSC PART NO is blank<br>";
				}

				if (sPrice.equals(""))
				{
					if (PRICETYPE.toUpperCase().equals("BOOK PRICE"))
					{					
						errMsg += "Price is blank<br>";
					}
					else
					{
						continue;
					}
				}
				else if (Float.parseFloat(sPrice)<=0)  //add by Peggy 20150422
				{
					if (PRICETYPE.toUpperCase().equals("BOOK PRICE"))
					{				
						errMsg += "Price must be granter than zero<br>";
					}
					else
					{
						continue;
					}						
				}
				
			
				if (!sTscPartNo.equals("")) 
				{  // 20130930 Marvie Add : Blank can't insert
					upload_cnt ++;
					sql = " insert into TSCE_DISTRIBUTION_PRICE(freight_term, currency_code, tsc_part_no, price,version_no, price_type, start_date, end_date,created_by,creation_date,last_updated_by,last_update_date)"+
						  " VALUES (?,?,?,?,?,?,TO_DATE(?,'YYYYMMDD'),TO_DATE(?,'YYYYMMDD'),?,sysdate,?,sysdate)";
					//out.println(sql+"<BR>");
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1, freightTerm);  //Freight Term
					pstmt.setString(2, currencyCode); //Currency Code
					pstmt.setString(3, sTscPartNo);   //TSC Part No
					pstmt.setString(4, sPrice);       //Price
					pstmt.setString(5, REVISIONNO);   //version
					pstmt.setString(6, PRICETYPE);    //PRICE TYPE
					pstmt.setString(7, VALIDFROM);    //START DATE
					pstmt.setString(8, VALIDTO);      //END DATE
					pstmt.setString(9, UserName);     //created_by
					pstmt.setString(10, UserName);    //last_updated_by
					pstmt.executeQuery();
					pstmt.close();
				}
			}
	  	//}
		if (upload_cnt>0)
		{
			if (!v_version_p.equals(""))
			{
				sql = " update TSCE_DISTRIBUTION_PRICE "+
				      " set end_date=to_date(?,'yyyymmdd')-1"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  " where version_no=?"+
					  " and freight_term=?"+
					  " and currency_code=?"+
					  " and price_type=?";
					//out.println(sql+"<BR>");
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1, VALIDFROM);    //START DATE
				pstmt.setString(2, UserName);    //last_updated_by
				pstmt.setString(3, v_version_p);   //version
				pstmt.setString(4, freightTerm);  //Freight Term
				pstmt.setString(5, currencyCode); //Currency Code
				pstmt.setString(6, PRICETYPE);    //PRICE TYPE
				pstmt.executeQuery();
				pstmt.close();			
			}
			if (!v_version_l.equals(""))
			{
				sql = " update TSCE_DISTRIBUTION_PRICE "+
				      " set start_date=to_date(?,'yyyymmdd')+1"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  " where version_no=?"+
					  " and freight_term=?"+
					  " and currency_code=?"+
					  " and price_type=?";
				//out.println(sql+"<BR>");
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1, VALIDTO);    //END DATE
				pstmt.setString(2, UserName);    //last_updated_by
				pstmt.setString(3, v_version_l);   //version
				pstmt.setString(4, freightTerm);  //Freight Term
				pstmt.setString(5, currencyCode); //Currency Code
				pstmt.setString(6, PRICETYPE);    //PRICE TYPE
				pstmt.executeQuery();
				pstmt.close();				
			}
		}
	  	con.commit();
	  	out.println("<font color='#0000ff'>Upload Record : "+upload_cnt+"<font><BR>");
	}
	catch(Exception e)
	{
		con.rollback();
	    String sMsg = e.getMessage();
		out.println("<font color='#ff0000'>Exception10:"+sMsg+"</font><BR>");
		if (sMsg.indexOf("ORA-00001") == 0) 
		{
			out.println("Data Duplicate.  Freight Term="+freightTerm+"  Price Type="+PRICETYPE+"  Currency Code="+currencyCode+ "   TSC Part No.="+sTscPartNo+"<BR>");
		}
	}
}
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<BR><HR>
  <strong><font color="#004080" size="4" face="Arial">TSCE Distribution Price Upload</font></strong> 

  <table width="80%" border="1">
	<tr>
		<td width="15%" style="color:#004080;font-family:arial;font-size:14px"><div align="right"><strong>Incoterms: </strong></div></td>
		<td width="85%" style="color:#333333;font-family:arial;font-size:14px">
  	<%
	try
    {   
		Statement statement=con.createStatement();
	   	ResultSet rs=null;	
	   	String sqlOrgInf = "SELECT a.a_value,a.a_eng_value  FROM oraddman.tsc_rfq_setup a  WHERE A_CODE ='TSCE_DISTRIBUTION_INCOTERM' ORDER BY A_SEQ ";   
	   	//out.println(sqlOrgInf);				      
	   	rs=statement.executeQuery(sqlOrgInf);
	   	comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(freightTerm);
	   	comboBoxBean.setFieldName("FREIGHTTERM");	   
	   	out.println(comboBoxBean.getRsString());
				   	  		  
		rs.close();   
		statement.close();     	 
	} //end of try		 
    catch (Exception e) 
	{
		out.println("Exception20:"+e.getMessage()); 
	} 
   	%>
		</td>
	</tr>

	<tr>
		<td width="15%" style="color:#004080;font-family:arial;font-size:14px"><div align="right"><strong>Currency: </strong></div></td>
		<td width="85%" style="color:#333333;font-family:arial;font-size:14px">
  	<%
	try
  	{   
  		Statement statement=con.createStatement();
        ResultSet rs=null;	
		String sqlOrgInf = "SELECT a.a_value,a.a_eng_value  FROM oraddman.tsc_rfq_setup a  WHERE A_CODE ='TSCE_DISTRIBUTION_CURRENCY' ORDER BY A_SEQ";   
	   	//out.println(sqlOrgInf);				      
	   	rs=statement.executeQuery(sqlOrgInf);
	   	comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(currencyCode);
	   	comboBoxBean.setFieldName("CURRENCYCODE");	   
	   	out.println(comboBoxBean.getRsString());
				   	  		  
		rs.close();   
		statement.close();     	 
	} //end of try		 
    catch (Exception e) 
	{
		out.println("Exception21:"+e.getMessage()); 
	} 
   	%>
		</td>
	</tr>

	<tr>
		<td width="15%" style="color:#004080;font-family:arial;font-size:14px"><div align="right"><strong>Price Type: </strong></div></td>
		<td width="85%" style="color:#333333;font-family:arial;font-size:14px">
  <%
	try
    {   
		Statement statement=con.createStatement();
	   	ResultSet rs=null;	
	   	String sqlOrgInf = "SELECT a.a_value,a.a_eng_value  FROM oraddman.tsc_rfq_setup a  WHERE A_CODE ='TSCE_DISTRIBUTION_PRICE_TYPE' ORDER BY A_SEQ ";   
	   	//out.println(sqlOrgInf);				      
	   	rs=statement.executeQuery(sqlOrgInf);
	   	comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(PRICETYPE);
	   	comboBoxBean.setFieldName("PRICETYPE");	   
	   	out.println(comboBoxBean.getRsString());
				   	  		  
		rs.close();   
		statement.close();     	 
	} //end of try		 
    catch (Exception e) 
	{
		out.println("Exception20:"+e.getMessage()); 
	} 
    %>
		</td>
	</tr>
	<tr>
		<td width="15%" style="color:#004080;font-family:arial;font-size:14px"><div align="right"><strong>Revision: </strong></div></td>
		<td width="85%" style="color:#333333;font-family:arial;font-size:14px"><input type="TEXT" NAME="REVISIONNO" value="<%=REVISIONNO%>"  style="font-family: Tahoma,Georgia;text-align:RIGHT" size="7" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)">
		</td>
	</tr>	
	<tr>
		<td width="15%" style="color:#004080;font-family:arial;font-size:14px"><div align="right"><strong>Valid Date: </strong></div></td>
		<td width="85%" style="color:#333333;font-family:arial;font-size:14px">
		From:<input type="TEXT" name="VALIDFROM" value="<%=VALIDFROM%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.VALIDFROM);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>&nbsp;
		To:<input type="TEXT" name="VALIDTO" value="<%=VALIDTO%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.VALIDFROM);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
	</tr>	
	<!--<tr>
		<td width="15%" style="color:#004080;font-family:arial;font-size:14px"><div align="right"><strong>Price Round To: </strong></div></td>
		<td width="85%" style="color:#333333;font-family:arial;font-size:14px"><input TYPE="text" name="PRICEROUNDTO" value="C1" size="4" maxlength="4" style="font-family:Arial;font-size:14px" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
	</tr>-->

    <tr> 
      <td width="15%"><div align="right"><font color="#004080" face="Arial"><strong>File: </strong></font></div></td>
      <td width="85%"><font size="2">
        <INPUT TYPE="FILE" NAME="UPLOADFILE" size="70">
		<INPUT TYPE="button" NAME="UPLOAD" value="UPLOAD" onClick="setSubmit('../jsp/TSCESalesDistributionPriceUpload.jsp')">
      </font></td>
    </tr>
  </table> 
<p><font color="#000099">1.上傳的Excel檔案, 請勿開啟。<br>
   2.上傳EXCEL檔案請依以下格式, 第三列為標題列, 實際資料由第四列填起。<br>
   3.欄位依序排列好位置要正確, 否則會抓錯資料。<br>
   4.請確認TSC PART NO.(B欄)及Price(C欄)欄位資料正確, 只上傳此兩個欄位。<br>
   5.範例格式如下所示:</font><br>
   <br>
  <img src="images/TSCEDistributionPrice.jpg" ></p>


<p>&nbsp;</p>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
