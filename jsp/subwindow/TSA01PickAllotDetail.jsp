<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="WIPBean" scope="session" class="Array2DimensionInputBean"/>
<!--<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<%
String sql = "";
String PICK_HEADER_ID = request.getParameter("PICK_HEADER_ID");
if (PICK_HEADER_ID==null) PICK_HEADER_ID="";
String PICK_LINE_ID = request.getParameter("PICK_LINE_ID");
if (PICK_LINE_ID==null) PICK_LINE_ID="";
String LOT = request.getParameter("LOT");
if (LOT==null) LOT="";
String PICK_QTY = request.getParameter("PICK_QTY");
if (PICK_QTY==null) PICK_QTY="";
String UOM  =request.getParameter("UOM");
if (UOM==null) UOM="";
String SEQ_NO = request.getParameter("SEQ_NO");
if (SEQ_NO==null) SEQ_NO="";
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="";
float ALLOT_SHIP_QTY=0;
%>
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
<title>TSA01 WIP Allot List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1()
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var line="";
	var tot_allot_qty =0;
	var vendor_id ="";
	var chkline="";
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
			else if (document.SUBFORM.COMP_TYPE_CODE.value !="C001" && document.SUBFORM.COMP_TYPE_CODE.value !="C008")
			{
				if (parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value) !=0 && parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value) != parseFloat(document.SUBFORM.elements["REQUEST_QTY_"+line].value) )
				{
					alert("撿貨量必須等於領用量!!");
					return false;
				}
			}
			tot_allot_qty += parseFloat(document.SUBFORM.elements["ALLOT_SHIP_QTY_"+line].value);
		}
	}
	document.SUBFORM.submit1.disabled= true;
	if (tot_allot_qty <= parseFloat(document.SUBFORM.PICK_QTY.value))
	{
		window.opener.document.MYFORMD.elements["PICK_QTY_"+document.SUBFORM.SEQ_NO.value].value = document.SUBFORM.PICK_QTY.value
	}
	else
	{
		window.opener.document.MYFORMD.elements["PICK_QTY_"+document.SUBFORM.SEQ_NO.value].value = tot_allot_qty;
	}
	if (document.SUBFORM.COMP_TYPE_CODE.value =="C001" || document.SUBFORM.COMP_TYPE_CODE.value =="C008")	
	{
		window.opener.document.MYFORMD.elements["ISSUE_QTY_"+document.SUBFORM.SEQ_NO.value].value = tot_allot_qty;
	}
	document.SUBFORM.action="TSA01PickAllotDetail.jsp?ACODE=SAVE";
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
<FORM METHOD="post" ACTION="TSA01PickAllotDetail.jsp" NAME="SUBFORM">
<INPUT TYPE="hidden" NAME="LOT" VALUE="<%=LOT%>">
<INPUT TYPE="hidden" NAME="PICK_HEADER_ID" VALUE="<%=PICK_HEADER_ID%>">
<INPUT TYPE="hidden" NAME="PICK_LINE_ID" VALUE="<%=PICK_LINE_ID%>">
<INPUT TYPE="hidden" NAME="UOM" VALUE="<%=UOM%>">
<INPUT TYPE="hidden" NAME="PICK_QTY" VALUE="<%=PICK_QTY%>">
<INPUT TYPE="hidden" NAME="SEQ_NO" VALUE="<%=SEQ_NO%>">
<%
if (!ACODE.equals("SAVE"))
{
%>
<table width="100%">
	<tr>
		<td>
			<%     
				try
				{ 
					sql = " SELECT a.request_no,b.line_no,a.wip_entity_name,b.component_name,b.request_qty,b.uom,b.pick_header_id,"+
                          " nvl((select sum(lot_qty)  from oraddman.tsa01_request_line_lots_all c where c.request_no=b.request_no and c.line_no=b.line_no and c.pick_header_id=b.pick_header_id and c.pick_line_id=?),0) allot_qty"+
 						  ",c.comp_type_no"+
                           " FROM oraddman.tsa01_request_headers_all a"+
						   ",oraddman.tsa01_request_lines_all b"+
						   ",oraddman.tsa01_component_detail c"+
                           " where a.request_no=b.request_no "+
						   " and a.inventory_item_id=c.inventory_item_id"+
						   " and a.organization_id=c.organization_id"+
                           " and b.pick_header_id=?";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,PICK_LINE_ID);
					statement.setString(2,PICK_HEADER_ID);
					ResultSet rs=statement.executeQuery();
					int vline=0;
					while (rs.next())
					{
						vline++;
						if (vline==1)
						{
							out.println("<div id='div1' style='font-size:12px'>LOT："+LOT+"</div>");
							out.println("<font style='color:#000000;font-family:Tahoma,Georgia; font-size: 12px'>撿貨總量："+PICK_QTY+" "+UOM+"</font><input type='hidden' name='COMP_TYPE_CODE' value='"+rs.getString("comp_type_no")+"'>");
							out.println("<TABLE border='1' width='100%' cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#ffffff'>");      
							out.println("<TR bgcolor='#cccccc' align='center'>");
							out.println("<Td width='8%'>領料單號</Td>");
							out.println("<Td width='10%'>工單號碼</Td>");
							out.println("<Td width='12%'>料號</Td>");
							out.println("<Td width='7%'>領用數量</Td>");
							out.println("<Td width='7%'>單位</Td>");
							out.println("<Td width='11%'>撿貨量</Td>");
							out.println("</TR>");
						}
						ALLOT_SHIP_QTY =rs.getFloat("ALLOT_QTY"); 
						String AllotArray[][]=WIPBean.getArray2DContent();
						if (AllotArray!=null)
						{
							for( int i=0 ; i<AllotArray.length ; i++ ) 
							{
								//if (IDLIST.indexOf(","+AllotArray[i][0]+",") <0 )
								//{
								//	AllotArray[i][0] ="-1";
								//	AllotArray[i][8] ="0";
								// 	continue;
								//}
								//out.println(AllotArray[i][0]);
								//out.println(AllotArray[i][1]);
								//out.println(AllotArray[i][2]);
								//out.println(AllotArray[i][3]);
								if (AllotArray[i][0].equals(PICK_HEADER_ID) && AllotArray[i][1].equals(PICK_LINE_ID) && AllotArray[i][2].equals(rs.getString("request_no")) && AllotArray[i][3].equals(rs.getString("line_no")))
								{
									ALLOT_SHIP_QTY = (AllotArray[i][4]==null?0:Float.parseFloat(AllotArray[i][4]));
								}
							}
						}
						
						//useful_qty =rs.getLong("RECEIVED_QUANTITY")-tot_allot_qty;
						out.println("<TR>");
						out.println("<TD><input type='checkbox' name='chkbox' value='"+vline+"' style='visibility:hidden' checked>");
						out.println(rs.getString("request_no")+"<input type='hidden' name='request_no_"+vline+"' value ='"+ rs.getString("request_no")+"'><input type='hidden' name='line_no_"+vline+"' value ='"+ rs.getString("line_no")+"'></TD>");
						out.println("<TD>"+ rs.getString("wip_entity_name")+"</TD>");
						out.println("<TD>"+ rs.getString("component_name")+"</TD>");
						out.println("<TD align='right'>"+  (new DecimalFormat("######0.####")).format(rs.getFloat("request_qty"))+"<input type='hidden' name='REQUEST_QTY_"+vline+"' value='"+rs.getString("request_qty")+"'></TD>");
						out.println("<TD align='center'>"+ rs.getString("uom")+"</TD>");
						out.println("<TD align='center'><input type='text' name='ALLOT_SHIP_QTY_"+vline+"' value='"+ALLOT_SHIP_QTY+"' size='7' style='text-align:right;font-family:Tahoma,Georgia; font-size: 12px'></TD>");
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
		String ShipArray [][]=WIPBean.getArray2DContent();
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				if (ShipArray[i][0].equals(PICK_HEADER_ID) && ShipArray[i][1].equals(PICK_LINE_ID)) del_cnt++;
			}
			tot_row = ShipArray.length + chk.length - del_cnt;	
		}
		else
		{
			tot_row = chk.length;
		}
		String ship_tot [][] = new String [tot_row][5];
		int iLine=0;
		for (int i = 0 ; i < chk.length ; i++)
		{
			ship_tot[iLine][0] = PICK_HEADER_ID;
			ship_tot[iLine][1] = PICK_LINE_ID;
			ship_tot[iLine][2] = request.getParameter("request_no_"+chk[i]);
			ship_tot[iLine][3] = request.getParameter("line_no_"+chk[i]);
			ship_tot[iLine][4] = request.getParameter("ALLOT_SHIP_QTY_"+chk[i]);
			iLine ++;
		} 
		if (ShipArray!=null)
		{
			for( int i=0 ; i< ShipArray.length ; i++ ) 
			{
				if (ShipArray[i][0].equals(PICK_HEADER_ID) && ShipArray[i][1].equals(PICK_LINE_ID))  continue;
				ship_tot[iLine][0] = ShipArray[i][0];
				ship_tot[iLine][1] = ShipArray[i][1];
				ship_tot[iLine][2] = ShipArray[i][2];
				ship_tot[iLine][3] = ShipArray[i][3];
				ship_tot[iLine][4] = ShipArray[i][4];
				iLine ++;
			}
		}
		WIPBean.setArray2DString(ship_tot);
%>
		<script language="JavaScript" type="text/JavaScript">
			setClose();
		</script>
<%			
	}
	catch(Exception e)
	{
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}
}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
