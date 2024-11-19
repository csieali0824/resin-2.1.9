<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,java.util.*,java.text.*,javax.mail.*,javax.mail.internet.*,javax.mail.Multipart.*,javax.activation.*,oracle.sql.*,oracle.jdbc.driver.*,java.lang.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="StockBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>TSC Stock Trans Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCStockTransProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
String rdoitem = request.getParameter("rdoitem");
if (rdoitem==null) rdoitem="";
String strWorkflowCode=request.getParameter("WORKFLOWCODE");
if (strWorkflowCode==null) strWorkflowCode="";
String STATUS_CODE=request.getParameter("STATUS_CODE");
if (STATUS_CODE==null) STATUS_CODE="";
String HID=request.getParameter("HID");
if (HID==null) HID="";
String WKCODE=request.getParameter("WKCODE");
if (WKCODE==null) WKCODE="";
String REQUESTNO="",TRANS_TYPE="",orig_trans_type_id="",new_trans_type_id="",orig_trans_source_id="",new_trans_source_id="",res_flag="S",strKey="";
Hashtable hashtb = new Hashtable();
int insert_cnt=0,err_cnt=0;
double iUseQty=0,ionhand=0,iQty=0,outQty=0;

if (STATUS_CODE.equals("NEWREQ"))
{
	try
	{
		StockBean.setArray2DString(null);
		
		String chk[]= request.getParameterValues("chk1");	
		if (chk.length <=0)
		{
			throw new Exception("No Request Data found!!");
		}
		
		sql = "select TRANS_TYPE from oraddman.TSC_STOCK_TRANS_TYPE a where a.ACTIVE_FLAG=? and a.TRANS_NAME=?";
		PreparedStatement statement2=con.prepareStatement(sql);
		statement2.setString(1,"A");
		statement2.setString(2,rdoitem);
		ResultSet rs2=statement2.executeQuery();
		if (rs2.next())
		{
			TRANS_TYPE=rs2.getString(1);
		}
		else
		{
			throw new Exception("trans type no data found!!");
		}
		rs2.close();
		statement2.close();	
		
		insert_cnt=0;		
		
		for(int i=0; i< chk.length ;i++)
		{
			if (request.getParameter("ORIG_ITEM_NAME_"+chk[i]).equals("")||request.getParameter("ORIG_ITEM_NAME_"+chk[i])==null) continue;	
				
			//檢查庫存
			sql = " select nvl(sum(TRANSACTION_QUANTITY* case when TRANSACTION_UOM_CODE='KPC' THEN 1000 ELSE 1 END ),0) onhand"+
				  " from (select b.organization_code,a.* from inv.mtl_onhand_quantities_detail a,inv.mtl_parameters b where a.organization_id=b.organization_id) a,inv.mtl_system_items_b c,(select distinct ORGANIZATION_CODE,SUBINVENTORY_CODE from oraddman.tsc_stock_trans_subinv where trans_type=?) d"+
				  " where a.organization_id=?"+
				  " and a.organization_id=c.organization_id"+
				  " and a.inventory_item_id=c.inventory_item_id"+
				  " and c.segment1=?"+
				  " and a.subinventory_code=?"+
				  " and a.lot_number=?"+
				  " and a.organization_code=d.organization_code(+)"+
				  " and a.subinventory_code=d.subinventory_code(+)";
                  //" and d.trans_type=?";
			//out.println(sql);
			statement2 = con.prepareStatement(sql);
			statement2.setString(1,TRANS_TYPE);
			statement2.setString(2,request.getParameter("ORIG_ORG_"+chk[i]));
			statement2.setString(3,request.getParameter("ORIG_ITEM_NAME_"+chk[i]));
			statement2.setString(4,request.getParameter("ORIG_SUBINV_"+chk[i]));
			statement2.setString(5,request.getParameter("ORIG_LOT_"+chk[i]));
			rs2=statement2.executeQuery();
			if (rs2.next())
			{	
				ionhand = Double.parseDouble(rs2.getString("onhand"));
			}
			else
			{
				ionhand=0;
			}
			rs2.close();
			statement2.close();
				
			strKey=request.getParameter("ORIG_ITEM_NAME_"+chk[i])+","+request.getParameter("ORIG_ORG_"+chk[i])+","+request.getParameter("ORIG_SUBINV_"+chk[i])+","+request.getParameter("ORIG_LOT_"+chk[i]);
			if ((String)hashtb.get(strKey)==null)
			{
				iUseQty=0;
			}
			else
			{
				iUseQty = Double.parseDouble((String)hashtb.get(strKey));
			}
			//outQty = Double.parseDouble(request.getParameter("QTY_"+chk[i]))*(request.getParameter("UOM_"+chk[i]).equals("KPC")?1000:1);
			outQty = Double.parseDouble(request.getParameter("QTY_"+chk[i]));
			outQty = Math.round((outQty*(request.getParameter("UOM_"+chk[i]).equals("KPC")?1000:1)));
			iQty =ionhand-iUseQty-outQty;
			if (iQty<0 && request.getParameter("REQ_REASON_"+chk[i]).indexOf("urgent出貨")<0)
			{
				out.println("<font color='red'>第"+(i+1)+"筆:料號:"+request.getParameter("ORIG_ITEM_NAME_"+chk[i])+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LOT:"+request.getParameter("ORIG_LOT_"+chk[i])+" 庫存不足("+ionhand+"/"+iUseQty+"/"+outQty+"/"+iQty+")!!</font><br>");
				err_cnt++;
			}
			
			iUseQty+= outQty;
			hashtb.put(strKey,""+iUseQty);
		}
		if (err_cnt>0)
		{
			throw new Exception("");
		}
		for(int i=0; i< chk.length ;i++)
		{
			if (request.getParameter("ORIG_ITEM_NAME_"+chk[i]).equals("")||request.getParameter("ORIG_ITEM_NAME_"+chk[i])==null) continue;
			insert_cnt ++;
	
			if (insert_cnt==1)
			{
				CallableStatement cs1 = con.prepareCall("{call TSC_STOCK_TRANS_PKG.GET_REQUEST_NO(?,?,to_char(sysdate,'yyyymmdd'),?)}");
				cs1.setString(1,strWorkflowCode);    
				cs1.setString(2,TRANS_TYPE);    
				cs1.registerOutParameter(3, Types.VARCHAR);   
				cs1.execute();
				REQUESTNO = cs1.getString(3);                    
				cs1.close();
				if (REQUESTNO.equals("ERROR"))
				{
					throw new Exception("REQUEST NO取得失敗!!");
				}
						
				/*Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(" SELECT APPS.TSC_STOCK_TRANS_REQ_ID_S.nextval from dual");
				if (rs1.next())
				{
					HID = rs1.getString(1);
				}
				else
				{
					rs1.close();
					statement1.close();		
					throw new Exception("HEADER ID取得失敗!!");
				}
				rs1.close();
				statement1.close();		
				*/
			}	
			sql = " INSERT INTO ORADDMAN.TSC_STOCK_TRANS_LINES "+
				  " (req_line_id"+               //1
				  ",req_header_id"+              //2
				  ",line_no"+                    //3
				  ",tsc_prod_group"+             //4
				  ",orig_organization_id"+       //5
				  ",orig_subinventory_code"+     //6
				  ",orig_inventory_item_id"+     //7
				  ",orig_item_name"+             //8
				  ",orig_item_desc"+             //9
				  ",orig_lot_number"+            //10
				  ",orig_date_code"+             //11
				  ",orig_qty"+                   //12
				  ",orig_uom"+                   //13
				  ",req_reason"+                 //14
				  ",unit_price"+                 //15
				  ",tot_amt"+                    //16
				  ",created_by"+                 //17
				  ",creation_date"+              //18
				  ",last_updated_by"+            //19
				  ",last_update_date "+          //20
				  ",new_qty"+                    //21
				  ",new_uom"+                    //22
				  ",orig_trans_type_id"+         //23
				  ",orig_trans_source_id"+       //24
				  ",new_trans_type_id"+          //25
				  ",new_trans_source_id"+        //26
				  ",new_organization_id"+        //27
				  ",new_subinventory_code"+      //28
				  ",new_inventory_item_id"+      //29
				  ",new_item_name"+              //30
				  ",new_item_desc"+              //31
				  ",new_lot_number"+             //32
				  ",new_date_code"+              //33
				  ",erp_reference_no"+           //34
				  ")"+
				  " select APPS.TSC_STOCK_TRANS_REQ_ID_S.nextval"+  //1
				  ",?"+    //2
				  ",?"+    //3
				  ",?"+    //4
				  ",?"+    //5
				  ",?"+    //6
				  ",(select inventory_item_id from inv.mtl_system_items_b x where x.segment1=? and x.organization_id=43)"+    //7
				  ",?"+    //8
				  ",?"+    //9
				  ",?"+    //10
				  ",trim(?)"+    //11
				  ",?"+    //12
				  ",?"+    //13
				  ",?"+    //14
				  ",?"+    //15
				  ",?"+    //16
				  ",?"+    //17
				  ",sysdate"+  //18
				  ",?"+        //19
				  ",sysdate"+  //20
				  ",?"+        //21				  
				  ",?"+    //22
				  ",?"+    //23
				  ",?"+        //24			  
				  ",?"+        //25				  
				  ",?"+        //26			  
				  ",?"+    //27
				  ",?"+    //28
				  ",(select inventory_item_id from inv.mtl_system_items_b x where x.segment1=? and x.organization_id=43)"+    //29
				  ",?"+    //30
				  ",?"+    //31
				  ",?"+    //32
				  ",trim(?)"+    //33
				  ",?"+    //34
				  " from dual";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,HID);
			pstmtDt.setString(2,""+insert_cnt);
			pstmtDt.setString(3,(request.getParameter("TSC_PROD_"+chk[i])==null?"":request.getParameter("TSC_PROD_"+chk[i])));
			pstmtDt.setString(4,(request.getParameter("ORIG_ORG_"+chk[i])==null?"":request.getParameter("ORIG_ORG_"+chk[i])));
			pstmtDt.setString(5,(request.getParameter("ORIG_SUBINV_"+chk[i])==null?"":request.getParameter("ORIG_SUBINV_"+chk[i])));
			pstmtDt.setString(6,(request.getParameter("ORIG_ITEM_NAME_"+chk[i])==null?"":request.getParameter("ORIG_ITEM_NAME_"+chk[i])));
			pstmtDt.setString(7,(request.getParameter("ORIG_ITEM_NAME_"+chk[i])==null?"":request.getParameter("ORIG_ITEM_NAME_"+chk[i])));
			pstmtDt.setString(8,(request.getParameter("ORIG_ITEM_DESC_"+chk[i])==null?"":request.getParameter("ORIG_ITEM_DESC_"+chk[i])));
			pstmtDt.setString(9,(request.getParameter("ORIG_LOT_"+chk[i])==null?"":request.getParameter("ORIG_LOT_"+chk[i])));
			pstmtDt.setString(10,(request.getParameter("ORIG_DC_"+chk[i])==null?"":request.getParameter("ORIG_DC_"+chk[i])));
			pstmtDt.setString(11,(request.getParameter("QTY_"+chk[i])==null?null:request.getParameter("QTY_"+chk[i])));
			pstmtDt.setString(12,(request.getParameter("UOM_"+chk[i])==null?"":request.getParameter("UOM_"+chk[i])));
			pstmtDt.setString(13,(request.getParameter("REQ_REASON_"+chk[i])==null?"":request.getParameter("REQ_REASON_"+chk[i])));
			pstmtDt.setString(14,(request.getParameter("UNITPRICE_"+chk[i])==null?null:request.getParameter("UNITPRICE_"+chk[i])));
			pstmtDt.setString(15,(request.getParameter("AMT_"+chk[i])==null?null:request.getParameter("AMT_"+chk[i])));
			pstmtDt.setString(16,UserName);
			pstmtDt.setString(17,UserName);			
			if (rdoitem.equals("SUBTRANS"))
			{
				//subinventory transfer
				if (request.getParameter("NEW_ORG_"+chk[i]).equals(request.getParameter("ORIG_ORG_"+chk[i])))
				{
					orig_trans_type_id="2";
					orig_trans_source_id=null;
					new_trans_type_id=null;
					new_trans_source_id=null;
				}
				else
				{
					//入I91費用化,使用雜收發
					if (request.getParameter("NEW_ORG_"+chk[i]).equals("746"))
					{
						orig_trans_type_id="444";  //(I)線上領料
						orig_trans_source_id="1734";  //PMD零數出庫
						new_trans_type_id="122";  //(R)線上退料
						new_trans_source_id="1674";  //PMD入庫
					}
					else if (request.getParameter("ORIG_ORG_"+chk[i]).equals("746"))
					{
						orig_trans_type_id="107"; //(I)線上領料
						orig_trans_source_id="1676";  //PMD領料
						new_trans_type_id="344";  //(R)成品零成本入
						new_trans_source_id="2416"; //(I)成品零成本出(入)
					}
					else
					{
						//inter org transfer
						orig_trans_type_id="3";
						orig_trans_source_id=null;
						new_trans_type_id=null;
						new_trans_source_id=null;
					}
				}
				pstmtDt.setString(18,(request.getParameter("QTY_"+chk[i])==null?null:request.getParameter("QTY_"+chk[i])));
				pstmtDt.setString(19,(request.getParameter("UOM_"+chk[i])==null?null:request.getParameter("UOM_"+chk[i])));
				pstmtDt.setString(20,orig_trans_type_id);
				pstmtDt.setString(21,orig_trans_source_id);
				pstmtDt.setString(22,new_trans_type_id);
				pstmtDt.setString(23,new_trans_source_id);
				pstmtDt.setString(24,(request.getParameter("NEW_ORG_"+chk[i])==null?"":request.getParameter("NEW_ORG_"+chk[i])));
				pstmtDt.setString(25,(request.getParameter("NEW_SUBINV_"+chk[i])==null?"":request.getParameter("NEW_SUBINV_"+chk[i])));
				pstmtDt.setString(26,(request.getParameter("ORIG_ITEM_NAME_"+chk[i])==null?"":request.getParameter("ORIG_ITEM_NAME_"+chk[i])));
				pstmtDt.setString(27,(request.getParameter("ORIG_ITEM_NAME_"+chk[i])==null?"":request.getParameter("ORIG_ITEM_NAME_"+chk[i])));
				pstmtDt.setString(28,(request.getParameter("ORIG_ITEM_DESC_"+chk[i])==null?"":request.getParameter("ORIG_ITEM_DESC_"+chk[i])));
				pstmtDt.setString(29,(request.getParameter("ORIG_LOT_"+chk[i])==null?"":request.getParameter("ORIG_LOT_"+chk[i])));
				pstmtDt.setString(30,(request.getParameter("ORIG_DC_"+chk[i])==null?"":request.getParameter("ORIG_DC_"+chk[i])));
				pstmtDt.setString(31,(request.getParameter("REQ_REASON_"+chk[i])==null?REQUESTNO+"-"+insert_cnt:request.getParameter("REQ_REASON_"+chk[i])));
			}
			else if (rdoitem.equals("MISC"))
			{
				if (request.getParameter("ORIG_ORG_"+chk[i]).equals("49"))
				{
					orig_trans_type_id="109";
					orig_trans_source_id="16";
					new_trans_type_id="124";
					new_trans_source_id="14";
				}
				else if (request.getParameter("ORIG_ORG_"+chk[i]).equals("746"))
				{
					orig_trans_type_id="109";
					orig_trans_source_id="2454";
					new_trans_type_id="124";
					new_trans_source_id="2456";		
					//if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
					//{	
					//	orig_trans_source_id="2394";
					//	new_trans_source_id="2396";		
					//}
					//else
					//{
						orig_trans_source_id="2454";
						new_trans_source_id="2456";		
					//}						
				}
				else if (request.getParameter("ORIG_ORG_"+chk[i]).equals("606"))
				{
					orig_trans_type_id="109";
					orig_trans_source_id="1248";
					new_trans_type_id="124";
					new_trans_source_id="1246";					
				}
				else
				{
					throw new Exception("The inv source type has not been defined!!");
				}
				pstmtDt.setString(18,(request.getParameter("NEW_QTY_"+chk[i])==null?request.getParameter("QTY_"+chk[i]):request.getParameter("NEW_QTY_"+chk[i])));
				pstmtDt.setString(19,(request.getParameter("NEW_UOM_"+chk[i])==null?request.getParameter("UOM_"+chk[i]):request.getParameter("NEW_UOM_"+chk[i])));
				pstmtDt.setString(20,orig_trans_type_id);
				pstmtDt.setString(21,orig_trans_source_id);
				pstmtDt.setString(22,new_trans_type_id);
				pstmtDt.setString(23,new_trans_source_id);
				pstmtDt.setString(24,(request.getParameter("ORIG_ORG_"+chk[i])==null?"":request.getParameter("ORIG_ORG_"+chk[i])));
				pstmtDt.setString(25,(request.getParameter("ORIG_SUBINV_"+chk[i])==null?"":request.getParameter("ORIG_SUBINV_"+chk[i])));
				pstmtDt.setString(26,(request.getParameter("NEW_ITEM_NAME_"+chk[i])==null?"":request.getParameter("NEW_ITEM_NAME_"+chk[i])));
				pstmtDt.setString(27,(request.getParameter("NEW_ITEM_NAME_"+chk[i])==null?"":request.getParameter("NEW_ITEM_NAME_"+chk[i])));
				pstmtDt.setString(28,(request.getParameter("NEW_ITEM_DESC_"+chk[i])==null?"":request.getParameter("NEW_ITEM_DESC_"+chk[i])));
				pstmtDt.setString(29,(request.getParameter("NEW_LOT_"+chk[i])==null?request.getParameter("ORIG_LOT_"+chk[i]):request.getParameter("NEW_LOT_"+chk[i])));
				pstmtDt.setString(30,(request.getParameter("NEW_DC_"+chk[i])==null?request.getParameter("ORIG_DC_"+chk[i]):request.getParameter("NEW_DC_"+chk[i])));
				pstmtDt.setString(31,(REQUESTNO.substring(0,1).equals("A")?request.getParameter("REQ_REASON_"+chk[i]):REQUESTNO+"-"+insert_cnt));
			}
			else
			{
				throw new Exception("request type not define!!");
			}
			pstmtDt.executeQuery();
			pstmtDt.close();
		}	
		
		if (insert_cnt>0)
		{
			sql = " INSERT INTO ORADDMAN.TSC_STOCK_TRANS_HEADERS "+
				  " (REQ_HEADER_ID, "+
				  " REQ_NO, "+
				  " TRANS_TYPE, "+
				  " WKFLOW_LEVEL,"+
				  " STATUS_CODE, "+
				  " CREATED_BY, "+
				  " CREATION_DATE, "+
				  " LAST_UPDATED_BY,"+
				  " LAST_UPDATE_DATE"+
				  " )"+
				  " VALUES "+
				  " ("+
				  " ?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",sysdate"+
				  " )";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,HID);
			pstmtDt.setString(2,REQUESTNO);
			pstmtDt.setString(3,TRANS_TYPE);
			pstmtDt.setString(4,strWorkflowCode);
			pstmtDt.setString(5,"AWAITING_APPROVE");
			pstmtDt.setString(6,UserName);
			pstmtDt.setString(7,UserName);
			pstmtDt.executeQuery();
			pstmtDt.close();

			if (!REQUESTNO.equals(HID))
			{
				java.io.File file = new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/ILAN_Attache/"+HID); 
			    file.renameTo(new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/ILAN_Attache/"+REQUESTNO));
  			}			
			
			/*mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name="",uploadFilePath="";
			uploadFile_name=upload_file.getFileName();
			out.println("uploadFile_name="+uploadFile_name);
			uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_label\\"+REQUESTNO+"."+upload_file.getFileExt();
			upload_file.saveAs(uploadFilePath); 
		
			if  (!upload_file.isMissing()) 
			{
				PreparedStatement pstmtDt2=con.prepareStatement("select ATTACH_FILES from ORADDMAN.TSC_STOCK_TRANS_HEADERS where REQ_HEADER_ID=? for UPDATE");
				pstmtDt2.setString(1,HID);
				rs2=pstmtDt2.executeQuery();
				if (rs2.next())
				{							
					BLOB myblob=null;
					FileInputStream instream=null;
					OutputStream outstream=null;
					int bufsize=0;
					byte[] buffer =null;
					int fileLength=0;   
		 
					myblob=((OracleResultSet)rs2).getBLOB(1);
					instream=new FileInputStream(uploadFilePath);
					outstream=myblob.getBinaryOutputStream();
					bufsize=myblob.getBufferSize();
					buffer = new byte[bufsize];   
					while ((fileLength=instream.read(buffer))!=-1)   
						outstream.write(buffer,0,fileLength);
					instream.close();	 
					outstream.close();	        	   
				}
				rs2.close();
				pstmtDt2.close();
			}	
			*/
					
			sql = " INSERT INTO ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG "+
				  " (REQ_HEADER_ID, "+
				  " SEQ_ID,"+
				  " ACTION_CODE, "+
				  " CREATED_BY,"+
				  " CREATION_DATE, "+
				  " REMARKS"+
				  " )"+
				  " VALUES "+
				  " ("+
				  " ?"+
				  ",NVL((SELECT max(SEQ_ID) FROM ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG WHERE REQ_HEADER_ID=?),0)+1"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  " )";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,HID);
			pstmtDt.setString(2,HID);
			pstmtDt.setString(3,"SUBMIT");
			pstmtDt.setString(4,UserName);
			pstmtDt.setString(5,"");
			pstmtDt.executeQuery();
			pstmtDt.close();			
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("申請成功!若要繼續申請下一筆請按確定鍵,否則按下取消鍵,回查詢功能!"))
			{
				setSubmit("../jsp/TSCStockTransRequest.jsp?WKCODE=<%=WKCODE%>");
			}
			else
			{
				setSubmit("../jsp/TSCStockTransQuery.jsp?WKCODE=<%=WKCODE%>");
			}
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		res_flag="E";
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCStockTransRequest.jsp?WKCODE="+WKCODE+"'>回申請功能</a></font>");
	}
}
else if (STATUS_CODE.equals("CONFIRMED"))
{
	try
	{
		sql = " update oraddman.tsc_stock_trans_headers a"+
		      " set wkflow_level=(select wkflow_next_level from oraddman.tsc_stock_trans_wkflow c where a.wkflow_level=c.wkflow_level and c.trans_type=a.trans_type)"+
			  " ,status_code=(select case when substr(substr(b.wkflow_next_level,-2),1,1)='9' then ? else ? end from oraddman.tsc_stock_trans_wkflow b,oraddman.tsc_stock_trans_wkflow c where b.trans_type=a.trans_type and b.wkflow_level=c.wkflow_next_level and a.wkflow_level=c.wkflow_level and c.trans_type=a.trans_type)"+
			  " ,last_updated_by=?"+
              " ,last_update_date=sysdate"+
			  " where req_header_id=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		//pstmtDt.setString(1,strWorkflowCode);
		pstmtDt.setString(1,"APPROVED");
		pstmtDt.setString(2,STATUS_CODE);
		//pstmtDt.setString(4,strWorkflowCode);
		pstmtDt.setString(3,UserName);	
		pstmtDt.setString(4,HID);	
		pstmtDt.executeQuery();
		pstmtDt.close();		

		sql = " update oraddman.tsc_stock_trans_lines a"+
			  " set last_updated_by=?"+
              " ,last_update_date=sysdate"+
			  " where req_header_id=?";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,UserName);	
		pstmtDt.setString(2,HID);	
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		sql = " INSERT INTO ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG "+
			  " (REQ_HEADER_ID, "+
			  " SEQ_ID,"+
			  " ACTION_CODE, "+
			  " CREATED_BY,"+
			  " CREATION_DATE, "+
			  " REMARKS"+
			  " )"+
			  " VALUES "+
			  " ("+
			  " ?"+
			  ",NVL((SELECT max(SEQ_ID) FROM ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG WHERE REQ_HEADER_ID=?),0)+1"+
			  ",(select case when substr(substr(b.wkflow_next_level,-2),1,1)='9' then ? else ? end from oraddman.tsc_stock_trans_headers a,oraddman.tsc_stock_trans_wkflow b where b.trans_type=a.trans_type and a.wkflow_level=b.wkflow_level and b.wkflow_level=? and a.req_header_id=?)"+
			  ",?"+
			  ",sysdate"+
			  ",?"+
			  " )";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,HID);
		pstmtDt.setString(2,HID);
		pstmtDt.setString(3,"APPROVED");
		pstmtDt.setString(4,STATUS_CODE);
		pstmtDt.setString(5,strWorkflowCode);
		pstmtDt.setString(6,HID);
		pstmtDt.setString(7,UserName);
		pstmtDt.setString(8,(request.getParameter("REMARKS")==null?"":request.getParameter("REMARKS")));
		pstmtDt.executeQuery();
		pstmtDt.close();
					
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("審核成功!若要繼續審核下一筆請按確定鍵,否則按下取消鍵回首頁!"))
			{
				setSubmit("../jsp/TSCStockTransConfirm.jsp?WKCODE=<%=WKCODE%>");
			}
			else
			{
				setSubmit("../ORADDSMainMenu.jsp");
			}
		</script>
	<%			
	}
	catch(Exception e)
	{	
		con.rollback();
		res_flag="E";
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCStockTransConfirm.jsp?WKCODE="+WKCODE+"'>回審核功能</a></font>");
	}	
}
else if (STATUS_CODE.equals("REJECTED"))
{
	try
	{
		sql = " update oraddman.tsc_stock_trans_headers a"+
		      " set wkflow_level=?"+
			  " ,status_code=?"+
			  " ,last_updated_by=?"+
              " ,last_update_date=sysdate"+
			  " where req_header_id=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,strWorkflowCode);
		pstmtDt.setString(2,STATUS_CODE);
		pstmtDt.setString(3,UserName);	
		pstmtDt.setString(4,HID);	
		pstmtDt.executeQuery();
		pstmtDt.close();		

		sql = " update oraddman.tsc_stock_trans_lines a"+
			  " set last_updated_by=?"+
              " ,last_update_date=sysdate"+
			  " where req_header_id=?";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,UserName);	
		pstmtDt.setString(2,HID);	
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		sql = " INSERT INTO ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG "+
			  " (REQ_HEADER_ID, "+
			  " SEQ_ID,"+
			  " ACTION_CODE, "+
			  " CREATED_BY,"+
			  " CREATION_DATE, "+
			  " REMARKS"+
			  " )"+
			  " VALUES "+
			  " ("+
			  " ?"+
			  ",NVL((SELECT max(SEQ_ID) FROM ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG WHERE REQ_HEADER_ID=?),0)+1"+
			  ",?"+
			  ",?"+
			  ",sysdate"+
			  ",?"+
			  " )";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,HID);
		pstmtDt.setString(2,HID);
		pstmtDt.setString(3,STATUS_CODE);
		pstmtDt.setString(4,UserName);
		pstmtDt.setString(5,(request.getParameter("REMARKS")==null?"":request.getParameter("REMARKS")));
		pstmtDt.executeQuery();
		pstmtDt.close();
				
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("退件成功!若要繼續審核下一筆請按確定鍵,否則按下取消鍵回首頁!"))
			{
				setSubmit("../jsp/TSCStockTransConfirm.jsp?WKCODE=<%=WKCODE%>");
			}
			else
			{
				setSubmit("../ORADDSMainMenu.jsp");
			}
		</script>
	<%			
	}
	catch(Exception e)
	{	
		con.rollback();
		res_flag="E";
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCStockTransConfirm.jsp?WKCODE="+WKCODE+"'>回審核功能</a></font>");
	}	
}
else if (STATUS_CODE.equals("COMPLY"))
{
	try
	{
		String ERP_GROUP_ID="";
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("No Request Data found!!");
		}
		
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(" SELECT APPS.TSC_STOCK_TRANS_GROUP_ID_S.nextval from dual");
		if (rs1.next())
		{
			ERP_GROUP_ID = rs1.getString(1);
		}
		else
		{
			rs1.close();
			statement1.close();		
			throw new Exception("ERP GROUP ID取得失敗!!");
		}
		rs1.close();
		statement1.close();				
		
		insert_cnt=0;		
		for(int i=0; i< chk.length ;i++)
		{
			sql = " update oraddman.tsc_stock_trans_lines a"+
				  " set last_updated_by=?"+
				  " ,last_update_date=sysdate"+
				  " ,erp_revised_by=?"+
				  " ,erp_revise_date=sysdate"+
				  " ,erp_group_id=?*(select case when substr(x.REQ_NO,1,1)=? and x.TRANS_TYPE=? then -1 else 1 end  from oraddman.tsc_stock_trans_headers x where x.req_header_id=a.req_header_id)"+
				  " ,erp_comply_flag=(select case when substr(x.REQ_NO,1,1)=? and x.TRANS_TYPE=? then ? else ? end  from oraddman.tsc_stock_trans_headers x where x.req_header_id=a.req_header_id)"+
				  " ,erp_error_msg =?"+
				  " where req_line_id=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,UserName);	
			pstmtDt.setString(2,UserName);	
			pstmtDt.setString(3,ERP_GROUP_ID);	
			pstmtDt.setString(4,"A");	
			pstmtDt.setString(5,"02");	
			pstmtDt.setString(6,"A");	
			pstmtDt.setString(7,"02");	
			pstmtDt.setString(8,"F");	
			pstmtDt.setString(9,"W");	
			pstmtDt.setString(10,"");	
			pstmtDt.setString(11,chk[i]);	
			pstmtDt.executeQuery();
			pstmtDt.close();
			insert_cnt++;
		}	
		if (insert_cnt>0)
		{
			sql = "select req_header_id from oraddman.tsc_stock_trans_headers a where exists (select 1 from oraddman.tsc_stock_trans_lines b where abs(b.erp_group_id)=? and b.req_header_id=a.req_header_id)";
			PreparedStatement statement2=con.prepareStatement(sql);
			statement2.setString(1,ERP_GROUP_ID);
			ResultSet rs2=statement2.executeQuery();
			while  (rs2.next())
			{
				sql = " update oraddman.tsc_stock_trans_headers a"+
					  " set status_code=case when (select count(1) from oraddman.tsc_stock_trans_lines c where c.req_header_id=a.req_header_id and c.erp_comply_flag is null)>0 then a.status_code else ? end "+
					  " ,last_updated_by=?"+
					  " ,last_update_date=sysdate"+
					  " where req_header_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"CLOSED");
				pstmtDt.setString(2,UserName);	
				pstmtDt.setString(3,rs2.getString("req_header_id"));	
				pstmtDt.executeQuery();
				pstmtDt.close();	
				
				sql = " INSERT INTO ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG "+
					  " (REQ_HEADER_ID, "+
					  " SEQ_ID,"+
					  " ACTION_CODE, "+
					  " CREATED_BY,"+
					  " CREATION_DATE, "+
					  " REMARKS"+
					  " )"+
					  " VALUES "+
					  " ("+
					  " ?"+
					  ",NVL((SELECT max(SEQ_ID) FROM ORADDMAN.TSC_STOCK_TRANS_ACTION_LOG WHERE REQ_HEADER_ID=?),0)+1"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  " )";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,rs2.getString("req_header_id"));
				pstmtDt.setString(2,rs2.getString("req_header_id"));
				pstmtDt.setString(3,STATUS_CODE);
				pstmtDt.setString(4,UserName);
				pstmtDt.setString(5,"");
				pstmtDt.executeQuery();
				pstmtDt.close();				
			}
			rs2.close();
			statement2.close();	

			CallableStatement cs3 = con.prepareCall("{call TSC_STOCK_TRANS_PKG.SUBMIT_REQ(?,?)}");
			cs3.setString(1,ERP_GROUP_ID); 
			cs3.setString(2,UserName); 
			cs3.execute();
			cs3.close();	
					
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("動作成功!若要繼續下一筆請按確定鍵,否則按下取消鍵回首頁!"))
			{
				setSubmit("../jsp/TSCStockTransComply.jsp?WKCODE=<%=WKCODE%>");
			}
			else
			{
				setSubmit("../ORADDSMainMenu.jsp");
			}
		</script>
	<%			
	}
	catch(Exception e)
	{	
		con.rollback();
		res_flag="E";
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCStockTransComply.jsp?WKCODE="+WKCODE+"'>回轉倉或料號移轉功能</a></font>");
	}	
}

