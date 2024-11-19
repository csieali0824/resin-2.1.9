<!--modify by Peggy 20141121,淨重,毛重欄位開放修改,快遞出貨同一箱毛重加總小於1公斤,以1公斤計,同箱每筆訂單淨重計算結果若小於0.1公斤,以0.1公斤計-->
<!--20151204 by Peggy,TSC_PROD_ROUP更名,Rect=>PRD,SSP=>SSD-->
<!--20180620 Peggy,add TSC_PARTNO欄位取代attribute1-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var carton_num=0;
	var SNO="",ENO="",SHIPPING_METHOD="",CUST_PO="";
	if (document.MYFORM.chk1.length != undefined)
	{
		iLen = document.MYFORM.chk1.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk1.checked;
			lineid = document.MYFORM.chk1.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk1[i-1].checked;
			lineid = document.MYFORM.chk1[i-1].value;
		}
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["SNO_"+lineid].value ==null || document.MYFORM.elements["SNO_"+lineid].value =="")
			{
				alert("項次"+i+":起始箱號不可空白!");
				return false;				
			}
			if (document.MYFORM.elements["ENO_"+lineid].value ==null || document.MYFORM.elements["ENO_"+lineid].value =="")
			{
				alert("項次"+i+":結束箱號不可空白!");
				return false;				
			}
			if (parseInt(document.MYFORM.elements["ENO_"+lineid].value)<parseInt(document.MYFORM.elements["SNO_"+lineid].value))
			{
				alert("項次"+i+":結束箱號不可小於起始箱號!");
				return false;		
			}
			if (document.MYFORM.elements["BOX_CODE_"+lineid].value==null || document.MYFORM.elements["BOX_CODE_"+lineid].value=="" || document.MYFORM.elements["BOX_CODE_"+lineid].value=="null")
			{
				alert("項次"+i+":箱碼不可空白!");
				return false;		
			}
			carton_num = parseInt(document.MYFORM.elements["ENO_"+lineid].value)-parseInt(document.MYFORM.elements["SNO_"+lineid].value)+1; 
			if ((carton_num * document.MYFORM.elements["CARTON_QTY_"+lineid].value) != document.MYFORM.elements["SHIP_QTY_"+lineid].value)
			{
				alert("項次"+i+":總出貨量必須等於出貨數量!");
				return false;		
			}
			//檢查淨重,add by Peggy 20141121
			if (document.MYFORM.elements["NW_"+lineid].value==null || document.MYFORM.elements["NW_"+lineid].value=="")
			{
				alert("項次"+i+":淨重不可為空值!");
				return false;				
			}
			else if (parseFloat(document.MYFORM.elements["NW_"+lineid].value)<=0)
			{
				alert("項次"+i+":淨重不可小於0!");
				return false;		
			}	
			if (document.MYFORM.elements["GW_"+lineid].value==null || document.MYFORM.elements["GW_"+lineid].value=="")
			{
				alert("項次"+i+":毛重不可為空值!");
				return false;					
			}
			//檢查毛重,add by Peggy 20141121
			else if (parseFloat(document.MYFORM.elements["GW_"+lineid].value)<=0)
			{
				alert("項次"+i+":毛重不可小於0!");
				return false;		
			}	
			
			SHIPPING_METHOD = document.MYFORM.elements["SHIPPING_METHOD_"+lineid].value;
			CUST_PO = document.MYFORM.elements["CUST_PO_"+lineid].value;
			for (var j = i+1; j <= iLen ;j++)
			{
				SNO = parseInt(document.MYFORM.elements["SNO_"+document.MYFORM.chk1[j-1].value].value);
				ENO = parseInt(document.MYFORM.elements["ENO_"+document.MYFORM.chk1[j-1].value].value);
			 	if ((SNO >= parseInt(document.MYFORM.elements["SNO_"+lineid].value) && SNO <=parseInt(document.MYFORM.elements["ENO_"+lineid].value)) || 
				    (ENO >= parseInt(document.MYFORM.elements["SNO_"+lineid].value) && ENO <=parseInt(document.MYFORM.elements["ENO_"+lineid].value)))
				{
					if ((SHIPPING_METHOD.indexOf("UPS") <0 && SHIPPING_METHOD.indexOf("TNT") <0 && SHIPPING_METHOD.indexOf("DHL") <0 && SHIPPING_METHOD.indexOf("FEDEX")<0 && SHIPPING_METHOD.indexOf("AIR")<0 && SHIPPING_METHOD.indexOf("SEA")<0) || (SHIPPING_METHOD!= document.MYFORM.elements["SHIPPING_METHOD_"+document.MYFORM.chk1[j-1].value].value))
					{
						alert("項次"+j+"與項次"+i+" 箱號重覆!");
						return false;				
					}
				}
			}	
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	document.MYFORM.save1.disabled=true;
	document.MYFORM.exit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到上頁功能嗎?")==true) 
	{
		document.MYFORM.ADVISE_NO.value="";
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit3(URL)
{   
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var pc_advise_id ="";
	var carton_qty=0;
	if (document.MYFORM.chk1.length != undefined)
	{
		iLen = document.MYFORM.chk1.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk1.checked;
			lineid = document.MYFORM.chk1.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk1[i-1].checked;
			lineid = document.MYFORM.chk1[i-1].value;
			pc_advise_id = document.MYFORM.elements["PC_ADVISE_ID_"+lineid].value;
			carton_qty =  document.MYFORM.elements["CARTON_QTY_"+lineid].value;  //add by Peggy 20160607
			if (chkvalue==true && carton_qty !=0)
			{
				for (var j = i+1; j <= iLen ;j++)
				{
					if (pc_advise_id==document.MYFORM.elements["PC_ADVISE_ID_"+document.MYFORM.chk1[j-1].value].value && document.MYFORM.chk1[j-1].checked==false)
					{
						alert("同一筆訂單的箱號必須一起刪除!");
						return false;
					}
				}
			}
		}
		if (chkvalue==true)
		{
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	if (confirm("您確定要刪除此筆編箱資料?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk1.length != undefined)
	{
		chkflag = document.MYFORM.chk1[irow].checked; 
		lineid = document.MYFORM.chk1[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk1.checked; 
		lineid = document.MYFORM.chk1.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#E4EDE2";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}

function setSubmit5(URL)
{
	document.MYFORM.delete1.disabled= true;
	document.MYFORM.exit1.disabled= true;
	subWin=window.open(URL,"subwin","left=200,width=800,height=600,scrollbars=yes,menubar=no");
}

function objCarton(objid)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var icnt=0,iseq=0;
	var lineid="";
	var TOT_NW=0,TOT_GW=0,TNW=0,TGW=0,TOT_QTY=0,NW=0,GW=0;
	if ( document.MYFORM.elements["SNO_"+objid].value == document.MYFORM.elements["ENO_"+objid].value)
	{
		if (document.MYFORM.chk1.length != undefined)
		{
			iLen = document.MYFORM.chk1.length;
		}
		else
		{
			iLen = 1;
		}
		for (var i=1; i<= iLen ; i++)
		{
			if (iLen==1)
			{
				chkvalue =document.MYFORM.chk1.checked;
				lineid = document.MYFORM.chk1.value;
				TOT_GW = eval(document.MYFORM.elements["ORIG_GW_1_"+lineid].value);
				if (eval(document.MYFORM.elements["ORIG_NW_1_"+lineid].value)<0.1) 
				{
					TOT_NW =0.1;
				}
				else
				{
					TOT_NW = eval(document.MYFORM.elements["ORIG_NW_1_"+lineid].value);
				}
				icnt=1;
			}
			else
			{
				chkvalue = document.MYFORM.chk1[i-1].checked;
				lineid = document.MYFORM.chk1[i-1].value;
				if (chkvalue==true)
				{
					if ( document.MYFORM.elements["SNO_"+lineid].value ==document.MYFORM.elements["SNO_"+objid].value && document.MYFORM.elements["ENO_"+lineid].value ==document.MYFORM.elements["ENO_"+objid].value)
					{
						TOT_GW += eval(document.MYFORM.elements["ORIG_GW_1_"+lineid].value);
						if (eval(document.MYFORM.elements["ORIG_NW_1_"+lineid].value) <0.1)
						{
							TOT_NW += 0.1;
						}
						else
						{						
							TOT_NW += eval(document.MYFORM.elements["ORIG_NW_1_"+lineid].value);
						}
						TOT_QTY += eval(document.MYFORM.elements["SHIP_QTY_"+lineid].value);
						icnt ++;
					}
				}
			}
		}
		if (icnt >0)
		{
			if (eval(TOT_GW)<1)
			{
				if (eval(icnt * 0.1) < 1)
				{
					TGW=1;
				}
				else
				{
					TGW=eval(icnt * 0.1);
				}
			}
			else
			{
				TGW=TOT_GW;
			}
			TOT_GW=TGW;
			TNW=TOT_NW;
			
			for (var i=1; i<= iLen ; i++)
			{
				if (iLen==1)
				{
					document.MYFORM.elements["NW_"+document.MYFORM.chk1.value].value = TNW;				
					document.MYFORM.elements["GW_"+document.MYFORM.chk1.value].value = TGW;				
				}
				else
				{
					chkvalue = document.MYFORM.chk1[i-1].checked;
					lineid = document.MYFORM.chk1[i-1].value;
					if (chkvalue==true)
					{
						if ( document.MYFORM.elements["SNO_"+lineid].value ==document.MYFORM.elements["SNO_"+objid].value && document.MYFORM.elements["ENO_"+lineid].value ==document.MYFORM.elements["ENO_"+objid].value)
						{
							if ((iseq+1)==icnt)
							{
								if (TNW <0.1) TNW =0.1;
								document.MYFORM.elements["NW_"+lineid].value = Math.round(TNW*10)/10;
								if (TGW <0.1) TGW =0.1;
								document.MYFORM.elements["GW_"+lineid].value = Math.round(TGW*10)/10;
							}
							else
							{
								NW =Math.round(eval(document.MYFORM.elements["SHIP_QTY_"+lineid].value) / eval(TOT_QTY) * TOT_NW *10) /10;
								if (NW < 0.1) NW=0.1; 
								document.MYFORM.elements["NW_"+lineid].value = NW;
								TNW -= NW;
								GW =Math.round(eval(document.MYFORM.elements["SHIP_QTY_"+lineid].value) / eval(TOT_QTY) * TOT_GW *10) /10;
								if (GW < 0.1) GW=0.1; 
								document.MYFORM.elements["GW_"+lineid].value = GW;
								TGW -= GW;
							}
							iseq++;
						}
					}
				}
			}
		}
	}
}
</script>
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
<title>TEW 出貨通知確認</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String sql = "",sql1="",sql2="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String ADVISE_NO_LIST="",SSD="",pick_flag="N";
String chk[] = request.getParameterValues("chk");
if (!ATYPE.equals("Q"))
{
	if (chk.length <=0)
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("未勾選編箱資料,請重新確認,謝謝!");
			location.href="/oradds/jsp/TEWShippingBoxConfirmQuery.jsp";
		</script>
	<%
	}
	else
	{
		for(int i=0; i< chk.length ;i++)
		{
			if (ADVISE_NO.equals("")) ADVISE_NO = chk[i];
			if (ADVISE_NO_LIST.length() >0) ADVISE_NO_LIST +=",";
			ADVISE_NO_LIST += "'"+chk[i]+"'";
		}
	}
}
int SNO =0,ENO=0,TOT_CARTON_NUM=0,icnt =0,confirm_cnt=0;
String ERPUSERID="",modify_flag="";
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
statement8.setString(1,UserName);
ResultSet rs8=statement8.executeQuery();
if (rs8.next())
{
	ERPUSERID = rs8.getString(1);
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWShippingBoxConfirm.jsp?ATYPE=<%=ATYPE%>&ADVISE_NO=<%=ADVISE_NO%>" METHOD="post" NAME="MYFORM">
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<HR>
<%
sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{	
	if (!ATYPE.equals("Q"))
	{
		//add by Peggy 20140704,檢查shipping method,fob,payment term,ship to,bill to,deliver to,customer,currency是否相同
		sql = " select group_by,count(1)"+
			  //" from (select distinct tew_rcv_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id) GROUP_BY,SHIPPING_METHOD,FOB_CODE,PAYMENT_TERM_ID,SHIP_TO_ORG_ID,CURRENCY_CODE,CUSTOMER_ID"+
			  //" from (select distinct tew_rcv_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id) GROUP_BY,SHIPPING_METHOD,FOB_CODE,CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') THEN 1 ELSE a.PAYMENT_TERM_ID END PAYMENT_TERM_ID,CASE WHEN SUBSTR(SO_NO,1,4) IN ('1131','1141') THEN 1 ELSE a.SHIP_TO_ORG_ID END SHIP_TO_ORG_ID,CURRENCY_CODE,CUSTOMER_ID"+ //回T訂單不考慮PAYMENT TERM&SHIP TO,modify by Peggy 20171211
			  " from (select distinct tew_rcv_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id) GROUP_BY,SHIPPING_METHOD,FOB_CODE,CASE WHEN SUBSTR(a.SO_NO,1,4) IN ('1131','1141') THEN 1 ELSE a.PAYMENT_TERM_ID END PAYMENT_TERM_ID,CASE WHEN SUBSTR(SO_NO,1,4) IN ('1131','1141') THEN 1 ELSE a.SHIP_TO_ORG_ID END SHIP_TO_ORG_ID,CASE WHEN SUBSTR(SO_NO,1,4) IN ('1131','1141') THEN 'TWD' ELSE CURRENCY_CODE end CURRENCY_CODE,CUSTOMER_ID"+ //回T訂單不考慮currency,modify by Peggy 20180309
			  " FROM tsc.tsc_shipping_advise_pc_tew a "+
			  " WHERE ORIG_ADVISE_NO in ("+ADVISE_NO_LIST+")  order by GROUP_BY)  group by  GROUP_BY"+
			  " having count(1) >1";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		ResultSet rs1=statement1.executeQuery();	
		if (rs1.next())
		{
			out.println("<div><font color='red'>訂單條件不一致,不允許進行編箱作業!!</font></div>");
			throw new Exception("Error");
		}
		rs1.close();  
		statement1.close();
	}
	
	if (ADVISE_NO.equals(ADVISE_NO_LIST.replace("'","")))
	{
		sql = " SELECT 1"+
			  " FROM tsc.tsc_shipping_advise_lines x"+
			  " where x.TEW_ADVISE_NO=? ";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISE_NO);
		ResultSet rs=statement.executeQuery();	
		if (rs.next())
		{
			out.println("<div><font color='red'>出貨通知單不可重複編箱,謝謝!</font></div>");
			throw new Exception("Error");
		}
	}
	if (!ADVISE_NO.equals(""))
	{
		
		if (ATYPE.equals("Q"))
		{
			//sql = " SELECT 1 from tsc.tsc_pick_confirm_headers a where exists (select 1 from  tsc.tsc_shipping_advise_lines x where x.tew_ADVISE_NO =? and x.advise_header_id = a.advise_header_id)"+
			//      " union all"+
			//	  " SELECT 1 from TSC_VENDOR_INVOICE_LINES a where TEW_ADVISE_NO=?"+
			//	  " union all"+
			//	  " select 1 from oraddman.TEW_LOT_ALLOT_DETAIL a where exists (select 1 from  tsc.tsc_shipping_advise_lines x where x.tew_ADVISE_NO =? and x.advise_header_id = a.advise_header_id)";
			sql = " SELECT 1 from TSC_VENDOR_INVOICE_LINES a where TEW_ADVISE_NO=?";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ADVISE_NO);
			//statement.setString(2,ADVISE_NO);
			//statement.setString(3,ADVISE_NO);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				pick_flag="Y";
			}
			rs.close();
			statement.close();
		}
			
		sql = " SELECT x.advise_line_id,99999 SEQNO,z.VENDOR_ID,z.VENDOR_SITE_CODE,y.ADVISE_NO,x.PC_ADVISE_ID,x.SO_NO,x.ITEM_DESC,x.SHIPPING_REMARK,y.SHIPPING_METHOD,x.PO_NO CUST_PO_NUMBER,to_char(x.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,x.SHIP_QTY ACT_SHIP_QTY,TO_CHAR(x.SHIP_QTY/1000,'99999.000') ACT_SHIP_QTY_S,x.CARTON_PER_QTY ACT_CARTON_QTY,TO_CHAR(x.CARTON_PER_QTY/1000,'99999.000') ACT_CARTON_QTY_S,x.CUBE CARTON_SIZE,x.NET_WEIGHT NW,x.GROSS_WEIGHT GW,1 as ROWSEQ,x.CARTON_QTY TOT_CARTON_NUM ,y.post_fix_code BOX_CODE"+
		      ",tew_rcv_pkg.GET_ADVISE_GROUP_VALUE(x.pc_advise_id) group_by,x.advise_header_id"+
			  ",CARTON_NUM_FR,CARTON_NUM_TO"+
			  ",(select count(1) from oraddman.TEW_LOT_ALLOT_DETAIL a where a.advise_line_id = x.advise_line_id) allot_cnt"+
			  " FROM tsc.tsc_shipping_advise_lines x"+
			  ",tsc.tsc_shipping_advise_headers y"+
			  ",ap.ap_supplier_sites_all z"+
			  " where x.ADVISE_HEADER_ID = y.ADVISE_HEADER_ID"+
			  " AND x.VENDOR_SITE_ID=z.VENDOR_SITE_ID"+
			  " AND x.TEW_ADVISE_NO=? "+
			  " order by x.CARTON_NUM_FR,x.CARTON_NUM_TO,x.advise_line_id";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISE_NO);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{
			if (icnt ==0)
			{
		%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" >
					<tr><td colspan="3"><div id="div1" style="font-size:13px">出貨日期：<font color="#0000CC"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></font></div></td><td colspan="11"><div id="div2" align="right" style="font-size:13px">Advise No：<font color="#0000CC"><%=(ADVISE_NO.equals("")?ADVISE_NO_LIST.replace("'",""):ADVISE_NO)%></font></div></td>
					<tr bgcolor="#538079" style="text-shadow:#FFFFFF;color:#FFFFFF;font-family:'細明體';font-size:11px">
						<td width="3%">項次</td>
						<td width="6%">MO#</td>
						<td width="10%">型號</td>            
						<td width="6%" align="right">數量(KPC)</td>            
						<td width="10%" align="center">C/NO</td>            
						<td width="3%" align="center">C/Code</td>            
						<td width="6%" align="right">Carton Qty</td>            
						<td width="5%" align="right">N.W.</td>            
						<td width="5%" align="right">G.W.</td>            
						<td width="7%" align="center">Carton Size</td>            
						<td width="12%">Cust P/O</td>            
						<td width="12%">嘜頭</td>
						<td width="10%">出貨方式</td>            
						<td width="5%">供應商</td>
					</tr>
				
	<%		
			}
			SNO = Integer.parseInt(rs.getString("CARTON_NUM_FR"));
			ENO = Integer.parseInt(rs.getString("CARTON_NUM_TO"));
			TOT_CARTON_NUM=Integer.parseInt(rs.getString("CARTON_NUM_TO"));
			modify_flag = "N";
	%>
			<tr style="font-size:11px" id="tr_<%=rs.getString("advise_line_id")%>">
				<td><input type="checkbox"  name="chk1" onClick="setCheck(<%=(icnt)%>)" value="<%=rs.getString("advise_line_id")%>" <%=((ATYPE.equals("Q") && rs.getInt("allot_cnt")==0)?"":"style='visibility:hidden'")%> <%=(modify_flag.equals("Y")?"checked":"")%>><%=(icnt+1)%><input type="hidden" name="PC_ADVISE_ID_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("PC_ADVISE_ID")%>"><input type="hidden" name="SEQNO_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("SEQNO")%>"></td>
				<td><%=(rs.getString("SO_NO")==null?"&nbsp;":rs.getString("SO_NO"))%></td>
				<td><%=rs.getString("ITEM_DESC")%></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_SHIP_QTY_S")))%><input type="hidden" name="SHIP_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_SHIP_QTY")==null?"":rs.getString("ACT_SHIP_QTY"))%>"></td>
				<td align="center"><input type="text" name="SNO_<%=rs.getString("advise_line_id")%>" value="<%=""+SNO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)"> 
				&nbsp;-&nbsp;
				<input type="text" name="ENO_<%=rs.getString("advise_line_id")%>" value="<%=""+ENO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">
				<%=((ATYPE.equals("Q") && pick_flag.equals("N") && rs.getInt("allot_cnt")==0)?"<input type='button' name='split"+rs.getString("advise_line_id")+"' value='拆箱' style='background-color:#FFCC66;height:17;font-size:11px;vertical-align:middle;font-family:細明體' onClick='setSubmit5("+'"'+"../jsp/TEWShippingBoxSplit.jsp?ADVISENO="+ADVISE_NO+"&ID="+rs.getString("advise_line_id")+'"'+")'>":"")%>
				</td>
				<td align="center"><input type="text" name="BOX_CODE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("BOX_CODE")==null?"":rs.getString("BOX_CODE"))%>" style="background-color:#E4EDE2;text-align:center;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;border-bottom:none;<%=(modify_flag.equals("N")?"color:#000000;":"font-weight:bold;color:#0000FF;")%>" readonly size="2"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_CARTON_QTY_S")))+" KPC"%><input type="hidden" name="CARTON_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_CARTON_QTY")==null?"":rs.getString("ACT_CARTON_QTY"))%>"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("NW")))+" KGS"%><input type="hidden" name="NW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("NW")==null?"":rs.getString("NW"))%>"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("GW")))+" KGS"%><input type="hidden" name="GW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("GW")==null?"":rs.getString("GW"))%>"></td>
				<td align="center"><%=rs.getString("CARTON_SIZE")%><input type="hidden" name="CUBE_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CARTON_SIZE")%>"><input type="hidden" name="TOT_CARTON_NUM_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("TOT_CARTON_NUM")%>"></td>
				<td align="left"><%=rs.getString("CUST_PO_NUMBER")%></td>
				<td align="left"><%=(rs.getString("shipping_remark")==null?"":rs.getString("shipping_remark"))%></td>
				<td align="left"><%=rs.getString("SHIPPING_METHOD")%></td>
				<td><%=(rs.getString("vendor_site_code")==null?"&nbsp;":rs.getString("vendor_site_code"))%></td>
			</tr>
	<%
			icnt++;
		}
		rs.close();
		statement.close();
		//if (icnt>0)
		//{
		%>
		<!--</table>-->
		<%
		//}

	}
	
	if (!ADVISE_NO_LIST.equals(""))
	{
		sql = " select tsc_shipping_advise_lines_s.nextval advise_line_id"+
		      ",box.*"+
			  ",case WHEN ACT_SHIP_QTY < CARTON_QTY THEN ACT_SHIP_QTY ELSE CARTON_QTY END AS ACT_CARTON_QTY"+
			  ",case WHEN ACT_SHIP_QTY_S < CARTON_QTY_S THEN ACT_SHIP_QTY_S ELSE CARTON_QTY_S END AS ACT_CARTON_QTY_S"+
			  " from (SELECT 1 as seq, y.*,floor(y.SHIP_QTY/y.CARTON_QTY) * y.CARTON_QTY ACT_SHIP_QTY,TO_CHAR(floor(y.SHIP_QTY/y.CARTON_QTY) * y.CARTON_QTY /1000,'99999.000') ACT_SHIP_QTY_S, floor(y.SHIP_QTY/y.CARTON_QTY) TOT_CARTON_NUM,y.NW as ACT_NW,y.GW as ACT_GW,y.NW as ACT_NW_1,y.GW as ACT_GW_1"+
			  "       FROM (SELECT x.* ,row_number() over (partition by x.PC_ADVISE_ID order by SEQNO) ROWSEQ"+
			  "            FROM (select 1 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,b.NW,b.GW,a.post_fix_code BOX_CODE "+
			  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_tew a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='TEW' and STATUS='Y') b"+
			  "                  where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")";
		sql2= "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                  and a.vendor_id = b.vendor_id(+)"+
			  "                  and a.ITEM_DESC =b.TSC_PARTNO(+)"+
			  "                  and b.TSC_PARTNO is not null"+
			  "                  UNION ALL"+
			  "                  select 2 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,b.NW,b.GW,a.post_fix_code BOX_CODE "+
			  "                  FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_tew a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                       ,(select b.* from tsc_item_packing_master b where  INT_TYPE='TEW' and STATUS='Y' ) b"+
			  "                  where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")"+
			  "                  and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                  and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                  and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                  and a.vendor_id = b.vendor_id(+)"+
			  "                  and b.TSC_PARTNO is null"+
			  "                  ORDER BY vendor_site_code,REGION_CODE,CUSTOMER_ID,SHIPPING_REMARK"+
			  "                  ) x"+
			  "            ) y where ROWSEQ=1 AND  floor(y.SHIP_QTY/NVL(y.CARTON_QTY,1)) >0";
		sql1 ="      union all "+
			  "      SELECT 2 as seq, y.*,mod(y.SHIP_QTY,y.CARTON_QTY) ACT_SHIP_QTY,TO_CHAR(mod(y.SHIP_QTY,y.CARTON_QTY) /1000,'99999.000') ACT_SHIP_QTY_S, ceil(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY) TOT_CARTON_NUM,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,1) < 0.1 then 0.1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,1) end as ACT_NW,case when round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,1) < 1 then 1 else round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,1) end as ACT_GW,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.NW,1) ACT_NW_1,round(mod(y.SHIP_QTY,y.CARTON_QTY)/y.CARTON_QTY*y.GW,1) ACT_GW_1"+
			  "      FROM (SELECT x.* ,row_number() over (partition by x.PC_ADVISE_ID order by SEQNO) ROWSEQ"+
			  "           FROM (select 1 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,b.NW,b.GW,a.post_fix_code BOX_CODE "+
			  "                 FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_tew a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                     ,(select b.* from tsc_item_packing_master b where  INT_TYPE='TEW' and STATUS='Y') b"+
			  "                 where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")"+
			  "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                 and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                 and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                 and a.vendor_id = b.vendor_id(+)"+
			  "                 and a.ITEM_DESC =b.TSC_PARTNO(+)"+
			  "                 and b.TSC_PARTNO is not null"+
			  "                 UNION ALL"+
			  "                 select 2 SEQNO,nvl(a.seq_no,99999) seq_no,a.vendor_id,a.vendor_site_code,a.ADVISE_NO,a.PC_ADVISE_ID,a.SO_NO,a.ITEM_DESC,a.REGION_CODE,a.CUSTOMER_ID,a.SHIPPING_REMARK,a.SHIPPING_METHOD,a.CUST_PO_NUMBER,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') PC_SCHEDULE_SHIP_DATE,a.SHIP_QTY,TO_CHAR(a.SHIP_QTY/1000,'99999.000') SHIP_QTY_S,b.CARTON_QTY,TO_CHAR(b.CARTON_QTY/1000,'99999.000') CARTON_QTY_S,b.CARTON_SIZE,b.NW,b.GW,a.post_fix_code BOX_CODE "+
			  "                 FROM (select c.vendor_id,c.vendor_site_code,a.* from tsc.tsc_shipping_advise_pc_tew a,ap.ap_supplier_sites_all c where a.vendor_site_id=c.vendor_site_id(+) and not exists (select 1 from tsc.tsc_shipping_advise_lines g where g.pc_advise_id = a.pc_advise_id)) a"+
			  "                      ,(select b.* from tsc_item_packing_master b where  INT_TYPE='TEW' and STATUS='Y' ) b"+
			  "                 where orig_ADVISE_NO in ("+ADVISE_NO_LIST+")"+
			  "                 and decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)= b.tsc_prod_group(+)"+
			  "                 and a.TSC_PACKAGE=b.TSC_PACKAGE(+)"+
			  "                 and a.PACKING_CODE =b.PACKING_CODE(+)"+
			  "                 and a.vendor_id = b.vendor_id(+)"+
			  "                 and b.TSC_PARTNO is null"+
			  "                  ORDER BY vendor_site_code,REGION_CODE,CUSTOMER_ID,SHIPPING_REMARK"+
			  "                 ) x"+
			  "       ) y "+
			  "       where ROWSEQ=1 "+
			  "       AND  mod(y.SHIP_QTY,y.CARTON_QTY) >0"+
			  "       order by  3,10,12,9,7,1,24 DESC ) box ";
		//out.println(sql+sql2+sql1);
		//out.println(sql1);
		//out.println(ADVISE_NO_LIST.substring(1,ADVISE_NO_LIST.length()-1));
		PreparedStatement statement = con.prepareStatement(sql+sql2+sql1);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{
			if (icnt ==0)
			{
		%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" >
					<tr><td colspan="3"><div id="div1" style="font-size:13px">出貨日期：<font color="#0000CC"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></font></div></td><td colspan="11"><div id="div2" align="right" style="font-size:13px">Advise No：<font color="#0000CC"><%=(ADVISE_NO.equals("")?ADVISE_NO_LIST.replace("'",""):ADVISE_NO)%></font></div></td>
					<tr bgcolor="#538079" style="text-shadow:#FFFFFF;color:#FFFFFF;font-family:'細明體';font-size:11px">
						<td width="3%">項次</td>
						<td width="6%">MO#</td>
						<td width="12%">型號</td>            
						<td width="6%" align="right">數量(KPC)</td>            
						<td width="10%" align="center">C/NO</td>            
						<td width="3%" align="center">C/Code</td>            
						<td width="6%" align="right">Carton Qty</td>            
						<td width="5%" align="center">N.W.</td>            
						<td width="5%" align="center">G.W.</td>            
						<td width="8%" align="center">Carton Size</td>            
						<td width="13%">Cust P/O</td>            
						<td width="12%">嘜頭</td>
						<td width="6%">出貨方式</td>            
						<td width="5%">供應商</td>
					</tr>
				
	<%		
			}
			if (rs.getString("CARTON_SIZE")==null || rs.getString("CARTON_SIZE").equals(""))
			{
				out.println("<div><font color='red'>型號:"+rs.getString("ITEM_DESC")+"未定義編箱基本資料!</font></div>");
				throw new Exception("Error");
			}
			SNO = TOT_CARTON_NUM+1;
			TOT_CARTON_NUM+=Integer.parseInt(rs.getString("TOT_CARTON_NUM"));
			ENO =TOT_CARTON_NUM;
			modify_flag = "Y";
	%>
			<tr style="font-size:11px">
				<td><input type="checkbox"  name="chk1" onClick="setCheck(<%=(icnt)%>)" value="<%=rs.getString("advise_line_id")%>" style="visibility:hidden" <%=(modify_flag.equals("Y")?"checked":"")%>><%=(icnt+1)%><input type="hidden" name="PC_ADVISE_ID_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("PC_ADVISE_ID")%>"><input type="hidden" name="SEQNO_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("SEQNO")%>"></td>
				<td><%=(rs.getString("SO_NO")==null?"&nbsp;":rs.getString("SO_NO"))%></td>
				<td><%=rs.getString("ITEM_DESC")%></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_SHIP_QTY_S")))%><input type="hidden" name="SHIP_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_SHIP_QTY")==null?"":rs.getString("ACT_SHIP_QTY"))%>"></td>
				<td align="center">
				<input type="text" name="SNO_<%=rs.getString("advise_line_id")%>" value="<%=""+SNO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onChange="objCarton('<%=rs.getString("advise_line_id")%>');" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)"> 
				&nbsp;-&nbsp;
				<input type="text" name="ENO_<%=rs.getString("advise_line_id")%>" value="<%=""+ENO%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-weight:bold;font-size:13px;color:#0000FF;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onChange="objCarton('<%=rs.getString("advise_line_id")%>');" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">
				</td>
				<td align="center"><input type="text" name="BOX_CODE_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("BOX_CODE")==null?"":rs.getString("BOX_CODE"))%>" style="background-color:#E4EDE2;text-align:center;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;border-bottom:none;<%=(modify_flag.equals("N")?"color:#000000;":"font-weight:bold;color:#0000FF;")%>" readonly size="2"></td>
				<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_CARTON_QTY_S")))+" KPC"%><input type="hidden" name="CARTON_QTY_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_CARTON_QTY")==null?"":rs.getString("ACT_CARTON_QTY"))%>"></td>
				<td align="right"><input type="text" name="NW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_NW")==null?"":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_NW"))))%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-size:11px;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onKeyPress="return ((event.keyCode>=48 && event.keyCode <=57) || event.keyCode ==46)"> KGS<input type="hidden" name="ORIG_NW_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("NW")%>"><input type="hidden" name="ORIG_NW_1_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("ACT_NW_1")%>"></td>
				<td align="right"><input type="text" name="GW_<%=rs.getString("advise_line_id")%>" value="<%=(rs.getString("ACT_GW")==null?"":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ACT_GW"))))%>" size="2" style="background-color:#E4EDE2;border-top:none;border-right:none;border-left:none;text-align:RIGHT;font-family: Tahoma,Georgia;<%=(modify_flag.equals("N")?"border-bottom:none;":"border-bottom-color:#000000;font-size:11px;")%>" <%=(modify_flag.equals("N")?" readonly ":"")%>  onKeyPress="return ((event.keyCode>=48 && event.keyCode <=57) || event.keyCode ==46)"> KGS<input type="hidden" name="ORIG_GW_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("GW")%>"><input type="hidden" name="ORIG_GW_1_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("ACT_GW_1")%>"></td>
				<td align="center"><%=rs.getString("CARTON_SIZE")%><input type="hidden" name="CUBE_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CARTON_SIZE")%>"><input type="hidden" name="TOT_CARTON_NUM_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("TOT_CARTON_NUM")%>"></td>
				<td align="left"><%=rs.getString("CUST_PO_NUMBER")%><input type="hidden" name="CUST_PO_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("CUST_PO_NUMBER")%>"></td>
				<td align="left"><%=(rs.getString("shipping_remark")==null?"&nbsp;":rs.getString("shipping_remark"))%></td>
				<td align="left"><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="SHIPPING_METHOD_<%=rs.getString("advise_line_id")%>" value="<%=rs.getString("SHIPPING_METHOD")%>"></td>
				<td><%=(rs.getString("vendor_site_code")==null?"&nbsp;":rs.getString("vendor_site_code"))%></td>
			</tr>
	<%
			icnt++;
			confirm_cnt++;
		}
		rs.close();
		statement.close();		
	}
	if (icnt >0)
	{
%>
			</table>
			<HR>	
<%
		if (confirm_cnt >0)
		{
%>		
			<table width="100%">
				<tr>
				  <td align="center"><input type="button" name="save1" value="編箱確認" style="font-family:'細明體'" onClick="setSubmit1('../jsp/TEWShippingBoxConfirmProcess.jsp')">				    &nbsp;&nbsp;&nbsp;
			    <input type="button" name="exit1" value="取消，回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TEWShippingBoxConfirmQuery.jsp')">				</td></tr>
			</table>
<%
		}
		else if (ATYPE.equals("Q"))
		{
%>
			<table width="100%">
				<tr><td align="center">
				<%
				if (pick_flag.equals("N"))
				{
				%>
					<input type='button' name='delete1' value='刪除' style='vertical-align:middle;font-family:細明體' onClick='setSubmit3("../jsp/TEWShippingBoxConfirmProcess.jsp?TYPE=DELETE")'> 
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<%
				}
				%>
				<input type="button" name="exit1" value="回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TEWShippingBoxHistoryQuery.jsp')">
				</td></tr>
			</table>
<%
		}
	}
	else
	{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料,請重新確認,謝謝!");
			//location.href="/oradds/jsp/TEWShippingBoxConfirmQuery.jsp";
		</script>
<%
	}
}
catch(Exception e)
{
	out.println("<font style='color:#ff0000;font-size:12px'>搜尋資料發生異常!!請洽系統管理人員,謝謝!</font>");
%>
	<table width="100%">
		<tr>
		  <td align="center"><input type="button" name="exit1" value="回上頁" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TEWShippingBoxHistoryQuery.jsp')">

		  </td>
	  </tr>
	</table>
<%
}

sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
PreparedStatement pstmt2=con.prepareStatement(sql2);
pstmt2.executeUpdate(); 
pstmt2.close();	
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
<input type="hidden" name="ADVISE_NO" value="<%=ADVISE_NO%>">
<input type="hidden" name="ADVISE_NO_LIST" value="<%=ADVISE_NO_LIST%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

