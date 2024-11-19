<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="TSCCSHBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="UPDRESBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0%";
		window.opener.document.getElementById("alpha").style.height="0px";
		window.close();				
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0%";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<title>Excel Upload</title>
</head>
<%
String ID = request.getParameter("ID");
if (ID==null) ID="";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String CUSTOMERNAME="",TSCINVOICE="",SHIPDATE="",CUSTPO="",CUSTITEM="",TSCITEM="",ORDER_QTY="",UNIT_PRICE="",TOT_AMT="",TSCDESC="",RES_MSG="",TSCITEMID="",CUSTITEMID="",ITEMTYPE="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();
int OK_CNT =0,ERR_CNT=0;
SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");

try
{
	sql = " select c.customer_id,'('||c.customer_number||') '|| c.customer_name customer_name from APPS.AR_CUSTOMERS c "+
          " where c.STATUS='A'"+
          " and c.customer_number in (4034,14312,8404)"+
		  " and c.customer_id='"+ID+"'";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if(rs.next())
	{
		CUSTOMERNAME = rs.getString("customer_name");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查詢客戶資料時發生異常,請洽系統管理人員,謝謝!");
		setClose();
		this.window.close();
	</script>
<%
}
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<input type="hidden" name="ID" value="<%=ID%>">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;客戶&nbsp;</font></TD>
		<TD><font style="color:#000099;font-family:Arial;font-size:12px">&nbsp;<strong><%=CUSTOMERNAME%></strong></font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/D4-014_SampleFile.xls"><font face="ARIAL" size="-1">&nbsp;Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TSCCSH1211ExcelUploadImport.jsp?ACTION=UPLOAD&ID=<%=ID%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		TSCCSHBean.setArray2DString(null);
		UPDRESBean.setArray2DString(null);
		StringBuilder sb = new StringBuilder();
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D4-014("+ID+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			
			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();
		
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
						
			sql  = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
				   " ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v where "+
				   " SOLD_TO_ORG_ID = '"+ID+"' "+
				   " and CROSS_REF_STATUS <>'INACTIVE' and ITEM_STATUS <>'INACTIVE'";
			Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rsh = statementh.executeQuery(sql);
			
			for (int i = 1 ; i <sht.getRows(); i++) 
			{
				RES_MSG="";
				
				//台半發票號
				jxl.Cell wcTSCINVOICE = sht.getCell(0, i);  
				if ((wcTSCINVOICE.getContents()).trim() !=null && !(wcTSCINVOICE.getContents()).trim().equals(""))
				{        
					TSCINVOICE = (wcTSCINVOICE.getContents()).trim();
				}
				if (TSCINVOICE  == null) TSCINVOICE = "";
				
				//出貨日期
				jxl.Cell wcSHIPDATE = sht.getCell(1, i);  
				if (wcSHIPDATE.getType() == CellType.DATE) 
				{
					SHIPDATE =sy1.format(((DateCell)wcSHIPDATE).getDate());
				}
				else
				{
					SHIPDATE= (wcSHIPDATE.getContents()).trim();
				}
				if (SHIPDATE != null) SHIPDATE=SHIPDATE.replace("-","/");		
				
				//客戶PO
				jxl.Cell wcCUSTPO = sht.getCell(2, i); 
				CUSTPO = (wcCUSTPO.getContents()).trim();
				if (CUSTPO == null) CUSTPO="";
				 		
				//客戶品號
				jxl.Cell wcCUSTITEM = sht.getCell(3, i); 
				CUSTITEM = (wcCUSTITEM.getContents()).trim();
				if (CUSTITEM == null) CUSTITEM="";						
						   
				//台半品號
				jxl.Cell wcTSCITEM = sht.getCell(4, i); 
				TSCDESC = (wcTSCITEM.getContents()).trim();
				if (TSCDESC == null) TSCDESC="";	
				
				TSCITEM="";TSCITEMID="";CUSTITEMID="";ITEMTYPE="";
				if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
				while (rsh.next())
				{
					if (rsh.getString("ITEM").equals(CUSTITEM) && rsh.getString("ITEM_DESCRIPTION").equals(TSCDESC))
					{
						TSCITEM = rsh.getString("INVENTORY_ITEM");
						TSCITEMID = rsh.getString("INVENTORY_ITEM_ID");
						CUSTITEMID = rsh.getString("ITEM_ID");
						ITEMTYPE = rsh.getString("ITEM_IDENTIFIER_TYPE");
						break;
					}
				}
				if (TSCITEM.equals(""))
				{
					RES_MSG +="第"+i+"列:查無對應的台半料號!!<br>";
				}
				
				//數量
				jxl.Cell wcQTY = sht.getCell(5, i); 						   
				if (wcQTY.getType() == CellType.NUMBER) 
				{
					ORDER_QTY = (new DecimalFormat("##########")).format(Float.parseFloat(""+((NumberCell) wcQTY).getValue()));
				}
				else ORDER_QTY = (wcQTY.getContents()).trim().replace(",","");
				if (ORDER_QTY == null || ORDER_QTY.equals(""))
				{
					RES_MSG +="第"+i+"列:數量不可空白!!<br>";
				}
				else  if (Float.parseFloat(ORDER_QTY)<=0)
				{
					RES_MSG +="第"+(i+1)+"列:數量必須大於0!!<br>";
				}

				//單價
				jxl.Cell wcPRICE = sht.getCell(6, i); 						   
				if (wcPRICE.getType() == CellType.NUMBER) 
				{
					UNIT_PRICE = (new DecimalFormat("#####.#####")).format(Float.parseFloat(""+((NumberCell) wcPRICE).getValue()));
				}
				else UNIT_PRICE = (wcPRICE.getContents()).trim().replace(",","");
				if (UNIT_PRICE == null || UNIT_PRICE.equals(""))
				{
					RES_MSG +="第"+i+"列:單價不可空白!!<br>";
				}
				else  if (Float.parseFloat(UNIT_PRICE)<=0)
				{
					RES_MSG +="第"+(i+1)+"列:單價必須大於0!!<br>";
				}				
				
				//總價
				jxl.Cell wcTOTAMT = sht.getCell(7, i); 						   
				if (wcTOTAMT.getType() == CellType.NUMBER) 
				{
					TOT_AMT = (new DecimalFormat("########.#####")).format(Float.parseFloat(""+((NumberCell) wcTOTAMT).getValue()));
				}
				else TOT_AMT = (wcTOTAMT.getContents()).trim().replace(",","");
				if (TOT_AMT == null || TOT_AMT.equals(""))
				{
					RES_MSG +="第"+i+"列:總價不可空白!!<br>";
				}
				else  if (Float.parseFloat(TOT_AMT)<=0)
				{
					RES_MSG +="第"+(i+1)+"列:總價必須大於0!!<br>";
				}	
				
				if (RES_MSG.equals(""))
				{
					RES_MSG ="<font color='blue'>OK</font>";
					OK_CNT ++;
				}
				else
				{
					RES_MSG ="<font color='red'>"+RES_MSG+"</font>";	
					ERR_CNT ++;
				}
								
				String ORDER[][]=TSCCSHBean.getArray2DContent();
				if (ORDER!=null)
				{
					String ORDERA[][]=new String[ORDER.length+1][ORDER[0].length];
					for (int k=0 ; k < ORDER.length ; k++)
					{
						for (int m=0 ; m < ORDER[k].length; m++)
						{ 
							ORDERA[k][m]=ORDER[k][m];				    
						} 
					}
					ORDERA[ORDER.length][0] = TSCINVOICE;
					ORDERA[ORDER.length][1] = SHIPDATE;
					ORDERA[ORDER.length][2] = CUSTPO;
					ORDERA[ORDER.length][3] = CUSTITEM;
					ORDERA[ORDER.length][4] = TSCDESC;		
					ORDERA[ORDER.length][5] = TSCITEM;		
					ORDERA[ORDER.length][6] = ORDER_QTY;		
					ORDERA[ORDER.length][7] = UNIT_PRICE;		
					ORDERA[ORDER.length][8] = TOT_AMT;	
					ORDERA[ORDER.length][9] = RES_MSG;	
					ORDERA[ORDER.length][10] = TSCITEMID;	
					ORDERA[ORDER.length][11] = CUSTITEMID;	
					ORDERA[ORDER.length][12] = ITEMTYPE;	
					TSCCSHBean.setArray2DString(ORDERA);					
				}
				else
				{
					String ORDERA[][]={{TSCINVOICE,SHIPDATE,CUSTPO,CUSTITEM,TSCDESC,TSCITEM,ORDER_QTY,UNIT_PRICE,TOT_AMT,RES_MSG,TSCITEMID,CUSTITEMID,ITEMTYPE}};
					TSCCSHBean.setArray2DString(ORDERA); 
				}	
			}
			wb.close();
			
			rsh.close();
			statementh.close();

			String ORDERB[][]={{""+OK_CNT,""+ERR_CNT}};
			UPDRESBean.setArray2DString(ORDERB); 			
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.action="../jsp/TSCCSH1211ExcelUpload.jsp?ACTIONCODE=UPLOAD&CUSTOMER="+document.SUBFORM.ID.value;
				window.opener.document.MYFORM.submit();
				setClose();		
			</script>
	<%				
			
		}
		catch(Exception e)
		{
			out.println("<div style='color:#ff0000;font-family:arial;font-size:12px'>上傳失敗!!錯誤原因如下說明..<br>"+e.getMessage()+"</div>");
		}
	}
%>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
