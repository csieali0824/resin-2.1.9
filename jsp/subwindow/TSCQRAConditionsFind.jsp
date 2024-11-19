<!-- 20141219 by Peggy, marker group顯示description-->
<!-- 20170603 by Peggy,新增erp family & package選項-->
<!-- 20170602 Peggy,新增ERP package & family查詢條件-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String TYPE=request.getParameter("TYPE");
if (TYPE==null) TYPE="";
String VALUE=request.getParameter("VALUE");
if (VALUE==null) VALUE="";
String PGROUP=request.getParameter("PGROUP");
if (PGROUP==null || PGROUP.equals("--")) PGROUP="%";  //add by Peggy 20140512
String sql = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<script language="JavaScript" type="text/JavaScript">
function chkall()
{
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.SUBFORM.CHKBOX.length ;i++)
		{
			document.SUBFORM.CHKBOX[i].checked= document.SUBFORM.CHKBOXALL.checked;
			setCheck((i+1));
		}
	}
	else
	{
		document.SUBFORM.CHKBOX.checked = document.SUBFORM.CHKBOXALL.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkflag = document.SUBFORM.CHKBOX[(irow-1)].checked; 
	}
	else
	{
		chkflag = document.SUBFORM.CHKBOX.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor = document.SUBFORM.STRBGCOLOR.value;
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
	}
}

