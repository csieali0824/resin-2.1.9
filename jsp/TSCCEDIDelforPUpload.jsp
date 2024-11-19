<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,org.apache.commons.net.ftp.FTP,org.apache.commons.net.ftp.FTPClient"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		setCloseWindow();
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("Please choose upload file!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('upload excel file must be 2003 format!');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setCloseWindow()
{
	window.opener.document.MYFORM.submit();
	setClose();
}
function setClose()
{
	//window.opener.document.getElementById("alpha").style.width="0px";
	//window.opener.document.getElementById("alpha").style.height="0px";
	window.close();	
}
</script>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",batch_id="";
int sheetRows=0,sheetCols=7,i=0,j=0,irow=0,rowcnt=0;
String strarray[]=new String [sheetCols];
DateCell vdate=null;
SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
FTPClient ftpClient = new FTPClient();
String server = "10.0.1.15";
int port = 21;
String user = "tsccedi";
String pass = "CYhs&Jbi";
String FileName="",remarks="",strPath="",v_status="",v_error="";
java.io.File strFile =null;
int v_tot_line=0;  //add by Peggy 20220401

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>Notice:upload excel file must be 2003 format!!</td>
	</tr>
	<tr>
		<td>
			<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
				<TR>
					<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
					<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px">
					<br>
					<A HREF="../jsp/samplefiles/I2-005_SampleFile.xls"><font style="font-size:13px;font-family:arial">Download Sample File</font></A>
					</TD>
				</TR>
				<TR>
					<TD colspan="2" align="center">
					<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSCCEDIDelforPUpload.jsp?ACTION=UPLOAD")'>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>
					</TD>
				</TR>
			</TABLE>
		</td>
	</tr>
</TABLE>
<BR>
<%
try
{
	if (ACTION.equals("UPLOAD"))
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\I2-005("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		for (i = 1 ; i <=sheetRows; i++) 
		{
			for (j = 0 ; j < sheetCols ; j++)
			{
				strarray[j]=null;
				
				try
				{
					jxl.Cell strCell= sht.getCell(j, i);
					if (strCell.getType() == CellType.DATE)
					{
						try
						{
							vdate = (DateCell)strCell;
							java.util.Date ReqDate = ((DateCell)strCell).getDate();
							vStr=sy1.format(ReqDate); 
						}
						catch(Exception e)
						{
							out.println(e.getMessage());
							throw new Exception("Date format error!!");
						}							
					}	
			   		else if ( j!=2 && strCell.getType() == CellType.NUMBER)  
					{
						vStr =""+((NumberCell)strCell).getValue();
					} 
					else
					{
						vStr = (strCell.getContents()).trim();
						if (vStr != null && !vStr.equals("") && vStr.substring(0,1).equals("'"))
						{
							vStr = vStr.substring(1);
						}
						if (j==5 && !vStr.equals(""))
						{
							throw new Exception("Quantity format error!!");
						}
					}
					if (j==0 || j==2)
					{
						if (vStr==null || vStr.equals(""))
						{
							if (v_tot_line==0)
							{
	 							throw new Exception("The field("+j+") must be input a value!!");
							}
							else
							{
								break;
							}
						}
					}
					
					if (j==0 || j==2 ||j==3 || j==4 || j==5 || j==6)
					{
						if (vStr ==null || vStr.equals(""))
						{
 							throw new Exception("The field("+j+") must be input a value!!");
						}
					}
				}
				catch(Exception e)
				{	
					throw new Exception(e.getMessage());
				}
				strarray[j]=vStr;
			}
			
			//檢查客戶是否需要發送delforp
			sql = " select * from edi.tscc_edi_customers a "+
			      " where nvl(a.inactive_date,to_date('21990101','yyyymmdd'))>trunc(sysdate)"+
				  " and a.delforp_folder_name is not null"+
				  " and exists (select 1 from ORADDMAN.TSCC_K3_CUST_LINK_ERP b where b.ERP_CUST_NUMBER=a.erp_cust_number and b.CUST_CODE=?)";
			PreparedStatement statementp = con.prepareStatement(sql);
			statementp.setString(1,strarray[0]);
			ResultSet rsp=statementp.executeQuery();
			if (!rsp.next())
			{
				rsp.close();
				statementp.close();
				throw new Exception("客戶:"+strarray[0]+" 未在發送DELFORP名單中!!");				
			}
			rsp.close();
			statementp.close();				  
			
			//檢查cust po/cust partno/tsc partno是否存在
			sql = " select distinct 1 "+
			      " from edi.tscc_delfor_lines_all a "+
				  ",edi.tscc_delfor_elements b"+
				  ",edi.tscc_edi_customers c"+
				  ",oraddman.tscc_k3_cust_link_erp d"+
			      " where a.cust_po=?"+
				  " and a.cust_part_no=?"+
				  " and a.CUST_PO=b.doc_no"+
				  " and a.CUST_PO_VERSION_NO=b.doc_version_no"+
				  " and b.edi_cust_code=c.edi_cust_code"+
				  " and c.erp_cust_number=d.erp_cust_number"+
				  " and d.cust_code=?";
				  //" and a.tsc_item_desc=?";
			statementp = con.prepareStatement(sql);
			statementp.setString(1,strarray[2]);
			statementp.setString(2,strarray[3]);
			statementp.setString(3,strarray[0]);
			rsp=statementp.executeQuery();
			if (!rsp.next())
			{
				rsp.close();
				statementp.close();
				throw new Exception("CUST PO:"+strarray[2]+" + CSUT P/N:"+strarray[3]+" 查無DELFOR資料!!");				
			}
			rsp.close();
			statementp.close();				  

			if (irow==0)
			{
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(" SELECT APPS.TSCC_ASN_JOB_BATCHID_S.nextval from dual");
				if (rs1.next())
				{
					batch_id = rs1.getString(1);
				}
				else
				{
					throw new Exception("Get Batch ID fail!!");
				}
				rs1.close();
				statement1.close();	
			}
			
			if (strarray[0]!=null && !strarray[0].equals(""))
			{
				sql = " insert into edi.tscc_delforp_delivery "+
					  " (edi_address_code"+
					  ",customer_po"+
					  ",buyer_code"+
					  ",supplier_code"+
					  ",cust_partno"+
					  ",tsc_partno"+
					  ",delivery_qty"+
					  ",delivery_date"+
					  //",delforp_doc_no"+
					  //",delforp_version_no"+
					  ",creation_date"+
					  ",created_by"+
					  ",last_update_date"+
					  ",last_updated_by"+
					  ",status_code"+
					  ",batch_id"+
					  ",k3_cust_number"+
					  ")"+
					  " select distinct b.edi_address_code"+
                      ",c.cust_po"+
                      ",(select trim(party_id) from edi.tscc_delfor_address_all x where x.cust_name=c.cust_name and x.cust_po=c.cust_po and x.cust_po_version_no=c.cust_po_version_no and x.party_code=?) buyer_code"+
                      ",(select trim(party_id) from edi.tscc_delfor_address_all x where x.cust_name=c.cust_name and x.cust_po=c.cust_po and x.cust_po_version_no=c.cust_po_version_no and x.party_code=?) supplier_code"+
                      ",c.cust_part_no"+
                      ",c.tsc_item_desc"+
					  ",?"+
					  ",to_date(?,'yyyy/mm/dd')"+
					  //",?"+
					  //",?"+
					  ",sysdate"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",a.cust_code"+
                      " from oraddman.tscc_k3_cust_link_erp a"+
                      ",edi.tscc_edi_customers b"+
                      ",edi.tscc_delfor_lines_all c"+
                      " where a.cust_code=?"+
                      " and a.erp_cust_number=b.erp_cust_number"+
                      " and b.edi_cust_code=c.ship_to_code"+
                      " and c.cust_po=?"+
					  " and c.cust_part_no=?";

				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"BY");
				pstmtDt.setString(2,"SU");
				pstmtDt.setString(3,strarray[5]);
				pstmtDt.setString(4,strarray[6]);
				pstmtDt.setString(5,UserName);
				pstmtDt.setString(6,UserName);
				pstmtDt.setString(7,"W");
				pstmtDt.setString(8,batch_id);
				pstmtDt.setString(9,strarray[0]);
				pstmtDt.setString(10,strarray[2]);
				pstmtDt.setString(11,strarray[3]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
				irow++;	
			}		  
		}
		wb.close();
		
		if (irow>0)
		{
			CallableStatement cs3 = con.prepareCall("{call TSCC_EDI_PKG.JOB_DELFORP_INITIAL(?,?)}");			 
			cs3.setString(1,batch_id); 
			cs3.setString(2,UserName); 
			cs3.execute();
			cs3.close();	
					
			sql = " select a.DELFORP_DOC_NO,a.DELFORP_VERSION_NO,a.CUST_PO,a.EDI_ELEMENT_VALUES,a.ERP_CUST_NUMBER||'_'||a.DELFORP_DOC_NO||'_'||a.CUST_PO||'_'||to_char(sysdate,'yyyymmddhh24missSSSSS')||rownum as fname "+
                  " ,'/'||replace(b.ftp_server_route,'TSCC\','')||CASE WHEN (SELECT NAME FROM v$database) ='PROD' THEN '' ELSE '_TEST' END ||'/'||b.delforp_folder_name file_folder"+
                  " from edi.tscc_delforp_elements a"+
                  ",(SELECT * FROM EDI.TSCC_EDI_CUSTOMERS WHERE nvl(INACTIVE_DATE,to_date('20990101','yyyymmdd'))>trunc(sysdate)) b"+
                  " where a.batch_id=?"+
				  " and a.STATUS_CODE=?"+
				  " and a.file_name is null"+
                  " and a.ERP_CUST_NUMBER=b.ERP_CUST_NUMBER(+)";
			//out.println(sql);
			PreparedStatement pstmtDt1=con.prepareStatement(sql);  
			pstmtDt1.setString(1,batch_id);
			pstmtDt1.setString(2,"W");	
			ResultSet rs =pstmtDt1.executeQuery();		
			while (rs.next()) 
			{ 	
				v_error="";v_status="";
				FileName="CONTI_DELFORP_"+rs.getString("fname")+".txt";
				
				strPath = "\\resin-2.1.9\\webapps\\oradds\\tsccedi\\"+FileName;
				strFile = new java.io.File(strPath);
				boolean fileCreated = strFile.createNewFile();
				 //File appending
				Writer objWriter = new BufferedWriter(new FileWriter(strFile));
				objWriter.write((rs.getClob("EDI_ELEMENT_VALUES")).getSubString(1,(int)(rs.getClob("EDI_ELEMENT_VALUES")).length()));
				objWriter.flush();
				objWriter.close();	
		
				try 
				{
					ftpClient.connect(server, port);
					ftpClient.login(user, pass);
					ftpClient.enterLocalPassiveMode();
					ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
					//ftpClient.changeWorkingDirectory("/CONTI_CHANGCHUN_TEST/ASN");
					ftpClient.changeWorkingDirectory(rs.getString("file_folder"));
		
					java.io.File uploadFile = new java.io.File(strPath);
		 
					boolean done = ftpClient.storeFile(uploadFile.getName(),new FileInputStream(uploadFile));
					if (done) 
					{
						v_status="F";
					}
					else
					{
						v_status="E";
						cs3 = con.prepareCall("{call TSC_SENDMAIL(?,?,?,?,?)}");			 
						cs3.setString(1,"prodsys@ts.com.tw"); 
						cs3.setString(2,"peggy.chen@ts.com.tw"); 
						cs3.setString(3,""); 
						cs3.setString(4,"TSCC DELFORP Upload Fail(RFQ)"); 
						cs3.setString(5,""); 
						cs3.execute();
						cs3.close();						
					}
				} 
				catch (IOException ex) 
				{
					v_status="E";
					v_error= ex.getMessage();
					ex.printStackTrace();
				} 
				finally 
				{
					try 
					{
						if (ftpClient.isConnected()) 
						{
							ftpClient.logout();
							ftpClient.disconnect();
						}
					} 
					catch (IOException ex) 
					{
						ex.printStackTrace();
					}
				}
				sql = " UPDATE EDI.TSCC_DELFORP_ELEMENTS A"+
					  " SET FILE_NAME=?"+
					  ",STATUS_CODE=?"+
					  ",ERROR_MSG=?"+
					  " WHERE DELFORP_DOC_NO=?"+
					  " AND DELFORP_VERSION_NO=?"+
					  " AND BATCH_ID=?"+
					  " AND CUST_PO=?";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,FileName); 
				pstmtDt.setString(2,v_status);
				pstmtDt.setString(3,v_error);
				pstmtDt.setString(4,rs.getString("DELFORP_DOC_NO"));
				pstmtDt.setString(5,rs.getString("DELFORP_VERSION_NO"));
				pstmtDt.setString(6,batch_id);
				pstmtDt.setString(7,rs.getString("CUST_PO")); 
				pstmtDt.executeUpdate();
				pstmtDt.close();					
				
			}
			rs.close();
			pstmtDt1.close();
			
			rowcnt=0;
			sql = "select a.DELFORP_DOC_NO,a.DELFORP_VERSION_NO,a.CUST_PO,FILE_NAME,STATUS_CODE,CASE STATUS_CODE WHEN 'F' THEN 'Success' ELSE 'Fail' end RESULT,ERROR_MSG"+
			  " from EDI.TSCC_DELFORP_ELEMENTS a"+
			  " where a.batch_id=?";
			pstmtDt1=con.prepareStatement(sql);  
			pstmtDt1.setString(1,batch_id);
			rs =pstmtDt1.executeQuery();				  
			//out.println(sql);
			while (rs.next())
			{
				if (rowcnt==0)
				{
				%>
					<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
						<tr style="background-color:#E1E3F0;color:#000000">
							<td width="15%" align="center">Delforp No</td>
							<td width="7%" align="center">Delforp Version No</td>
							<td width="10%" align="center">Customer PO</td>
							<td width="30%" align="center">File Name</td>	
							<td width="10%" align="center">Result</td>	
							<td width="20%" align="center">Error Message </td>	
						</tr>

				<%
				}
				%>
				<tr>
					<td><%=rs.getString("DELFORP_DOC_NO")%></td>
					<td align="center"><%=rs.getString("DELFORP_VERSION_NO")%></td>
					<td align="center"><%=rs.getString("CUST_PO")%></td>
					<td><%=rs.getString("FILE_NAME")%></td>
					<td align="center" style="color:<%=(rs.getString("STATUS_CODE").equals("F")?"#0000ff":"#ff0000")%>;font-weight:bold"><%=rs.getString("RESULT")%></td>
					<td style="color:#ff0000"><%=(rs.getString("ERROR_MSG")==null?"&nbsp;":rs.getString("ERROR_MSG"))%></td>
				</tr>
			<%	
				rowcnt++;
			}
			rs.close();
			pstmtDt1.close();			

			if (rowcnt>0)
			{
			%>
			</table>
			<%
			}	
			else
			{
			%>
				<div style="font-size:12px;color:#ff0000">交易失敗,請速洽系統管理人員,謝謝!</div>
			<%
				cs3 = con.prepareCall("{call TSC_SENDMAIL(?,?,?,?,?)}");			 
				cs3.setString(1,"prodsys@ts.com.tw"); 
				cs3.setString(2,"peggy.chen@ts.com.tw"); 
				cs3.setString(3,""); 
				cs3.setString(4,"TSCC Delforp fail("+batch_id+")"); 
				cs3.setString(5,""); 
				cs3.execute();
				cs3.close();			
			}			
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>Record#"+i+":"+e.getMessage()+"</div>");
}
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
