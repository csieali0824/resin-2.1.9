<%@ page contentType="text/html; charset=utf-8" import="java.util.*,java.text.*,java.io.*,java.sql.*,java.lang.*,org.apache.commons.net.ftp.FTP,org.apache.commons.net.ftp.FTPClient"%>
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
	setClose();
	window.opener.document.MYFORM.submit();
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
int sheetRows=0,sheetCols=26,i=0,j=0,irow=0,rowcnt=0;
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
					<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
				</TR>
				<TR>
					<TD colspan="2" align="center">
					<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSCCEDIDesadvUpload.jsp?ACTION=UPLOAD")'>
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

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\I2-003("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-2;
		String v_lot="",v_dc=""; //add by Peggy 20210202
								
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
			   		else if (j != 10  && strCell.getType() == CellType.NUMBER)  //po排外,add by Peggy 20210524
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
						if (j==11 && !vStr.equals(""))
						{
							throw new Exception("Quantity format error!!");
						}
						//else if (j==26 && vStr.equals(""))
						//{
						//	vStr ="0";
						//}
					}
					//out.println("j="+j);
					//out.println(vStr);
					if (j==0 || j==1)
					{
						//if (vStr==null || vStr.equals("") || vStr.startsWith("合")) break;
						//out.println(vStr);
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
						if (vStr.startsWith("合"))
						{
							v_tot_line=i;
							break;
						}
					}
					
					if (j==1 || j==3 ||j==4 || j==5 || j==6 || j==9 || j==10 || j==11 || j==13 || j ==14 || j==17 || j==24 )
					{
						if (vStr ==null || vStr.equals(""))
						{
							//out.println("i="+i +"   j="+j);
 							throw new Exception("The field("+j+") must be input a value!!");
						}
						if (j==3) //add by Peggy 20211108
						{
							if (!vStr.startsWith("TS-"))
							{
								throw new Exception("The field("+j+") despatch no is invaild!!");
							}
						}
					}
				}
				catch(Exception e)
				{	
					throw new Exception(e.getMessage());
				}
				strarray[j]=vStr;
			}
			
			//檢查cust po/cust partno/tsc partno是否存在
			sql = " select distinct 1 from edi.tscc_delfor_lines_all a "+
			      " where a.cust_po=?"+
				  " and a.cust_part_no=?";
				  //" and a.tsc_item_desc=?";
			PreparedStatement statementp = con.prepareStatement(sql);
			statementp.setString(1,strarray[10]);
			statementp.setString(2,strarray[6]);
			//statementp.setString(3,strarray[9]);
			ResultSet rsp=statementp.executeQuery();
			if (!rsp.next())
			{
				rsp.close();
				statementp.close();
				//throw new Exception("CUST PO:"+strarray[10]+" + CSUT P/N:"+strarray[6]+" + TSC P/N:"+strarray[9]+" 查無DELFOR資料!!");				
				throw new Exception("CUST PO:"+strarray[10]+" + CSUT P/N:"+strarray[6]+" 查無DELFOR資料!!");				
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
			
			//add by Peggy 20200822
			PreparedStatement statementx = con.prepareStatement("select 1 from edi.tscc_delivery_details a where a.k3_delivery_no=? and a.batch_id<>?");
			statementx.setString(1,strarray[3]);
			statementx.setString(2,batch_id);
			ResultSet rsx=statementx.executeQuery();
			if (rsx.next())
			{
				rsx.close();
				statementx.close();
				throw new Exception("單據號碼:"+strarray[3]+"已存在,不允許重複上傳!!");				
			}
			rsx.close();
			statementx.close();
						
			if (strarray[0]!=null && !strarray[0].equals(""))
			{
				sql = " insert into edi.tscc_delivery_details "+
					  "(k3_delivery_no"+     //0
					  ",seq_no"+             //1
					  ",k3_order_no"+        //2
					  ",k3_cust_number"+     //3
					  ",k3_cust_name"+       //4
					  ",cust_po"+            //5
					  ",k3_item_no"+         //6
					  ",k3_item_desc"+       //7
					  ",cust_part_no"+       //8
					  ",delivery_note"+      //9
					  ",carton_num"+         //10
					  ",lot_no"+             //11
					  ",qty"+                //12
					  ",uom"+                //13
					  ",delivery_date"+      //14
					  ",k3_locator"+         //15
					  ",batch_id"+           //16
					  ",creation_date"+      //17
					  ",status_code"+        //18
					  ",despatch_date"+      //19
					  ",arrival_date"+       //20
					  ",created_by"+         //21
					  ")"+
					  " values"+
					  " ("+
					  " ?"+                  //0
					  ",(select nvl(max(seq_no),0)+1 from edi.tscc_delivery_details x where x.k3_delivery_no=?)"+            //1 
					  ",?"+                  //2
					  ",?"+                  //3
					  ",?"+                  //4
					  ",?"+                  //5
					  ",?"+                  //6
					  ",?"+                  //7
					  ",?"+                  //8
					  ",case when ? is null then (select PACKING_NO FROM TSC_T_PACKING_L_FAIRCHILD A WHERE LOT_DATA=?) else ? end"+  //9
					  ",?"+                  //10
					  ",?"+                  //11
					  ",?"+                  //12
					  ",?"+                  //13
					  ",to_date(?,'yyyy/mm/dd')"+                  //14
					  ",?"+                  //15
					  ",?"+                  //16
					  ",sysdate"+            //17
					  ",?"+                  //18
					  ",sysdate"+            //19
					  ",sysdate+3"+          //20
					  ",?"+                  //21
					  " )";
				//out.println(sql);
				//add by Peggy 20210202
				if (strarray[13].length()-strarray[13].replace("-","").length()>2)
				{
					v_lot=strarray[13].substring(0,strarray[13].lastIndexOf("-"));
					v_dc = strarray[13].substring(strarray[13].lastIndexOf("-")+1);
				}
				else if ( strarray[13].substring(2,3)!="-" && strarray[13].length()-strarray[13].replace("-","").length()==2)
				{	
					//example ES5632801-3281E-3281E_ add by Peggy 20230924
					v_lot=strarray[13].substring(0,strarray[13].lastIndexOf("-"));
					v_dc = strarray[13].substring(strarray[13].lastIndexOf("-")+1);							
				}
				else
				{
					v_lot=strarray[13];
					v_dc ="";
				}
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,strarray[3]);
				pstmtDt.setString(2,strarray[3]);
				pstmtDt.setString(3,strarray[5]);
				pstmtDt.setString(4,strarray[24]);
				pstmtDt.setString(5,strarray[8]);
				pstmtDt.setString(6,strarray[10]);
				pstmtDt.setString(7,strarray[1]);
				pstmtDt.setString(8,strarray[9]);
				pstmtDt.setString(9,strarray[6]);
				pstmtDt.setString(10,strarray[25]);
				//pstmtDt.setString(11,strarray[13].substring(0,strarray[13].lastIndexOf("-")));
				pstmtDt.setString(11,v_lot);
				pstmtDt.setString(12,strarray[25]);
				pstmtDt.setString(13,"0");
				//pstmtDt.setString(14,strarray[13].substring(0,strarray[13].lastIndexOf("-")));
				pstmtDt.setString(14,v_lot);
				pstmtDt.setString(15,strarray[11]);
				pstmtDt.setString(16,strarray[4]);
				pstmtDt.setString(17,strarray[14]);
				//pstmtDt.setString(18,strarray[13].substring(strarray[13].lastIndexOf("-")+1));
				pstmtDt.setString(18,v_dc);
				pstmtDt.setString(19,batch_id);
				pstmtDt.setString(20,"W");
				pstmtDt.setString(21,UserName);
				pstmtDt.executeQuery();
				pstmtDt.close();	
				irow++;	
			}		  
		}
		wb.close();
		
		if (irow>0)
		{
			CallableStatement cs3 = con.prepareCall("{call TSCC_EDI_PKG.JOB_ASN_INITIAL(?,?)}");			 
			cs3.setString(1,batch_id); 
			cs3.setString(2,UserName); 
			cs3.execute();
			cs3.close();	
					
			//out.println("<script language='JavaScript' type='text/JavaScript'>");
			//out.println("window.location.replace('../jsp/TSCCEDIDesadvDespatch.jsp?BATCH_ID="+batch_id+"')"); 
			//out.println("</script>");
			sql = " select a.DESPATCH_NO,a.DESPATCH_VERSION_NO,a.CUST_PO,a.EDI_ELEMENT_VALUES,CUST_LOCATION_CODE||'_'||DESPATCH_NO||'_'||a.CUST_PO||'_'||to_char(sysdate,'yyyymmddhh24missSSSSS')||rownum as fname "+
				  " ,'/'||replace(b.ftp_server_route,'TSCC\','')||CASE WHEN (SELECT NAME FROM v$database) ='PROD' THEN '' ELSE '_TEST' END ||'/'||b.desadv_folder_name file_folder"+
				  " from edi.tscc_desadv_elements a"+
				  //",edi.tscc_edi_customers b "+
				  ",(SELECT * FROM EDI.TSCC_EDI_CUSTOMERS WHERE nvl(INACTIVE_DATE,to_date('20990101','yyyymmdd'))>trunc(sysdate)) b"+ //modify by Peggy 20200827
				  " where a.batch_id="+batch_id+" and a.STATUS_CODE='W' and a.file_name is null"+
				  " and a.cust_location_code=b.edi_cust_code(+)";
			//out.println(sql);
			Statement statement=con.createStatement(); 
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next()) 
			{ 	
				v_error="";v_status="";
				FileName="CONTI_DESADV_CHANGCHUN"+rs.getString("fname")+".txt";
			
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
						cs3.setString(2,"mars.wang@ts.com.tw");
						cs3.setString(3,""); 
						cs3.setString(4,"TSCC ASN Upload Fail(RFQ)"); 
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
				sql = " UPDATE edi.tscc_desadv_elements a"+
					  " SET FILE_NAME=?"+
					  ",STATUS_CODE=?"+
					  ",ERROR_MSG=?"+
					  " WHERE DESPATCH_NO=?"+
					  " AND DESPATCH_VERSION_NO=?"+
					  " AND BATCH_ID=?"+
					  " AND CUST_PO=?";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,FileName); 
				pstmtDt.setString(2,v_status);
				pstmtDt.setString(3,v_error);
				pstmtDt.setString(4,rs.getString("DESPATCH_NO"));
				pstmtDt.setString(5,rs.getString("DESPATCH_VERSION_NO"));
				pstmtDt.setString(6,batch_id);
				pstmtDt.setString(7,rs.getString("CUST_PO")); //add by Peggy 20191014
				pstmtDt.executeUpdate();
				pstmtDt.close();					
				
			}
			rs.close();
			statement.close();
			
			rowcnt=0;
			sql = "select a.DESPATCH_NO,a.DESPATCH_VERSION_NO,a.CUST_PO,FILE_NAME,STATUS_CODE,CASE STATUS_CODE WHEN 'F' THEN 'Success' ELSE 'Fail' end RESULT,ERROR_MSG"+
			  " from edi.tscc_desadv_elements a"+
			  " where a.batch_id="+batch_id+" ";
			//out.println(sql);
			statement=con.createStatement();
			rs=statement.executeQuery(sql);
			while (rs.next())
			{
				if (rowcnt==0)
				{
				%>
					<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
						<tr style="background-color:#E1E3F0;color:#000000">
							<td width="15%" align="center">Despatch No</td>
							<td width="7%" align="center">Despatch Version No</td>
							<td width="10%" align="center">Customer PO</td>
							<td width="30%" align="center">File Name</td>	
							<td width="10%" align="center">Result</td>	
							<td width="20%" align="center">Error Message </td>	
						</tr>

				<%
				}
				%>
				<tr>
					<td><%=rs.getString("DESPATCH_NO")%></td>
					<td align="center"><%=rs.getString("DESPATCH_VERSION_NO")%></td>
					<td align="center"><%=rs.getString("CUST_PO")%></td>
					<td><%=rs.getString("FILE_NAME")%></td>
					<td align="center" style="color:<%=(rs.getString("STATUS_CODE").equals("F")?"#0000ff":"#ff0000")%>;font-weight:bold"><%=rs.getString("RESULT")%></td>
					<td style="color:#ff0000"><%=(rs.getString("ERROR_MSG")==null?"&nbsp;":rs.getString("ERROR_MSG"))%></td>
				</tr>
			<%	
				rowcnt++;
			}
			rs.close();
			statement.close();			

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
				cs3.setString(2,"mars.wang@ts.com.tw");
				cs3.setString(3,""); 
				cs3.setString(4,"TSCC ASN fail("+batch_id+")"); 
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