function sendToMainWindow()
{
	var chkleng =0;
	var chked = false;
	var strchkvlaue = "";
	var choosevalue = "";
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkleng = document.SUBFORM.CHKBOX.length;
	}
	else
	{
		chkleng = 1;
	}
	for (var i = 0 ; i < chkleng ; i++)
	{
		if ( chkleng == 1)
		{
			chked = document.SUBFORM.CHKBOX.checked;
			strchkvlaue = document.SUBFORM.CHKBOX.value;
		}
		else
		{
			chked = document.SUBFORM.CHKBOX[i].checked; 
			strchkvlaue = document.SUBFORM.CHKBOX[i].value;
		}
		if (chked)
		{
			if (choosevalue.length >0) choosevalue +="\n";
			//choosevalue += document.getElementById("div_"+(i+1)).innerHTML;
			choosevalue += document.SUBFORM.elements["txt_"+(i+1)].value;
		}
	}
	//alert(choosevalue);
	window.opener.document.MYFORM.elements[document.SUBFORM.TYPE.value].value = choosevalue;
	this.window.close();
}
</script>
<title>Page for choose Condition List</title>
</head>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSQRAConditionsFind.jsp">
<%  
	Statement statement=con.createStatement();
	String trBgColor="#D9D540";
	try
    { 
		if (TYPE.equals("TSCFAMILY"))
		{
			//sql = " SELECT  distinct a.d_value  FROM oraddman.tsqra_product_setup a  where D_TYPE='TSC_FAMILY' order by 1"; //modify by Peggy 20140508,family list以官網上的資料顯示
			//sql = " select trim(FLEX_VALUE) FMAILY from fnd_flex_values  where flex_value_set_id=1005122 and ENABLED_FLAG='Y' ORDER BY  1";
			sql = "select distinct TSC_FAMILY FROM oraddman.tsqra_product_list a ORDER BY TSC_FAMILY";
		}
		else if (TYPE.equals("TSCPACKAGE"))
		{
			//sql = " select trim(FLEX_VALUE) PACKAGE from fnd_flex_values  where flex_value_set_id=1005126 and ENABLED_FLAG='Y' ORDER BY 1";
			sql = "select distinct TSC_PACKAGE FROM oraddman.tsqra_product_list a ORDER BY TSC_PACKAGE"; //modify by Peggy 20140603
		}
		else if (TYPE.equals("TSCPACKINGCODE"))
		{
			sql = " select tsc_package_code PACKING_CODE from (select case when (tsc_om_category (x.inventory_item_id, x.organization_id, 'TSC_PROD_GROUP')='PMD' and substr(x.segment1,4,1)='G') then substr(x.segment1,9,2)||'G' when  ( tsc_om_category (x.inventory_item_id, x.organization_id, 'TSC_PROD_GROUP')<>'PMD' and substr(x.segment1,11,1)='1' ) then substr(x.segment1,9,2)||'G' else substr(x.segment1,9,2) end as tsc_package_code"+
                  " from inv.mtl_system_items_b x where x.organization_id=43 and length(x.segment1)>20 and x.segment1 not like 'OSP-%' and x.segment1 not like 'PK%' and x.segment1 not like 'SOP-%' and x.segment1 not like 'Opening%' and x.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' and upper(x.description) NOT LIKE '%FAIRCHILD%' ) a group by tsc_package_code order by 1";
		}
		else if (TYPE.equals("TSCAMP"))
		{
			sql = " SELECT DISTINCT trim(SEGMENT1) AMP  FROM MTL_CATEGORIES_V  WHERE  ENABLED_FLAG='Y' AND STRUCTURE_NAME ='Amp' ORDER BY 1";
		}
		else if (TYPE.equals("TERRITORY"))
		{
			sql = " SELECT distinct TOG.GROUP_NAME TERRITORY FROM HZ_CUST_SITE_USES_ALL hcsu,TSC_OM_GROUP TOG"+
                  " WHERE TO_NUMBER(hcsu.ATTRIBUTE1) = TOG.GROUP_ID  AND tog.ORG_ID in (41,325) AND tog.MASTER_GROUP_ID IS NOT NULL order by 1";
		}
		else if (TYPE.equals("MARKETGROUP"))
		{
			//sql = " select distinct attribute2 MARKET_GROUP from AR_CUSTOMERS where attribute2 is not null order by 1";
			sql = " select b.flex_value market_group,t.description market_group_name from fnd_flex_values_tl t, fnd_flex_values b"+
                  " where b.flex_value_id = t.flex_value_id  and t.language = 'US' and b.flex_value_set_id = 1007058 and nvl(b.ENABLED_FLAG,'N')='Y' order by 1";  //modify by Peggy 20141229
		}
		else if (TYPE.equals("MANUFACTORY"))
		{
			sql = " SELECT distinct alname||'-'|| decode(alname,'Y','山東陽信','I','宜蘭PMD','T','天津外購','A','宜蘭封裝','E','天津PMD') factory"+
                  " FROM oraddman.tsprod_manufactory a  WHERE ALNAME IN ('Y','I','T','A','E') order by 1";
		}
		else if (TYPE.equals("ERPTSCFAMILY"))
		{
			sql = " SELECT DISTINCT trim(SEGMENT1) as \"TSC Family\"  FROM MTL_CATEGORIES_V  WHERE ENABLED_FLAG='Y' AND STRUCTURE_NAME ='Family' ORDER BY 1";
		}	
		else if (TYPE.equals("ERPTSCPACKAGE"))
		{
			sql = " SELECT DISTINCT trim(SEGMENT1) as \"TSC Package\"  FROM MTL_CATEGORIES_V  WHERE ENABLED_FLAG='Y' AND STRUCTURE_NAME ='Package' ORDER BY 1";
		}			
		//out.println(sql);
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1]; 
		out.println("<table align='align' width='100%' >");
		out.println("<tr>");
		out.println("<td>");  
		out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
		out.println("<TR><TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'><input type='checkbox' name='CHKBOXALL' onClick='chkall();'></TH>");        
		for (int i=1;i<=colCount;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'>"+colLabel[i].trim()+"</TH>");
		} 
		out.println("</TR>");
		String strListValue = "",strchk="",strbgColor="";
		int vline=0;
		String [] chooseList  = VALUE.split(";");
		while (rs.next())
		{
			strbgColor = "#FFFFFF"; 
			strchk = "";
			vline++;
			for (int i = 0 ; i < chooseList.length ; i++)
			{
				if (chooseList[i].equals(rs.getString(1)))
				{
					strchk="checked";
					strbgColor=trBgColor;
					break;
				}
			}
			out.println("<TR id='tr_"+vline+"' BGCOLOR='"+strbgColor+"'>");
			out.println("<TD><input type='checkbox' name='CHKBOX' value='"+vline+"' "+strchk+"  onclick=setCheck('"+vline+"');></TD>");
			for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				strListValue=rs.getString(i).trim();
				out.println("<TD style='font-size:12px;font-family:arial'>"+ strListValue+"<input type='hidden' name='txt_"+vline+(i==1?"":"_"+i)+"' value='"+strListValue+"'></TD>");
			} 
			out.println("</TR>");	
		}
		out.println("</TABLE>");	
		out.println("</td>");  
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td align='center'><input type='button' name='btn1' value='Confirm' style='font-size:12px;font-family:arial' onclick='sendToMainWindow()'></td>");
		out.println("</tr>");
		out.println("</table>");
		rs.close();       
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
%>
 <BR>
<!--%表單參數%-->
<input type="hidden" name="STRBGCOLOR" value="<%=trBgColor%>">
<input type="hidden" name="TYPE" value="<%=TYPE%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
