<!-- modify by Peggy 20150305,增加年度條件及是否清除該年度所有DC資料-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 

<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<body>
<FORM NAME="MYFORMD" METHOD="post">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<%
String DC_YEAR = request.getParameter("DC_YEAR");
if (DC_YEAR==null) DC_YEAR="";
//out.println("DC_YEAR="+DC_YEAR);
String DEL_FLAG = request.getParameter("DEL_FLAG");
if (DEL_FLAG==null) DEL_FLAG="N";
//out.println("DEL_FLAG="+DEL_FLAG);
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
//out.println("Step1");
com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
upload_file.saveAs("d:/resin-2.1.9/webapps/oradds/report/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="d:/resin-2.1.9/webapps/oradds/report/"+request.getRemoteAddr()+"-"+upload_file.getFileName();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
			 
/*  For Excel View  */         
// 取得上傳Excel報表
InputStream is = new FileInputStream("d:/resin-2.1.9/webapps/oradds/report/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 			
jxl.Workbook wb = Workbook.getWorkbook(is);                
jxl.Sheet sht = wb.getSheet(0);   //20100428 liling 改 取第一個工作表
int rowCount = sht.getRows();  // 取此次筆數 
out.println("<br>");
out.println("<div id='div1'>上傳筆數:"+(rowCount-1)+"</div>");
out.println("<table width='60%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' color='#FFFFFF'>no.</font></td><td><font size='2' color='#FFFFFF'>TSC_PACKAGE</font></td><td><font size='2' color='#FFFFFF'>TSC_MAKEBUY</font></td><td><font size='2' color='#FFFFFF'>PERIOD</font></td>"+
			 "<td><font size='2' color='#FFFFFF'>Week</font></td><td><font size='2' color='#FFFFFF'>DATE_CODE</font></td><td><font size='2' color='#FFFFFF'>上傳結果</font></td></tr>");    
            
int i = 1,fail_cnt=0;			
String sql = "",errmsg=""; //add by Peggy 20130701

try 
{
	while (i<rowCount)  
	{  
		errmsg="";  //add by Peggy 20150305
		
		if (DEL_FLAG.equals("Y") && i==1)
		{
			//新增前,先刪除該年度資料,add by Peggy 20150305
			sql = " delete APPS.YEW_DATE_CODE "+
				  " where substr(trim(PERIOD),1,4) =?";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,DC_YEAR);
			pstmt.executeUpdate();
			pstmt.close();
		}		
		
		out.print("<tr bgcolor='#FFFFCC'><td>"+i+"</td>");       
        jxl.Cell wcDTsc_Package = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀Supplier_id                                
        String dTsc_Package = wcDTsc_Package.getContents();           
		out.print("<td><font size='2'>"+dTsc_Package+"</font></td>");
			 
	  	jxl.Cell wcDTSC_Makebuy = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀Supplier_name                                
	  	String dTSC_Makebuy = wcDTSC_Makebuy.getContents();              
	    out.print("<td><font size='2'>"+dTSC_Makebuy+"</font></td>");
			 
		jxl.Cell wcDPeriod = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀Created_by                               
        String dPeriod = wcDPeriod.getContents();
		out.print("<td><font size='2'>"+dPeriod+"</font></td>");
		if ( !dPeriod.substring(0,4).equals(DC_YEAR))
		{
			errmsg+="Period:"+dPeriod.substring(0,4)+"與指定年度:"+DC_YEAR+"不符<br>"; 
		}

		jxl.Cell wcDWeek = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀Created_by                               
        String dWeek = wcDWeek.getContents(); 
        out.print("<td><font size='2'>"+dWeek+"</font></td>");			  
		try
		{
			if (Integer.parseInt(dWeek) <0 || Integer.parseInt(dWeek)>52)
			{
				errmsg+="Week值錯誤<br>"; 
			}
		}
		catch(Exception e)
		{
			errmsg+="Week格式錯誤<br>"; 
		}             
			  
		jxl.Cell wcDDate_Code = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀Supplier_item                             
        String dDate_Code = wcDDate_Code.getContents();              
        out.print("<td><font size='2'>"+dDate_Code+"</font></td>");
        out.print("<td>"+(errmsg.equals("")?"<font size='2' color='blue'>成功":"<font size='2' color='red'>失敗!"+errmsg)+"</font></td></tr>");

		if (!errmsg.equals(""))
		{
			fail_cnt++;
		}
		else
		{	
			if (!DEL_FLAG.equals("Y"))
			{
				//新增前,先刪除已存在的資料,add by Peggy 20130701
				sql = " delete APPS.YEW_DATE_CODE"+
					  " where trim(TSC_PACKAGE)=?"+
					  " and trim(TSC_MAKEBUY)=?"+
					  " and trim(PERIOD)=?"+
					  " and trim(WEEK)=?";
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,dTsc_Package.trim());
				pstmt.setString(2,dTSC_Makebuy.trim());
				pstmt.setString(3,dPeriod.trim());
				pstmt.setString(4,dWeek.trim());
				pstmt.executeUpdate();
				pstmt.close();
			}
											  
			sql =  "insert into APPS.YEW_DATE_CODE(TSC_PACKAGE,TSC_MAKEBUY,PERIOD,WEEK,DATE_CODE) "+
									"values(?,?,?,?,?)";   			            
			PreparedStatement seqstmt=con.prepareStatement(sql); //out.println("Step1.1.2");    				
			seqstmt.setString(1,dTsc_Package.trim()); // out.println("Step1.1");
			seqstmt.setString(2,dTSC_Makebuy.trim());// out.println("Step1.2"); 
			seqstmt.setString(3,dPeriod.trim()); //out.println("Step1.4");
			seqstmt.setString(4,dWeek.trim()); //out.println("Step1.4");				 
			seqstmt.setString(5,dDate_Code.trim()); //out.println("Step1.5");
			seqstmt.executeUpdate();
			seqstmt.close(); 	
		}		 
        i++;  
	}   // End of While (i<rowCount)
} // end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());		  
} 
out.println("</table>"); 
wb.close(); 

if (fail_cnt >0)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("共有<%=fail_cnt%>筆資料上傳失敗,請確認!");
	</script>
<%
}
%>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
