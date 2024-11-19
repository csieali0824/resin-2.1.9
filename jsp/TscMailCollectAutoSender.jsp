<!-- 20141216 Peggy,客戶滿意度調查表mail cc給sales-->
<!-- 20150629 Peggy,問卷調查email密件副本加natalie_lin-->
<!-- 20180628 Peggy,add new column =customer group-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,javax.mail.*,javax.mail.internet.*"%>
<%@ page import="java.io.*,DateBean,ArrayComboBoxBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean" %> 
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	if (document.form1.SYEAR.value == null || document.form1.SYEAR.value == "")
	{
		alert("請輸入調查年度!");
		document.form1.SYEAR.focus();
		return false;
	}
	if (document.form1.CURRMONTH.value == null || document.form1.CURRMONTH.value == "" || document.form1.CURRMONTH.value == "--")
	{
		alert("請輸入調查月份!");
		document.form1.CURRMONTH.focus();
		return false;
	}
	var C_TYPE = "";
	var radioLength = document.form1.resubmit.length;
	for(var i = 0; i < radioLength; i++) 
	{
		if ( document.form1.resubmit[i].checked)
		{
			C_TYPE = document.form1.resubmit[i].value;
		}
	}
	if (C_TYPE=="")
	{
		alert("請輸入調查類型!");
		return false;
	}
		
	if (C_TYPE!="R")
	{
		if (C_TYPE=="S" && (document.form1.deadline.value == null || document.form1.deadline.value == "" || document.form1.deadline.value == "--"))
		{
			alert("請輸入調查截止日!");
			document.form1.deadline.focus();
			return false;
		}
		if (document.form1.UPLOADFILE.value == "")
		{
			alert("請選擇上傳檔案!");
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
	}
	URL=URL+"?func="+C_TYPE;
    document.form1.UPLOAD.disabled=true;
	document.form1.action=URL+"&SYEAR="+document.form1.SYEAR.value+"&CURRMONTH="+document.form1.CURRMONTH.value+"&DEADLINE="+document.form1.deadline.value;
	document.form1.submit(); 

}
</script>
</head>
<%
String strFunc =request.getParameter("func");
if (strFunc==null) strFunc="U";
String strYear = request.getParameter("SYEAR");
if (strYear==null) strYear="";
String strMonth = request.getParameter("CURRMONTH");
if (strMonth==null) strMonth = "";
String deadline = request.getParameter("DEADLINE");
if (deadline==null) deadline="";   //add by Peggy 20130125
String color1="#FFCC33",color2="#FFFFCC",fontcolor1="#000",fontcolor2="#666",tb1="",tb2="",f1="",f2="",strBatchID="",errMsg ="";
String keycode="",id= "", name= "", email= "", title= "", department= "", telephone= "", fax= "", company= "", region= "",terrority = "",status="",dealline_date="";
int upload_cnt =0;
String httl="",sql ="",sName = "",sEmail="",sDept="",sTitle="",sCompany="",sTele="",sFax="",sRegion="",sTerrority,sLanguage="",sales="",salesManager="",hqSales="",	sales_email = "",manager_email="",hq_email ="",custGroup="";
String reqURL = request.getRequestURL().toString();
if (reqURL != null) reqURL = reqURL.substring(0,reqURL.lastIndexOf("/")+1);

if (strFunc.equals("U"))
{
	tb1=color1;tb2=color2;f1=fontcolor1;f2=fontcolor2;
}
else
{
	tb1=color2;tb2=color1;f1=fontcolor2;f2=fontcolor1;
}

