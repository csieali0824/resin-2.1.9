<!-- 20150721 Peggy,shipping method改以call tsc_edi_pkg.get_shipping_method取得-->
<!-- 20151026 Peggy,get_ssd  arrow ssd+運輸天數>=crd -->
<!-- 20160513 Peggy,for TSC_EDI_PKG.GET_SHIPPING_METHOD新增customer_id而修改-->
<!-- 20160706 Peggy,TSCA shipping method顯示&SSD計算-->
<!-- 20161019 by Peggy,停用function:TSC_RFQ_GET_TSCA_SSD,改用TSCA_GET_ORDER_SSD-->
<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String CRD=request.getParameter("CRD");
String plant=request.getParameter("plant");
String odrtype=request.getParameter("odrtype");
String salesArea=request.getParameter("region");
String createdt=request.getParameter("createdt");
String shipMethod = request.getParameter("shippingMethod");
String fob = (request.getParameter("fob")).replace("\"","&"); //add by Peggy 20210207
if (fob ==null) fob ="";
String itemName =request.getParameter("itemname");
if (shipMethod == null) shipMethod = "";
String lineNo = request.getParameter("LINENO");  //add by Peggy 20130605
if (lineNo==null) lineNo="";
String PROGID = request.getParameter("PROGID");  //add by Peggy 20130605
if (PROGID==null) PROGID="";
String cust_id = request.getParameter("custid"); //add by Peggy 20151026
if (cust_id==null) cust_id="";
String objtype = request.getParameter("objtype");  //add by Peggy 20190521
if (objtype==null) objtype="";
String deliverid = request.getParameter("deliverid"); //add by Peggy 20210208
if (deliverid==null) deliverid="";

