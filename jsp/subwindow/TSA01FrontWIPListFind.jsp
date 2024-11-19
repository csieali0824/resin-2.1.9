<!--20170814 Peggy,新增21 : 原物料-重驗合格倉 22 : 半成品-重驗合格倉-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="FrontWIPBean" scope="session" class="Array2DimensionInputBean"/>
<!--<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSA01 WIP List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setClick(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.SUBFORM.chkbox.length != undefined)
	{
		chkflag = document.SUBFORM.chkbox[irow-1].checked; 
		lineid = document.SUBFORM.chkbox[irow-1].value;
	}
	else
	{
		chkflag = document.SUBFORM.chkbox.checked; 
		lineid = document.SUBFORM.chkbox.value;
	}
	if (chkflag == true)
	{
		if (document.SUBFORM.CTYPENO.value =="C008")  //半成品
		{
			document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = ""+(parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value));
		}
		else
		{
			if (parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value)>= parseFloat(document.SUBFORM.REQQTY.value))
			{
				document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = document.SUBFORM.REQQTY.value;
			}
			else
			{
				document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = ""+(parseFloat(document.SUBFORM.elements["ONHAND_"+lineid].value));
			}
		}
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].disabled = false;
	}
	else
	{
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].value = "";
		document.SUBFORM.elements["ALLOT_SHIP_QTY_"+lineid].disabled = true;
	}
}
function setSubmit1()
{
	var iLen=0;
	var chkvalue = false;
	var chk_cnt =0;	
	var line="";
	var tot_allot_qty =0;
	var chkline="";
	var lot_list="";
	if (document.SUBFORM.chkbox.length != undefined)
	{
		iLen = document.SUBFORM.chkbox.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.SUBFORM.chkbox.checked;
			line = document.SUBFORM.chkbox.value;
		}
		else
		{
			chkvalue = document.SUBFORM.chkbox[i-1].checked;
			line = document.SUBFORM.chkbox[i-1].value;
		}
		if (chkvalue==true)
		{
			chkline = line;
			if (document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value==null || document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value=="" || isNaN(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value))
			{
				alert("請輸入數字型態!!");
				document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].focus();
				return false;
			}
			//if (parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value) > (parseFloat(document.SUBFORM.elements["ONHAND_"+line].value)))
			//{
			//	alert("批號:"+document.SUBFORM.elements["LOT_"+line].value+" 分配量("+parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value)+")不可超過可使用量("+(parseFloat(document.SUBFORM.elements["ONHAND_"+line].value))+")");
			//	return false;
			//}
			
			tot_allot_qty = parseFloat(tot_allot_qty) + parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value);
			if (lot_list.length>0) lot_list +="\n";
			lot_list += document.SUBFORM.elements["LOT_"+line].value + "   "+document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value+document.SUBFORM.UOM.value;
			chk_cnt++;
		}
	}
	if (tot_allot_qty < parseFloat(document.SUBFORM.REQQTY.value))
	{
		//alert("分配量必須大於等於工單用量!!");
		//return false;
	}
	document.SUBFORM.submit1.disabled= true;
	window.opener.document.MYFORM.elements["LOT_LIST_"+document.SUBFORM.LINENO.value].value = lot_list;
	if (document.SUBFORM.CTYPENO.value =="C008")  //半成品
	{
		window.opener.document.MYFORM.elements["REQUEST_QTY_"+document.SUBFORM.LINENO.value].value = tot_allot_qty;
	}	
	document.SUBFORM.action="TSA01FrontWIPListFind.jsp?PTYPE=SAVE";
	document.SUBFORM.submit();	
	
}
function setClose()
{
	//window.opener.document.getElementById("alpha").style.width="0%";
	//window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSA01FrontWIPListFind.jsp" NAME="SUBFORM">
<%
String sql = "";
String ITEMID  =request.getParameter("ITEMID");
if (ITEMID==null) ITEMID="";
String UOM  =request.getParameter("UOM");
if (UOM==null) UOM="";
String ITEM_NAME = request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String ORGANIZATION_ID= request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="";
String LINENO = request.getParameter("LINENO");
if (LINENO==null ) LINENO="";
String REQQTY = request.getParameter("REQQTY");
if (REQQTY==null) REQQTY="";
String PTYPE = request.getParameter("PTYPE");
if (PTYPE ==null) PTYPE="";
String WIPNO = request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String CTYPENO = request.getParameter("CTYPENO");
if (CTYPENO==null) CTYPENO=""; 

if (!PTYPE.equals("SAVE"))
{
%>
<table width="100%">
	<tr>
		<td>
			<%     
				try
				{ 
					/*
					sql = " SELECT A.WIP_ENTITY_NAME"+
					      ",A.WIP_ENTITY_ID"+
						  ",D.INVENTORY_ITEM_ID"+
						  ",D.SEGMENT1 ITEM_NAME"+
						  ",D.DESCRIPTION ITEM_DESC"+
						  ",D.PRIMARY_UOM_CODE UOM"+
						  ",A.ORGANIZATION_ID"+
						  ",NVL(C.QUANTITY_IN_QUEUE,0) + NVL(C.QUANTITY_RUNNING,0)+ NVL(C.QUANTITY_WAITING_TO_MOVE,0)+NVL(C.QUANTITY_COMPLETED,0)-NVL(C.QUANTITY_SCRAPPED,0)-NVL(C.QUANTITY_REJECTED,0) WIP_QTY"+
						  ",(SELECT SUM(WIP_QTY) FROM ORADDMAN.TSA01_REQUEST_SUBSTRATE_ALL X WHERE X.ORGANIZATION_ID=A.ORGANIZATION_ID AND X.WIP_ENTITY_ID=A.WIP_ENTITY_ID) ALLOT_QTY"+
                          " FROM WIP.WIP_ENTITIES A"+
						  ",WIP.WIP_DISCRETE_JOBS B"+
						  ",WIP_OPERATIONS_V C"+
						  ",INV.MTL_SYSTEM_ITEMS_B D"+
                          " WHERE A.WIP_ENTITY_ID=B.WIP_ENTITY_ID"+
                          " AND A.ORGANIZATION_ID=B.ORGANIZATION_ID"+
                          " AND A.ORGANIZATION_ID=?"+
                          " AND B.PRIMARY_ITEM_ID=?"+
                          " AND B.STATUS_TYPE<>? "+
                          " AND B.WIP_ENTITY_ID=C.WIP_ENTITY_ID"+
                          " AND B.ORGANIZATION_ID=C.ORGANIZATION_ID"+
                          " AND C.DEPARTMENT_ID=? "+
						  " AND TRUNC(B.SCHEDULED_START_DATE)>= TO_DATE('20'||SUBSTR(?,4,6),'YYYYMMDD')-7"+
                          " AND NVL(C.QUANTITY_IN_QUEUE,0) + NVL(C.QUANTITY_RUNNING,0)+ NVL(C.QUANTITY_WAITING_TO_MOVE,0)+NVL(C.QUANTITY_COMPLETED,0)-NVL(C.QUANTITY_SCRAPPED,0)-NVL(C.QUANTITY_REJECTED,0) >0"+
						  " AND A.ORGANIZATION_ID=D.ORGANIZATION_ID"+
						  " AND A.PRIMARY_ITEM_ID=D.INVENTORY_ITEM_ID"+
                          " ORDER BY A.WIP_ENTITY_NAME";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ORGANIZATION_ID);
					statement.setString(2,ITEMNAME);
					statement.setString(3,"7");
					statement.setInt(4,128);
					statement.setString(5,WIPNO);
						  
					sql = " select a.MONO FRONT_WIP_NO"+
					      ",a.BASELOTNO LOT"+
						  ",a.INPUTQTY WIP_QTY"+
						  ",a.INPUTUNITNO UOM"+
						  ",(SELECT SUM(lot_QTY) FROM ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL X,oraddman.tsa01_request_headers_all y WHERE x.REQUEST_NO=y.REQUEST_NO and y.STATUS not in ('REJECT','DISAGREE') AND X.WIP_NO=A.MONO AND X.LOT=A.BASELOTNO) ALLOT_QTY";
					if (request.getRequestURL().toString().toLowerCase().indexOf("tsrfq.") <0 && request.getRequestURL().toString().toLowerCase().indexOf("yewintra.") <0) //測試環境
					{
						sql += " from mesatest.tblwiplotbasis@crp_mestest a ";
					}
					else
					{	 
						sql += " from mesaprd.tblwiplotbasis@prod_mesprod a";
					}
				
					sql += " ,(select distinct c.organization_id,b.segment1 item_name,c.subinventory_code,c.lot_number from inv.mtl_system_items_b b,inv.mtl_onhand_quantities_detail c"+
                           " where b.organization_id=c.organization_id "+
						   " and b.inventory_item_id=c.inventory_item_id"+
						   " and b.organization_id=606) x"+
						   " where a.PRODUCTNO=?"+
						   " and a.PRODUCTNO=x.item_name(+)"+
						   " and a.BASELOTNO=x.lot_number(+)"+
                           " and TO_DATE('20'||SUBSTR(MONO,4,6),'YYYYMMDD') between trunc(sysdate-1080) and sysdate+0.99999"+
						   " ORDER BY a.BASELOTNO,a.MONO";
					*/
					sql =" select '' as FRONT_WIP_NO,c.lot_number lot,sum(c.transaction_quantity) WIP_QTY,c.transaction_uom_code UOM,"+
                         " NVL((SELECT SUM(lot_QTY) FROM ORADDMAN.TSA01_REQUEST_WAFER_LOT_ALL X,oraddman.tsa01_request_lines_all y WHERE x.REQUEST_NO=y.REQUEST_NO and y.STATUS not in ('REJECT','DISAGREE','CLOSED') AND  X.LOT=c.lot_number),0) ALLOT_QTY"+
                         " from inv.mtl_system_items_b b,inv.mtl_onhand_quantities_detail c"+
                         " where b.organization_id=c.organization_id "+
                         " and b.inventory_item_id=c.inventory_item_id"+
                         " and b.organization_id=?"+
                         " and b.segment1=?"+
						 " and c.SUBINVENTORY_CODE in (?,?,?,?)"+
						 " group by c.lot_number,c.transaction_uom_code";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,"606");
					statement.setString(2,ITEM_NAME);
					statement.setString(3,"01");
					statement.setString(4,"02");
					statement.setString(5,"21");   //add by Peggy 20170814
					statement.setString(6,"22");   //add by Peggy 20170814
					ResultSet rs=statement.executeQuery();
					int vline=0;
					float useful_qty = 0;
					float tot_allot_qty =0;
					String ALLOT_SHIP_QTY ="",V_FLAG="N",LOT_REMARKS="";
					while (rs.next())
					{
						vline++;
						if (vline==1)
						{
							out.println("<div id='div1' style='font-size:12px'>料號："+ITEM_NAME+"</div>");
							out.println("<font style='color:#000000;font-family:Tahoma,Georgia; font-size: 12px'>需求量："+REQQTY+" "+UOM+"</font><input type='hidden' name='REQQTY' value='"+REQQTY+"'><INPUT TYPE='hidden' name='ITEMID' value='"+ITEMID+"'><input type='hidden' name='WIPNO' value='"+WIPNO+"'>");
							out.println("<TABLE border='1' width='100%' cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#ffffff'>");      
							out.println("<TR bgcolor='#cccccc' align='center'>");
							out.println("<Td width='10%'>工單號碼</Td>");
							out.println("<Td width='10%'>LOT</Td>");
							out.println("<Td width='9%'>工單數量</Td>");
							out.println("<Td width='9%'>已使用量</Td>");
							out.println("<Td width='9%'>可使用量</Td>");
							out.println("<Td width='3%'>&nbsp;</Td>");        
							out.println("<Td width='9%'>此次分配量</Td>");
							out.println("<Td width='11%'>備註</Td>");
							out.println("</TR>");
						}
						ALLOT_SHIP_QTY ="";V_FLAG="N";
						tot_allot_qty =rs.getFloat("ALLOT_QTY"); 
						String AllotArray[][]=FrontWIPBean.getArray2DContent();
						if (AllotArray!=null)
						{
							for( int i=0 ; i<AllotArray.length ; i++ ) 
							{
								if (AllotArray[i][0].equals(WIPNO) && AllotArray[i][1].equals(ITEM_NAME))
								{
									if (AllotArray[i][2].equals(LINENO) && AllotArray[i][4].equals(rs.getString("LOT")))
									{
										ALLOT_SHIP_QTY = AllotArray[i][5];
										LOT_REMARKS = AllotArray[i][6];
										V_FLAG="Y";
									}
									else
									{
										//tot_allot_qty +=  Long.parseLong(AllotArray[i][5]); 
										LOT_REMARKS ="";
									}
								}
							}
						}
						
						useful_qty =rs.getFloat("WIP_QTY")-tot_allot_qty;
						out.println("<TR id='tr_"+vline+"' "+">");
						out.println("<TD>"+ (rs.getString("FRONT_WIP_NO")==null?"&nbsp;":rs.getString("FRONT_WIP_NO"))+"<input type='hidden' name='FRONT_WIP_NO_"+vline+"' value ='"+  (rs.getString("FRONT_WIP_NO")==null?"":rs.getString("FRONT_WIP_NO"))+"'></TD>");
						out.println("<TD>"+ rs.getString("LOT")+"<input type='hidden' name='LOT_"+vline+"' value ='"+ rs.getString("LOT")+"'></TD>");
						out.println("<TD align='right'>"+ rs.getString("WIP_QTY")+"<input type='hidden' name='WIP_QTY_"+vline+"' value='"+rs.getString("WIP_QTY")+"'></TD>");
						out.println("<TD align='right'>"+ tot_allot_qty+"<input type='hidden' name='ALLOT_QTY_"+vline+"' value='"+tot_allot_qty+"'></TD>");
						out.println("<TD align='right' "+(useful_qty>0 ?"style='color:#0000ff'":"")+">"+ useful_qty+"<input type='hidden' name='ONHAND_"+vline+"' value='"+useful_qty+"'></TD>");
						out.println("<TD align='center'><input type='checkbox' name='chkbox' value='"+vline+"' onClick='setClick("+vline+")' "+ (V_FLAG.equals("N")?"":"checked")+">");
						out.println("</TD>");
						out.println("<TD align='center'><input type='text' name='ALLOT_SHIP_QTY_"+vline+"' value='"+ALLOT_SHIP_QTY+"' size='7' style='text-align:right;font-family:Tahoma,Georgia; font-size: 12px' "+ (V_FLAG.equals("N")?"disabled":"")+"></TD>");
						out.println("<TD align='center'><input type='text' name='LOT_REMARKS_"+vline+"' value='"+(LOT_REMARKS.equals("")?"&nbsp;":LOT_REMARKS)+"' style='font-family: Tahoma,Georgia; color: #000000; font-size: 12px'></TD>");
						out.println("</TR>");	
					}
					out.println("</TABLE>");	
					rs.close();  
					statement.close(); 
					
					if (vline>0)
					{
						out.println("<table border='0' width='100%'>");
						out.println("<tr><td align='center'><input type='button' name='submit1' value='確定' onclick='setSubmit1();'></td></tr>");
						out.println("</table>");
						
					}    
					else
					{
						out.println("查無資料!");
					}
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
</table>
<%
}
else
{
	try
	{
		int tot_row  =0, del_cnt=0;
		String chk[]= request.getParameterValues("chkbox");
		//out.println("len="+chk.length);
		String ShipArray [][]=FrontWIPBean.getArray2DContent();
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				if (ShipArray[i][0].equals(WIPNO) && ShipArray[i][1].equals(ITEM_NAME)) del_cnt++;
			}
			tot_row = ShipArray.length + chk.length - del_cnt;	
		}
		else
		{
			tot_row = chk.length;
		}
		String ship_tot [][] = new String [tot_row][7];
		int iLine=0;
		for (int i = 0 ; i < chk.length ; i++)
		{
			ship_tot[iLine][0] = WIPNO;
			ship_tot[iLine][1] = ITEM_NAME;
			ship_tot[iLine][2] = LINENO;
			ship_tot[iLine][3] = request.getParameter("FRONT_WIP_NO_"+chk[i]);
			ship_tot[iLine][4] = request.getParameter("LOT_"+chk[i]);
			ship_tot[iLine][5] = request.getParameter("ALLOT_SHIP_QTY_"+chk[i]);
			ship_tot[iLine][6] = request.getParameter("LOT_REMARKS_"+chk[i]);
			iLine ++;
		} 
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				//out.println(ShipArray[i][0]);
				if (ShipArray[i][0].equals(WIPNO) && ShipArray[i][2].equals(LINENO)) continue;
				//out.println(ShipArray[i][0]);
				ship_tot[iLine][0] = ShipArray[i][0];
				ship_tot[iLine][1] = ShipArray[i][1];
				ship_tot[iLine][2] = ShipArray[i][2];
				ship_tot[iLine][3] = ShipArray[i][3];
				ship_tot[iLine][4] = ShipArray[i][4];
				ship_tot[iLine][5] = ShipArray[i][5];
				ship_tot[iLine][6] = ShipArray[i][6];
				iLine ++;
			}
		}
		FrontWIPBean.setArray2DString(ship_tot);
%>
		<script language="JavaScript" type="text/JavaScript">
			setClose();
		</script>
<%			
	}
	catch(Exception e)
	{
		out.println("<font color='red'>Error:"+e.getMessage()+"</font>");
	}
}
%>
<INPUT TYPE="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
<INPUT TYPE="hidden" name="LINENO" value="<%=LINENO%>">
<INPUT TYPE="hidden" name="PTYPE" value="<%=PTYPE%>">
<INPUT TYPE="hidden" name="UOM" value="<%=UOM%>">
<INPUT TYPE="hidden" name="ITEM_NAME" value="<%=ITEM_NAME%>">
<input type="hidden" name="WIPNO" value="<%=WIPNO%>">
<input type="hidden" name="CTYPENO" value="<%=CTYPENO%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
