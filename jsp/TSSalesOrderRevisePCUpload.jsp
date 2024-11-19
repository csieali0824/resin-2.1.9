<!--20180817 Peggy,for yew issue=>the remarks field must be empty when the pc result =ok-->
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
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="FactoryCFMBean" scope="session" class="Array2DimensionInputBean"/>

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
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();	
}
</script>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String FACT = request.getParameter("FACT");
if (FACT==null) FACT="";
String STATUS="AWAITING_CONFIRM"; //add by Peggy 20230519
String STATUS1="AWAITING_APPROVE"; //add by Peggy 20230519
String sql ="",v_source_ssd="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",temp_id="",id="",V_BATCH_ID="",v_cancel_move_flag="",v_status="";
int sheetRows=0,sheetCols=7,i=0,j=0,k=0,rec_cnt=0,err_cnt=0;
String strarray[]=new String [sheetCols];
Hashtable hashtb = new Hashtable();
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#99CC99">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSSalesOrderRevisePCUpload.jsp?ACTION=UPLOAD&FACT=<%=FACT%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
try
{
	if (ACTION.equals("UPLOAD"))
	{
		FactoryCFMBean.setArray2DString(null);
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D12-002("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		//out.println("sheetRows="+sheetRows);
		String fact_cfm[][]=new String[sheetRows][5];
		int v_year=0,v_month=0,v_day=0;
						
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(" SELECT TSC_OM_SALESORDERREVISE_U_IS_S.nextval from dual");
		if (rs1.next())
		{
			V_BATCH_ID = rs1.getString(1);
			%>
				<input type="hidden" name="BATCHID" value="<%=V_BATCH_ID%>">
			<%
			
		}
		else
		{
			throw new Exception("Batch Id取得失敗!!");
		}
		rs1.close();
		statement1.close();	
												
		for (i = 1 ; i <=sheetRows; i++) 
		{
			k=0;
			strarray[0]="";strarray[1]="";strarray[2]="";strarray[3]="";strarray[4]="";strarray[5]="";strarray[6]="";
			for (j = 0 ; j < 29+(FACT.equals("002")?3:0) ; j++)
			{
				//if (j ==0 || j == 1 || j==22 || j==23 || j==24 || j==25)
				if (j ==0 || j == 1 || (j>=(25+(FACT.equals("002")?3:0)) && j <=(28+(FACT.equals("002")?3:0))))
				{
					jxl.Cell strCell= sht.getCell(j, i);
					if (strCell.getType() == CellType.DATE)
					{
						DateCell vdate = (DateCell)strCell;
						java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
						SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
						vStr=sy1.format(ReqDate); 
					}	
					else
					{
					
						vStr = (strCell.getContents()).trim();
						if (vStr != null && !vStr.equals("") && vStr.substring(0,1).equals("'"))
						{
							vStr = vStr.substring(1);
						}
					}
					//out.println("j="+j+"    "+vStr);
					strarray[k]=vStr;
					//if (k==4) out.println(vStr);
					k++;
				}
			}
			if ((strarray[0]==null || strarray[0].equals("")) || (strarray[1]==null || strarray[1].equals(""))) //request_no,seq_no
			{	
				if ((strarray[2]!=null && !strarray[2].equals("")) || (strarray[3]!=null && !strarray[3].equals("")) || (strarray[4]!=null && !strarray[4].equals("")) || (strarray[5]!=null && !strarray[5].equals("")))
				{
					throw new Exception("Request# or Seq# can not empty!!");
				}
				else
				{
					continue;  //add by Peggy 20160701
				}
			}
		
			sql = " select temp_id||'.'||seq_id as id,TEMP_ID,SEQ_ID,SOURCE_ITEM_DESC,SOURCE_SO_QTY,to_char(SOURCE_REQUEST_DATE,'yyyymmdd') SOURCE_REQUEST_DATE,to_char(SOURCE_SSD,'yyyymmdd') SOURCE_SSD,a.CANCEL_MOVE_FLAG,a.status from oraddman.tsc_om_salesorderrevise_req a"+
				  " where REQUEST_NO=?"+
				  " and SEQ_ID=?";
				  //" and STATUS=?";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,strarray[0]);
			statement.setString(2,strarray[1]);
			//statement.setString(3,STATUS);
			ResultSet rs=statement.executeQuery();
			v_source_ssd="";
			v_cancel_move_flag="";
			v_status="";	
			if (rs.next())
			{
				id=rs.getString("id"); 
				v_source_ssd=rs.getString("SOURCE_SSD"); //add by Peggy 20180831
				v_cancel_move_flag=rs.getString("CANCEL_MOVE_FLAG");  //add by Peggy 20230508
				v_status=rs.getString("STATUS"); //add by Peggy 20230519
				if ((String)hashtb.get(id)==null)
				{
					fact_cfm[i-1][0] = id;
					fact_cfm[i-1][1] = strarray[2];
					fact_cfm[i-1][2] = strarray[3];
					fact_cfm[i-1][3] = strarray[4];
					fact_cfm[i-1][4] = strarray[5];		
					
					sql = " insert into oraddman.tsc_om_salesorderrevise_u"+
						   " values(?,?,?,?,?,to_date(?,'yyyy/mm/dd'),?,?,sysdate,?)";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,V_BATCH_ID);
					pstmtDt.setString(2,strarray[0]);
					pstmtDt.setString(3,rs.getString("temp_id"));
					pstmtDt.setString(4,rs.getString("seq_id")); 
					pstmtDt.setString(5,strarray[2]);
					pstmtDt.setString(6,strarray[3]);
					pstmtDt.setString(7,strarray[4]);
					pstmtDt.setString(8,strarray[5]);
					pstmtDt.setString(9,UserName);
					pstmtDt.executeQuery();
					pstmtDt.close();						
				}
				else
				{
					strarray[6]="Data Duplicate";
					err_cnt ++;
				}
			}
			else
			{
				strarray[6]="no Data found";
				err_cnt ++;
			}
			rs.close();
			statement.close();  				

			if (strarray[2] == null || strarray[2] .equals(""))
			{
				strarray[6]="Qty can not be empty";
				err_cnt ++;
			}
			if (Double.valueOf(strarray[2]).doubleValue() >0)
			{
				if (strarray[3] == null || strarray[3] .equals(""))
				{
					strarray[6]="SSD can not be empty";
					err_cnt ++;
				}	
				else if (strarray[3].length()!=8)
				{
					strarray[6]="SSD format error";
					err_cnt ++;			
				}
				else if (strarray[4] != null && !strarray[4].toUpperCase().startsWith("REJ") && Long.parseLong(v_source_ssd)!= Long.parseLong(strarray[3]) && Long.parseLong(strarray[3]) < Long.parseLong(strDate))
				{
					strarray[6]="SSD error";
					err_cnt ++;			
				}
				else
				{
					v_year = Integer.parseInt(strarray[3].substring(1,4));
					v_month = Integer.parseInt(strarray[3].substring(4,6));
					v_day = Integer.parseInt(strarray[3].substring(6,8));
					if (v_month >12 || v_month<1)
					{
						strarray[6]="SSD month error("+strarray[3]+"-"+strarray[3].substring(4,6)+")";
						err_cnt ++;					
					}
					else if ((v_month ==1 || v_month ==3 || v_month ==5 || v_month ==7  || v_month ==8  || v_month ==10  || v_month ==12) && v_day >31)
					{
						strarray[6]="1.SSD error("+v_month+v_day+")";
						err_cnt ++;					
					}
					else if ((v_month ==4 || v_month ==6 || v_month ==9  || v_month ==11) && v_day >30)
					{
						strarray[6]="2.SSD error("+v_month+v_day+")";
						err_cnt ++;	
					}
					else if (((v_year % 4 !=0 || v_year % 100 ==0) || (v_year%400 != 0)) && v_month ==2 && v_day>28) 
					{
						strarray[6]="3.SSD error("+v_month+v_day+")";
						err_cnt ++;					
					}
				}
			}
			if (strarray[4] == null || (!strarray[4].toUpperCase().equals("OK") && !strarray[4].toUpperCase().startsWith("REJ")))
			{
				strarray[6]="The result must be a  [OK] or [Reject] value";
				err_cnt ++;
			}
			else if (strarray[4].toUpperCase().startsWith("REJ") && (strarray[5]==null || strarray[5].trim().equals("")))
			{
				strarray[6]="Please input a reject reason";
				err_cnt ++;
			}
			else if (strarray[4].toUpperCase().startsWith("REJ") && v_cancel_move_flag.equals("1")) //add by Peggy 20230508
			{
				strarray[6]="This order is the first cancellation/movement, you can only agree";
				err_cnt ++;			
			}
			else if (FACT.equals("002") && strarray[4].toUpperCase().startsWith("OK") && (strarray[5]!=null && !strarray[5].trim().equals("")))
			{
				//strarray[6]="Please not input remarks when the value of pc result field is ok";
				//err_cnt ++;
			}
			else if (v_status.equals(STATUS1))
			{
				strarray[6]="This order is awaiting for sales head to approve,you can not confirm";
				err_cnt ++;				
			}
			else if (!v_status.equals(STATUS) && !v_status.equals(STATUS1))
			{
				strarray[6]="This order has confirmed";
				err_cnt ++;				
			}			
			if ( rec_cnt==0)
			{
			%>
			<table width="100%">
				<tr bgcolor="#99CC99">
					<td width="12%">Request No </td>
					<td width="7%">Seq No</td>
					<td width="11%">Factory CFM Qty</td>
					<td width="11%">Factory CFM SSD</td>
					<td width="20%" colspan="2">Factory CFM Result</td>
					<td width="10%">Factory CFM Remarks</td>
					<td width="29%">Error Message</td>
				</tr>
			<%
			}
			
			%>
				<tr>
					<td><%=strarray[0]%></td>
					<td><%=strarray[1]%></td>
					<td><input type="text" name="qty_<%=id%>" value="<%=strarray[2]%>" style="font-family: Tahoma,Georgia;font-size:11px; text-align:right" size="7" readonly></td>
					<td><input type="text" name="ssd_<%=id%>" value="<%=strarray[3]%>" style="font-family: Tahoma,Georgia;font-size:11px; text-align:right" size="8" readonly></td>
					<td align="center"><input type="checkbox" name="chk" value="<%=id%>" checked readonly></td>
					<td><input type="radio" name="rdo_<%=id%>" value="A" <%=(strarray[4].toUpperCase().equals("OK")?" checked":"")%> style="font-family: Tahoma,Georgia;font-size:11px;">Accept&nbsp;&nbsp;<input type="radio" name="rdo_<%=id%>" value="R" <%=(strarray[4].toUpperCase().startsWith("REJ")?" checked":"")%> style="font-family: Tahoma,Georgia;font-size:11px;">Reject</td>
					<td><input type="text" name="pcremark_<%=id%>" value="<%=strarray[5]%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px" size="8" readonly></td>
					<td style="color:#FF0000"><%=(strarray[6]==null?"&nbsp;":strarray[6])%></td>
				</tr>
			<%
			rec_cnt++;
		}
		if (rec_cnt >0)
		{
		%>
			</table>
		<%
		}		
		wb.close();
		
		if (err_cnt ==0)
		{
			FactoryCFMBean.setArray2DString(fact_cfm);					
		%>
		<script language="JavaScript" type="text/JavaScript">
			window.opener.document.MYFORM.action="../jsp/TSSalesOrderReviseReply.jsp?ATYPE=UPD&BID="+document.SUBFORM.BATCHID.value;
			window.opener.document.MYFORM.submit();
			window.close();	
		</script>
		<%
			
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>Row#"+i+" Data Error"+e.getMessage()+"</div>");
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