if (res_flag.equals("S") && (STATUS_CODE.equals("REJECTED") || STATUS_CODE.equals("CONFIRMED") || STATUS_CODE.equals("NEWREQ")))
{
	try
	{
		Properties props = System.getProperties();
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", "mail.ts.com.tw");
		props.put("mail.smtp.port", "25");
		String remarks="",strSubject="",strContent="",strUrl= request.getRequestURL().toString(),strProgram="";
		strUrl=strUrl.substring(0,strUrl.lastIndexOf("/"));
		strProgram=strUrl;
		boolean  testenv_flag=false;
		if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("rfq134.") <0 &&request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0  && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.134") <0 && request.getRequestURL().toString().toLowerCase().indexOf("10.0.1.135") <0) //測試環境
		{
			testenv_flag=true;
		}
		
		Session s = Session.getInstance(props, null);
		javax.mail.internet.MimeMessage message = new javax.mail.internet.MimeMessage(s);
		message.setSentDate(new java.util.Date());
		message.setFrom(new javax.mail.internet.InternetAddress("prodsys@ts.com.tw"));
		
		sql = " select a.req_no"+
			  ",a.req_header_id"+
			  ",a.wkflow_level"+
			  ",b.wkflow_next_level"+
			  ",c.user_name"+
			  ",d.usermail"+
			  ",e.usermail req_usermail"+
			  ",f.trans_desc"+
			  ",substr(a.wkflow_level,1,1) wkcode"+
			  " from oraddman.tsc_stock_trans_headers a"+
			  ",oraddman.tsc_stock_trans_wkflow b"+
			  ",oraddman.tsc_stock_trans_member c"+
			  ",oraddman.wsuser d,oraddman.wsuser e"+
			  ",oraddman.tsc_stock_trans_type f"+
			  " where a.trans_type=b.trans_type"+
			  " and a.wkflow_level=b.wkflow_level"+
			  " and b.trans_type=c.trans_type"+
			  " and b.wkflow_next_level=c.wkflow_level"+
			  " and c.user_name=d.username"+
			  " and a.created_by=e.username"+
			  " and a.trans_type=f.trans_type"+
			  " and a.req_header_id=?";
		PreparedStatement statement2=con.prepareStatement(sql);
		statement2.setString(1,HID);
		ResultSet rs2=statement2.executeQuery();
		while (rs2.next())
		{
			if (STATUS_CODE.equals("REJECTED"))
			{
				strProgram =strUrl+"//TSCStockTransQuery.jsp?WKCODE="+rs2.getString("wkcode")+"&HID="+rs2.getString("req_header_id");
				if (testenv_flag) //測試環境
				{
					remarks="(This is a test letter, please ignore it)";
					//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("req_usermail")));  
				}
				else
				{	
					message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("req_usermail")));  
				}
				strSubject = rs2.getString("trans_desc")+":"+rs2.getString("req_no")+" has been rejected"+remarks;
				strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to review reject reason.<br><br>p.s. login account & password with the ERP system same";
			}
			else
			{
				if (STATUS_CODE.equals("CONFIRMED") && rs2.getString("wkflow_next_level").substring(1,2).equals("9"))
				{
					strProgram =strUrl+"/TSCStockTransComply.jsp?WKCODE="+rs2.getString("wkcode")+"&HID="+rs2.getString("req_header_id") ;
					if (testenv_flag) //測試環境
					{
						remarks="(This is a test letter, please ignore it)";
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("usermail")));
					}
					else
					{	
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("usermail")));
					} 
					strSubject =rs2.getString("trans_desc")+":"+rs2.getString("req_no")+" has been approved"+remarks;
					strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to comply the ERP system transactions.<br><br>p.s. login account & password with the ERP system same";
				}
				else		
				{
					strProgram =strUrl+"/TSCStockTransConfirm.jsp?WKCODE="+rs2.getString("wkcode")+"&HID="+rs2.getString("req_header_id") ;
					if (testenv_flag) //測試環境
					{
						remarks="(This is a test letter, please ignore it)";
						//message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress("peggy_chen@ts.com.tw"));
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("usermail")));
					}
					else
					{	
						message.addRecipient(Message.RecipientType.TO, new javax.mail.internet.InternetAddress(rs2.getString("usermail")));
					} 
					strSubject =rs2.getString("trans_desc")+":"+rs2.getString("req_no")+" is waiting for your approval"+remarks;
					strContent = "Request Notification,<p>Please login at:<a href="+'"'+strProgram+'"'+">"+strUrl+"</a> to approve.<br><br>p.s. login account & password with the ERP system same";
				}
			}
		}
		rs2.close();
		statement2.close();
					  
		message.addRecipient(Message.RecipientType.BCC, new javax.mail.internet.InternetAddress("peggy.chen@ts.com.tw"));
			
		message.setSubject(strSubject, "UTF-8");
		javax.mail.internet.MimeMultipart mp = new javax.mail.internet.MimeMultipart();
		javax.mail.internet.MimeBodyPart mbp = new javax.mail.internet.MimeBodyPart();
		mbp.setContent(strContent, "text/html;charset=UTF-8");
	
		// create the Multipart and add its parts to it
		mp.addBodyPart(mbp);
		message.setContent(mp);
		Transport.send(message);
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}	
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

