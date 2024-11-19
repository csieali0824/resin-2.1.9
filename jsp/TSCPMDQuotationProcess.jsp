<!--20161106,新增PRD外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<title>PMD&PRD 外包PO單價簽核 Process</title>
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
<FORM ACTION="TSCPMDQuotationProcess.jsp" METHOD="post" NAME="PMDFORM">
<%
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
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
String SUPPLIERSITE = request.getParameter("SUPPLIERSITE");
if (SUPPLIERSITE==null) SUPPLIERSITE="";
String CURRENCYCODE = request.getParameter("CURRENCYCODE");
if (CURRENCYCODE ==null) CURRENCYCODE="";
String ACTIONID=request.getParameter("ACTIONID");
if (ACTIONID==null) ACTIONID="";
String actioncode="";
String REMARKS = request.getParameter("REMARKS");
if (REMARKS == null) REMARKS="";
String LINENUM=request.getParameter("LINENUM");
String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  //add by Peggy 20120705
String FILEID = request.getParameter("FILEID");
if (FILEID == null) FILEID ="";
String ITEMID="",ITEMNAME="",ITEMDESC="",PRICE="",PREPRICE="",STARTDATE="",ENDDATE="",STARTQTY="",ENDQTY="",REASON="",sql="",statuscode="",strURL="",error="",UOM="",QTY_UNIT="",PROD_GROUP="",ORGANIZATION_ID="";
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
String Orig_Status=request.getParameter("STATUS");
if (Orig_Status==null)  Orig_Status="";
String THISWKFLOW = request.getParameter("THISWKFLOW");  //add by Peggy 20130913
if (THISWKFLOW==null) THISWKFLOW="";      
         
//String NEXTWKFLOW = request.getParameter("NEXTWKFLOW");
//if (NEXTWKFLOW==null) NEXTWKFLOW="";
//String REQ_STATUS = "";
String NEXTWKFLOW ="";

// 為存入日期格式為US考量,將語系先設為美國
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
	  
try
{
	String sqla = " SELECT  a.type_name  FROM oraddman.tspmd_data_type_tbl a  where DATA_TYPE='F2_ACTION' AND TYPE_NO='"+ACTIONID+"'  AND STATUS_FLAG='A'"; //add by Peggy 20130913
	//out.println(sqla);
	Statement statementa=con.createStatement();
	ResultSet rsa=statementa.executeQuery(sqla);
	if (rsa.next())
	{
		actioncode = rsa.getString("type_name");
	}
	else
	{
		throw new Exception("查無action code("+ACTIONID+")!!");
	}
	rsa.close();
	statementa.close();
		
	//String sqla = " SELECT  a.type_name  FROM oraddman.tspmd_data_type_tbl a  where DATA_TYPE='F2_ACTION'  AND TYPE_NO='"+ACTIONID+"'  AND STATUS_FLAG='A'";
	sqla = " SELECT  a.type_name  FROM oraddman.tspmd_data_type_tbl a  where DATA_TYPE='F2_"+THISWKFLOW+"' AND TYPE_NO='"+ACTIONID+"'  AND STATUS_FLAG='A'"; //add by Peggy 20130913
	//out.println(sqla);
	statementa=con.createStatement();
	rsa=statementa.executeQuery(sqla);
	if (rsa.next())
	{
		statuscode = rsa.getString("type_name");
	}
	else
	{
		throw new Exception("查無status code!!");
	}
	rsa.close();
	statementa.close();
}
catch(Exception e)
{
	ACTIONID=""; //清除ACTIONID
	out.println("Exception1:"+e.getMessage());
}
	   
