<!--modify by Peggy 20170920,新增remarks欄位-->
<!--modify by Peggy 20171205,檢查供應商來貨D/C是否符FIFO,不符者需填入原因-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>TEW PO Receive Process</title>
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
<FORM ACTION="TEWPOReceiveProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";

if (TRANSTYPE.equals("INSERT"))
{
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無收料交易!!");
		}
		for(int i=0; i< chk.length ;i++)
		{
			sql = "select 1 from oraddman.TEWPO_RECEIVE_HEADER where po_line_location_id=?";
			//out.println(sql);
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,chk[i]);
			ResultSet rs1=statement1.executeQuery();
			if (!rs1.next())
			{
				sql = " insert into oraddman.TEWPO_RECEIVE_HEADER"+
				 	  "(po_line_location_id"+    //1
					  ",po_no"+                  //2
					  ",po_header_id"+           //3
					  ",po_line_id"+             //4
					  ",organization_id"+        //5
					  ",inventory_item_id"+      //6
					  ",item_name"+              //7
					  ",item_desc"+              //8
					  ",creation_date"+          //9
					  ",created_by"+             //10
					  ",last_update_date"+       //11
					  ",last_updated_by"+        //12
					  ",vendor_name"+            //13
					  ",vendor_site_id)"+        //14
				      " values"+
				      "(?"+                      //1
				      ",?"+                      //2
				      ",?"+                      //3
				      ",?"+                      //4
				      ",?"+                      //5
				      ",?"+                      //6
				      ",?"+                      //7
				      ",?"+                      //8
				      ",sysdate"+                //9
				      ",?"+                      //10
				      ",sysdate"+                //11
				      ",?"+                      //12
				      ",?"+                      //13
					  ",?)";                     //14
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]); 
				pstmtDt.setString(2,request.getParameter("PO_NO_"+chk[i]));
				pstmtDt.setString(3,request.getParameter("PO_HEADER_ID_"+chk[i])); 
				pstmtDt.setString(4,request.getParameter("PO_LINE_ID_"+chk[i]));
				pstmtDt.setString(5,request.getParameter("ORG_ID_"+chk[i]));
				pstmtDt.setString(6,request.getParameter("ITEM_ID_"+chk[i])); 
				pstmtDt.setString(7,request.getParameter("ITEM_NAME_"+chk[i]));
				pstmtDt.setString(8,request.getParameter("ITEM_DESC_"+chk[i])); 
				pstmtDt.setString(9,UserName);
				pstmtDt.setString(10,UserName);
				pstmtDt.setString(11,request.getParameter("VENDOR_NAME_"+chk[i]));
				pstmtDt.setString(12,request.getParameter("VENDOR_SITE_ID_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			else
			{
				sql = " update oraddman.TEWPO_RECEIVE_HEADER"+
					  " set last_update_date=sysdate"+
					  ",last_updated_by=?"+
					  " where po_line_location_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName);
				pstmtDt.setString(2,chk[i]); 
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			rs1.close();  
			statement1.close();
			
			String LotArray[][]=POReceivingBean.getArray2DContent();
			if (LotArray!=null)
			{
				for( int j=0 ; j< LotArray.length ; j++ ) 
				{
					//line_location_id
					if (LotArray[j][0] != null && LotArray[j][0].equals(chk[i]))
					{
						sql = "select 1 from oraddman.tewpo_receive_detail where po_line_location_id=? and lot_number=? and date_code=? and received_date=to_date(?,'yyyy/mm/dd')";
						PreparedStatement statement2 = con.prepareStatement(sql);
						statement2.setString(1,chk[i]);
						statement2.setString(2,LotArray[j][2]); 
						statement2.setString(3,LotArray[j][3]); 
						statement2.setString(4,LotArray[j][1]); 								
						ResultSet rs2=statement2.executeQuery();
						if (rs2.next())
						{	
							sql = " update oraddman.tewpo_receive_detail "+
							      " set RECEIVED_QUANTITY=RECEIVED_QUANTITY+?"+
								  " ,LAST_UPDATE_DATE=sysdate"+
								  " ,LAST_UPDATED_BY=?"+
								  ", REMARKS=NVL(REMARKS,'')||?"+  //add by Peggy 20170920
								  ", NO_MATCH_FIFO_REASON=?"+      //add by Peggy 20171205
								  " where po_line_location_id=?"+
								  " and lot_number=?"+
								  " and date_code=?"+
								  " and RECEIVED_DATE=to_date(?,'yyyy/mm/dd')";
							PreparedStatement pstmtDtl=con.prepareStatement(sql);  
							pstmtDtl.setString(1,LotArray[j][4]); 
							pstmtDtl.setString(2,UserName); 
							pstmtDtl.setString(3,LotArray[j][5]); 
							pstmtDtl.setString(4,LotArray[j][6]); 
							pstmtDtl.setString(5,LotArray[j][0]); 
							pstmtDtl.setString(6,LotArray[j][2]); 
							pstmtDtl.setString(7,LotArray[j][3]); 
							pstmtDtl.setString(8,LotArray[j][1]); 
							pstmtDtl.executeQuery();
							pstmtDtl.close();								  
						}
						else
						{				
							sql =" insert into oraddman.tewpo_receive_detail "+
								 "(po_line_location_id"+      //1
								 ",lot_number"+               //2
								 ",date_code"+                //3
								 ",received_quantity"+        //4
								 ",received_date"+            //5
								 ",shipped_quantity"+         //6
								 ",creation_date"+            //7
								 ",created_by"+               //8
								 ",last_update_date"+         //9
								 ",last_updated_by"+          //10
								 ",seq_id"+                   //11
								 ",remarks"+                  //12
								 ", NO_MATCH_FIFO_REASON"+    //13
								 ")"+
								 " select "+
								 " ?"+                        //1
								 ",?"+                        //2
								 ",?"+                        //3
								 ",?"+                        //4
								 ",to_date(?,'yyyymmdd')"+    //5
								 ",?"+                        //6
								 ",sysdate"+                  //7
								 ",?"+                        //8
								 ",sysdate"+                  //9
								 ",?"+                        //10
								 ",APPS.TEW_RECEIVE_SEQ_ID_S.nextval "+  //11
								 ",?"+                        //12,add by Peggy 20170920
								 ",?"+                        //13,add by Peggy 20171205
								 " from dual";
							PreparedStatement pstmtDtl=con.prepareStatement(sql);  
							pstmtDtl.setString(1,LotArray[j][0]); 
							pstmtDtl.setString(2,LotArray[j][2]); 
							pstmtDtl.setString(3,LotArray[j][3]); 
							pstmtDtl.setString(4,LotArray[j][4]); 
							pstmtDtl.setString(5,LotArray[j][1]); 
							pstmtDtl.setString(6,"0"); 
							pstmtDtl.setString(7,UserName); 
							pstmtDtl.setString(8,UserName); 
							pstmtDtl.setString(9,LotArray[j][5]); 
							pstmtDtl.setString(10,LotArray[j][6]); 
							pstmtDtl.executeQuery();
							pstmtDtl.close();
						}
						rs2.close();
						statement2.close();
					}
				}
			}
		}	
		con.commit();
		POReceivingBean.setArray2DString(null);	
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("收貨動作成功!!");
			setSubmit("../jsp/TEWPOReceive.jsp");
		</script>
	<%		
	}
	catch(Exception e)
	{	
		con.rollback();
		POReceivingBean.setArray2DString(null);	
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TEWPOReceive.jsp'>回廠商來貨收料功能</a></font>");
	}
}
else if (TRANSTYPE.equals("UPDATE"))
{
	try
	{
		String ACTIONCODE = request.getParameter("ACTIONCODE");
		String RESULT_MSG = request.getParameter("RESULT_MSG");
		if (RESULT_MSG==null) RESULT_MSG="";
		String NEW_SEQ_ID =""; //add by Peggy 20140724
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無處理交易!!");
		}
		for(int i=0; i< chk.length ;i++)
		{
			sql = " select count(1) from oraddman.tewpo_receive_revise where request_id=? and APPROVE_FLAG=?";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,chk[i]);
			statement1.setString(2,"N");
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{
				if (rs1.getInt(1)>0)
				{
					NEW_SEQ_ID ="";
					if (ACTIONCODE.equals("Y"))
					{
						sql = " update oraddman.tewpo_receive_detail a"+
							  "	set RECEIVED_QUANTITY=RECEIVED_QUANTITY - nvl((select OLD_RECEIVED_QUANTITY from oraddman.tewpo_receive_revise y where y.request_id=?),0)"+
							  ",last_update_date=sysdate"+
							  ",last_updated_by=?"+
							  " where exists (select 1 from oraddman.tewpo_receive_revise x "+
							  " where x.po_line_location_id=a.po_line_location_id "+
							  " and x.OLD_LOT_NUMBER = a.lot_number "+
							  " and x.OLD_DATE_CODE=a.date_code "+
							  " and x.OLD_RECEIVED_DATE=a.received_date "+
							  " and x.seq_id = a.seq_id "+
							  " and x.request_id=?)";
						PreparedStatement pstmtDt1=con.prepareStatement(sql);  
						pstmtDt1.setString(1,chk[i]);
						pstmtDt1.setString(2,UserName);
						pstmtDt1.setString(3,chk[i]);
						pstmtDt1.executeQuery();
						pstmtDt1.close();	
						
						sql = " select seq_id from oraddman.tewpo_receive_detail a"+
							  " where exists (select 1 from oraddman.tewpo_receive_revise x"+
							  " where x.po_line_location_id=a.po_line_location_id"+
							  " and x.new_lot_number=a.lot_number"+
							  " and x.new_date_code=a.date_code"+
							  " and x.new_received_date=a.received_date"+
							  " and x.request_id=?)";
						PreparedStatement statement2 = con.prepareStatement(sql);
						statement2.setString(1,chk[i]);
						ResultSet rs2=statement2.executeQuery();
						if (rs2.next())
						{	
							NEW_SEQ_ID=rs2.getString(1); //add by Peggy 20140724
							
							sql = " update oraddman.tewpo_receive_detail a "+
								  " set RECEIVED_QUANTITY=RECEIVED_QUANTITY+ nvl((select NEW_RECEIVED_QUANTITY from oraddman.tewpo_receive_revise y where y.request_id=?),0)"+
								  " ,LAST_UPDATE_DATE=sysdate"+
								  " ,LAST_UPDATED_BY=?"+
								  " where seq_id =?";
								  //" where exists (select 1 from oraddman.tewpo_receive_revise x"+
								  //" where x.po_line_location_id=a.po_line_location_id"+
								  //" and x.new_lot_number=a.lot_number"+
								  //" and x.new_date_code=a.date_code"+
								  //" and x.new_received_date=a.received_date"+
								  //" and x.request_id=?)";
							PreparedStatement pstmtDt2=con.prepareStatement(sql);  
							pstmtDt2.setString(1,chk[i]); 
							pstmtDt2.setString(2,UserName); 
							//pstmtDt2.setString(3,chk[i]); 
							pstmtDt2.setString(3,NEW_SEQ_ID); 
							pstmtDt2.executeQuery();
							pstmtDt2.close();	
						}					
						else
						{
							//modify by Peggy 20140724
							sql = " select APPS.TEW_RECEIVE_SEQ_ID_S.nextval from dual";
							Statement statement3 = con.createStatement();
							ResultSet rs3=statement3.executeQuery(sql);
							if (rs3.next())
							{
								NEW_SEQ_ID=rs3.getString(1);
							}
							rs3.close();
							statement3.close();
							
							sql = " insert into oraddman.tewpo_receive_detail "+
								  " (po_line_location_id"+      //1
								  ",lot_number"+               //2
								  ",date_code"+                //3
								  ",received_quantity"+        //4
								  ",received_date"+            //5
								  ",shipped_quantity"+         //6
								  ",creation_date"+            //7
								  ",created_by"+               //8
								  ",last_update_date"+         //9
								  ",last_updated_by"+          //10
								  ",seq_id"+                   //11
								  ")"+
								  " select po_line_location_id"+
								  ",new_lot_number"+
								  ",new_date_code"+
								  ",new_received_quantity"+
								  ",new_received_date"+
								  ",0"+
								  ",sysdate"+
								  ",CREATED_BY"+
								  ",sysdate"+
								  ",CREATED_BY"+
								  ",'"+NEW_SEQ_ID+"'"+
								  " from oraddman.tewpo_receive_revise x"+
								  " where request_id=?";
							PreparedStatement pstmtDt2=con.prepareStatement(sql);  
							pstmtDt2.setString(1,chk[i]); 
							pstmtDt2.executeQuery();
							pstmtDt2.close();	
						}
						rs2.close();
						statement2.close();
					}		

					sql = " update oraddman.tewpo_receive_revise"+
						  " set APPROVE_FLAG=?"+
						  ",last_update_date=sysdate"+
						  ",last_updated_by=?"+
						  ",RESULT_MSG=?"+
						  ",NEW_SEQ_ID=?"+
						  " where request_id=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,ACTIONCODE);
					pstmtDt.setString(2,UserName);
					pstmtDt.setString(3,RESULT_MSG);
					pstmtDt.setString(4,NEW_SEQ_ID);
					pstmtDt.setString(5,chk[i]); 
					pstmtDt.executeQuery();
					pstmtDt.close();	
				}	  
			}
			rs1.close();
			statement1.close();
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("動作成功!!");
			setSubmit("../jsp/TEWPOReviseConfirm.jsp");
		</script>
	<%			
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TEWPOReviseConfirm.jsp'>回收料修改確認功能</a></font>");
	}	
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

