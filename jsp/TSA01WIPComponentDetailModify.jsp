<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>A01 Component Detail</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,ComboBoxBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setAddLine(URL)
{
	var TXTLINE = document.MYFORM.TXTLINE.value;
	if (TXTLINE == "" || TXTLINE == null || TXTLINE == "null")
	{
		alert("請輸入欲新增行數!");
		document.MYFORM.TXTLINE.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+$/;
		if (TXTLINE.match(regex)==null) 
		{ 
    		alert("數量必須是整數數值型態!"); 
			document.MYFORM.TXTLINE.focus();
			return false;
		} 
		else if (parseInt(TXTLINE)<1 || parseInt(TXTLINE)>20)
		{
    		alert("行數新增範圍1~20!"); 
			document.MYFORM.TXTLINE.focus();
			return false;		
		}
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var num=0,spq=0,moq=0;
	if (document.MYFORM.NEW_COMP_TYPE_NO.value ==null || document.MYFORM.NEW_COMP_TYPE_NO.value =="--" || document.MYFORM.NEW_COMP_TYPE_NO.value =="")
	{
		alert("請選擇原物料類別名稱!");
		document.MYFORM.NEW_COMP_TYPE_NO.focus();
		return false;
	}
	for (var i =1 ; i <= document.MYFORM.LINECNT.value ; i++)
	{
		if (document.MYFORM.elements["ITEM_NAME_"+i].value != null && document.MYFORM.elements["ITEM_NAME_"+i].value != "")
		{
			if (document.MYFORM.elements["ITEM_NAME_"+i].value != document.MYFORM.elements["ITEM_NAME_T_"+i].value)
			{
				alert("Line#"+i+":料號與品名不符,請重新確認!");
				document.MYFORM.elements["ITEM_NAME_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["LEVEL1_VALUE_"+i].value == null || document.MYFORM.elements["LEVEL1_VALUE_"+i].value =="")
			{
				alert("Line#"+i+":第一層包裝量必須輸入!");
				document.MYFORM.elements["LEVEL1_VALUE_"+i].focus();
				return false;			
			
			}
			else if (document.MYFORM.elements["LEVEL1_VALUE_"+i].value != null && document.MYFORM.elements["LEVEL1_VALUE_"+i].value !="")
			{
				if(isNaN(document.MYFORM.elements["LEVEL1_VALUE_"+i].value))
				{
					alert("Line#"+i+":第一層包裝量必須是數值型態!");
					document.MYFORM.elements["LEVEL1_VALUE_"+i].focus();
					return false;			
				}
				else if (document.MYFORM.NEW_COMP_TYPE_NO.value=="C002" && document.MYFORM.elements["LEVEL1_NAME_"+i].value == null || document.MYFORM.elements["LEVEL1_NAME_"+i].value =="")
				{
					alert("Line#"+i+":第一層包裝單位必須輸入!");
					document.MYFORM.elements["LEVEL1_NAME_"+i].focus();
					return false;			
				}
			}
			if (document.MYFORM.elements["LEVEL2_VALUE_"+i].value != null && document.MYFORM.elements["LEVEL2_VALUE_"+i].value !="")
			{
				if(isNaN(document.MYFORM.elements["LEVEL2_VALUE_"+i].value))
				{
					alert("Line#"+i+":第二層包裝量必須是數值型態!");
					document.MYFORM.elements["LEVEL2_VALUE_"+i].focus();
					return false;			
				}
				else if (document.MYFORM.NEW_COMP_TYPE_NO.value=="C002" && document.MYFORM.elements["LEVEL2_NAME_"+i].value == null || document.MYFORM.elements["LEVEL2_NAME_"+i].value =="")
				{
					alert("Line#"+i+":第二層包裝單位必須輸入!");
					document.MYFORM.elements["LEVEL2_NAME_"+i].focus();
					return false;			
				}
				else
				{
					if (document.MYFORM.elements["ITEM_NAME_"+i].value!="15-2455006")
					{
						moq = eval(document.MYFORM.elements["LEVEL2_VALUE_"+i].value)*1000;
						spq = eval(document.MYFORM.elements["LEVEL1_VALUE_"+i].value)*1000;
						num =moq%spq;
						if (num!=0)
						{
							alert("Line#"+i+":第二層包裝量必須是第一層包裝量的倍數!");
							document.MYFORM.elements["LEVEL2_VALUE_"+i].focus();
							return false;		
						}	
					}
				}
			}
			if (document.MYFORM.elements["LEVEL3_VALUE_"+i].value != null && document.MYFORM.elements["LEVEL3_VALUE_"+i].value !="")
			{
				if(isNaN(document.MYFORM.elements["LEVEL3_VALUE_"+i].value))
				{
					alert("Line#"+i+":第三層包裝量必須是數值型態!");
					document.MYFORM.elements["LEVEL3_VALUE_"+i].focus();
					return false;			
				}
				else if (document.MYFORM.NEW_COMP_TYPE_NO.value=="C002" && document.MYFORM.elements["LEVEL3_NAME_"+i].value == null || document.MYFORM.elements["LEVEL3_NAME_"+i].value =="")
				{
					alert("Line#"+i+":第三層包裝單位必須輸入!");
					document.MYFORM.elements["LEVEL3_NAME_"+i].focus();
					return false;			
				}
				else
				{
					moq = eval(document.MYFORM.elements["LEVEL3_VALUE_"+i].value)*1000;
					spq = eval(document.MYFORM.elements["LEVEL2_VALUE_"+i].value)*1000;
					num =moq%spq;
					if (num!=0)
					{
						alert("Line#"+i+":第三層包裝量必須是第二層包裝量的倍數!");
						document.MYFORM.elements["LEVEL3_VALUE_"+i].focus();
						return false;		
					}	
				}
			}			
			if (document.MYFORM.elements["LEVEL4_VALUE_"+i].value != null && document.MYFORM.elements["LEVEL4_VALUE_"+i].value !="")
			{
				if(isNaN(document.MYFORM.elements["LEVEL4_VALUE_"+i].value))
				{
					alert("Line#"+i+":第四層包裝量必須是數值型態!");
					document.MYFORM.elements["LEVEL4_VALUE_"+i].focus();
					return false;			
				}
				else if (document.MYFORM.NEW_COMP_TYPE_NO.value=="C002" && document.MYFORM.elements["LEVEL4_NAME_"+i].value == null || document.MYFORM.elements["LEVEL4_NAME_"+i].value =="")
				{
					alert("Line#"+i+":第四層包裝單位必須輸入!");
					document.MYFORM.elements["LEVEL4_NAME_"+i].focus();
					return false;			
				}
				else
				{
					moq = eval(document.MYFORM.elements["LEVEL4_VALUE_"+i].value)*1000;
					spq = eval(document.MYFORM.elements["LEVEL3_VALUE_"+i].value)*1000;
					num =moq%spq;
					if (num!=0)
					{
						alert("Line#"+i+":第四層包裝量必須是第三層包裝量的倍數!");
						document.MYFORM.elements["LEVEL4_VALUE_"+i].focus();
						return false;		
					}	
				}
			}	
			if (document.MYFORM.elements["MOQ_LEVEL_"+i].value == null || document.MYFORM.elements["MOQ_LEVEL_"+i].value =="" || document.MYFORM.elements["MOQ_LEVEL_"+i].value =="--")
			{
				alert("Line#"+i+":發料包裝層必須輸入!");
				document.MYFORM.elements["MOQ_LEVEL_"+i].focus();
				return false;			
			
			}
					
			/*
			else if (document.MYFORM.elements["SPQ_"+i].value == null || document.MYFORM.elements["SPQ_"+i].value =="")
			{
				alert("Line#"+i+":最小包裝量必須輸入!");
				document.MYFORM.elements["SPQ_"+i].focus();
				return false;			
			}
			else if (document.MYFORM.elements["MOQ_"+i].value == null || document.MYFORM.elements["MOQ_"+i].value =="")
			{
				alert("Line#"+i+":最低申請量必須輸入!");
				document.MYFORM.elements["MOQ_"+i].focus();
				return false;			
			}
			if (document.MYFORM.elements["SPQ_"+i].value != null && document.MYFORM.elements["SPQ_"+i].value !="")
			{
				if(isNaN(document.MYFORM.elements["SPQ_"+i].value))
				{
					alert("Line#"+i+":最小包裝量必須是數值型態!");
					document.MYFORM.elements["SPQ_"+i].focus();
					return false;			
				}
			}
			if (document.MYFORM.elements["MOQ_"+i].value != null && document.MYFORM.elements["MOQ_"+i].value !="")
			{
				if(isNaN(document.MYFORM.elements["MOQ_"+i].value))
				{
					alert("Line#"+i+":最低申請量必須是數值型態!");
					document.MYFORM.elements["MOQ_"+i].focus();
					return false;			
				}			
			}
			moq = eval(document.MYFORM.elements["MOQ_"+i].value)*1000;
			spq = eval(document.MYFORM.elements["SPQ_"+i].value)*1000;
			num =moq%spq;
			if (num!=0)
			{
				alert("Line#"+i+":最低申請量必須等於最小包裝量或其倍數("+num+")!!");
				document.MYFORM.elements["MOQ_"+i].focus();
				return false;					
			}
			*/
		}
	}
	document.MYFORM.save1.disabled= true;
	document.MYFORM.cancel1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit1(URL)
{   
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到上頁功能嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setClear()
{
}
function setLineCheck(irow)
{
	if ((document.MYFORM.elements["ITEM_NAME_"+irow].value != null && document.MYFORM.elements["ITEM_NAME_"+irow].value != "") && document.MYFORM.elements["ITEM_NAME_"+irow].value != document.MYFORM.elements["ITEM_NAME_T_"+irow].value && (document.MYFORM.elements["ITEM_NAME_T_"+irow].value ==null || document.MYFORM.elements["ITEM_NAME_T_"+irow].value ==""))
	{
		subWin=window.open("../jsp/subwindow/TSA01WIPItemFind.jsp?ID="+irow+"&ORGANIZATION_ID="+document.MYFORM.ORGANIZATION_ID.value+"&ITEM="+document.MYFORM.elements["ITEM_NAME_"+irow].value,"subwin","width=10,height=10,scrollbars=yes,menubar=no");  
	}
}
function setDelete(objLine)
{
	if (confirm("您確定要刪除Line No:"+objLine+"的資料嗎?"))
	{
		for (var i = objLine ; i <= document.MYFORM.LINECNT.value ; i++)
		{
			if ( i < document.MYFORM.LINECNT.value)
			{
				document.MYFORM.elements["ITEM_NAME_"+i].value    = document.MYFORM.elements["ITEM_NAME_"+(i+1)].value;
				document.MYFORM.elements["ITEM_ID_"+i].value      = document.MYFORM.elements["ITEM_ID_"+(i+1)].value;
				document.MYFORM.elements["ITEM_NAME_T_"+i].value  = document.MYFORM.elements["ITEM_NAME_T_"+(i+1)].value;
				document.MYFORM.elements["ITEM_DESC_"+i].value    = document.MYFORM.elements["ITEM_DESC_"+(i+1)].value;
				document.MYFORM.elements["LEVEL1_VALUE_"+i].value = document.MYFORM.elements["LEVEL1_VALUE_"+(i+1)].value;
				document.MYFORM.elements["LEVEL1_NAME_"+i].value  = document.MYFORM.elements["LEVEL1_NAME_"+(i+1)].value;
				document.MYFORM.elements["LEVEL2_VALUE_"+i].value = document.MYFORM.elements["LEVEL2_VALUE_"+(i+1)].value;
				document.MYFORM.elements["LEVEL2_NAME_"+i].value  = document.MYFORM.elements["LEVEL2_NAME_"+(i+1)].value;
				document.MYFORM.elements["LEVEL3_VALUE_"+i].value = document.MYFORM.elements["LEVEL3_VALUE_"+(i+1)].value;
				document.MYFORM.elements["LEVEL3_NAME_"+i].value  = document.MYFORM.elements["LEVEL3_NAME_"+(i+1)].value;
				document.MYFORM.elements["LEVEL4_VALUE_"+i].value = document.MYFORM.elements["LEVEL4_VALUE_"+(i+1)].value;
				document.MYFORM.elements["LEVEL4_NAME_"+i].value  = document.MYFORM.elements["LEVEL4_NAME_"+(i+1)].value;
				document.MYFORM.elements["UOM_"+i].value          = document.MYFORM.elements["UOM_"+(i+1)].value;
				document.MYFORM.elements["MOQ_LEVEL_"+i].value    = document.MYFORM.elements["MOQ_LEVEL_"+(i+1)].value;
				document.MYFORM.elements["chk"+i].checked         = document.MYFORM.elements["chk"+(i+1)].checked;
			}
			else
			{
				document.MYFORM.elements["ITEM_NAME_"+i].value    = "";
				document.MYFORM.elements["ITEM_ID_"+i].value      = "";
				document.MYFORM.elements["ITEM_NAME_T_"+i].value  = "";
				document.MYFORM.elements["ITEM_DESC_"+i].value    = "";
				document.MYFORM.elements["LEVEL1_VALUE_"+i].value = "";
				document.MYFORM.elements["LEVEL1_NAME_"+i].value  = "";
				document.MYFORM.elements["LEVEL2_VALUE_"+i].value = "";
				document.MYFORM.elements["LEVEL2_NAME_"+i].value  = "";
				document.MYFORM.elements["LEVEL3_VALUE_"+i].value = "";
				document.MYFORM.elements["LEVEL3_NAME_"+i].value  = "";
				document.MYFORM.elements["LEVEL4_VALUE_"+i].value = "";
				document.MYFORM.elements["LEVEL4_NAME_"+i].value  = "";
				document.MYFORM.elements["UOM_"+i].value          = "";
				document.MYFORM.elements["MOQ_LEVEL_"+i].value    = "";
				document.MYFORM.elements["chk"+i].checked         = false;
			}
		}
	}
	else
	{
		return false;
	}
}
</script>
<%
String sql = "";
String COMP_TYPE_NO = request.getParameter("COMP_TYPE_NO");
if (COMP_TYPE_NO==null) COMP_TYPE_NO="";
String NEW_COMP_TYPE_NO = request.getParameter("NEW_COMP_TYPE_NO");
if (NEW_COMP_TYPE_NO==null) NEW_COMP_TYPE_NO=COMP_TYPE_NO;
String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="606";
String ITEM_ID = request.getParameter("ITEM_ID");
if (ITEM_ID==null) ITEM_ID="";
boolean Line_Exist = false;
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="";
String TRANS_TYPE = request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null) TRANS_TYPE="";
String TXTLINE = request.getParameter("TXTLINE");
if (TXTLINE==null) TXTLINE="0";
String LINECNT = request.getParameter("LINECNT");
if (LINECNT==null) LINECNT ="15";
if (ACODE.equals("ADDLINE") || ACODE.equals("NEW"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)+Integer.parseInt(TXTLINE));
}
if (LINECNT.equals("0")) LINECNT="15";
%>
<body>  
<FORM ACTION="../jsp/TSA01WIPComponentDetailModify.jsp" METHOD="post" NAME="MYFORM">
<input type="hidden" name="TRANS_TYPE" value="<%=TRANS_TYPE%>">
<input type="hidden" name="COMP_TYPE_NO" value="<%=COMP_TYPE_NO%>">
<TABLE border="0" width="100%" align="center" >
	<tr>
		<td width="10%" style="font-size:12px" align="right"><span style="font-size:12px;font-weight:bold;color:#006666;"><span style="font-size:12px;color:#006666">原物料類別名稱</span></span>：</td>
		<td width="30%" colspan="3">					
		<%
		try
		{   
			sql = "select COMP_TYPE_NO,COMP_TYPE_NAME from oraddman.tsa01_component_type a where NVL(a.ACTIVE_FLAG,'N')='Y'";
			//if (!COMP_TYPE_NO.equals("")) sql += " AND COMP_TYPE_NO='"+ COMP_TYPE_NO+"'";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(NEW_COMP_TYPE_NO);
			comboBoxBean.setFieldName("NEW_COMP_TYPE_NO");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();      	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		<input type="hidden" name="ITEM_ID" value="<%=ITEM_ID%>"></td>
		<td>&nbsp;</td>
	</tr>
</TABLE>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="3%" align="center" rowspan="2">&nbsp;</td>
		<td width="3%" align="center" rowspan="2">序號</td>
		<td width="15%" align="center" rowspan="2">料號</td>
		<td width="22%" align="center" rowspan="2">品名</td>
		<td width="40%" align="center" colspan="4">小--->大</td>
		<td width="6%" align="center" rowspan="2">單位</td>
		<td width="9%" align="center" rowspan="2">發料包裝層</td>
		<td width="5%" align="center" rowspan="2">停用記號</td>
	</tr>
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="10%" align="center">第一層包裝</td>
		<td width="10%" align="center">第二層包裝</td>
		<td width="10%" align="center">第三層包裝</td>
		<td width="10%" align="center">第四層包裝</td>
	</tr>
<%
try
{
	if (ACODE.equals("ADDLINE") || ACODE.equals("NEW") || ACODE.equals("UPDATE")||ACODE.equals("SAVE"))
	{	
		String data [][] = new String [Integer.parseInt(LINECNT)][14];
		if (ACODE.equals("UPDATE"))
		{
			int icnt =0;
			sql = " select a.comp_type_no, a.organization_id, a.inventory_item_id,"+
                  " a.item_name, a.uom, a.spq, a.moq, a.change_rate, a.created_by,"+
                  " a.creation_date, a.last_updated_by, a.last_update_date,b.description,"+
				  " a.level1_packing_name,a.level1_packing_value,"+
				  " a.level2_packing_name,a.level2_packing_value,"+
				  " a.level3_packing_name,a.level3_packing_value,"+
				  " a.level4_packing_name,a.level4_packing_value,"+
				  " a.moq_level,"+
                  " a.inactive_flag,row_number() over (partition by a.comp_type_no order by a.item_name desc) seq_no"+
                  " from oraddman.tsa01_component_detail a,inv.mtl_system_items_b b"+
				  " where a.comp_type_no ='"+ NEW_COMP_TYPE_NO+"'"+
				  " and a.organization_id ='"+ORGANIZATION_ID +"'"+
				  " and a.organization_id = b.organization_id"+
				  " and a.inventory_item_id = b.inventory_item_id";
			if (ITEM_ID!=null && !ITEM_ID.equals(""))
			{
				sql += " and a.inventory_item_id='"+ ITEM_ID+"'";
			}	
			//out.println(sql);
			Statement statement=con.createStatement(); 
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next()) 
			{	
				if (icnt==0)
				{
					data= new String [rs.getInt("seq_no")][14];
					LINECNT =""+rs.getInt("seq_no"); 
				}
				data[icnt][0] = rs.getString("inventory_item_id");
				data[icnt][1] = rs.getString("item_name");
				data[icnt][2] = rs.getString("description");
				data[icnt][3] = rs.getString("uom");
				//data[icnt][4] = (new DecimalFormat("######0.####")).format(rs.getFloat("spq"));
				//data[icnt][5] = (new DecimalFormat("######0.####")).format(rs.getFloat("moq"));
				data[icnt][4] = rs.getString("level1_packing_name");
				data[icnt][5] = (rs.getString("level1_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level1_packing_value")));
				data[icnt][6] = rs.getString("level2_packing_name");
				data[icnt][7] = (rs.getString("level2_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level2_packing_value")));
				data[icnt][8] = rs.getString("level3_packing_name");
				data[icnt][9] = (rs.getString("level3_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level3_packing_value")));
				data[icnt][10] = rs.getString("level4_packing_name");
				data[icnt][11] = (rs.getString("level4_packing_value")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("level4_packing_value")));
				//data[icnt][12] = (rs.getString("change_rate")==null?"":(new DecimalFormat("######0.####")).format(rs.getFloat("change_rate")));
				data[icnt][12] = rs.getString("moq_level");
				data[icnt][13] = (rs.getString("inactive_flag")==null?"":rs.getString("inactive_flag"));
				icnt++;				
			}
			rs.close();
			statement.close();		
				  
		}
		for (int i =0 ; i <Integer.parseInt(LINECNT) ; i++)
		{
			if (ACODE.equals("ADDLINE")||ACODE.equals("SAVE"))
			{
				data[i][0] = request.getParameter("ITEM_ID_"+(i+1));
				data[i][1] = request.getParameter("ITEM_NAME_"+(i+1));
				data[i][2] = request.getParameter("ITEM_DESC_"+(i+1));
				data[i][3] = request.getParameter("UOM_"+(i+1));
				//data[i][4] = request.getParameter("SPQ_"+(i+1));
				//data[i][5] = request.getParameter("MOQ_"+(i+1));
				//data[i][6] = request.getParameter("CHANGE_RATE_"+(i+1));
				data[i][4] = request.getParameter("LEVEL1_NAME_"+(i+1));
				data[i][5] = request.getParameter("LEVEL1_VALUE_"+(i+1));
				data[i][6] = request.getParameter("LEVEL2_NAME_"+(i+1));
				data[i][7] = request.getParameter("LEVEL2_VALUE_"+(i+1));
				data[i][8] = request.getParameter("LEVEL3_NAME_"+(i+1));
				data[i][9] = request.getParameter("LEVEL3_VALUE_"+(i+1));
				data[i][10] = request.getParameter("LEVEL4_NAME_"+(i+1));
				data[i][11] = request.getParameter("LEVEL4_VALUE_"+(i+1));
				data[i][12] = request.getParameter("MOQ_LEVEL_"+(i+1));
				data[i][13] = request.getParameter("chk"+(i+1));
				if (data[i][13]==null) data[i][13]="";
			}
	%>
			<tr>
				<td align="center">
				<%
				if ( !ACODE.equals("UPDATE"))
				{
				%>
				<input type="button" name="DEL<%=(i+1)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick='setDelete(<%=(i+1)%>)'>
				<%
				}
				else
				{
					out.println("&nbsp;");
				}
				%>
				</td>
				<td align="center"><%=(i+1)%></td>
				<td><input type="text" NAME="ITEM_NAME_<%=(i+1)%>" value="<%=(data[i][1]==null?"":data[i][1])%>" style="font-family: Tahoma,Georgia;" size="20" <%=(TRANS_TYPE.equals("UPDATE")?" readonly":"onBlur='setLineCheck("+(i+1)+")'")%>><input type="hidden" name="ITEM_ID_<%=(i+1)%>" value="<%=(data[i][0]==null?"":data[i][0])%>"><input type="hidden" name="ITEM_NAME_T_<%=(i+1)%>" value="<%=(data[i][1]==null?"":data[i][1])%>"></td>
				<td><input type="text" name="ITEM_DESC_<%=(i+1)%>" value="<%=(data[i][2]==null?"":data[i][2])%>" style="font-family: Tahoma,Georgia;" size="40" readonly></td>
				<td align="center">
				<input type="text" name="LEVEL1_VALUE_<%=(i+1)%>" value="<%=(data[i][5]==null?"":data[i][5])%>" style="font-family: Tahoma,Georgia;" size="7">/
				<%
				try
				{   
					sql = "select TYPE_VALUE,TYPE_VALUE from oraddman.tsa01_base_setup a where TYPE_CODE='PACKING_CODE' ";
					if (!NEW_COMP_TYPE_NO.equals("")) sql += " AND TYPE_NAME='"+ NEW_COMP_TYPE_NO+"'";
					sql += " order by to_number(TYPE_DESC)";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					comboBoxBean.setRs(rs);
					comboBoxBean.setSelection(data[i][4]);
					comboBoxBean.setFieldName("LEVEL1_NAME_"+(i+1));	
					comboBoxBean.setFontName("Tahoma,Georgia");   
					out.println(comboBoxBean.getRsString());
					rs.close();   
					statement.close();      	 
				} 
				catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				} 	
				%>
				</td>
				<td align="center">
				<input type="text" name="LEVEL2_VALUE_<%=(i+1)%>" value="<%=(data[i][7]==null?"":data[i][7])%>" style="font-family: Tahoma,Georgia;" size="7">/
				<%
				try
				{   
					sql = "select TYPE_VALUE,TYPE_VALUE from oraddman.tsa01_base_setup a where TYPE_CODE='PACKING_CODE' ";
					if (!NEW_COMP_TYPE_NO.equals("")) sql += " AND TYPE_NAME='"+ NEW_COMP_TYPE_NO+"'";
					sql += " order by to_number(TYPE_DESC)";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					comboBoxBean.setRs(rs);
					comboBoxBean.setSelection(data[i][6]);
					comboBoxBean.setFieldName("LEVEL2_NAME_"+(i+1));	
					comboBoxBean.setFontName("Tahoma,Georgia");   
					out.println(comboBoxBean.getRsString());
					rs.close();   
					statement.close();      	 
				} 
				catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				} 	
				%>				
				</td>
				<td align="center">
				<input type="text" name="LEVEL3_VALUE_<%=(i+1)%>" value="<%=(data[i][9]==null?"":data[i][9])%>" style="font-family: Tahoma,Georgia;" size="7">/
				<%
				try
				{   
					sql = "select TYPE_VALUE,TYPE_VALUE from oraddman.tsa01_base_setup a where TYPE_CODE='PACKING_CODE' ";
					if (!NEW_COMP_TYPE_NO.equals("")) sql += " AND TYPE_NAME='"+ NEW_COMP_TYPE_NO+"'";
					sql += " order by to_number(TYPE_DESC)";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					comboBoxBean.setRs(rs);
					comboBoxBean.setSelection(data[i][8]);
					comboBoxBean.setFieldName("LEVEL3_NAME_"+(i+1));	
					comboBoxBean.setFontName("Tahoma,Georgia");   
					out.println(comboBoxBean.getRsString());
					rs.close();   
					statement.close();      	 
				} 
				catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				} 	
				%>				
				</td>
				<td align="center">
				<input type="text" name="LEVEL4_VALUE_<%=(i+1)%>" value="<%=(data[i][11]==null?"":data[i][11])%>" style="font-family: Tahoma,Georgia;" size="7">/
				<%
				try
				{   
					sql = "select TYPE_VALUE,TYPE_VALUE from oraddman.tsa01_base_setup a where TYPE_CODE='PACKING_CODE' ";
					if (!NEW_COMP_TYPE_NO.equals("")) sql += " AND TYPE_NAME='"+ NEW_COMP_TYPE_NO+"'";
					sql += " order by to_number(TYPE_DESC)";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					comboBoxBean.setRs(rs);
					comboBoxBean.setSelection(data[i][10]);
					comboBoxBean.setFieldName("LEVEL4_NAME_"+(i+1));	
					comboBoxBean.setFontName("Tahoma,Georgia");   
					out.println(comboBoxBean.getRsString());
					rs.close();   
					statement.close();      	 
				} 
				catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				} 	
				%>				
				</td>
				<!--<td align="center"><input type="text" NAME="SPQ_<%=(i+1)%>" value="<%=(data[i][4]==null?"":data[i][4])%>" style="font-family: Tahoma,Georgia;" size="8"></td>-->
				<!--<td align="center"><input type="text" NAME="MOQ_<%=(i+1)%>" value="<%=(data[i][5]==null?"":data[i][5])%>" style="font-family: Tahoma,Georgia;" size="8"></td>-->
				<!--<td align="center"><input type="text" NAME="CHANGE_RATE_<%=(i+1)%>" value="<%=(data[i][6]==null?"":data[i][6])%>" style="font-family: Tahoma,Georgia;" size="8"></td>-->
				<td align="center">
				<input type="text" name="UOM_<%=(i+1)%>" value="<%=(data[i][3]==null?"":data[i][3])%>" style="font-family: Tahoma,Georgia;" size="7" readonly></td>
				<td align="center">
				<%
				try
				{   
					sql = "select TYPE_VALUE,TYPE_NAME from oraddman.tsa01_base_setup a where TYPE_CODE='MOQ_LEVEL' ";
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery(sql);
					comboBoxBean.setRs(rs);
					comboBoxBean.setSelection(data[i][12]);
					comboBoxBean.setFieldName("MOQ_LEVEL_"+(i+1));	
					comboBoxBean.setFontName("Tahoma,Georgia");   
					out.println(comboBoxBean.getRsString());
					rs.close();   
					statement.close();      	 
				} 
				catch (Exception e) 
				{ 
					out.println("Exception:"+e.getMessage()); 
				} 	
				%>				
				</td>
				<td align="center"><input type="checkbox" name="chk<%=(i+1)%>" value="Y" <%=(data[i][13]==null || data[i][13].equals("")?"":"checked")%>></td>
			</tr>	
	<%		

		}		
	}
	
	if (ACODE.equals("SAVE"))
	{
		String strExist="";
		for (int i = 1 ; i <= Integer.parseInt(LINECNT) ;i++)
		{
			if (request.getParameter("ITEM_NAME_"+i) == null || request.getParameter("ITEM_NAME_"+i).equals("")) continue;
			
			if (TRANS_TYPE.equals("UPDATE"))
			{
				sql = " update oraddman.tsa01_component_detail a"+
				      " set a.level1_packing_name=?"+
					  ",a.level1_packing_value=?"+
					  ",a.level2_packing_name=?"+
					  ",a.level2_packing_value=?"+
                      ",a.level3_packing_name=?"+
					  ",a.level3_packing_value=?"+
                      ",a.level4_packing_name=?"+
					  ",a.level4_packing_value=?"+
                      ",a.moq_level=?"+
					  ",a.spq=?"+
					  ",a.moq=?"+
					  ",inactive_flag=?"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  ",comp_type_no=?"+
					  " where comp_type_no=?"+
					  " and organization_id=?"+
					  " and inventory_item_id=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,(request.getParameter("LEVEL1_NAME_"+i).equals("--")?"":request.getParameter("LEVEL1_NAME_"+i)));
				pstmtDt.setString(2,request.getParameter("LEVEL1_VALUE_"+i));
				pstmtDt.setString(3,(request.getParameter("LEVEL2_NAME_"+i).equals("--")?"":request.getParameter("LEVEL2_NAME_"+i)));
				pstmtDt.setString(4,request.getParameter("LEVEL2_VALUE_"+i));
				pstmtDt.setString(5,(request.getParameter("LEVEL3_NAME_"+i).equals("--")?"":request.getParameter("LEVEL3_NAME_"+i)));
				pstmtDt.setString(6,request.getParameter("LEVEL3_VALUE_"+i));
				pstmtDt.setString(7,(request.getParameter("LEVEL4_NAME_"+i).equals("--")?"":request.getParameter("LEVEL4_NAME_"+i)));
				pstmtDt.setString(8,request.getParameter("LEVEL4_VALUE_"+i));
				pstmtDt.setString(9,request.getParameter("MOQ_LEVEL_"+i));
				pstmtDt.setString(10,request.getParameter("LEVEL1_VALUE_"+i));
				pstmtDt.setString(11,request.getParameter("LEVEL"+request.getParameter("MOQ_LEVEL_"+i)+"_VALUE_"+i));
				pstmtDt.setString(12,request.getParameter("chk"+i));
				pstmtDt.setString(13,UserName);
				pstmtDt.setString(14,NEW_COMP_TYPE_NO);
				pstmtDt.setString(15,COMP_TYPE_NO);
				pstmtDt.setString(16,ORGANIZATION_ID);
				pstmtDt.setString(17,ITEM_ID);
				pstmtDt.executeQuery();
				pstmtDt.close();					  
			}
			else
			{
				//check data is exists or not 
				sql = " select item_name from oraddman.tsa01_component_detail a"+
				      " where organization_id=?"+
					  " and inventory_item_id=?";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,ORGANIZATION_ID);
				statement.setString(2,request.getParameter("ITEM_ID_"+i));
				ResultSet rs=statement.executeQuery();
				if (rs.next()) 
				{ 
					strExist = "Y";
				}
				else
				{
					strExist = "N";
				}
				rs.close();
				statement.close();
				
				if (strExist.equals("Y"))
				{
					throw new Exception("Item:"+request.getParameter("ITEM_NAME_"+i)+" 已存在,不可重複新增!");				  				
				}
				
				sql = " insert into oraddman.tsa01_component_detail"+
					  " (comp_type_no"+      //1
					  ",organization_id"+    //2
					  ",inventory_item_id"+  //3
					  ",item_name"+          //4
					  ",uom"+                //5
					  ",spq"+                //6
					  ",moq"+                //7
					  ",change_rate"+        //8
					  ",created_by"+         //9
					  ",creation_date"+      //10
					  ",last_updated_by"+    //11
					  ",last_update_date"+   //12
					  ",inactive_flag"+       //13      
				      ",level1_packing_name"+  //14
					  ",level1_packing_value"+  //15
					  ",level2_packing_name"+   //16
					  ",level2_packing_value"+  //17
                      ",level3_packing_name"+   //18
					  ",level3_packing_value"+  //19
                      ",level4_packing_name"+   //20
					  ",level4_packing_value"+  //21
                      ",moq_level"+	            //22				  
					  ")"+
					  " values("+
					  " ?"+       //1
					  ",?"+       //2
					  ",?"+       //3
					  ",?"+       //4
					  ",?"+       //5
					  ",?"+       //6
					  ",?"+       //7
					  ",?"+       //8
					  ",?"+       //9
					  ",sysdate"+ //10
					  ",?"+       //11
					  ",sysdate"+ //12
					  ",?"+       //13
					  ",?"+       //14
					  ",?"+       //15
					  ",?"+       //16
					  ",?"+       //17
					  ",?"+       //18
					  ",?"+       //19
					  ",?"+       //20
					  ",?"+       //21
					  ",?"+       //22
					  " )";
				PreparedStatement pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,NEW_COMP_TYPE_NO);
				pstmtDt1.setString(2,ORGANIZATION_ID); 
				pstmtDt1.setString(3,request.getParameter("ITEM_ID_"+i));
				pstmtDt1.setString(4,request.getParameter("ITEM_NAME_"+i));
				pstmtDt1.setString(5,request.getParameter("UOM_"+i)); 
				pstmtDt1.setString(6,request.getParameter("LEVEL1_VALUE_"+i));
				pstmtDt1.setString(7,request.getParameter("LEVEL"+request.getParameter("MOQ_LEVEL_"+i)+"_VALUE_"+i)); 
				pstmtDt1.setString(8,request.getParameter("CHANGE_RATE_"+i));
				pstmtDt1.setString(9,UserName);
				pstmtDt1.setString(10,UserName);
				pstmtDt1.setString(11,request.getParameter("chk"+i));
				pstmtDt1.setString(12,(request.getParameter("LEVEL1_NAME_"+i).equals("--")?"":request.getParameter("LEVEL1_NAME_"+i)));
				pstmtDt1.setString(13,request.getParameter("LEVEL1_VALUE_"+i));
				pstmtDt1.setString(14,(request.getParameter("LEVEL2_NAME_"+i).equals("--")?"":request.getParameter("LEVEL2_NAME_"+i)));
				pstmtDt1.setString(15,request.getParameter("LEVEL2_VALUE_"+i));
				pstmtDt1.setString(16,(request.getParameter("LEVEL3_NAME_"+i).equals("--")?"":request.getParameter("LEVEL3_NAME_"+i)));
				pstmtDt1.setString(17,request.getParameter("LEVEL3_VALUE_"+i));
				pstmtDt1.setString(18,(request.getParameter("LEVEL4_NAME_"+i).equals("--")?"":request.getParameter("LEVEL4_NAME_"+i)));
				pstmtDt1.setString(19,request.getParameter("LEVEL4_VALUE_"+i));
				pstmtDt1.setString(20,request.getParameter("MOQ_LEVEL_"+i));
				pstmtDt1.executeQuery();
				pstmtDt1.close();
			}
		}
		
		con.commit();
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("儲存成功!");
			if (document.MYFORM.TRANS_TYPE.value=="UPDATE")
			{
				setSubmit1("../jsp/TSA01WIPComponentDetailQuery.jsp");
			}
			else
			{
				setSubmit1("../jsp/TSA01WIPComponentDetailModify.jsp?ACODE=NEW&COMP_TYPE_NO=");
			}
		</script>			
		<%				
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div align='center' style='color:#ff0000;font-size:12px'>"+e.getMessage()+"</div>");
}
if (!ACODE.equals("UPDATE"))
{
%>	
	<tr>
		<td  colspan="11"><input type="button" name="Addline" value="Add Line" style="font-family: Tahoma,Georgia;" onClick='setAddLine("../jsp/TSA01WIPComponentDetailModify.jsp?ACODE=ADDLINE")'><input type="text" NAME="TXTLINE" value="15" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="5"></td>
	</tr>
<%
}
%>
</table>
<table width="100%" align="center">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TSA01WIPComponentDetailModify.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">
			&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick="setSubmit2('../jsp/TSA01WIPComponentDetailQuery.jsp')" style="font-family: Tahoma,Georgia;">
		</td>
	</tr>
</table>
<input type="hidden" name="LINECNT" value="<%=LINECNT%>">
<input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