if (strFunc.equals("S") || strFunc.equals("X"))
{
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	String strDate=dateBean.getYearMonthDay();
	String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	String uploadFile_name=upload_file.getFileName();
	strBatchID =strYear+strMonth+"-"+dateBean.getMonthString()+dateBean.getDayString()+dateBean.getHourMinute();
	try
	{
		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D6001("+strYear+")"+strDateTime+"-"+uploadFile_name;
		upload_file.saveAs(uploadFilePath); 
		java.util.Date datetime = new java.util.Date();
		SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
		String CreationDate = (String) formatter.format( datetime );
		int icnt=0;
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		for (int i = 1; i <sht.getRows(); i++) 
		{
			errMsg ="";
			//NAME
			jxl.Cell wcName = sht.getCell(0, i);          
			sName = (wcName.getContents()).trim();
			if (sName == null) sName= "";
		
			//EMAIL
			jxl.Cell wcEMail = sht.getCell(1, i);          
			sEmail = (wcEMail.getContents()).trim();
			if (sEmail  == null) sEmail = "";
		
			//DEPARTMENT
			jxl.Cell wcDEPT = sht.getCell(2, i);  
			sDept = (wcDEPT.getContents()).trim();
			if (sDept == null) sDept="";
		

			//TITLE
			jxl.Cell wcTitle = sht.getCell(3, i);  
			sTitle = (wcTitle.getContents()).trim();
			if (sTitle == null) sTitle="";
		
			//COMPANY
			jxl.Cell wcCompany = sht.getCell(4, i);           
			sCompany = (wcCompany.getContents()).trim();
			if (sCompany == null) sCompany = "";
			
			//TELEPHONE
			jxl.Cell wcTele = sht.getCell(5, i);           
			sTele = (wcTele.getContents()).trim();
			if (sTele == null) sTele = "";

			//FAX
			jxl.Cell wcFax = sht.getCell(6, i);           
			sFax = (wcFax.getContents()).trim();
			if (sFax == null) sFax = "";

			//REGION
			jxl.Cell wcRegion = sht.getCell(7, i);           
			sRegion = (wcRegion.getContents()).trim();
			if (sRegion == null) sRegion = "";
			
			//TERRORITY
			jxl.Cell wcTerrority = sht.getCell(8, i);           
			sTerrority = (wcTerrority.getContents()).trim();
			if (sTerrority == null) sTerrority = "";
			
			//LANGUAGE
			jxl.Cell wcLanguage = sht.getCell(9, i);           
			sLanguage = (wcLanguage.getContents()).trim().toUpperCase();
			if (sLanguage == null) sLanguage = "";
			
			//SALES
			jxl.Cell wcSales = sht.getCell(10, i);           
			sales = (wcSales.getContents()).trim();
			if (sales == null) sales = "";
			
			//SALES MANAGER
			jxl.Cell wcSalesManager = sht.getCell(11, i);           
			salesManager= (wcSalesManager.getContents()).trim();
			if (salesManager == null) salesManager = "";
			
			//HQ CONTACT SALES
			jxl.Cell wcHQSales = sht.getCell(12, i);           
			hqSales= (wcHQSales.getContents()).trim();
			if (hqSales == null) hqSales = "";
			hqSales = hqSales.replace(";",","); //add by Peggy 20130110
			
			//CUSTOMER GROUP,add by Peggy 20180628
			jxl.Cell wcCustGroup = sht.getCell(13, i);           
			custGroup= (wcCustGroup.getContents()).trim();
			if (custGroup == null) custGroup = "";
						
			if (sName.equals(""))
			{
				errMsg += "Name不可空白<br>";
			}
			if (sEmail.equals(""))
			{
				errMsg += "Email不可空白<br>";
			}
			else if (sEmail.indexOf("@") <0)
			{
				errMsg += "Email錯誤<br>";
			}
			if (sCompany.equals(""))
			{
				errMsg += "Company不可空白<br>";
			}
			if (sTerrority.equals(""))
			{
				errMsg += "Terrority不可空白<br>";
			}
			if (sLanguage.equals(""))
			{
				errMsg += "Language不可空白<br>";
			}
			else if (!sLanguage.equals("KOREAN") && !sLanguage.equals("JAPANESE")  && !sLanguage.equals("TRADITIONAL CHINESE") && !sLanguage.equals("SIMPLIFIED CHINESE") && !sLanguage.equals("ENGLISH"))
			{
				errMsg += "Language錯誤<br>";
			}
			//if (sales.equals(""))
			//{
			//	errMsg += "Sales email不可空白<br>";
			//}
			if (!sales.equals("") && sales.indexOf("@") <0)
			{
				errMsg += "Sales email錯誤<br>";
			}
			
			//if (salesManager.equals(""))
			//{
			//	errMsg += "Sales manager email不可空白<br>";
			//}
			if (!salesManager.equals("") && salesManager.indexOf("@") <0)
			{
				errMsg += "Sales manager email錯誤<br>";
			}
			//if (hqSales.equals(""))
			//{
			//	errMsg += "HQ contact sales email不可空白<br>";
			//}
			if (!hqSales.equals("") && hqSales.indexOf("@") <0)
			{
				errMsg += "HQ contact sales email錯誤<br>";
			}
			if (sales.equals("") && salesManager.equals("") && hqSales.equals(""))
			{
				errMsg += "email至少填入一個<br>";
			}
			
			if (!sName.equals("") && !sEmail.equals(""))
			{
				sql = " select batch_mailed from oraddman.cust_mail where EMAIL ='" + sEmail +"' and YEAR= '" + strYear + "' and  BIANNUAL_CODE ='" + strMonth + "' and active_flag ='Y'";
				//out.println(sql);
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(sql);
				if (!rs.next())
				{
					upload_cnt ++;
					sql = " insert into oraddman.cust_mail(id, name, email, department, title, company,telephone, fax, region, active_flag, terrority,creation_date, batch_mailed, language_version,sales_email, sales_manager_email, hq_sales_email,YEAR, BIANNUAL_CODE,DEADLINE,ERR_MESSAGE,CUSTOMER_GROUP)"+
						  " SELECT NVL((select id from (select id, ROW_NUMBER() OVER (partition by a.email order by a.creation_date desc) rownumber FROM oraddman.cust_mail a where email='"+sEmail+"') a"+
                          " where rownumber=1),(select max(to_number(b.id))+1 from oraddman.cust_mail b)),?,?,?,?,?,?,?,?,?,?,to_char(sysdate,'yyyymmddhh24miss'),'N_"+strBatchID+"',?,?,?,?,?,?,?,?,? FROM DUAL";
					//out.println(sql+"<BR>");
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1, sName);        //姓名
					pstmt.setString(2, sEmail);       //email
					pstmt.setString(3, sDept);        //部門
					pstmt.setString(4, sTitle);       //抬頭
					pstmt.setString(5, sCompany);     //公司名稱
					pstmt.setString(6, sTele);        //電話
					pstmt.setString(7, sFax);         //傳真
					pstmt.setString(8, sRegion);      //區域
					pstmt.setString(9, (errMsg.length()>0?"N":"Y"));  //是否生效
					pstmt.setString(10,sTerrority);   //國別
					pstmt.setString(11,sLanguage);    //語言 
					pstmt.setString(12,sales);        //sales email
					pstmt.setString(13,salesManager); //sales manager email
					pstmt.setString(14,hqSales);      //hq contact sales email
					pstmt.setString(15,strYear);
					pstmt.setString(16,strMonth);
					pstmt.setString(17,deadline);     //調查截止日,add by Peggy 20130125
					pstmt.setString(18,errMsg);    
					pstmt.setString(19,custGroup);    //customer group,add by Peggy 20180628
					pstmt.executeUpdate();
					pstmt.close();
				}
				else
				{
					if (strFunc.equals("X") || rs.getString("batch_mailed").startsWith("N_"))
					{
						sql = " update  oraddman.cust_mail set batch_mailed = ?,NAME=?,customer_group=?,deadline=nvl(?,deadline)"+
							  " where EMAIL ='" + sEmail +"' and YEAR= '" + strYear + "' and  BIANNUAL_CODE ='" + strMonth + "' and active_flag ='Y' and batch_mailed ='" + rs.getString("batch_mailed")+"'";
						//out.println(sql+"<BR>");
						//out.println(sql);
						PreparedStatement pstmt=con.prepareStatement(sql);
						pstmt.setString(1, "N_"+strBatchID);  //batch id
						pstmt.setString(2, sName);  //add by Peggy 20140113
						pstmt.setString(3, custGroup);  //customer group,add by Peggy 20180628
						pstmt.setString(4, deadline);  //deadline,add by Peggy 20190220
						pstmt.executeUpdate();
						pstmt.close();
					}
				}
				rs.close();
				st.close();
			}
		}
		if (strFunc.equals("S"))
		{
			CallableStatement cs3 = con.prepareCall("{call TSC_CUST_QUESTIONNAIRE_TRACING.CREATE_JOB(?)}");
			cs3.setString(1,strYear+strMonth); 
			cs3.execute();
			cs3.close();
		}
	}
	catch(Exception e)
	{
		out.println("Exception1:"+e.getMessage());
	}
}
%>
<body>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<table width="900" border="0" align="center" cellpadding="1" cellspacing="0" bordercolor="#FFCC00" bgcolor="#FFFFFF" frame="below">
	<tr><td colspan="2" width="30%" height="60"><img src="images/TS_LOGO.jpg" width="158" height="48"></td><td width="70%" style="vertical-align:middle;font-size:32px;font-family:'新細明體'">顧 客 滿 意 度 調 查</td></tr>
	<tr><td colspan="3">
		<table width="100%" border="1" bordercolor="<%=color1%>" cellspacing="0">
		<tr><td width="15%" style="border:none;text-align:center;font-size:14px;background-color:<%=tb1%>"><% if (strFunc.equals("U")) out.println("名單上傳及寄送"); else out.println("<a style='COLOR: #000; TEXT-DECORATION: none' href='/oradds/jsp/TscMailCollectAutoSender.jsp?func=U'>名單上傳及寄送</a>");%></td>
	        <!--<td width="15%" style="border:none;text-align:center;font-size:14px;background-color:<%=tb2%>"><% if (strFunc.equals("S")) out.println("調查年度設定"); else out.println("<a style='COLOR: #666; TEXT-DECORATION: none' href='/oradds/jsp/TscMailCollectAutoSender.jsp?func=S'>調查年度設定</a>");%></td>-->
		    <td width="85%" style="border:none;text-align:right;font-size:14px"><A style="TEXT-DECORATION: none" HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A></td>
		</tr>
		</table>
		</td>
	</tr>
	<tr><td height="5" colspan="3" style="background-color:<%=color1%>"></td></tr>
	<tr><td colspan="3">&nbsp;</td></tr>
	<%
	if (strFunc.equals("U") || strFunc.equals("S") || strFunc.equals("R") || strFunc.equals("X"))
	{	
	%>
	<tr><td colspan="3">
		<table width="100%" border="1" bordercolor="#FFFFFF" cellspacing="1" cellpadding="0" bgcolor="#D2ECFB">
			<tr><td width="15%" style="color:#000000;font-family:arial;font-size:14px">調查年度：</td><td width="85%" style="color:#333333;font-family:arial;font-size:14px"><input TYPE="text" name="SYEAR" value="<%=strYear%>" size="4" maxlength="4" style="font-family:Arial;font-size:14px">
  <%
			try
			{       
				int  j =0; 
				String b[]= new String[4];
				for (int i =3;i <= 12;i=i+3)
				{
					if (i <10)	b[j++] = "0"+i;
					else b[j++] = ""+i;		
				}
				arrayComboBoxBean.setArrayString(b);
				if (strMonth!=null)
				{
					arrayComboBoxBean.setSelection(strMonth);
				}
				arrayComboBoxBean.setFieldName("CURRMONTH");	
				arrayComboBoxBean.setFontSize(14);  
				out.println(arrayComboBoxBean.getArrayString());		      		 
			}
			catch (Exception e)
			{
				out.println("Exception21:"+e.getMessage());
			}
   %>
			</td></tr>
			<tr><td width="15%" style="color:#000000;font-family:arial;font-size:14px">調查截止日：</td><td width="85%" style="color:#333333;font-family:arial;font-size:14px"><input type="text" name="deadline" size="8" value="<%=deadline%>" style="font-family:Arial;font-size:14px" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.deadline);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td></tr>
			<tr><td width="15%" style="color:#000000;font-family:arial;font-size:14px">調查類型</td><td td width="85%" style="color:#333333;font-family:arial;font-size:14px"><input type="radio" name="resubmit" VALUE="S" checked="checked">年度問卷調查<br><input type="radio" name="resubmit" VALUE="R">針對尚未回覆之客戶,重新發送問卷<br><input type="radio" name="resubmit" VALUE="X">針對特定客戶,重新發送問卷</td>
			<tr><td width="15%" style="color:#000000;font-family:arial;font-size:14px">資料來源：</td><td width="85%" style="color:#333333;font-family:arial;font-size:14px"><INPUT TYPE="FILE" NAME="UPLOADFILE" size="90" style="font-family:Arial;font-size:14px"></td></tr>
			<tr><td width="15%" style="color:#000000;font-family:arial;font-size:14px">範本下載：</td><td width="85%" style="color:#333333;font-family:arial;font-size:14px" ><A HREF="/oradds/jsp/samplefiles/D6-001_SampleFile.xls">Download Sample File</A></td></tr>
			<tr><td width="100%" colspan="2" style="text-align:center;color:#333333;font-family:arial;font-size:14px"><input type="button" name="UPLOAD" value="名單上傳及發送" onClick="setSubmit('../jsp/TscMailCollectAutoSender.jsp')"></td></tr>
		</table>
	</td>
	</tr>

	<%
		if (strFunc.equals("S") || strFunc.equals("R")  || strFunc.equals("X"))
		{
			if (strFunc.equals("S"))
			{
				out.println("<tr><td colspan='3' style='font-family:arial;font-size:14px;color:#0000ff'>上傳成功筆數: "+upload_cnt+" 筆</td></tr>");
			}
			if (upload_cnt>0 || strFunc.equals("R") || strFunc.equals("X"))
			{
	%>
	<tr><td colspan="3">
		<table width="100%" border="1" bordercolor="#99CCFF" cellpadding="1" cellspacing="0">
			<tr bgcolor="#99CCFF">
			<td width="3%" style="font-family:arial;font-size:12px">SEQ</td>
			<td width="5%" style="font-family:arial;font-size:12px">ID</td>
			<td width="28%" style="font-family:arial;font-size:12px">Company Name</td>
			<td width="19%" style="font-family:arial;font-size:12px">Name</td>
			<td width="15%" style="font-family:arial;font-size:12px">E-Mail</td>
			<td width="10%" style="font-family:arial;font-size:12px">Region</td>
			<td width="10%" style="font-family:arial;font-size:12px">Territory</td>
			<td width="10%" style="font-family:arial;font-size:12px">Status</td>
			</tr>
	<%	
			}
			try
			{ 
				if (strFunc.equals("R"))
				{
					//sql = " select ACTIVE_FLAG,ROWID,ID,NAME,EMAIL,TITLE,DEPARTMENT,TELEPHONE,FAX,COMPANY,REGION,TERRORITY,SALES_EMAIL,SALES_MANAGER_EMAIL,HQ_SALES_EMAIL,ERR_MESSAGE,DEADLINE "+
					sql = " select ACTIVE_FLAG,ROWID,ID,NAME,EMAIL,TITLE,DEPARTMENT,TELEPHONE,FAX,COMPANY,REGION,TERRORITY,SALES_EMAIL,SALES_MANAGER_EMAIL,HQ_SALES_EMAIL,ERR_MESSAGE,nvl('"+deadline+"',DEADLINE) DEADLINE "+
                          " from ORADDMAN.CUST_MAIL a  "+
						  " where email is not null "+
                          " and YEAR='"+strYear+"'  and BIANNUAL_CODE='"+strMonth+"' and ACTIVE_FLAG='Y'"+
						  " and BATCH_MAILED like 'Y%'"+ //add by Peggy 20220217
						  //" and id in (1286,1274,282 ,1285,1143,1211)"+
                          " and not exists (select 1 from oraddman.cust_collect_questionnaire b where b.YEAR=a.YEAR and b.BIANNUAL_CODE=a.BIANNUAL_CODE"+
                          " AND b.ORIG_ROWID =a.rowid)  ORDER BY TERRORITY,to_number(id) ";
					//out.println(sql);
				}
				else
				{
					//sql = " select ACTIVE_FLAG,ROWID,ID,NAME,EMAIL,TITLE,DEPARTMENT,TELEPHONE,FAX,COMPANY,REGION,TERRORITY,SALES_EMAIL,SALES_MANAGER_EMAIL,HQ_SALES_EMAIL,ERR_MESSAGE,DEADLINE "+
					sql = " select ACTIVE_FLAG,ROWID,ID,NAME,EMAIL,TITLE,DEPARTMENT,TELEPHONE,FAX,COMPANY,REGION,TERRORITY,SALES_EMAIL,SALES_MANAGER_EMAIL,HQ_SALES_EMAIL,ERR_MESSAGE,nvl('"+deadline+"',DEADLINE) DEADLINE "+
						  " from ORADDMAN.CUST_MAIL where email is not null  and batch_mailed like '%_"+strBatchID+"%' ORDER BY to_number(id) "; // 全部的 id
				}
				//out.println(sql);
				Statement st = con.createStatement();
				ResultSet rs = st.executeQuery(sql);
				int seq=0;
				while(rs.next())
				{
					//add by Peggy 20190220
					if (strFunc.equals("R"))
					{
						sql = " update  oraddman.cust_mail set deadline=nvl(?,deadline)"+
							  " where rowid='"+rs.getString("rowid")+"'";
						//out.println(sql+"<BR>");
						//out.println(sql);
						PreparedStatement pstmtx=con.prepareStatement(sql);
						pstmtx.setString(1, deadline); 
						pstmtx.executeUpdate();
						pstmtx.close();
					}
									
					seq++;
					keycode=rs.getString("ROWID");
					id= rs.getString("ID");
					name= rs.getString("NAME");
					email= rs.getString("EMAIL");
					title= rs.getString("TITLE");
					if (title == null) title = "";
					department= rs.getString("DEPARTMENT");
					if (department == null) department = "";
					telephone= rs.getString("TELEPHONE");
					if (telephone==null) telephone = "";
					fax= rs.getString("FAX");
					if (fax == null) fax = "";
					company= rs.getString("COMPANY");
					if (company == null) company = "";
					region = rs.getString("REGION");
					if (region == null) region ="";
					terrority = rs.getString("TERRORITY");
					if (terrority == null) terrority="";
					status=rs.getString("ERR_MESSAGE");
					sales_email = rs.getString("SALES_EMAIL");
					manager_email = rs.getString("SALES_MANAGER_EMAIL");
					hq_email =rs.getString("HQ_SALES_EMAIL");
					dealline_date =rs.getString("DEADLINE");  //add by Peggy 20130125
					dealline_date = dealline_date.substring(0,4)+"/"+dealline_date.substring(4,6)+"/"+dealline_date.substring(6,8);
					
					if (rs.getString("ACTIVE_FLAG").equals("Y"))
					{
						if (reqURL.toLowerCase().indexOf("tsrfq.") <0 && reqURL.toLowerCase().indexOf("rfq134.") <0) //測試環境
						{
							email ="peggy_chen@ts.com.tw";
						}
						%>
							<%@ include file="/jsp/TscMailQuestBody.jsp"%>
						<%
						  // 夾帶問卷調查表表身,並帶入上一次相同人員的答覆_迄
						Properties props = System.getProperties();
						props.put("mail.transport.protocol","smtp");
						props.put("mail.smtp.host", "mail.ts.com.tw");
						props.put("mail.smtp.port", "25");
					
						Session s = Session.getInstance(props, null);
						javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
						javax.mail.internet.InternetAddress from = new javax.mail.internet.InternetAddress("salescss@ts.com.tw");
						javax.mail.internet.InternetAddress to=new javax.mail.internet.InternetAddress(email);
						javax.mail.internet.InternetAddress bcc=new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw");

						message.setSentDate(new java.util.Date());
						message.setFrom(from);
						message.addRecipient(Message.RecipientType.TO, to);
						//add by Peggy 20141216
						if (reqURL.toLowerCase().indexOf("tsrfq.") >=0 || reqURL.toLowerCase().indexOf("rfq134.")>=0) //正式環境
						{
							String mail_cc_list [] = (sales_email.replace(";",",")).split(",");
							for (int m = 0 ; m < mail_cc_list.length ; m++)
							{
								message.addRecipient(Message.RecipientType.CC, new javax.mail.internet.InternetAddress(mail_cc_list[m].trim()));
							}	
							message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("claire.chen@ts.com.tw"));  //add by Peggy 20171228
						}					
						message.addRecipient(Message.RecipientType.BCC, bcc);
						
						message.setSubject("====== Taiwan Semi Customer Questionnaire(Deadline:"+dealline_date+")======");
						message.setContent(httl,"text/html;charset=UTF-8");
						Transport.send(message);
	
						if (strFunc.equals("S") || strFunc.equals("X"))
						{
							String sqlUp =" update ORADDMAN.cust_mail set batch_mailed = 'Y_"+strBatchID+"'"+
										  " where id = '"+id+"' and batch_mailed ='N_"+strBatchID+"'";	
							PreparedStatement stUp = con.prepareStatement(sqlUp);				
							stUp.execute();		               
							stUp.close();
						}
						
						status="Mailed";
					}
					out.println("<tr>");
					out.println("<td style='font-family:arial;font-size:12px'>"+seq+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+id+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+company+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+name+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+email+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+((region==null || region.equals(""))?"&nbsp;":region)+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+terrority+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+status+"</td>");
					out.println("</tr>");  
				}
				rs.close();
				st.close();
			}
			catch(MessagingException e)
			{ 
				out.println(e.toString()); 
			}
	%>
		</table></td></tr>
	<%
		}
	}
	%>
</table>
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
 