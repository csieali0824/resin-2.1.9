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
	window.opener.location.reload();
}
function setClose()
{
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
int sheetRows=0,sheetsline=7,i=0,j=0,k=0,rec_cnt=0,err_cnt=0,succ_cnt=0;
Hashtable hashtb = new Hashtable();
String strRfq="",strRfqLine="",strRfqDate="",strErr="",strRfq1="",v_new_ssd="",sToStatusID="",sToStatusName="",newShipDate="",newshipmethod="";
String fromStatusID="004",actionID="009";
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
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSSalesDRQArrangedPagePCUpload.jsp?ACTION=UPLOAD")'>
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
	
		String sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='886' and FORMID='TS'";
		Statement getStatusStat=con.createStatement();  
		ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
		if (getStatusRs.next()) 
		{
			sToStatusID = getStatusRs.getString("TOSTATUSID");
			sToStatusName = getStatusRs.getString("STATUSNAME");
		}
		getStatusStat.close();
		getStatusRs.close();  
		
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D1-004("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
										
		for (i = sheetsline ; i <=sheetRows; i++) 
		{
			strErr="";
			jxl.Cell strCell= sht.getCell(1, i);  //rfq no
			strRfq = (strCell.getContents()).trim();
			if (i==sheetsline) strRfq1=strRfq;
			if (strRfq.equals("")) continue;
			
			strCell= sht.getCell(10, i);  //rfq no line
			strRfqLine = (strCell.getContents()).trim();
			if (strRfqLine.equals("")) continue;

			strCell= sht.getCell(16, i);  //rfq confirm date
			if (strCell.getType() == CellType.DATE)
			{				
				DateCell vdate = (DateCell)strCell;
				java.util.Date ReqDate  =  ((DateCell)strCell).getDate();
				SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
				strRfqDate=sy1.format(ReqDate); 
			}
			else
			{
				strRfqDate = (strCell.getContents()).trim();
				if (strRfqDate.length()!=10)
				{
					err_cnt++;
					strErr="日期格式錯誤";				
				}
			}
					
			if (strErr.equals("") && Long.parseLong(strRfqDate.replace("/",""))< Long.parseLong(dateBean.getYearMonthDay()))
			{
				err_cnt++;
				strErr="交期必須大於系統日";				
			}
			
			rec_cnt++;
			if (strErr.equals(""))
			{
				sql = " select a.*"+
                      ",tsc_get_china_to_tw_days(null,c.order_num,a.inventory_item_id,a.assign_manufact,a.tscustomerid,to_char(sysdate,'yyyymmdd'),a.cust_po_number)* CASE WHEN a.direct_ship_to_cust =1  and a.assign_manufact='002' THEN 0 ELSE 1 END  TOTW_DAYS"+					  
					  ",to_char(to_date(?,'yyyy/mm/dd'),'D') w_day"+
                      " from (select a.dndocno,a.tsareano,b.line_no,b.item_description,a.tscustomerid,b.inventory_item_id,b.pc_leadtime,b.assign_manufact,b.direct_ship_to_cust,b.lstatusid,to_date(?,'yyyy/mm/dd')-TO_DATE(b.pc_leadtime,'YYYYMMDD') over_days"+
                      "      ,(SELECT meaning  FROM fnd_lookup_values x WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD' and x.lookup_code=nvl(b.shipping_method,a.SHIPMETHOD)) shipping_method_name"+
					  "      ,nvl(b.order_type_id,a.order_type_id) order_type_id"+
					  "      ,nvl(b.CUST_PO_NUMBER,a.CUST_PO) cust_po_number"+ //add by Peggy 20220224
					  "      from oraddman.tsdelivery_notice a"+
					  "      ,oraddman.tsdelivery_notice_detail b"+
                      "      where a.dndocno=b.dndocno) a"+
					  ",oraddman.tsarea_ordercls c"+
					  " where a.order_type_id=c.otype_id(+)"+
					  " and a.tsareano=c.SAREA_NO(+)"+
                      " and a.dndocno=?"+
                      " and a.line_no=?";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,strRfqDate);
				statement.setString(2,strRfqDate);
				statement.setString(3,strRfq);
				statement.setString(4,strRfqLine);
				//out.println(sql);
				//out.println(strRfqDate);
				//out.println(strRfq);
				//out.println(strRfqLine);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{
					//out.println("**"+strRfq+"  "+strRfqLine +"    "+strErr);
					newshipmethod="";newShipDate=null;
					if (!rs.getString("lstatusid").equals(fromStatusID))
					{
						err_cnt++;
						strErr="非合法RFQ狀態";
					} 
					else if (rs.getString("tsareano").equals("001") && rs.getString("shipping_method_name").equals("SEA(C)"))
					{
						//err_cnt++;
						//strErr="TSCE SEA(C)不允許上傳CONFIRM";		
						newShipDate=null;newshipmethod="AIR(C)";			
						sql = " select  b.TSAREANO,a.ASSIGN_MANUFACT,a.CUST_REQUEST_DATE,a.SHIPPING_METHOD,c.ORDER_NUM,b.TSCUSTOMERID,nvl(a.fob,b.FOB_POINT) FOB_POINT,b.delivery_to_org "+
							  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,oraddman.TSDELIVERY_NOTICE b,oraddman.tsarea_ordercls c ,oraddman.tsprod_manufactory d,inv.mtl_system_items_b e "+
							  " where a.DNDOCNO=?"+
							  " and to_char(a.LINE_NO)=?"+
							  " and a.SHIPPING_METHOD=?"+
							  " and to_date(?,'yyyymmdd')+ ? > to_date(substr(a.REQUEST_DATE,1,8),'yyyymmdd') "+
							  " and abs(to_date(?,'yyyymmdd')+ ? +tsce_get_fob_term_days(a.SHIPPING_METHOD,a.FOB,c.ORDER_NUM,d.ALNAME,'OC',b.tscustomerid,null,b.delivery_to_org)-TO_DATE(SUBSTR(a.CUST_REQUEST_DATE,1,8),'yyyymmdd'))>2"+
							  " and a.dndocno =b.dndocno"+
							  " and b.TSAREANO=c.SAREA_NO"+
							  " and a.ORDER_TYPE_ID=c.OTYPE_ID"+
 							  " and a.ASSIGN_MANUFACT=d.MANUFACTORY_NO"+
							  " and a.inventory_item_id=e.inventory_item_id"+
							  " and e.organization_id=?"+
							  " and tsc_freight_rule_chk(b.TSAREANO, e.inventory_item_id,?,'CHKFLAG')='1'"; 
						//out.println(sql);
						//out.println(strRfq);
						//out.println(strRfqLine);
						//out.println(strRfqDate.replace("/",""));
						//out.println(rs.getInt("TOTW_DAYS"));
						PreparedStatement statex = con.prepareStatement(sql);
						statex.setString(1,strRfq);
						statex.setString(2,strRfqLine);
						statex.setString(3,rs.getString("shipping_method_name"));
						statex.setString(4,strRfqDate.replace("/",""));
						statex.setInt(5,rs.getInt("TOTW_DAYS"));
						statex.setString(6,strRfqDate.replace("/",""));
						statex.setInt(7,rs.getInt("TOTW_DAYS"));
						statex.setInt(8,49);
						statex.setString(9,newshipmethod);
						ResultSet rsx=statex.executeQuery();
						if (rsx.next())
						{
							CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");
							//out.println(rsx.getString("TSAREANO"));
							//out.println(rsx.getString("ASSIGN_MANUFACT"));
							//out.println(rsx.getString("CUST_REQUEST_DATE"));
							//out.println(rsx.getString("ORDER_NUM"));
							//out.println(rsx.getString("TSCUSTOMERID"));
							//out.println(rsx.getString("FOB_POINT"));
							//out.println(rsx.getString("delivery_to_org"));
							csg.setString(1,rsx.getString("TSAREANO"));
							csg.setString(2,rsx.getString("ASSIGN_MANUFACT"));      
							csg.setString(3,rsx.getString("CUST_REQUEST_DATE"));                   
							csg.setString(4,newshipmethod);    
							csg.setString(5,rsx.getString("ORDER_NUM"));   
							csg.registerOutParameter(6, Types.VARCHAR);  
							csg.setString(7,rsx.getString("TSCUSTOMERID"));   
							csg.setString(8,rsx.getString("FOB_POINT"));   //add by Peggy 20210207 
							csg.setString(9,rsx.getString("delivery_to_org"));   //add by Peggy 20210207 
							csg.execute();
							newShipDate = (csg.getString(6)==null?"":csg.getString(6)); 
							//out.println("Line:"+strRfqLine+"   newShipDate="+newShipDate);
							csg.close();
						}
						rsx.close();
						statex.close();								
							  				
					}
					else if (rs.getString("tsareano").equals("008") && rs.getString("shipping_method_name").equals("SEA(UC)"))
					{
						//err_cnt++;
						//strErr="TSCA SEA(UC)不允許上傳CONFIRM";	
						newShipDate=null;newshipmethod="AIR(UC)";			
						sql = " select '1' as  data_type, b.TSAREANO,a.ASSIGN_MANUFACT,a.CUST_REQUEST_DATE,f.meaning SHIPPING_METHOD,c.ORDER_NUM,b.TSCUSTOMERID ,tsc_om_category(e.inventory_item_id,49,'TSC_Package') tsc_package,tsc_om_category(e.inventory_item_id,49,'TSC_Family') tsc_family"+
							  ",TSCA_GET_ORDER_SSD(c.ORDER_NUM,?,SUBSTR(a.CUST_REQUEST_DATE,1,8),'CRD',trunc(sysdate),null) NEW_SSD"+ 
							  ",(SELECT lookup_code  FROM fnd_lookup_values lv WHERE  language ='US' AND view_application_id = 3  AND lookup_type = 'SHIP_METHOD' AND security_group_id = 0 and meaning=?) NEW_SHIPPING_METHOD"+
							  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,oraddman.TSDELIVERY_NOTICE b,oraddman.tsarea_ordercls c,inv.mtl_system_items_b e,"+
							  " (SELECT lookup_code, meaning,description,enabled_flag,start_date_active,end_date_active FROM fnd_lookup_values lv"+
							  " WHERE  language ='US' AND view_application_id = 3   AND lookup_type = 'SHIP_METHOD' AND security_group_id = 0) f"+
							  " where a.DNDOCNO=? "+
							  " and to_char(a.LINE_NO)=?"+ 
							  " and a.SHIPPING_METHOD=f.lookup_code"+
							  " and f.meaning=?"+
							  " and to_date(?,'yyyymmdd')+? > to_date(substr(a.REQUEST_DATE,1,8),'yyyymmdd') "+
							  " and a.dndocno =b.dndocno"+
							  " and a.inventory_item_id=e.inventory_item_id"+
							  " and e.organization_id=?"+
							  " and b.TSAREANO=c.SAREA_NO"+
							  " and a.ORDER_TYPE_ID=c.OTYPE_ID"+
							  " and TO_DATE(SUBSTR(a.CUST_REQUEST_DATE,1,8),'yyyymmdd')-to_date(?,'yyyymmdd') +? < tsc_freight_rule_chk(b.TSAREANO, e.inventory_item_id,f.meaning,'START_DAY')"+ 
							  " and tsc_freight_rule_chk(b.TSAREANO, e.inventory_item_id,?,'CHKFLAG')='1'"+
							  " order by 1";
						//out.println(sql);
						PreparedStatement statex = con.prepareStatement(sql);
						statex.setString(1,newshipmethod);
						statex.setString(2,newshipmethod);
						statex.setString(3,strRfq);
						statex.setString(4,strRfqLine);
						statex.setString(5,rs.getString("shipping_method_name"));
						statex.setString(6,strRfqDate.replace("/",""));
						statex.setInt(7,rs.getInt("TOTW_DAYS"));
						statex.setInt(8,49);
						statex.setString(9,strRfqDate.replace("/",""));
						statex.setInt(10,rs.getInt("TOTW_DAYS"));
						statex.setString(11,newshipmethod);
						ResultSet rsx=statex.executeQuery();						
						if (rsx.next())
						{
							newShipDate = rsx.getString("new_ssd");
							newshipmethod=rsx.getString("NEW_SHIPPING_METHOD");
						} 										
						rsx.close();
						statex.close();							
					}
					else if (rs.getInt("TOTW_DAYS")>0)
					{
						if (rs.getString("ORDER_TYPE_ID").equals("1015") && rs.getInt("W_DAY")!=3)
						{
							err_cnt++;
							strErr="回T樣品訂單工廠出貨日必須confirm周二日期";
						}
						else if (!rs.getString("ORDER_TYPE_ID").equals("1015") && rs.getInt("W_DAY")!=2)
						{
							err_cnt++;
							strErr="回T訂單工廠出貨日必須confirm周一日期";
						}
					}
					//else if (rs.getInt("over_days")>0)
					//{
					//	err_cnt++;
					//	strErr="Over L/T:"+rs.getString("pc_leadtime");					
					//} 
					
					if (strErr.equals(""))
					{
						try
						{
							sql = "insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY"+
								  "(DNDOCNO"+
								  ",ORISTATUSID"+
								  ",ORISTATUS"+
								  ",ACTIONID"+
								  ",ACTIONNAME"+
								  ",UPDATEUSERID"+
								  ",UPDATEDATE"+
								  ",UPDATETIME"+
								  ",ASSIGN_FACTORY"+
								  ",CDATETIME"+
								  ",SERIALROW"+
								  ",LINE_NO"+
								  ",PROCESS_WORKTIME"+
								  ",ARRANGED_DATE"+
								  ")"+
								  " select a.dndocno"+
								  ",a.lstatusid"+
								  ",a.lstatus"+
								  ",?"+
								  ",(select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID=?)"+
								  ",?"+
								  ",to_char(sysdate,'yyyymmdd')"+
								  ",TO_CHAR(SYSDATE,'hh24miss')"+
								  ",a.ASSIGN_MANUFACT"+
								  ",TO_CHAR(SYSDATE,'yyyymmddhh24miss')"+
								  ",(select count(1)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no)"+
								  ",a.line_no"+
								  ",(select round((sysdate-to_date(CDATETIME,'yyyymmddhh24miss'))*24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no and x.ORISTATUSID ='003')"+
								  ",replace(?,'/','')"+
								  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
								  " where a.DNDOCNO=?"+
								  " and a.LINE_NO=?"+
								  " and a.LSTATUSID=?";
							PreparedStatement pstmtDt=con.prepareStatement(sql);  
							pstmtDt.setString(1,actionID);
							pstmtDt.setString(2,actionID);
							pstmtDt.setString(3,userID);
							pstmtDt.setString(4,strRfqDate); 
							pstmtDt.setString(5,rs.getString("dndocno"));
							pstmtDt.setString(6,rs.getString("line_no"));
							pstmtDt.setString(7,fromStatusID);
							pstmtDt.executeQuery();
							pstmtDt.close();	
							
							sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
								" set ORIG_SHIPPING_METHOD=NVL2(?,nvl(ORIG_SHIPPING_METHOD,SHIPPING_METHOD),ORIG_SHIPPING_METHOD)"+
								",ORIG_SSD=NVL2(?,nvl(ORIG_SSD,REQUEST_DATE),ORIG_SSD)"+								
								",PROMISE_DATE=nvl(?,PROMISE_DATE)"+
								",REQUEST_DATE=NVL(?,REQUEST_DATE)"+
								",SHIPPING_METHOD=NVL2(?,?,SHIPPING_METHOD)"+
								" where a.DNDOCNO=?"+
								" and a.LINE_NO=?"+
								" and a.LSTATUSID=?";	
							PreparedStatement pstmt=con.prepareStatement(sql);          
							pstmt.setString(1,newShipDate);
							pstmt.setString(2,newShipDate);
							pstmt.setString(3,newShipDate);
							pstmt.setString(4,newShipDate);
							pstmt.setString(5,newShipDate);
							pstmt.setString(6,newshipmethod);
							pstmt.setString(7,rs.getString("dndocno"));
							pstmt.setString(8,rs.getString("line_no"));
							pstmt.setString(9,fromStatusID);
							pstmt.executeQuery();
							pstmt.close();  				
							
							sql = " select tsc_rfq_recheck_ssd(a.DNDOCNO,a.LINE_NO,to_char(to_date(?,'yyyy/mm/dd')+(nvl(?,0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id=?),1)),'yyyymmdd'),(nvl(?,0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id=?),1)),nvl(a.ORDER_TYPE_ID,(select x.ORDER_TYPE_ID from oraddman.tsdelivery_notice x where x.dndocno=?))) from oraddman.tsdelivery_notice_detail a where a.dndocno=? and a.line_no=?";//modify by Peggy 20200930
							PreparedStatement statementb = con.prepareStatement(sql);
							statementb.setString(1,strRfqDate); 
							statementb.setInt(2,rs.getInt("TOTW_DAYS")); 
							statementb.setString(3,"0");        
							statementb.setInt(4,rs.getInt("TOTW_DAYS")); 
							statementb.setString(5,"0");        
							statementb.setString(6,rs.getString("dndocno"));
							statementb.setString(7,rs.getString("dndocno"));
							statementb.setString(8,rs.getString("line_no"));
							ResultSet rsb=statementb.executeQuery();	
							if (rsb.next())
							{	
								v_new_ssd = rsb.getString(1);
							}
							else
							{
								v_new_ssd = "ERROR";
							}
							rsb.close();
							statementb.close();
								
							sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
								" set a.LAST_UPDATED_BY=?"+
								",a.LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
								",a.LSTATUSID=?"+
								",a.LSTATUS=?"+
								",a.FTACPDATE=to_char(to_date(?,'yyyy/mm/dd'),'yyyymmdd')"+
								",SHIP_DATE=?"+
								",PC_OVER_LEADTIME_REASON=case when ?>0 then '需購買芯片' else '' end "+ //add by Peggy 20210621
								",ORIG_PC_SSD=NVL2(?,?,ORIG_PC_SSD)"+	
								" where a.DNDOCNO=?"+
								" and a.LINE_NO=?"+
								" and a.LSTATUSID=?";	
							pstmt=con.prepareStatement(sql);          
							pstmt.setString(1,userID);
							pstmt.setString(2,sToStatusID);
							pstmt.setString(3,sToStatusName);
							pstmt.setString(4,strRfqDate);
							pstmt.setString(5,v_new_ssd);				
							pstmt.setInt(6,rs.getInt("over_days")); 
							pstmt.setString(7,newShipDate);
							pstmt.setString(8,v_new_ssd);				
							pstmt.setString(9,rs.getString("dndocno"));
							pstmt.setString(10,rs.getString("line_no"));
							pstmt.setString(11,fromStatusID);
							pstmt.executeQuery();
							pstmt.close();  				
								
							sql=" update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=to_char(sysdate,'yyyymmddhh24miss'),LAST_UPDATED_BY=?,LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss') "+
								" where DNDOCNO=? ";     
							pstmt=con.prepareStatement(sql);          
							pstmt.setString(1,userID);
							pstmt.setString(2,rs.getString("dndocno"));
							pstmt.executeQuery();
							pstmt.close();  	     

							con.commit();
							succ_cnt ++;
							
						}
						catch(Exception e)
						{
							con.rollback();
							err_cnt++;
							strErr=e.getMessage();	
							//out.println(e.getMessage());				
						}
					}	
				}
				else
				{				
					err_cnt++;
					strErr="Not found";					
				}
				rs.close();
				statement.close();  				
			}	
			//out.println(strRfq+"  "+strRfqLine +"    "+strErr);
			if (!strErr.equals(""))
			{
				hashtb.put(strRfq+("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#"+strRfqLine)+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+strErr,"");
			}			
		}

		out.println("<div style='color:#0000ff;font-family:Tahoma,Georgia;font-size:12px'>上傳筆數:"+(rec_cnt)+"   成功筆數:"+succ_cnt+"    失敗筆數:"+(rec_cnt-succ_cnt)+"</div>");
		if (hashtb!=null)
		{
			Enumeration enkey  = hashtb.keys(); 
			while (enkey.hasMoreElements())   
			{
				out.println("<div style='color:#FF0000;font-family:Tahoma,Georgia;font-size:12px'>"+enkey.nextElement().toString()+"</div>");
			} 
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause.."+e.getMessage()+"</div>");
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
