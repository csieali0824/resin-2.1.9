<!-- 20150209 Peggy,�L��3292,�_�s��3867,�@�����2012�T�a�H���p��-->
<!-- 20150608 Peggy,�خ��q�l3915�H���p��-->
<!-- 20160914 Peggy,�s�Wbill_sequence_id-->
<!-- 20161107 Peggy,�s�WPRD�~�]-->
<!-- 20170817 Peggy,�s�W�Ȥ��o�ƿﶵ-->
<!-- 20171012 Peggy,�s�WRD3�u�{�J�w���-->
<!-- 20180131 Peggy,Date Code=HOLD,LINE#�q100�s�_,�H�Q�Ƨ�-->
<!-- 20180724 Peggy,�s�W�����������for4056�Ѥ��ؤѶ���-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<title>PMD OEM Process</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.PMDFORM.action=URL;
	document.PMDFORM.submit();
}
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<FORM ACTION="TSCPMDOEMProcess.jsp" METHOD="post" NAME="PMDFORM">
<%
try
{
	String REQUESTNO = request.getParameter("REQUESTNO");
	if (REQUESTNO==null) REQUESTNO="";
	String VERSIONID = request.getParameter("VERSIONID");
	if (VERSIONID==null) VERSIONID="";
	String ORIGVERSIONID = request.getParameter("ORIGVERSIONID");
	if (ORIGVERSIONID==null) ORIGVERSIONID="";
	String WIPTYPE = request.getParameter("WIPTYPE");
	if (WIPTYPE ==null) WIPTYPE ="";
	String ISSUEDATE = request.getParameter("ISSUEDATE");
	if (ISSUEDATE ==null) ISSUEDATE="";
	String CREATOR = request.getParameter("CREATOR");
	if (CREATOR == null) CREATOR=UserName;
	String CREATEDATE= request.getParameter("CREATEDATE");
	if (CREATEDATE == null) CREATEDATE="";
	String CREATORID = request.getParameter("CREATORID");
	if (CREATORID==null) CREATORID=userID;
	String SUPPLIERNO = request.getParameter("SUPPLIERNO");
	if (SUPPLIERNO==null) SUPPLIERNO="";
	String SUPPLIERNAME = request.getParameter("SUPPLIERNAME");
	if (SUPPLIERNAME==null) SUPPLIERNAME="";
	String SUPPLIERCONTACT = request.getParameter("SUPPLIERCONTACT");
	if (SUPPLIERCONTACT==null) SUPPLIERCONTACT="";
	String CHKASSEMBLY = request.getParameter("CHKASSEMBLY");
	if (CHKASSEMBLY==null) CHKASSEMBLY="N";
	String CHKTESTING = request.getParameter("CHKTESTING");
	if (CHKTESTING==null) CHKTESTING="N";
	String CHKTAPING = request.getParameter("CHKTAPING");
	if (CHKTAPING==null) CHKTAPING="N";
	String CHKLAPPING = request.getParameter("CHKLAPPING");
	if (CHKLAPPING==null) CHKLAPPING="N";
	String FSM = request.getParameter("FSM");
	if (FSM == null) FSM="N";
	String RINGCUT = request.getParameter("RINGCUT");
	if (RINGCUT == null) RINGCUT="N";	
	String CHKOTHERS = request.getParameter("CHKOTHERS");
	if (CHKOTHERS==null) CHKOTHERS="N";
	String OTHERS = request.getParameter("OTHERS");
	if (OTHERS==null) OTHERS="";
	String ITEMID = request.getParameter("ITEMID");
	if (ITEMID==null) ITEMID="";
	String ITEMNAME = request.getParameter("ITEMNAME");
	if (ITEMNAME==null) ITEMNAME="";
	String ITEMDESC = request.getParameter("ITEMDESC");
	if (ITEMDESC==null) ITEMDESC="";
	String PACKAGE = request.getParameter("PACKAGE");
	if (PACKAGE==null || PACKAGE.equals("--") || PACKAGE.equals("null")) PACKAGE = "";
	String DIENAME = request.getParameter("DIENAME");
	if (DIENAME==null) DIENAME="";
	String [] DIE_NAME = DIENAME.split(",");
	String DIEID = request.getParameter("DIEID");
	if (DIEID==null) DIEID="";
	String [] DIE_ID = DIEID.split(",");
	String DIE_QTY = request.getParameter("DIEQTY");
	if (DIE_QTY ==null) DIE_QTY = "1";  //add by Peggy 20121009
	String QTY = request.getParameter("QTY");
	if (QTY==null) QTY="";
	String UNITPRICE = request.getParameter("UNITPRICE");
	if (UNITPRICE==null) UNITPRICE="";
	String PACKING = request.getParameter("PACKING");
	if (PACKING==null || PACKING.equals("--") || PACKING.equals("null"))PACKING = "";
	String PACKAGESPEC = request.getParameter("PACKAGESPEC");
	if (PACKAGESPEC==null) PACKAGESPEC="";
	String TESTSPEC = request.getParameter("TESTSPEC");
	if (TESTSPEC==null) TESTSPEC="";
	String REMARKS=request.getParameter("REMARKS");
	String MARKING= request.getParameter("MARKING");
	if (MARKING ==null) MARKING="";
	String LINENUM=request.getParameter("LINENUM");
	String PROGRAMNAME = request.getParameter("PROGRAMNAME");
	if (PROGRAMNAME == null) PROGRAMNAME="";
	String ACTIONID = request.getParameter("ACTIONID");
	if (ACTIONID ==null) ACTIONID="";
	String APPROVE_REMARKS = request.getParameter("approvemark");
	if (APPROVE_REMARKS==null) APPROVE_REMARKS = "";
	String SUBINVENTORY = request.getParameter("SUBINVENTORY");
	if (SUBINVENTORY ==null) SUBINVENTORY="";
	String CURRENCYCODE = request.getParameter("CURRENCYCODE");
	if (CURRENCYCODE ==null) CURRENCYCODE="";
	String WIPNO = request.getParameter("WIPNO");
	if (WIPNO==null) WIPNO="";
	String PRNO=request.getParameter("PRNO");
	if (PRNO==null) PRNO="";
	String PONO=request.getParameter("PONO");
	if (PONO==null) PONO="";
	String WIPID= request.getParameter("WIPID");
	if (WIPID ==null) WIPID="";
	String PRICEUOM = request.getParameter("PRICE_UOM");
	if (PRICEUOM == null) PRICEUOM="";  //add by Peggy 20120705
	String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
	if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  //add by Peggy 20120705
	String totChipQty = request.getParameter("totChipQty");
	if (totChipQty==null) totChipQty="0";
	String WaferLot="",ChipQty="",WaferQty="",DateCode="",RequestSD="",statuscode="",strURL="",Stock="",INVITEM="",INVITEMID="",sql="",TRANS_SOURCE_ID="",LineNo="",WIP_ISSUE_LINE_FLAG="",WaferNumber="",DC_YYWW="",DIE_MODE="";
	String WIPMODIFY="MODIFY",WIPCHANGE="CHANGE";
	String INV_TIME="";
	String BILLSEQID = request.getParameter("BILLSEQID"); //add by Peggy 20160914
	if (BILLSEQID==null || BILLSEQID.equals("null")) BILLSEQID="";
	String PROD_GROUP=request.getParameter("PROD_GROUP");
	if (PROD_GROUP==null) PROD_GROUP=""; //add by Peggy 20161107   
	String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
	String COMPLETEDATE= request.getParameter("COMPLETEDATE");
	if (COMPLETEDATE==null) COMPLETEDATE="";  //add by Peggy 20170817
	String WIP_ISSUE_FLAG=request.getParameter("WIP_ISSUE_FLAG");
	if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG="N"; //add by Peggy 20170817
	String ERR_DC_LIST=""; //add by Peggy 20220407
	String REQLIST=request.getParameter("REQLIST");	
	if (REQLIST==null) REQLIST="";
	String CHANGE_REASON=request.getParameter("CHANGE_REASON"); //add by Peggy 20240529
	if (CHANGE_REASON==null) CHANGE_REASON="";	
	int data_cnt=0,s_week=-1,s_month=-1,e_week=-1,e_month=-1,s_year=-1,e_year=-1;
	
	// ���s�J����榡��US�Ҷq,�N�y�t���]������
	String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	pstmtNLS.executeUpdate(); 
	pstmtNLS.close();
	
	if (PROGRAMNAME.equals("F1-004"))  //add by Peggy 20121222
	{
		String [] check=request.getParameterValues("CHKBOX");
		String INV_DATE = "";
		if (check !=null)
		{
			try
			{
				for (int i=0;i<check.length;i++) 
				{ 
					if (i ==0)
					{
						out.println("<table width='100%'>");
						out.println("<tr><td width='30%'>&nbsp;</td>");
						out.println("<td>");
						out.println("<table align='center' width='100%' border='1' cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1'>");
						out.println("<tr><td style='font-family:�з���;color:'#000000'>�u�渹�X</td><td style='font-family:�з���;color:'#000000'>��ưʧ@</td></tr>");
					}
					INV_DATE = request.getParameter("date"+check[i]);
					REQUESTNO = request.getParameter("REQUESTNO"+check[i]);
					VERSIONID = request.getParameter("VERSIONID"+check[i]);
					WIPNO = request.getParameter("WIPNO"+check[i]);
					if (request.getParameter("ORIGINVDATE"+check[i])==null || request.getParameter("ORIGINVDATE"+check[i]).equals("null") || request.getParameter("ORIGINVDATE"+check[i]).equals(""))
					{
						INV_TIME = request.getParameter("RELEASEDDATE"+check[i]);
					}
					else
					{
						INV_TIME = request.getParameter("ORIGINVDATE"+check[i]);
					}
					sql=" update oraddman.tspmd_oem_headers_all "+
						" set INV_DATE = case when "+ INV_DATE+">"+INV_TIME.substring(0,8)+" or "+INV_TIME.substring(0,8)+" = to_char(sysdate,'yyyymmdd') then '"+INV_DATE+"' || to_char(sysdate,'hh24miss') else to_char(to_date('"+INV_DATE+INV_TIME.substring(8,14)+"','yyyymmddhh24miss')+1/1440,'yyyymmddhh24miss') end"+
						",INV_BY=?"+
						",LAST_UPDATE_DATE=sysdate"+
						",LAST_UPDATED_BY=?"+
						" where REQUEST_NO='" + REQUESTNO+"' and VERSION_ID='"+VERSIONID+"'";
					//out.println(sql);
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,userID);           //�o�ƤH��
					pstmt.setString(2,userID);           //�̫Ყ�ʪ�
					pstmt.executeUpdate();
					pstmt.close();
					con.commit();
					
					/*
					CallableStatement cs3 = con.prepareCall("{call TSC_PMD_OEM_PKG.WIP_TRANSACTIONS(?,?,?)}");	//add by Peggy 20121224	 
					cs3.setString(1,REQUESTNO); 
					cs3.setInt(2,Integer.parseInt(VERSIONID)); 
					cs3.registerOutParameter(3, Types.VARCHAR);
					cs3.execute();
					String WIP_MISC_Status = cs3.getString(3);
					cs3.close();
					out.println("<tr><td>"+WIPNO+"</td><td>"+(WIP_MISC_Status.equals("S")?"<font style='color:#0000ff;font-family:�з���'>���\</font>":"<font style='color:#ff0000;font-family:�з���'>����</font>")+"</td></tr>");
					*/
				}
				out.println("</table></td><td width='30%'>&nbsp;</td></tr>");
				out.println("<tr height='100'><td>&nbsp;</td><td align='center'><A href='/oradds/ORADDSMainMenu.jsp'><font style='font-size:18px;font-family:�з���'>�^����</font></A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='TSCPMDOEMInventoryTransaction.jsp'><font style='font-size:18px;font-family:�з���'>�^�u���ƽT�{�e��</font></A></td><td>&nbsp;</td></table>");
			}
			catch(Exception e)
			{
				out.println("��ƥ������,�Ь��t�κ޲z�H��,����!("+e.getMessage()+")");
				con.rollback();
			}
		} 
	}
	else
	{
		try
		{
			String sqla = " SELECT  a.type_name  FROM oraddman.tspmd_data_type_tbl a  where DATA_TYPE='ACTION'  AND TYPE_NO='"+ACTIONID+"'  AND STATUS_FLAG='A'";
			Statement statementa=con.createStatement();
			ResultSet rsa=statementa.executeQuery(sqla);
			if (rsa.next())
			{
				statuscode = rsa.getString("type_name");
			}
			else
			{
				if (!ACTIONID.equals("006") &&  !ACTIONID.equals("007"))
				{
					throw new Exception("�d�Lstatus code!!");
				}
			}
			rsa.close();
			statementa.close();
		}
		catch(Exception e)
		{
			ACTIONID=""; //�M��ACTIONID
			out.println("Exception1:"+e.getMessage());
		}
		
		//�����s�ɫ�^�_		   
		//�e�X��Z or �e�X�ӽ�
		if (ACTIONID.equals("001") || ACTIONID.equals("002"))
		{
			if (WIPTYPE.equals("01") || WIPTYPE.equals("02"))
			{
				//�ˬd������ add by Peggy 20130522
				if (WIPTYPE.equals("01"))  //�q��
				{
					String sourcePriceUom="";
					sql = " SELECT distinct decode( LOWER(a.uom),'kpcs','k',LOWER(a.uom)) UOM FROM oraddman.tspmd_item_quotation a  "+
						  " where a.vendor_code ='"+SUPPLIERNO+"'"+
						  " and a.inventory_item_id ='"+ ITEMID+"'"+
						  " and a.VENDOR_SITE_ID='"+VENDOR_SITE_ID +"'";
					Statement statement1=con.createStatement();
					ResultSet rs1=statement1.executeQuery(sql);
					if (rs1.next())
					{
						 sourcePriceUom = rs1.getString("uom");
					}
					rs1.close();
					statement1.close();
					
					if (!PRICEUOM.equals(sourcePriceUom) || PRICEUOM.equals(""))
					{
						throw new Exception("��������~,���T����"+sourcePriceUom+"!!");
					}
				}
				else if (WIPTYPE.equals("02")) //�u�{
				{
					if (!PACKAGE.toUpperCase().equals("WAFER"))
					{
						//if (CURRENCYCODE.equals("TWD") && !PRICEUOM.toLowerCase().equals("ea"))
						if (CURRENCYCODE.equals("TWD") && !PRICEUOM.toLowerCase().equals("ea") && !SUPPLIERNO.equals("3292") && !SUPPLIERNO.equals("3867") && !SUPPLIERNO.equals("2012") && !SUPPLIERNO.equals("3915") && !SUPPLIERNO.equals("3212")  && !SUPPLIERNO.equals("4682"))  //add 3212�Z�� by Peggy 20201201,add 4682�L�� by Peggy 20220516
						{
							throw new Exception("��������~,���T����ea!!");
						}
						else if (!CURRENCYCODE.equals("TWD") && PRICEUOM.toLowerCase().equals("ea"))
						{
							throw new Exception("��������~,���T����k!!");
						}
					}
				}
				//else if (WIPTYPE.equals("03") && !PRICEUOM.toLowerCase().equals("k")) //���u
				//{
				//	throw new Exception("��������~,���T����k!!");
				//}
				
				if (!PACKAGE.equals("WAFER"))
				{
					if (VERSIONID.equals("0"))
					{
						//add by Peggy 20220407 check D/C
						sql = " select to_number(tsc_get_calendar_week(sysdate,'WEEK',null)) s_week"+
							  ",to_number(to_char(sysdate,'mm')) s_month"+
							  ",to_number(tsc_get_calendar_week(to_date(?,'yyyymmdd'),'WEEK',null)) e_week"+
							  ",to_number(to_char(to_date(?,'yyyymmdd'),'mm')) e_month"+
							  ",to_number(to_char(sysdate,'yyyy')) s_year "+
							  ",to_number(to_char(to_date(?,'yyyymmdd'),'yyyy')) e_year from dual";
					}
					else
					{	sql = " select to_number(tsc_get_calendar_week(CREATION_DATE,'WEEK',null)) s_week"+
							  ",to_number(to_char(CREATION_DATE,'mm')) s_month"+
							  ",to_number(tsc_get_calendar_week(to_date(?,'yyyymmdd'),'WEEK',null)) e_week"+
							  ",to_number(to_char(to_date(?,'yyyymmdd'),'mm')) e_month "+
							  ",to_number(to_char(CREATION_DATE,'yyyy')) s_year "+
							  ",to_number(to_char(to_date(?,'yyyymmdd'),'yyyy')) e_year "+
							  " from oraddman.tspmd_oem_headers_all "+
  						      " where REQUEST_NO=? and VERSION_ID=?";
					}
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,COMPLETEDATE);  //add by Peggy 20220713
					pstmt.setString(2,COMPLETEDATE);  //add by Peggy 20220713 
					pstmt.setString(3,COMPLETEDATE);  //add by Peggy 20220713 
					if (!VERSIONID.equals("0"))
					{					
						pstmt.setString(4,REQUESTNO);   
						pstmt.setString(5,ORIGVERSIONID); 
					}    
					ResultSet rs1=pstmt.executeQuery();	
					if (rs1.next())
					{
						s_week = rs1.getInt(1);
						s_month = rs1.getInt(2);
						e_week = rs1.getInt(3);
						e_month = rs1.getInt(4);
						s_year = rs1.getInt(5);
						e_year = rs1.getInt(6);
					}
					else
					{
						s_week=-1;s_month=-1;e_week=-1;e_month=-1;s_year=-1;e_year=-1;
					}
					rs1.close();
					pstmt.close();					
						  
					
					for (int i = 1 ; i <= Integer.parseInt(LINENUM) ;i++)
					{
						DateCode=request.getParameter("DateCode"+i);
						if (DateCode==null) DateCode="";
						if (DateCode.equals("") || DateCode.toUpperCase().equals("HOLD") || DateCode.toUpperCase().equals("NA") || DateCode.toUpperCase().equals("N/A")) continue;
						
						sql = " SELECT a.date_code, YEAR||CASE WHEN DATE_VALUE NOT BETWEEN ?||CASE WHEN DATE_TYPE='WEEK' THEN ? ELSE ? END AND ?||CASE WHEN DATE_TYPE='WEEK' THEN ? ELSE ? END THEN 0 ELSE 1 END CHK_FLAG,b.DATE_CODE_EXAMPLE"+
							  " FROM tsc.tsc_date_code a"+
							  ",oraddman.tspmd_item_date_code b"+
							  ",(select * from oraddman.ts_label_supplier_list x,ap_suppliers y where NVL(x.ACTIVE_FLAG,?)=? and x.ERP_VENDOR_ID=y.vendor_id and y.segment1=? ) c"+
							  " WHERE a.YEAR IN (?,?)"+
							  " AND a.PROD_GROUP IN (?,?,?)"+
							  " and a.dc_rule=b.date_code_rule"+
							  " AND b.item_description=?"+
							  " AND a.DATE_CODE=?"+
							  " AND a.PROD_GROUP=c.tsc_prod_group"+
							  //" AND DATE_VALUE BETWEEN CASE WHEN DATE_TYPE='WEEK' THEN ? ELSE ? END AND CASE WHEN DATE_TYPE='WEEK' THEN ? ELSE ? END "+
							  " AND c.SUPPLIER_CODE=NVL(A.FACTORY_CODE,c.SUPPLIER_CODE)"+
							  " ORDER BY YEAR,DATE_VALUE";
						pstmt=con.prepareStatement(sql);
						pstmt.setInt(1,s_year);  
						pstmt.setInt(2,s_week); 
						pstmt.setInt(3,s_month); 
						pstmt.setInt(4,e_year);  
						pstmt.setInt(5,e_week); 
						pstmt.setInt(6,e_month); 
						pstmt.setString(7,"I"); 
						pstmt.setString(8,"A"); 
						pstmt.setString(9,SUPPLIERNO); 
						pstmt.setInt(10,s_year);  
						pstmt.setInt(11,e_year);  
						pstmt.setString(12,"PRD"); 
						pstmt.setString(13,"PMD"); 
						pstmt.setString(14,"SSD"); 						
						pstmt.setString(15,ITEMDESC); 
						pstmt.setString(16,DateCode.replace("_","")); 
						rs1=pstmt.executeQuery();	
						if (!rs1.next())
						{
							ERR_DC_LIST += DateCode+"���ŦX"+ITEMDESC+" ��Date Code Rule<br>";
						}
						else if (rs1.getInt(2)==0)
						{
							ERR_DC_LIST += DateCode+"�P�O���~,�Э��s�T�{!<br>";
						}
						else if (rs1.getString(3)!=null)
						{
							if (rs1.getString(3).length()!=DateCode.length())
							{
								ERR_DC_LIST += ITEMDESC+" ��Date Code ���u��m���~<br>";
							}
							else
							{
								for (int x=0 ; x <DateCode.length() ; x++)
								{	
									if (DateCode.substring(x,x+1).equals("_") && !rs1.getString(3).substring(x,x+1).equals("_"))
									{
										ERR_DC_LIST += ITEMDESC+" ��Date Code ���u��m���~.<br>";
									}
									else if (!DateCode.substring(x,x+1).equals("_") && rs1.getString(3).substring(x,x+1).equals("_"))
									{
										ERR_DC_LIST += ITEMDESC+" ��Date Code ���u��m���~..<br>";
									}
								}
							}
						}
						rs1.close();
						pstmt.close();					
					}	
					if (ERR_DC_LIST.length()>0)
					{			
						throw new Exception(ERR_DC_LIST);
					}
				}
			}
		
			try
			{
				if (PROGRAMNAME.equals("F1-001") && REQUESTNO.equals(""))
				{
					//���o�ӽг渹
					CallableStatement cs3 = con.prepareCall("{call tsc_pmd_get_requestno(?,?)}");
					cs3.setString(1,"OEM"); 
					cs3.registerOutParameter(2, Types.VARCHAR);
					cs3.execute();
					REQUESTNO= cs3.getString(2);
					cs3.close();
				}
				else if (PROGRAMNAME.equals(WIPMODIFY) && !REQUESTNO.equals(""))
				{
					/*
					sql = " delete from oraddman.tspmd_oem_headers_all a  where a.REQUEST_NO =? and a.VERSION_ID =? and a.status ='Reject'";
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,REQUESTNO);   //�ӽг渹
					pstmt.setString(2,VERSIONID);   //����
					if (pstmt.executeUpdate()>0)
					{
						sql = " delete from oraddman.tspmd_oem_lines_all a  where a.REQUEST_NO =? and a.VERSION_ID =?";
						pstmt=con.prepareStatement(sql);
						pstmt.setString(1,REQUESTNO);   //�ӽг渹
						pstmt.setString(2,VERSIONID);   //����
						pstmt.executeUpdate();
					}
					else
					{
						throw new Exception("�ӽг檬�A���ŦX�ק����!!");
					}
					*/
					sql = " update oraddman.tspmd_oem_headers_all set LOCK_FLAG='Y' where REQUEST_NO =? and VERSION_ID =? and status ='Reject'";
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,REQUESTNO);   //�ӽг渹
					pstmt.setString(2,ORIGVERSIONID);   //����
					pstmt.executeUpdate();					
				}
				else if (PROGRAMNAME.equals(WIPCHANGE) && !REQUESTNO.equals(""))
				{
						sql = " update oraddman.tspmd_oem_headers_all set LOCK_FLAG='Y' where REQUEST_NO =? and VERSION_ID =? and status ='Approved'";
						PreparedStatement pstmt=con.prepareStatement(sql);
						pstmt.setString(1,REQUESTNO);   //�ӽг渹
						pstmt.setString(2,ORIGVERSIONID);   //����
						pstmt.executeUpdate();
				}
				sql=" insert into oraddman.tspmd_oem_headers_all(request_no, version_id,wip_type_no, vendor_code, vendor_name,"+
						  " vendor_contact, request_date, inventory_item_id,inventory_item_name,"+
						  " item_description, item_package,die_item_id, die_name,"+
						  " quantity, unit_price, packing,package_spec, "+
						  " test_spec, assembly, testing,taping_reel,"+
						  " lapping, others, remarks, marking,"+
						  " status, creation_date,created_by, created_by_name,"+
						  " last_update_date, last_updated_by,SUBINVENTORY_CODE,CURRENCY_CODE,"+
						  " ORIG_VERSION_ID,WIP_NO,PR_NO,WIP_ENTITY_ID,LOCK_FLAG,UNIT_PRICE_UOM,VENDOR_SITE_ID,po_no,tot_chip_qty,die_item_id1,die_name1,die_qty,BILL_SEQUENCE_ID,"+ //add BILL_SEQUENCE_ID by Peggy 20160914
						  " organization_id,tsc_prod_group,COMPLETION_DATE,WIP_ISSUE_PENDING_FLAG,VENDOR_ITEM_DESC,FRONT_SIDE_METAL,RING_CUT)"+ //add by Peggy 20161107, add VENDOR_ITEM_DESC by Peggy 20220930
						  " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,sysdate,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,to_date(?,'yyyymmdd'),?,TSC_PMD_PKG.GET_VENDOR_ITEM(?,?),?,?)";
				//out.println(sql);
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,REQUESTNO);         //�ӽг渹
				pstmt.setInt(2,Integer.parseInt(VERSIONID));                  //����
				pstmt.setString(3,WIPTYPE);         //�u������
				pstmt.setString(4,SUPPLIERNO);      //�����ӥN�X
				pstmt.setString(5,SUPPLIERNAME);    //�����ӦW��
				pstmt.setString(6,SUPPLIERCONTACT); //�����Ӥ��p���H
				pstmt.setString(7,ISSUEDATE);       //�ݨD��
				pstmt.setInt(8,Integer.parseInt(ITEMID));             //ITEMID
				pstmt.setString(9,ITEMNAME);        //ITEMNAME
				pstmt.setString(10,ITEMDESC);        //ITEMDESC 
				pstmt.setString(11,PACKAGE);        //PACKAGE
				pstmt.setInt(12,Integer.parseInt(DIE_ID[0]));             //DIEID
				pstmt.setString(13,DIE_NAME[0]);        //DIENAME
				pstmt.setFloat(14,Float.parseFloat(QTY));             //QTY
				pstmt.setFloat(15,Float.parseFloat(UNITPRICE));       //UNITPRICE
				pstmt.setString(16,PACKING);        //PACKING
				pstmt.setString(17,PACKAGESPEC);    //PACKAGESPEC
				pstmt.setString(18,TESTSPEC);       //TESTSPEC
				pstmt.setString(19,CHKASSEMBLY);    //CHKASSEMBLY
				pstmt.setString(20,CHKTESTING);     //CHKTESTING
				pstmt.setString(21,CHKTAPING);      //CHKTAPING
				pstmt.setString(22,CHKLAPPING);     //CHKLAPPING
				pstmt.setString(23,(CHKOTHERS.equals("Y")) ? OTHERS: null); //OTHERS
				pstmt.setString(24,REMARKS);        //REMARKS
				pstmt.setString(25,MARKING);        //MARKING
				pstmt.setString(26,statuscode);     //STATUS
				//pstmt.setDate(27,java.sql.Date.valueOf(CREATEDATE));     //creation_date
				pstmt.setString(27,CREATEDATE);     //creation_date
				pstmt.setString(28,CREATORID);       //created_by
				pstmt.setString(29,CREATOR);        //USERNAME
				pstmt.setString(30,userID);         //USERID
				pstmt.setString(31,SUBINVENTORY);   //���u�J�w��
				pstmt.setString(32,CURRENCYCODE);   //���O
				pstmt.setString(33,(ORIGVERSIONID.equals("")||ORIGVERSIONID.equals("null")?null:ORIGVERSIONID));  //�쪩��
				pstmt.setString(34,(WIPNO.equals("")||WIPNO.equals("null")?null:WIPNO));          //WIP NO
				pstmt.setString(35,(PRNO.equals("")||PRNO.equals("null")?null:PRNO));           //PR NO
				pstmt.setString(36,(WIPID.equals("")||WIPID.equals("null")?null:WIPID));          //WIP ENTITY ID
				pstmt.setString(37,"N");           //LOCK FLAG
				pstmt.setString(38,PRICEUOM);      //������
				pstmt.setString(39,VENDOR_SITE_ID); //VENDOR_SITE_ID
				pstmt.setString(40,(PONO.equals("")||PONO.equals("null")?null:PONO));           //PR NO
				pstmt.setString(41,totChipQty);    //�o���`�q
				pstmt.setString(42,(DIE_ID.length >1)?DIE_ID[1]:null);  //DIEID,add by Peggy 20121009
				pstmt.setString(43,(DIE_NAME.length>1)?DIE_NAME[1]:null);               //DIENAME,add by Peggy 20121009
				pstmt.setString(44,DIE_QTY);        //add by Peggy 20121009
				pstmt.setString(45,BILLSEQID);      //add by Peggy 20160914
				pstmt.setString(46,ORGANIZATION_ID);        //add by Peggy 20161107
				pstmt.setString(47,PROD_GROUP);             //add by Peggy 20161107
				pstmt.setString(48,COMPLETEDATE);           //add by Peggy 20170817
				pstmt.setString(49,(WIPNO.equals("")||WIPNO.equals("null")?WIP_ISSUE_FLAG:(WIPNO.startsWith("W-")?"Y":WIP_ISSUE_FLAG)));        //add by Peggy 20170817
				pstmt.setString(50,SUPPLIERNO);            //�����ӥN�X
				pstmt.setInt(51,Integer.parseInt(ITEMID));  //ITEMID
				pstmt.setString(52,FSM);      //FSM,ADD BY PEGGY 20230426
				pstmt.setString(53,RINGCUT);  //RING CUT BY PEGGY 20230426						
				pstmt.executeQuery();
				
				int insertCnt =0;
				for (int i = 1 ; i <= Integer.parseInt(LINENUM) ;i++)
				{
						  
					Stock=request.getParameter("Stock"+i);
					if (Stock==null) Stock="";
					WaferLot=request.getParameter("WaferLot"+i);
					if (WaferLot==null) WaferLot="";
					ChipQty=request.getParameter("ChipQty"+i);
					if (ChipQty ==null) ChipQty="";
					WaferQty=request.getParameter("WaferQty"+i);
					if (WaferQty==null) WaferQty="";
					DateCode=request.getParameter("DateCode"+i);
					if (DateCode==null) DateCode="";
					//RequestSD=request.getParameter("RequestSD"+i);
					//if (RequestSD==null) RequestSD= "";
					INVITEM=request.getParameter("INVITEM"+i);
					if (INVITEM==null) INVITEM="";
					INVITEMID=request.getParameter("INVITEMID"+i);
					if (INVITEMID==null) INVITEMID="";
					TRANS_SOURCE_ID=request.getParameter("trans_source_id_"+i);  //add by Peggy 20171012
					if (TRANS_SOURCE_ID==null || TRANS_SOURCE_ID.equals("0")) TRANS_SOURCE_ID="";  
					WaferNumber=request.getParameter("WaferNumber"+i);    //add by Peggy 20180724
					if (WaferNumber==null) WaferNumber="";	
					DC_YYWW=request.getParameter("DC_YYWW"+i); //add by Peggy 20221203
					if (DC_YYWW==null) DC_YYWW="";
					DIE_MODE=request.getParameter("DIE_MODE"+i); //add by Peggy 20221208
					if (DIE_MODE==null || DIE_MODE.equals("--")) DIE_MODE="";
									
					
					//���~���u�u�椣�ˬdfrom esther issue by Peggy 20201207
					if ((!WIPTYPE.equals("03") && !WIPTYPE.equals("05")) || ITEMNAME.length()<22)
					{
						//�ˬddate code�O�_����,add by Peggy 20200925
						sql = " select LISTAGG(a.wip_no,',') WITHIN GROUP (ORDER BY a.wip_no) WIP_NO_LIST"+
							  " from oraddman.tspmd_oem_headers_all a,oraddman.tspmd_oem_lines_all b"+
							  " where a.request_no=b.request_no"+
							  " and a.version_id=b.version_id"+
							  //" and A.completion_date BETWEEN ADD_MONTHS(TRUNC(SYSDATE),-108) AND TRUNC(SYSDATE)"+ //add by Peggy 20221124
							  " and A.completion_date BETWEEN ADD_MONTHS(TRUNC(SYSDATE),-108) AND ADD_MONTHS(TRUNC(SYSDATE),108)"+ //add by Peggy 20230523
							  " and a.status in (?,?)"+
							  " and a.wip_type_no not in (?,?)"+
							  " and a.request_no<>?"+
							  " and a.item_description=?"+
							  " and b.date_code=?"+
							  " and b.date_code not in (?,?,?)";
						pstmt=con.prepareStatement(sql);
						pstmt.setString(1,"Approved"); 
						pstmt.setString(2,"Submit"); 
						pstmt.setString(3,"03"); 
						pstmt.setString(4,"05");  //add by Peggy 20210820
						pstmt.setString(5,REQUESTNO); 
						pstmt.setString(6,ITEMDESC); 
						pstmt.setString(7,DateCode); 
						pstmt.setString(8,"N/A"); 
						pstmt.setString(9,"NA"); 
						pstmt.setString(10,"HOLD"); 
						ResultSet rsk=pstmt.executeQuery();	
						if (rsk.next())
						{
							if (rsk.getString(1) != null)
							{
								throw new Exception("�o�{���~=>D/C:"+DateCode+" �b�u��"+rsk.getString(1)+"�w�ϥ�,�Э��s�T�{!!");
							}
						}
						rsk.close();	
					}
										
					if ( !WaferLot.equals("") || (!WIPTYPE.equals("03") && !WIPTYPE.equals("05") && !INVITEMID.equals("") && !ChipQty.equals("") && !WaferQty.equals("") && !DateCode.equals("")) || ((WIPTYPE.equals("03") || WIPTYPE.equals("05")) && !INVITEMID.equals("") && !ChipQty.equals("")) || (WIP_ISSUE_FLAG.equals("Y") && !INVITEMID.equals("") && !ChipQty.equals("")) )
					{
						sql=" insert into oraddman.tspmd_oem_lines_all(request_no,version_id, line_no, lot_number, wafer_qty, chip_qty,date_code, completion_date, creation_date, created_by,last_update_date, last_updated_by,subinventory_code,inventory_item_id,inventory_item_name,transactions_type_id,transaction_source_id,miscellaneous_erp_flag,WIP_ISSUE_PENDING_FLAG,WAFER_NUMBER,DC_YYWW,DIE_MODE)"
						   +" values(?,?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,sysdate,?,?,?,?,(SELECT a.type_no  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE=? AND TYPE_NAME=? AND STATUS_FLAG=?),?,?,?,?,?,?)";
						pstmt=con.prepareStatement(sql);
						pstmt.setString(1,REQUESTNO);       //�ӽг渹
						pstmt.setInt(2,Integer.parseInt(VERSIONID));                  //����
						//pstmt.setInt(3,i);                //�渹
						pstmt.setInt(3,(DateCode.toUpperCase().equals("HOLD")?i*100:i)); //D/C=HOLD,LINE#�q100�_��,add by Peggy 20180131
						pstmt.setString(4,(WaferLot.equals("")?"":WaferLot));      //LOT
						pstmt.setFloat(5,Float.parseFloat((WaferQty.equals("")?"0":WaferQty)));      //Wafer Qty
						pstmt.setFloat(6,Float.parseFloat(ChipQty));       //Chip Qty
						pstmt.setString(7,(DateCode.equals("")?"":DateCode.toUpperCase()));      //DATECODE
						//pstmt.setString(8,RequestSD);     //�w�p���u��
						pstmt.setString(8,COMPLETEDATE);     //�w�p���u��
						//pstmt.setDate(9,java.sql.Date.valueOf(CREATEDATE));    //�}���
						pstmt.setString(9,CREATEDATE);    //�}���
						pstmt.setString(10,CREATORID);    //userID
						pstmt.setString(11,userID);       //userID
						pstmt.setString(12,Stock);        //subinventory code
						pstmt.setInt(13,Integer.parseInt(INVITEMID));        //inventory itemid
						pstmt.setString(14,INVITEM);        //INVITEM
						pstmt.setString(15,"ONHAND_TYPE");          //transactions_type_ID
						pstmt.setString(16,TRANS_SOURCE_ID);        //transaction_source_id
						pstmt.setString(17,"A");          //STATUS
						pstmt.setString(18,TRANS_SOURCE_ID);        //transactions_source_id
						pstmt.setString(19,(TRANS_SOURCE_ID.equals("")?"N":"Y")); //miscellaneous_erp_flag
						pstmt.setString(20,"Y"); //WIP_ISSUE_PENDING_FLAG,add by Peggy 20180525
						pstmt.setString(21,WaferNumber); //wafer_number,add by Peggy 20180724
						pstmt.setString(22,DC_YYWW); //DC_YYWW,add by Peggy 20221205
						pstmt.setString(23,DIE_MODE); //DIE_MODE,add by Peggy 20221208
						pstmt.executeQuery();
		
						insertCnt ++;
					}
				}
				if (insertCnt ==0) throw new Exception("�o�Ʃ��ӥ���J!!");

				sql=" INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor, remark)"+
					" VALUES(?,?,?,sysdate,?,?)";
				//out.println(sql);
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1,REQUESTNO);         //�ӽг渹
				pstmt.setInt(2,Integer.parseInt(VERSIONID));  //����
				pstmt.setString(3,statuscode);         //���A
				pstmt.setString(4,UserName);        //�ާ@�̦W��
				pstmt.setString(5, CHANGE_REASON);              //�Ƶ�
				pstmt.executeQuery();
					
				con.commit();	
		
				strURL = "../jsp/TSCPMDOEMInformationDetail.jsp?REQUESTNO="+REQUESTNO+"-"+VERSIONID+"&PROGRAMNAME="+PROGRAMNAME;
		
				try
				{
					//CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_OEM_PKG.PMD_EMAIL_NOTICE(?,?,?)}");			 
					CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_PKG.PMD_EMAIL_NOTICE(?,?,?)}");			 
					cs4.setString(1,REQUESTNO); 
					cs4.setInt(2,Integer.parseInt(VERSIONID)); 
					cs4.setString(3,(PROGRAMNAME.equals(WIPCHANGE))?"WIPCHANGE":"Request"); 
					cs4.execute();
					cs4.close();
				}
				catch(Exception e)
				{
					//�L
				}		
			}
			catch(Exception e)
			{	  
				con.rollback();
				strURL="";
				if (PROGRAMNAME.equals("F1-001"))
				{
					out.println("<font color='red'>�ӽаʧ@����!�гt���t�κ޲z��,����!<br>�o�Ϳ��~�i���]:"+e.getMessage().toString()+"</font>");
					out.println("<p><input type='button' name='goback' value='�^�ӽеe��' onclick='setSubmit("+'"'+"../jsp/TSCPMDOEMCreate.jsp"+'"'+")'>");
				}
				else if (PROGRAMNAME.equals(WIPMODIFY))
				{
					out.println("<font color='red'>�ק�ʧ@����!�гt���t�κ޲z��,����!<br>�o�Ϳ��~�i���]:"+e.getMessage().toString()+"</font>");
					out.println("<p><input type='button' name='goback' value='�^�ק�e��' onclick='setSubmit("+'"'+"../jsp/TSCPMDOEMModify.jsp?ACTIONTYPE="+WIPMODIFY+"&REQUESTNO="+REQUESTNO+"-"+ORIGVERSIONID+'"'+")'>");
				}
				else if (PROGRAMNAME.equals(WIPCHANGE))
				{
					out.println("<font color='red'>�u���ܧ󥢱�!�гt���t�κ޲z��,����!<br>�o�Ϳ��~�i���]:"+e.getMessage().toString()+"</font>");
					out.println("<p><input type='button' name='goback' value='�^�u���ܧ�e��' onclick='setSubmit("+'"'+"../jsp/TSCPMDOEMModify.jsp?ACTIONTYPE="+WIPCHANGE+"&REQUESTNO="+REQUESTNO+"-"+ORIGVERSIONID+'"'+")'>");
				}
			}
		}
		//�ֲa or �h��
		else if (ACTIONID.equals("003") || ACTIONID.equals("004"))
		{
			try
			{
				/*
				sql=  " select orig_version_id ,wip_type_no "+
				      " ,(select distinct  SUBINVENTORY_CODE FROM oraddman.tspmd_oem_lines_all b where b.request_no = a.request_no and b.version_id = a.version_id and rownum=1) SUBINVENTORY_CODE"+
					  " from oraddman.tspmd_oem_headers_all a"+
				      " where REQUEST_NO ='" + REQUESTNO+"'"+
					  " and VERSION_ID ="+VERSIONID+""+
					  " and STATUS in (SELECT a.type_name  FROM oraddman.tspmd_data_type_tbl a  where a.DATA_TYPE='ACTION'  and a.TYPE_NO='002')";
				Statement statementax=con.createStatement();
				ResultSet rsx=statementax.executeQuery(sql);
				if (rsx.next())
				{
					ORIGVERSIONID = rsx.getString("orig_version_id");
					if (ACTIONID.equals("003"))
					{
						String WIP_Status="",WIP_MISC_Status="",PR_Status="",PO_Status="";
						
						//�}�u�{�ζq���u��κޭܮw�S�ܦ��P�@�H,�ҥH�u���Ƨ令�D�ޮֲa��Ѩt�ΰ���,add by Peggy 20131014
						//if (!rsx.getString("SUBINVENTORY_CODE").equals("61"))
						//{
							CallableStatement cs3 = con.prepareCall("{call TSC_PMD_OEM_PKG.JOB_INITIAL(?,?,?,?,?,?)}");	//add by Peggy 20120704		 
							cs3.setString(1,REQUESTNO); 
							cs3.setInt(2,Integer.parseInt(VERSIONID)); 
							cs3.registerOutParameter(3, Types.VARCHAR);
							cs3.registerOutParameter(4, Types.VARCHAR); 
							cs3.registerOutParameter(5, Types.VARCHAR); 
							cs3.registerOutParameter(6, Types.VARCHAR); 
							cs3.execute();
							WIP_Status = cs3.getString(3);
							WIP_MISC_Status = cs3.getString(4);
							PR_Status = cs3.getString(5);  
							PO_Status = cs3.getString(6);
							cs3.close();
						//}
						//else
						//{
						//	CallableStatement cs3 = con.prepareCall("{call TSC_PMD_OEM_PKG.JOB_INITIAL(?,?,?,?,?)}");	//add by Peggy 20121224	 
						//	cs3.setString(1,REQUESTNO); 
						//	cs3.setInt(2,Integer.parseInt(VERSIONID)); 
						//	cs3.registerOutParameter(3, Types.VARCHAR);
						//	cs3.registerOutParameter(4, Types.VARCHAR); 
						//	cs3.registerOutParameter(5, Types.VARCHAR); 
						//	cs3.execute();
						//	WIP_Status = cs3.getString(3);
						//	PR_Status = cs3.getString(4);  
						//	PO_Status = cs3.getString(5);
						//	cs3.close();
						//}
						
						String strMessage = "";
						if (!WIP_Status.equals("R"))  //add by Peggy 20140815
						{
							if (!WIP_Status.equals("S"))
							{
								if (ORIGVERSIONID==null)
								{
									throw new Exception("�u�沣�ͥ���");
								}
								else
								{
									throw new Exception(WIP_Status);
								}
							}
							//if (!rsx.getString("SUBINVENTORY_CODE").equals("61") && !WIP_MISC_Status.equals("S"))
							if (!WIP_MISC_Status.equals("S"))
							{
								strMessage +="*****�u��o�ƥ���("+WIP_MISC_Status+")*****<br>";
							}
							if (!PR_Status.equals("S"))
							{
								strMessage +="*****���ʳ�ͦ�����("+PR_Status+")*****<br>";
							}
							if (!PO_Status.equals("S"))
							{
								strMessage +="*****���ʳ�ͦ�����("+PO_Status+")*****<br>";
							}
							if (strMessage.equals(""))
							{
								strURL = "../jsp/TSCPMDOEMInformationDetail.jsp?REQUESTNO="+REQUESTNO+"-"+VERSIONID+"&PROGRAMNAME="+PROGRAMNAME;
							}
							else
							{
								strMessage = "�ֲa�ʧ@���\!���U�C����o�Ϳ��~,�гt���t�κ޲z�H��,����!<br>"+strMessage;
								out.println("<font color='red'>"+strMessage+"</font>");
								out.println("<p><input type='button' name='goback' value='�^�ֲa�e��' onclick='setSubmit("+'"'+"../jsp/TSCPMDOEMConfirmQuery.jsp"+'"'+")'>");
							}
						}
					}
					*/
					
					/*
					if (ORIGVERSIONID != null)
					{
						sql = " update oraddman.tspmd_oem_headers_all set status='Inactive' where REQUEST_NO =? and VERSION_ID =? and status ='Approved'";
						PreparedStatement pstmt=con.prepareStatement(sql);
						pstmt.setString(1,REQUESTNO);   //�ӽг渹
						pstmt.setString(2,ORIGVERSIONID);   //����
						pstmt.executeQuery();
					}
					*/
					
					//�}�u�{�ζq���u��κޭܮw�S�ܦ��P�@�H,�ҥH�u���Ƨ令�D�ޮֲa��Ѩt�ΰ���,add by Peggy 20131014
					//add by Peggy 20130118
					//if (rsx.getString("SUBINVENTORY_CODE").equals("61")) //61��
					//{
					//	String WIP_MISC_Status ="S";
					//	sql = " select inventory_item_id,inventory_item_name,subinventory_code,LOT_NUMBER,sum(orig_chip_qty) orig_chip_qty ,sum(chip_qty) chip_qty,sum(orig_chip_qty)- Sum(chip_qty) tot_chip_qty"+
					//		  " from (select inventory_item_id,INVENTORY_ITEM_NAME,subinventory_code,LOT_NUMBER,sum( a.chip_qty) orig_chip_qty,0 chip_qty from oraddman.tspmd_oem_lines_all a"+
					//		  " where a.request_no ='"+REQUESTNO+"'"+
					//		  " AND EXISTS (select 1 from oraddman.tspmd_oem_headers_all x where x.request_no ='"+REQUESTNO+"' and x.version_id='"+VERSIONID+"' and x.orig_version_id = a.version_id)"+
					//		  " group by inventory_item_id,INVENTORY_ITEM_NAME,subinventory_code,LOT_NUMBER"+
					//		  " union all "+
					//		  " select inventory_item_id,INVENTORY_ITEM_NAME,subinventory_code,LOT_NUMBER,0 orig_chip_qty,sum( a.chip_qty) chip_qty from oraddman.tspmd_oem_lines_all a"+
					//		  " where a.request_no ='"+REQUESTNO+"'"+
					//		  " AND a.version_id='"+VERSIONID+"'"+
					//		  " group by inventory_item_id,INVENTORY_ITEM_NAME,subinventory_code,LOT_NUMBER) a"+
					//		  " group by inventory_item_id,INVENTORY_ITEM_NAME,subinventory_code,LOT_NUMBER"+
					//		  " HAVING sum(orig_chip_qty)- Sum(chip_qty) <>0";
					//	//out.println(sql);
					//	Statement statementak=con.createStatement();
					//	ResultSet rsk=statementak.executeQuery(sql);
					//	if (rsk.next())
					//	{
					//		WIP_MISC_Status = "";
					//	}
					//	statementak.close();
					//	rsk.close();
					//	
					//	sql=" update oraddman.tspmd_oem_headers_all "+
					//		  " set WIP_MTL_STATUS=?"+
					//		  " where REQUEST_NO ='" + REQUESTNO+"'"+
					//		  " and VERSION_ID ="+VERSIONID+""+
					//		  " and STATUS in (SELECT a.type_name  FROM oraddman.tspmd_data_type_tbl a  where a.DATA_TYPE='ACTION'  and a.TYPE_NO='002')";
					//	PreparedStatement pstmt=con.prepareStatement(sql);
					//	pstmt.setString(1,WIP_MISC_Status);    //�u���ƪ��A
					//	pstmt.executeQuery();
					//}
					
					sql=" update oraddman.tspmd_oem_headers_all "+
						  " set STATUS = ?"+
						  ",APPROVE_DATE = sysdate"+
						  ",APPROVED_BY =?"+
						  ",APPROVED_BY_NAME =?"+
						  ",APPROVE_REMARK=?"+
						  ",LAST_UPDATE_DATE=sysdate"+
						  ",LAST_UPDATED_BY=?"+
						  ",INV_DATE=TO_CHAR(sysdate,'yyyymmddhh24miss')"+
						  ",INV_BY=CREATED_BY"+
						  " where REQUEST_NO ='" + REQUESTNO+"'"+
						  " and VERSION_ID ="+VERSIONID+""+
						  " and STATUS in (SELECT a.type_name  FROM oraddman.tspmd_data_type_tbl a  where a.DATA_TYPE='ACTION'  and a.TYPE_NO='002')";
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,statuscode);         //���A
					pstmt.setString(2,userID);             //approve user
					pstmt.setString(3,UserName);           //approve user name
					pstmt.setString(4,APPROVE_REMARKS);    //�h���]
					pstmt.setString(5,userID);             //�̫Ყ�ʪ�
					if ( pstmt.executeUpdate()>0)
					{
						//20150904 by Peggy,�⤣�p��mark��code�ɦ^��
						sql=" INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor, remark)"+
							" VALUES(?,?,?,sysdate,?,?)";
						pstmt=con.prepareStatement(sql);
						pstmt.setString(1,REQUESTNO);         //�ӽг渹
						pstmt.setInt(2,Integer.parseInt(VERSIONID));  //����
						pstmt.setString(3,statuscode);         //���A
						pstmt.setString(4,UserName);        //�ާ@�̦W��
						pstmt.setString(5,APPROVE_REMARKS);              //�Ƶ�
						pstmt.executeUpdate();
										
						if (ACTIONID.equals("003"))
						{
							CallableStatement cs1 = con.prepareCall("{call tsc_pmd_pkg.SUBMIT_PMD_REQ(?,?)}");
							cs1.setString(1,REQUESTNO); 	
							cs1.setString(2,VERSIONID); 	
							cs1.execute();
							cs1.close();
						}
						else if (ACTIONID.equals("004"))
						{
							//20150904 by Peggy,�⤣�p��mark��code�ɦ^��
							CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_PKG.PMD_EMAIL_NOTICE(?,?,?)}");			 
							cs4.setString(1,REQUESTNO); 
							cs4.setInt(2,Integer.parseInt(VERSIONID)); 
							cs4.setString(3,statuscode); 
							cs4.execute();
							cs4.close();
						}
					}
					
					if (!REQLIST.equals(""))
					{
						int v_confirm_cnt=0;
						sql = " select count(1) from oraddman.tspmd_oem_headers_all a"+
				              " WHERE a.status=?"+
		                      " and ',"+REQLIST+",' like '%,'||a.request_no||'-'||a.version_id||',%'";
						PreparedStatement pstmt1=con.prepareStatement(sql);
						pstmt1.setString(1,"Submit"); 
						ResultSet rs1=pstmt1.executeQuery();	
						if (rs1.next())
						{
							v_confirm_cnt=rs1.getInt(1);
						}
						rs1.close();
						pstmt1.close();								  
						
						if (v_confirm_cnt==0)
						{
							%>
							<script language="JavaScript" type="text/JavaScript">
								document.location.href="../jsp/TSCPMDOEMConfirmQuery.jsp";
							</script>	
							<%					
						}
						else
						{
							%>
							<script language="JavaScript" type="text/JavaScript">
								document.location.href="../jsp/TSCPMDOEMConfirm.jsp?REQLIST=<%=REQLIST%>";
							</script>	
							<%	
						}
					}
					else
					{
						%>
						<script language="JavaScript" type="text/JavaScript">
						if (confirm("<%=(ACTIONID.equals("003")?"�ֲa":"�h��")%>���\!!\n\n�Y�n�~��ֲa�U�@���A�Ы��T�w��A����!"))
						{
							document.location.href="../jsp/TSCPMDOEMConfirmQuery.jsp";
						}	
						else
						{
							document.location.href="/oradds/ORADDSMainMenu.jsp";
						}	
						</script>	
						<%
					}					
				//}
				//else
				//{
				//	throw new Exception("���ӽЪ��A�D�ݮֲa(Submit)!!!");
				//}	
			}
			catch(Exception e)
			{
				con.rollback();	  
				strURL="";
				out.println("<font color='red'>"+(ACTIONID.equals("003")?"�ֲa":"�h��")+"�ʧ@����!�гt���t�κ޲z��,����!<br>�o�Ϳ��~�i���]:"+e.getMessage().toString()+"</font>");
				out.println("<p><input type='button' name='goback' value='�^�ֲa�e��' onclick='setSubmit("+'"'+"../jsp/TSCPMDOEMConfirmQuery.jsp"+'"'+")'>");
			}
		}
		else if (ACTIONID.equals("005"))
		{
			try
			{
				sql=" update oraddman.tspmd_oem_headers_all "+
					  " set STATUS = ?"+
					  " where REQUEST_NO ='" + REQUESTNO+"'"+
					  " and VERSION_ID ="+VERSIONID+""+
					  " and STATUS ='Reject'";
				//out.println(sql);			  
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,statuscode);         //���A
				pstmt.executeQuery();
				
				sql=" update oraddman.tspmd_oem_headers_all "+
					  " set LOCK_FLAG = 'N'"+
					  " where REQUEST_NO ='" + REQUESTNO+"'"+
					  " and VERSION_ID = (select orig_version_id from oraddman.tspmd_oem_headers_all where REQUEST_NO ='" + REQUESTNO+"' and VERSION_ID="+VERSIONID+")"+
					  " and STATUS ='Approved'";
				//out.println(sql);
				pstmt=con.prepareStatement(sql);
				pstmt.executeQuery();
				
				con.commit();
				
				strURL = "../jsp/TSCPMDOEMInformationDetail.jsp?REQUESTNO="+REQUESTNO+"-"+VERSIONID+"&PROGRAMNAME="+PROGRAMNAME;
			}
			catch(Exception e)
			{	  
				con.rollback();
				strURL="";
				out.println("<font color='red'>�����ʧ@����!�гt���t�κ޲z��,����!<br>�o�Ϳ��~�i���]:"+e.getMessage().toString()+"</font>");
				out.println("<p><input type='button' name='goback' value='�^�d�ߵe��' onclick='setSubmit("+'"'+"../jsp/TSCPMDOEMInformationQuery.jsp"+'"'+")'>");
			}
		}
		//�u��ɵo��
		else if (ACTIONID.equals("006") || ACTIONID.equals("007"))
		{
			try
			{
				int insertCnt =0;
				sql=" update oraddman.tspmd_oem_headers_all "+
					" set LAST_UPDATE_DATE=sysdate"+
					",LAST_UPDATED_BY=?"+
					",INV_DATE=TO_CHAR(sysdate,'yyyymmddhh24miss')"+
					",INV_BY=?"+
					",WIP_ISSUE_PENDING_FLAG=?"+
					",TOT_CHIP_QTY=?"+
					",DIE_QTY=?"+
					",REMARKS=?"+
					",WIP_MTL_STATUS=NULL"+ //add by Peggy 20210820
					" where REQUEST_NO =?"+
					" and VERSION_ID =?";
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,userID);          
				pstmt.setString(2,userID);          
				pstmt.setString(3,(ACTIONID.equals("007")?"R":"Y"));          
				pstmt.setString(4,totChipQty);          
				pstmt.setString(5,DIE_QTY);    
				pstmt.setString(6,REMARKS);
				pstmt.setString(7,REQUESTNO);  //�ӽг渹  
				pstmt.setString(8,VERSIONID);  //����      
				pstmt.executeQuery();         
				
				//sql = " delete oraddman.tspmd_oem_lines_all"+
				//      " where request_no=?"+
				//	  " and version_id=?";
				//pstmt=con.prepareStatement(sql);
				//pstmt.setString(1,REQUESTNO);  //�ӽг渹
				//pstmt.setString(2,VERSIONID);  //����      
				//pstmt.executeQuery();				  
					  
				sql=" INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor, remark)"+
					" VALUES(?,?,(select TYPE_NAME from oraddman.tspmd_data_type_tbl where DATA_TYPE='F1-001' AND TYPE_NO=?),sysdate,?,?)";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1,REQUESTNO);         //�ӽг渹
				pstmt.setString(2,VERSIONID);         //����
				pstmt.setString(3,ACTIONID);        //���A
				pstmt.setString(4,UserName);          //�ާ@�̦W��
				pstmt.setString(5,"");                //�Ƶ�
				pstmt.executeQuery();
											
				for (int i = 1 ; i <= Integer.parseInt(LINENUM) ;i++)
				{
					LineNo=request.getParameter("LineNo"+i);
					if (LineNo==null) LineNo="";
					Stock=request.getParameter("Stock"+i);
					if (Stock==null) Stock="";
					WaferLot=request.getParameter("WaferLot"+i);
					if (WaferLot==null) WaferLot="";
					WaferNumber=request.getParameter("WaferNumber"+i);
					if (WaferNumber==null) WaferNumber="";  //add by Peggy 20180724
					ChipQty=request.getParameter("ChipQty"+i);
					if (ChipQty ==null) ChipQty="";
					WaferQty=request.getParameter("WaferQty"+i);
					if (WaferQty==null) WaferQty="";
					DateCode=request.getParameter("DateCode"+i);
					if (DateCode==null || DateCode.toLowerCase().equals("")) DateCode="";
					INVITEM=request.getParameter("INVITEM"+i);
					if (INVITEM==null) INVITEM="";
					INVITEMID=request.getParameter("INVITEMID"+i);
					if (INVITEMID==null) INVITEMID="";
					TRANS_SOURCE_ID=request.getParameter("trans_source_id_"+i);  //add by Peggy 20171120
					if (TRANS_SOURCE_ID==null || TRANS_SOURCE_ID.equals("0")) TRANS_SOURCE_ID="";  
					WIP_ISSUE_LINE_FLAG=request.getParameter("WIP_ISSUE_FLAG_"+i);
					if (WIP_ISSUE_LINE_FLAG==null) WIP_ISSUE_LINE_FLAG="Y"; 
					DC_YYWW=request.getParameter("DC_YYWW"+i); //add by Peggy 20221208
					if (DC_YYWW==null) DC_YYWW="";
					DIE_MODE=request.getParameter("DIE_MODE"+i); //add by Peggy 20221208
					if (DIE_MODE==null || DIE_MODE.equals("--")) DIE_MODE="";
					
					//�ˬddate code�O�_����,add by Peggy 20200925
					sql = " select LISTAGG(a.wip_no,',') WITHIN GROUP (ORDER BY a.wip_no) WIP_NO_LIST"+
						  " from oraddman.tspmd_oem_headers_all a,oraddman.tspmd_oem_lines_all b"+
						  " where a.request_no=b.request_no"+
						  " and a.version_id=b.version_id"+
						  " and a.status in (?,?)"+
						  " and a.wip_type_no not in (?,?)"+
						  " and a.request_no<>?"+
						  " and exists (select 1 from oraddman.tspmd_oem_headers_all x where x.request_no=? and x.version_id=? and x.item_description=a.item_description)"+
						  " and b.date_code=?"+
						  " and b.date_code not in (?,?,?)";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,"Approved"); 
					pstmt.setString(2,"Submit"); 
					pstmt.setString(3,"03"); 
					pstmt.setString(4,"05");  //add by Peggy 20210820
					pstmt.setString(5,REQUESTNO); 
					pstmt.setString(6,REQUESTNO); 
					pstmt.setString(7,VERSIONID); 
					pstmt.setString(8,DateCode); 
					pstmt.setString(9,"N/A"); 
					pstmt.setString(10,"NA"); 
					pstmt.setString(11,"HOLD"); 
					ResultSet rsk=pstmt.executeQuery();	
					if (rsk.next())
					{
						if (rsk.getString(1) != null)
						{					
							throw new Exception("�o�{���~=>D/C:"+DateCode+" �b�u��"+rsk.getString(1)+"�w�ϥ�,�Э��s�T�{!!");
						}
					}
					rsk.close();		
							
					//if ( !WaferLot.equals("") || (!WIPTYPE.equals("03") && !INVITEMID.equals("") && !ChipQty.equals("") && !WaferQty.equals("") && !DateCode.equals("")) || (WIPTYPE.equals("03") && !INVITEMID.equals("") && !ChipQty.equals("")) || (WIP_ISSUE_FLAG.equals("Y") && !INVITEMID.equals("") && !ChipQty.equals("")) )
					//{
					
					if (WIP_ISSUE_LINE_FLAG.equals("Y"))
					{
						sql = " SELECT count(1) FROM oraddman.tspmd_oem_lines_all a  "+
							  " where a.request_no='"+REQUESTNO+"'"+
							  " and a.version_id='"+ VERSIONID+"'"+
							  " and a.line_no='"+LineNo+"'";
						//out.println(sql);
						Statement statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery(sql);
						if (rs1.next())
						{
							data_cnt=rs1.getInt(1);
						}
						rs1.close();
						statement1.close();
						
						if (data_cnt >0)
						{					
							sql=" update oraddman.tspmd_oem_lines_all "+
								  " set lot_number=?"+
								  ",wafer_qty=?"+
								  ",chip_qty=?"+
								  ",date_code=?"+
								  ",completion_date=?"+
								  ",last_update_date=sysdate"+
								  ",last_updated_by=?"+
								  ",transactions_type_id=(SELECT a.type_no  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE=? AND TYPE_NAME=? AND STATUS_FLAG=?)"+
								  ",transaction_source_id=?"+
								  ",miscellaneous_erp_flag=?"+
								  ",wip_issue_pending_flag=?"+
								  ",subinventory_code=?"+
								  ",wafer_number=?"+ 
								  ",die_mode=?"+
								  " where REQUEST_NO =?"+
								  " and VERSION_ID =?"+
								  " and LINE_NO =?";
							//out.println(sql);			  
							pstmt=con.prepareStatement(sql);
							pstmt.setString(1,(WaferLot.equals("")?"":WaferLot));      
							pstmt.setFloat(2,Float.parseFloat((WaferQty.equals("")?"0":WaferQty)));      
							pstmt.setFloat(3,Float.parseFloat(ChipQty));      
							pstmt.setString(4,(DateCode.equals("")?"":DateCode.toUpperCase()));      
							pstmt.setString(5,COMPLETEDATE);      
							pstmt.setString(6,userID);      
							pstmt.setString(7,"ONHAND_TYPE");          //transactions_type_ID
							pstmt.setString(8,TRANS_SOURCE_ID);        //transaction_source_id
							pstmt.setString(9,"A");                    //STATUS
							pstmt.setString(10,TRANS_SOURCE_ID);      
							pstmt.setString(11,(TRANS_SOURCE_ID.equals("")?"N":"Y"));      
							pstmt.setString(12,WIP_ISSUE_LINE_FLAG); 
							pstmt.setString(13,Stock);     
							pstmt.setString(14,WaferNumber); //add by Peggy 20180724
							pstmt.setString(15,DIE_MODE); //add by Peggy 20221215
							pstmt.setString(16,REQUESTNO); //add by Peggy 20221215
							pstmt.setString(17,VERSIONID); //add by Peggy 20221215
							pstmt.setString(18,LineNo); //add by Peggy 20221215
							pstmt.executeQuery();	
							if (!WaferLot.equals("")) insertCnt ++;				
						
						}
						else
						{
						
							sql=" insert into oraddman.tspmd_oem_lines_all(request_no,version_id, line_no, lot_number, wafer_qty, chip_qty,date_code, completion_date, creation_date, created_by,last_update_date, last_updated_by,subinventory_code,inventory_item_id,inventory_item_name,transactions_type_id,transaction_source_id,miscellaneous_erp_flag,wip_issue_pending_flag,wafer_number,dc_yyww,die_mode)"
							   +" values(?,?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,sysdate,?,?,?,?,(SELECT a.type_no  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE=? AND TYPE_NAME=? AND STATUS_FLAG=?),?,?,?,?,?,?)";
							   
							pstmt=con.prepareStatement(sql);
							pstmt.setString(1,REQUESTNO);       //�ӽг渹
							pstmt.setInt(2,Integer.parseInt(VERSIONID));                  //����
							pstmt.setString(3,LineNo);                //�渹
							pstmt.setString(4,(WaferLot.equals("")?"":WaferLot));      //LOT
							pstmt.setFloat(5,Float.parseFloat((WaferQty.equals("")?"0":WaferQty)));      //Wafer Qty
							pstmt.setFloat(6,Float.parseFloat(ChipQty));       //Chip Qty
							pstmt.setString(7,(DateCode.equals("")?"":DateCode.toUpperCase()));      //DATECODE
							pstmt.setString(8,COMPLETEDATE);     //�w�p���u��
							pstmt.setString(9,CREATEDATE);    //�}���
							pstmt.setString(10,CREATORID);    //userID
							pstmt.setString(11,userID);       //userID
							pstmt.setString(12,Stock);        //subinventory code
							pstmt.setInt(13,Integer.parseInt(INVITEMID));        //inventory itemid
							pstmt.setString(14,INVITEM);        //INVITEM
							pstmt.setString(15,"ONHAND_TYPE");          //transactions_type_ID
							pstmt.setString(16,TRANS_SOURCE_ID);        //transaction_source_id
							pstmt.setString(17,"A");          //STATUS
							pstmt.setString(18,TRANS_SOURCE_ID);        //transactions_source_id
							pstmt.setString(19,(TRANS_SOURCE_ID.equals("")?"N":"Y")); //miscellaneous_erp_flag
							pstmt.setString(20,WIP_ISSUE_LINE_FLAG); //add by Peggy 20180528
							pstmt.setString(21,WaferNumber); //add by Peggy 20180724
							pstmt.setString(22,DC_YYWW); //add by Peggy 20221208
							pstmt.setString(23,DIE_MODE); //add by Peggy 20221208
							pstmt.executeQuery();
							if (!WaferLot.equals("")) insertCnt ++;				
						}
					}
				}
				if (insertCnt ==0) throw new Exception("�o�Ʃ��ӥ���J!!");

				/*int errcnt=0;
				//�ˬd���L�w�s,add by Peggy 20171120
				sql = " SELECT a.INVENTORY_ITEM_ID,A.INVENTORY_ITEM_NAME,A.SUBINVENTORY_CODE,A.LOT_NUMBER,a.CHIP_QTY ,NVL(c.TRANSACTION_QUANTITY,0) ONHAND_QTY"+
					  " FROM (SELECT a.INVENTORY_ITEM_ID,a.INVENTORY_ITEM_NAME,a.SUBINVENTORY_CODE,a.LOT_NUMBER,b.ORGANIZATION_ID,SUM(a.CHIP_QTY) CHIP_QTY "+
					  "       FROM oraddman.tspmd_oem_lines_all a,oraddman.tspmd_oem_headers_all b"+
					  "       WHERE a.REQUEST_NO ='"+REQUESTNO+"'"+
					  "       AND a.VERSION_ID='"+ VERSIONID+"'"+
					  "       AND a.REQUEST_NO=b.REQUEST_NO"+
					  "       AND a.VERSION_ID=b.VERSION_ID"+
					  "       GROUP BY a.INVENTORY_ITEM_ID,a.INVENTORY_ITEM_NAME,a.SUBINVENTORY_CODE,a.LOT_NUMBER,b.ORGANIZATION_ID) a,inv.mtl_onhand_quantities_detail c"+
					  " WHERE a.ORGANIZATION_ID=c.ORGANIZATION_ID(+)"+
					  " AND a.INVENTORY_ITEM_ID=c.INVENTORY_ITEM_ID(+)"+
					  " AND a.SUBINVENTORY_CODE=c.SUBINVENTORY_CODE(+)"+
					  " AND a.LOT_NUMBER=c.LOT_NUMBER(+)"+
					  " AND a.CHIP_QTY >NVL(c.TRANSACTION_QUANTITY,0) ";
					Statement statement11=con.createStatement();
				ResultSet rs11=statement11.executeQuery(sql);
				while (rs11.next())
				{
					out.println(" <font style='font-family::Tahoma,Georgia;font-size:12px'>�Ƹ�:"+rs11.getString("INVENTORY_ITEM_NAME") + "  "+ rs11.getString("SUBINVENTORY_CODE")+"�� LOT:"+rs11.getString("LOT_NUMBER")+ "  ERP�w�s����</font><br>");
					errcnt++;
				}
				rs11.close();
				statement11.close();
			
				if (errcnt>0)
				{
					throw new Exception("");
				}
				*/
			
				con.commit();	
				
				if (ACTIONID.equals("007"))
				{
					CallableStatement cs1 = con.prepareCall("{call tsc_pmd_pkg.SUBMIT_PMD_REQ(?,?)}");
					cs1.setString(1,REQUESTNO); 	
					cs1.setString(2,VERSIONID); 	
					cs1.execute();
					cs1.close();
				}
				strURL = "../jsp/TSCPMDOEMInformationDetail.jsp?REQUESTNO="+REQUESTNO+"-"+VERSIONID+"&PROGRAMNAME="+PROGRAMNAME;
			}
			catch(Exception e)
			{
				con.rollback();	  
				out.println("<font color='red'>�������,�гt���t�Τu�{�v,����!!<br>"+e.getMessage()+"</font>");
			}				
		}		
	}
	// ���s�J����榡��US�Ҷq,�N�y�t���]������
	sqlNLS="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' "; 
	pstmtNLS=con.prepareStatement(sqlNLS);
	pstmtNLS.executeUpdate(); 
	pstmtNLS.close();

	if (!strURL.equals(""))	response.sendRedirect(strURL);
	if (ACTIONID.equals("004"))
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
		if (confirm("�e�~�[�u��w�h��!!\n\n�Y�n�~��ֲa�U�@���A�Ы��T�w��A����!"))
		{
			document.location.href="../jsp/TSCPMDOEMConfirmQuery.jsp";
		}	
		else
		{
			document.location.href="/oradds/ORADDSMainMenu.jsp";
		}	
		</script>	
	<%
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<font color='red'>�������,�гt���t�Τu�{�v,����!!<br>"+e.getMessage()+"</font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