%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(shippingMethod,ssd,limitdays,lineNo,PROGID,shippingMethodCode,objtype)
{
	if (lineNo==null || lineNo =="")
	{
		window.opener.document.MYFORM.SHIPPINGMETHOD.value=shippingMethodCode;      
		window.opener.document.MYFORM.REQUESTDATE.value=ssd;   
		//window.opener.document.MYFORM.LIMITDAYS.value=limitdays; 
		window.opener.document.MYFORM.LNREMARK.focus(); 
	}
	else
	{
		if (PROGID=="D90021") //modify by Peggy 20190521
		{
			window.opener.document.MYFORM.elements[objtype+"_SHIPMETHOD_"+lineNo].value=shippingMethodCode;      
			window.opener.document.MYFORM.elements[objtype+"_SSD_"+lineNo].value=ssd; 
		}
		else if (PROGID=="D110021")
		{
		
			window.opener.document.MYFORM.elements["RFQ_SHIPMETHOD_"+lineNo].value=shippingMethodCode;      
			window.opener.document.MYFORM.elements["RFQ_SSD_"+lineNo].value=ssd; 
		}
		else
		{
			window.opener.document.MYFORM.elements["SHIPPINGMETHOD_"+lineNo].value=shippingMethodCode;      
			window.opener.document.MYFORM.elements["SSD_"+lineNo].value=ssd; 
		}  
	}
  	this.window.close();
}
</script>
<title>Page for choose Shipping Method List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSDRQSSDFind.jsp">
<BR>
<%  
	Statement statement=con.createStatement();
	int datacnt = 0;
	String shippingMethod=null;
	String ssd=null;
	String mark="";
	String buttonContent=null;
	String trBgColor = "";
	String halign = "";
	String fontcolor="";
	String limitdays=""; 
	String shipping_method_code="";
	String coo="";
	//int i_days=7;
	String sql ="";
	//if (cust_id.equals("7147")) i_days=1; //add by Peggy 20151026
	//if (cust_id.equals("7147")) i_days=-1; //add by Peggy 20160729,CRD往前推11天
	
	try
    {
		if (shipMethod.equals("*") || salesArea.equals("008")) //add by Peggy 20160706
		{
			//modify by Peggy 20150721
			sql = " select description, TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE, "+
						 " TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY, "+
						 " case when '" + plant + "' IN ('002') and '" + salesArea + "' in('008') and TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Package') in ('SMA', 'SMB','SMC','SOD-123W','SOD-128') then 'TW' "+
						 " else tsc_get_item_coo(a.inventory_item_id) end coo "+
						 " from APPS.MTL_SYSTEM_ITEMS A WHERE A.ORGANIZATION_ID=43"+
						 " and a.segment1= '"+itemName+"'";
			ResultSet rsx=statement.executeQuery(sql);
			if (rsx.next())
			{
				//CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?)}");
				CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}"); //modify by Peggy 20160513
				csf.setString(1,salesArea);
				csf.setString(2,rsx.getString("TSC_PACKAGE"));      
				csf.setString(3,rsx.getString("TSC_FAMILY"));                   
				csf.setString(4,rsx.getString("description"));    
				csf.setString(5,CRD);   
				csf.registerOutParameter(6, Types.VARCHAR);  
				csf.setString(7,odrtype);   
				csf.setString(8,plant);   
				csf.setString(9,cust_id);   //add by Peggy 20160513 
				csf.setString(10,fob);       //add by Peggy 20190319
				csf.setString(11,deliverid);       //add by Peggy 20190319
				csf.execute();
				shipMethod = csf.getString(6);
				coo=rsx.getString("COO");
				csf.close();			
			}
			rsx.close();						 
		}
		if (salesArea.equals("008")) //add by Peggy 20160706
		{
			sql = " select '"+shipMethod+"' as \"SHIPPING METHOD\","+
			      //" TSC_RFQ_GET_TSCA_SSD('"+odrtype+"','"+shipMethod+"','"+CRD+"') AS \"SCHEDULE SHIP DATE\","+
				  " TSCA_GET_ORDER_SSD('"+odrtype+"','"+shipMethod+"','"+CRD+"','CRD',trunc(sysdate),null) AS \"SCHEDULE SHIP DATE\","+  //add by Peggy 20161019
				  " '' as Mark,"+
				  " 0 as limit_days ,"+
				  "  (SELECT LOOKUP_CODE from fnd_lookup_values WHERE view_application_id = 3 AND lookup_type = 'SHIP_METHOD' and LANGUAGE='US' AND security_group_id = 0 AND ENABLED_FLAG='Y' AND meaning ='"+shipMethod+"') AS shipping_method_code "+
				  " from dual";
		}
		else
		{
			String isCNFunction = coo.equals("CN")?
					"GET_TSCE_PMD_SSD('"+salesArea+"','"+plant+"','"+CRD+"',X.shipping_method,'"+odrtype+"','"+cust_id+"',to_date('"+createdt+"','yyyymmdd'),'"+fob+"','"+deliverid+"','"+coo+"') ":
					"tsc_edi_pkg.GET_TSCE_ORDER_SSD('"+salesArea+"','"+plant+"','"+CRD+"',X.shipping_method,'"+odrtype+"','"+cust_id+"',to_date('"+createdt+"','yyyymmdd'),'"+fob+"','"+deliverid+"') ";

			/*sql = " SELECT X.shipping_method AS \"SHIPPING METHOD\","+
			      " tsc_edi_pkg.GET_TSCE_ORDER_SSD('"+salesArea+"','"+plant+"','"+CRD+"',X.shipping_method,'"+odrtype+"','"+cust_id+"',to_date('"+createdt+"','yyyymmdd'))  AS \"SCHEDULE SHIP DATE\","+
				  " '' as Mark,"+
				  "  X.limit_days ,"+
		          "  (select LOOKUP_CODE from fnd_lookup_values Z WHERE Z.view_application_id = 3 AND Z.lookup_type = 'SHIP_METHOD' and Z.LANGUAGE='US' AND Z.security_group_id = 0 AND Z.ENABLED_FLAG='Y' AND Z.MEANING =X.shipping_method) shipping_method_code "+
                  " FROM (SELECT SHIPPING_METHOD,NVL(A.LIMIT_DAYS,0) LIMIT_DAYS,ROW_NUMBER () OVER (PARTITION BY shipping_method ORDER BY DECODE(A.ORDER_TYPE,"+odrtype+",1,2)) AS rownumber "+
                  "       FROM ORADDMAN.TSC_TRANSPORTATION_TBL A"+
                  "       WHERE A.PLANT_CODE='"+ plant+"'"+
                  "       AND A.SALES_REGION='" + salesArea + "'"+
                  "       AND (A.ORDER_TYPE ="+odrtype+" OR A.ORDER_TYPE IS NULL)"+
                  "       ) X WHERE X.rownumber =1";*/
			sql = " select a.* from (SELECT X.shipping_method AS \"SHIPPING METHOD\","+
			      " " + isCNFunction +"  AS \"SCHEDULE SHIP DATE\","+
				  " '' as Mark,"+
				  "  0 limit_days ,"+
				  "  shipping_method_code"+
		          "  from (select LOOKUP_CODE shipping_method_code , Z.MEANING shipping_method from fnd_lookup_values Z WHERE Z.view_application_id = 3 AND Z.lookup_type = 'SHIP_METHOD' and Z.LANGUAGE='US' AND Z.security_group_id = 0 AND Z.ENABLED_FLAG='Y') x"+ 
				  " ,(select distinct shipping_method from oraddman.tsce_acceptance_rule) tar"+
				  "  where x.shipping_method like tar.shipping_method";
			if (!shipMethod.equals(""))
			{
				sql += " AND X.SHIPPING_METHOD='"+ shipMethod+"'";
				//sql += " and (x.shipping_method = '" + shipMethod+ "' or x.LOOKUP_CODE='"+ shipMethod+ "')";
			}
			sql += ") a where \"SCHEDULE SHIP DATE\" is not null "+
			       "  ORDER BY 1";
		}
		//out.println("sql:"+sql);
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];     
		out.println("<TABLE>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
		for (int i=1;i<=colCount-2;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
		} //end of for 
		out.println("</TR>");
		while (rs.next())
		{
			datacnt ++;
			shippingMethod=rs.getString("SHIPPING METHOD");
			ssd=rs.getString("SCHEDULE SHIP DATE");
			mark=rs.getString("Mark");
			if (mark ==null) mark = "";
			limitdays=rs.getString("limit_days");
			shipping_method_code=rs.getString("shipping_method_code");
			trBgColor = "E3E3CF"; 
			buttonContent="this.value=sendToMainWindow("+'"'+shippingMethod+'"'+','+'"'+ssd+'"'+','+'"'+limitdays+'"'+","+'"'+lineNo+'"'+","+'"'+PROGID+'"'+","+'"'+shipping_method_code+'"'+","+'"'+objtype+'"'+")";		
			out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount-2;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				if (i>=2)
				{	
					halign = "center";
				 	if (mark.equals("*"))
					{
						fontcolor = "red";
					}
					else
					{
						fontcolor = "black";
					}
				}
				else
				{	
					halign = "left";
					fontcolor="black";
				}
				out.println("<TD align='"+halign+"'><FONT SIZE=2  color='"+fontcolor+"'>"+((s==null)?"&nbsp;":s)+"</FONT></TD>");
			} //end of for
			out.println("</TR>");	
		} //end of while
		out.println("</TABLE>");						
		
		rs.close();       
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
	if (datacnt ==1)
	{
		out.print("<script type=\"text/javascript\">sendToMainWindow("+'"'+shippingMethod+'"'+','+'"'+ssd+'"'+','+'"'+limitdays+'"'+","+'"'+lineNo+'"'+","+'"'+PROGID+'"'+","+'"'+shipping_method_code+'"'+","+'"'+objtype+'"'+")</script>"); 
	}

%>
 <BR>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