//取消 或 送出申請
if (ACTIONID.equals("001") || ACTIONID.equals("002"))
{
	try
	{
		//送出申請
		if (ACTIONID.equals("002"))
		{
			if (REQUESTNO.equals(""))
			{
				//取得申請單號
				CallableStatement cs3 = con.prepareCall("{call tsc_pmd_get_requestno(?,?)}");
				cs3.setString(1,"QUO"); 
				cs3.registerOutParameter(2, Types.VARCHAR);
				cs3.execute();
				REQUESTNO= cs3.getString(2);
				cs3.close();

				if (REQUESTNO.equals("")) throw new Exception("申請單號取得失敗,請速洽系統管理人員,謝謝!!");
			}
			else
			{
				sql = "delete from oraddman.tspmd_quotation_headers_all where request_no=? and status='"+Orig_Status+"'";
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,REQUESTNO);   //申請單號
				if (pstmt.executeUpdate()>0)
				{
					sql = "delete from oraddman.tspmd_quotation_lines_all where request_no=?";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,REQUESTNO);   //申請單號
					pstmt.executeQuery();
					pstmt.executeUpdate();
					
					ACTIONID="0021";//表示退件後再重送的申請單
				}
				else
				{
					throw new Exception("申請單狀態不符合修改條件!!");
				}
			}
			
			if (!REQUESTNO.equals(FILEID))
			{
				java.io.File file = new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/PMD_Attache/"+FILEID); 
			    file.renameTo(new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/PMD_Attache/"+REQUESTNO));
  			}
			
			try
			{
				String sqlc = " SELECT a.type_name FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE='F2_WORKFLOW' and TYPE_NO='"+THISWKFLOW+"' AND a.status_flag='A'";
				//out.println(sqla);
				Statement statementc=con.createStatement();
				ResultSet rsc=statementc.executeQuery(sqlc);
				if (rsc.next())
				{
					NEXTWKFLOW = rsc.getString("type_name");
				}
				else
				{
					throw new Exception("查無Next Work Flow Setup!!");
				}
				rsc.close();
				statementc.close();
			}
			catch(Exception e)
			{
				out.println("Exception2:"+e.getMessage());
			}		
				
			sql=" insert into oraddman.tspmd_quotation_headers_all(request_no, vendor_code, vendor_name, vendor_site,currency_code,"+
				" creation_date, created_by,created_by_name, last_update_date, last_updated_by,status,VENDOR_SITE_ID,NEXT_WKFLOW"+
				" )"+
				" values(?,?,?,?,?,sysdate,?,?,sysdate,?,?,?,?)";
			//out.println(sql);
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,REQUESTNO);       //申請單號
			pstmt.setString(2,SUPPLIERNO);      //供應商代碼
			pstmt.setString(3,SUPPLIERNAME);    //供應商名稱
			pstmt.setString(4,SUPPLIERSITE);    //供應商SITE
			pstmt.setString(5,CURRENCYCODE);    //幣別
			pstmt.setString(6,CREATORID);       //created_by
			pstmt.setString(7,CREATOR);         //USERNAME
			pstmt.setString(8,CREATORID);       //last update by
			pstmt.setString(9,statuscode);       //status
			pstmt.setString(10,VENDOR_SITE_ID);   //VENDOR_SITE_ID
			pstmt.setString(11,NEXTWKFLOW);       //next workflow code
			pstmt.executeQuery();
	
			int insertCnt =0;
			for (int i = 1 ; i <= Integer.parseInt(LINENUM) ;i++)
			{
				PROD_GROUP=request.getParameter("PROD_GROUP"+i);
				if (PROD_GROUP==null) PROD_GROUP="";
				ORGANIZATION_ID=request.getParameter("ORGANIZATION_ID"+i);
				if (ORGANIZATION_ID==null) ORGANIZATION_ID="";
				ITEMID=request.getParameter("ITEMID"+i);
				if (ITEMID==null) ITEMID="";
				ITEMNAME=request.getParameter("ITEMNAME"+i);
				if (ITEMNAME==null) ITEMNAME="";
				ITEMDESC=request.getParameter("ITEMDESC"+i);
				if (ITEMDESC==null) ITEMDESC="";
				PRICE=request.getParameter("PRICE"+i);
				if (PRICE==null) PRICE="";
				PREPRICE=request.getParameter("PREPRICE"+i);
				if (PREPRICE ==null || PREPRICE.equals("")) PREPRICE="0";
				STARTQTY=request.getParameter("STARTQTY"+i);
				if (STARTQTY==null) STARTQTY="0";
				ENDQTY=request.getParameter("ENDQTY"+i);
				if (ENDQTY==null) ENDQTY="0";
				REASON=request.getParameter("REASON"+i);
				if (REASON==null) REASON= "";
				UOM=request.getParameter("UOM"+i);
				if (UOM==null) UOM="";
				//QTY_UNIT=request.getParameter("QTY_UNIT"+i);
				//if (QTY_UNIT==null) QTY_UNIT="500";
				
				if (!ITEMID.equals("") && !ITEMNAME.equals("") && !ITEMDESC.equals("") && !PRICE.equals("") && !STARTQTY.equals("")  && !ENDQTY.equals("") && !REASON.equals(""))
				{
					QTY_UNIT = ""+(Long.parseLong(ENDQTY)-Long.parseLong(STARTQTY));
				
					sql=" insert into oraddman.tspmd_quotation_lines_all(request_no, line_no, inventory_item_id,"+
						" inventory_item_name, item_description, unit_price,previous_price, start_date, end_date, request_reason,"+
						" creation_date, created_by, last_update_date,last_updated_by,status,start_qty,end_qty,uom,QTY_UNIT,organization_id,tsc_prod_group)"+
						" values(?,?,?,?,?,?,?,to_char(sysdate,'yyyymmdd'),null,?,sysdate,?,sysdate,?,?,?,?,?,?,?,?)";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,REQUESTNO);      //申請單號
					pstmt.setString(2,""+i);           //行號
					pstmt.setString(3,ITEMID);         //itemid
					pstmt.setString(4,ITEMNAME);       //ITEMNAME
					pstmt.setString(5,ITEMDESC);       //ITEMDESC
					pstmt.setFloat(6,Float.parseFloat(PRICE));        //UNIT PRICE
					pstmt.setFloat(7,Float.parseFloat(PREPRICE));     //PREVIOUS UNIT PRICE
					pstmt.setString(8,REASON);       //異動原因
					pstmt.setString(9,CREATORID);    //CREATORID
					pstmt.setString(10,CREATORID);    //last update by
					pstmt.setString(11,statuscode);       //status
					pstmt.setString(12,STARTQTY);   //STARTQTY
					pstmt.setString(13,ENDQTY);   //ENDQTY
					pstmt.setString(14,UOM);      //UOM
					pstmt.setInt(15,Integer.parseInt(QTY_UNIT));    //QTY_UNIT
					pstmt.setString(16,ORGANIZATION_ID);  //organization_id,add by Peggy 20161106
					pstmt.setString(17,PROD_GROUP);       //tsc_prod_group,add by Peggy 20161106
					pstmt.executeQuery();
					
					insertCnt ++;
				}
			}
			if (insertCnt ==0) throw new Exception("報價明細未輸入!!");
		}
		else
		{
			sql= " update oraddman.tspmd_quotation_headers_all "+
				 " set STATUS = ?"+
				 ",LAST_UPDATE_DATE=sysdate"+
				 ",LAST_UPDATED_BY=?"+
				 " where REQUEST_NO ='" + REQUESTNO+"'"+
				 " and STATUS ='"+Orig_Status+"'";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,statuscode);         //狀態
			pstmt.setString(2,userID);             //user id
			if (pstmt.executeUpdate()>0)
			{
				sql= " update oraddman.tspmd_quotation_lines_all "+
					 " set STATUS = ?"+
					 ",LAST_UPDATE_DATE=sysdate"+
					 ",LAST_UPDATED_BY=?"+
					 " where REQUEST_NO ='" + REQUESTNO+"'"+
					 " and STATUS ='"+Orig_Status+"'";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1,statuscode);         //狀態
				pstmt.setString(2,userID);             //最後異動者
				pstmt.executeUpdate();
			}
			else
			{
				throw new Exception("申請單狀態不符合修改條件!!");
			}
		}
		
		sql=" INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor, remark)"+
            " VALUES(?,?,?,sysdate,?,?)";
		PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.setString(1,REQUESTNO);         //申請單號
		pstmt.setInt(2,0);  //版次
		pstmt.setString(3,actioncode);        //狀態
		pstmt.setString(4,UserName);          //操作者名稱
		pstmt.setString(5,REMARKS);           //備註
		pstmt.executeQuery();
			
		//送出申請
		if (ACTIONID.equals("002"))
		{
			//CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_OEM_PKG.PMD_QUOTATION_EMAIL_NOTICE(?,?)}");			 
			CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_PKG.PMD_QUOTATION_EMAIL_NOTICE(?,?)}");	//modify by Peggy 20140924		 
			cs4.setString(1,REQUESTNO); 
			cs4.setString(2,statuscode); 
			cs4.execute();
			cs4.close();	
		}

		con.commit();	

		strURL = "../jsp/TSCPMDQuotationDetail.jsp?REQUESTNO="+REQUESTNO+"&ACTIONID="+ACTIONID;
	}
	catch(Exception e)
	{	  
		con.rollback();
		error ="Y";
		out.println("<font color='red'>申請動作失敗!請速洽系統管理員,謝謝!<br>發生錯誤可能原因:"+e.getMessage().toString()+"</font>");
		out.println("<p><input type='button' name='goback' value='回申請畫面' onclick='setSubmit("+'"'+"../jsp/TSCPMDQuotationCreate.jsp"+'"'+")'>");
	}
}
else if (ACTIONID.equals("003") || ACTIONID.equals("004"))
{
	try
	{
		sql= " select 1 from oraddman.tspmd_quotation_headers_all where REQUEST_NO ='" + REQUESTNO+"'"+ " and STATUS ='"+Orig_Status+"' and NEXT_WKFLOW='"+THISWKFLOW+"'";
		Statement statementax=con.createStatement();
		ResultSet rsx=statementax.executeQuery(sql);
		if (rsx.next())
		{
			if (ACTIONID.equals("003"))
			{
				String sqlb = " SELECT  a.type_name  FROM oraddman.tspmd_data_type_tbl a  where DATA_TYPE='F2_WORKFLOW'  AND TYPE_NO='"+THISWKFLOW+"'  AND STATUS_FLAG='A'";
				Statement statementb=con.createStatement();
				ResultSet rsb=statementb.executeQuery(sqlb);
				if (rsb.next())
				{
					NEXTWKFLOW = rsb.getString("type_name");
					//REQ_STATUS = statuscode;
				}
				else
				{
					sql = " delete oraddman.tspmd_item_quotation a"+
						  " where exists (select 1 from oraddman.tspmd_quotation_headers_all b,oraddman.tspmd_quotation_lines_all c"+
						  " where b.REQUEST_NO ='" + REQUESTNO+"' and b.request_no = c.request_no "+
						  " and b.vendor_code = a.vendor_code"+
						  " and c.inventory_item_id = a.inventory_item_id"+
						  " and b.vendor_site_id = a.vendor_site_id)"; //modify by Peggy 20130204
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.executeQuery();
					
					//REQ_STATUS = "Closed";
				}
				rsb.close();
				statementb.close();
				
				strURL = "../jsp/TSCPMDQuotationDetail.jsp?REQUESTNO="+REQUESTNO+"&ACTIONID="+ACTIONID;
			//}
			//else
			//{
				//REQ_STATUS = statuscode;
			}
			sql= " update oraddman.tspmd_quotation_headers_all "+
				 " set STATUS = ?"+
				 ",APPROVE_DATE = sysdate"+
				 ",APPROVED_BY =?"+
				 ",APPROVED_BY_NAME =?"+
				 ",APPROVE_REMARK=?"+
				 ",LAST_UPDATE_DATE=sysdate"+
				 ",LAST_UPDATED_BY=?"+
				 ",NEXT_WKFLOW=?"+
				 " where REQUEST_NO ='" + REQUESTNO+"'"+
				 " and STATUS ='"+Orig_Status+"'";
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,statuscode);         //狀態
			pstmt.setString(2,userID);             //approve user
			pstmt.setString(3,UserName);           //approve user name
			pstmt.setString(4,REMARKS);    //退件原因
			pstmt.setString(5,userID);             //最後異動者
			pstmt.setString(6,NEXTWKFLOW);          //下一關
			pstmt.executeQuery();

			sql= " update oraddman.tspmd_quotation_lines_all "+
				 " set STATUS = ?"+
				 ",LAST_UPDATE_DATE=sysdate"+
				 ",LAST_UPDATED_BY=?"+
				 " where REQUEST_NO ='" + REQUESTNO+"'"+
				 " and STATUS ='"+Orig_Status+"'";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,statuscode);         //狀態
			pstmt.setString(2,userID);             //最後異動者
			pstmt.executeQuery();
			
			sql= " INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor, remark)"+
				 " VALUES(?,?,?,sysdate,?,?)";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,REQUESTNO);         //申請單號
			pstmt.setInt(2,0);                    //版次
			pstmt.setString(3,actioncode);        //狀態
			pstmt.setString(4,UserName);          //操作者名稱
			pstmt.setString(5,REMARKS);   //備註
			pstmt.executeQuery();
			
			if (statuscode.equals("Approved"))
			{
				sql= " INSERT INTO oraddman.tspmd_action_history(request_no, version_id, action_name, action_date,actor)"+
					 " VALUES(?,?,?,SYSDATE+(1/(24*60*60)),?)";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1,REQUESTNO);         //申請單號
				pstmt.setInt(2,0);                    //版次
				pstmt.setString(3,"Closed");          //狀態
				pstmt.setString(4,"System");          //操作者名稱
				pstmt.executeQuery();
			}
			
			//CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_OEM_PKG.PMD_QUOTATION_EMAIL_NOTICE(?,?)}");			 
			CallableStatement cs4 = con.prepareCall("{call APPS.TSC_PMD_PKG.PMD_QUOTATION_EMAIL_NOTICE(?,?)}");			 
			cs4.setString(1,REQUESTNO); 
			cs4.setString(2,statuscode); 
			cs4.execute();
			cs4.close();		

			con.commit();
		}
		else
		{
			//throw new Exception("申請單已核淮,不允許重複核淮!!!");
			if (ACTIONID.equals("003"))
			{
				//寶惠經理核淮時常發生SUBMIT送出兩次問題,但她說沒按兩次,所以直接PASS這個錯誤,add by Peggy 20150623
				strURL = "../jsp/TSCPMDQuotationDetail.jsp?REQUESTNO="+REQUESTNO+"&ACTIONID="+ACTIONID;
			}
		}	
	}
	catch(Exception e)
	{	  
		con.rollback();
		error ="Y";
		out.println("<font color='red'>"+(ACTIONID.equals("003")?"核淮":"退件")+"動作失敗!請速洽系統管理員,謝謝!<br>發生錯誤可能原因:"+e.getMessage().toString()+"</font>");
		out.println("<p><input type='button' name='goback' value='回核淮畫面' onclick='setSubmit("+'"'+"../jsp/TSCPMDQuotationConfirmList.jsp"+'"'+")'>");
	}
}
// 為存入日期格式為US考量,將語系先設為美國
sqlNLS="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' "; 
pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
%>
</FORM>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
if (error.equals("") && !strURL.equals(""))	response.sendRedirect(strURL);
if (ACTIONID.equals("004"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("外包PO單價申請單已退件!!\n\n若要繼續核淮下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDQuotationConfirmList.jsp";
	}	
	else
	{
		document.location.href="/oradds/ORADDSMainMenu.jsp";
	}	
	</script>	
<%
}
%>
</html>

