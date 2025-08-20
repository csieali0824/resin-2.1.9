<!-- 20150317 Peggy,北新科3867只做測試-->
<!-- 20151119 Peggy,AP.ap_supplier_sites_all增加 (b.INACTIVE_DATE IS NULL or trunc(b.INACTIVE_DATE)>trunc(sysdate)) and b.PURCHASING_SITE_FLAG='Y'條件-->
<!-- 20151225 Peggy,3083天水華天微電子股份有限公司改名為4056天水華天電子集團-->
<%@ page language="java" import="java.sql.*"%>
<%@ page import="java.text.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String SupplierNo=request.getParameter("SUPPLIERNO");
if (SupplierNo == null) SupplierNo = "";
String SupplierName=request.getParameter("SUPPLIERNAME");
if (SupplierName ==null) SupplierName = "";
String SearchStr=request.getParameter("SEARCHSTRING");
if (SearchStr == null) SearchStr = "";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID==null) ITEMID ="";
String QTY = request.getParameter("QTY");
if (QTY==null || QTY.equals("")) QTY="0";
String VENDOR_SITE_ID = request.getParameter("SUPPLIERSITE");
if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  
String WIPTYPE = request.getParameter("WIPTYPE");  //add by Peggy 20130719
if (WIPTYPE==null) WIPTYPE="";
String FUNCNAME = request.getParameter("FUNCNAME"); //add by Peggy 20130801
if (FUNCNAME==null) FUNCNAME="F1001";

%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(VendorNo,VendorName,VendorContact,Currency,VendorSite,Price,VendorSiteID,PriceUom,PackageSpec,TestSpec,lineno,FUNCNAME)
{ 
	window.opener.document.MYFORM.SUPPLIERNO.value=VendorNo;
  	window.opener.document.MYFORM.SUPPLIERNAME.value=VendorName;
	window.opener.document.MYFORM.VENDOR_SITE_ID.value=VendorSiteID;                                  //add by Peggy 20120705
	if (FUNCNAME=="F1001")
	{
		if (window.opener.document.MYFORM.WIPTYPE.value =="01" || window.opener.document.MYFORM.WIPTYPE.value =="03")  //modify by Peggy 20170712,add重工	
		{
			if ( VendorNo=="2012") //昇陽科無封裝,add by Peggy 20141110
			{
				window.opener.document.MYFORM.CHKASSEMBLY.checked =false;
			}
			else if (VendorNo=="3867")  //北新科只有測試,add by Peggy 20150317
			{
				window.opener.document.MYFORM.CHKASSEMBLY.checked=false;
				window.opener.document.MYFORM.CHKTESTING.checked=true;
				window.opener.document.MYFORM.CHKTAPING.checked=false;
				window.opener.document.MYFORM.CHKLAPPING.checked=false;
				window.opener.document.MYFORM.CHKOTHERS.checked=false;
				window.opener.document.MYFORM.OTHERS.value="";
			}
			window.opener.document.MYFORM.PACKAGESPEC.value=PackageSpec;                                      //add by Peggy 20130719
			window.opener.document.MYFORM.TESTSPEC.value=TestSpec;                                            //add by Peggy 20130719
			window.opener.document.MYFORM.MARKING.value=document.SITEFORM.elements["MARKING_"+lineno].value;     //add by Peggy 20130722
		}
		else if (window.opener.document.MYFORM.WIPTYPE.value =="04") //add by Peggy 20240418
		{
			window.opener.document.MYFORM.PACKAGESPEC.value=PackageSpec;                                  
			window.opener.document.MYFORM.TESTSPEC.value=TestSpec;  		
		}
	}
	//add by Peggy 20120627
	if (document.SITEFORM.ITEMID.value!="")
	{
		if (Price ==null || Price == "" || Price =="null" || (window.opener.document.MYFORM.WIPTYPE.value !="01" && window.opener.document.MYFORM.WIPTYPE.value !="04" && window.opener.document.MYFORM.WIPTYPE.value !="05")) //add 05-CP by Peggy 20220316
		{
			window.opener.document.MYFORM.UNITPRICE.value="";
		}
		else
		{
			window.opener.document.MYFORM.UNITPRICE.value=Price;
			window.opener.document.MYFORM.UNITPRICELIST.options.length = 0;
		}
	}
	if (FUNCNAME !="F1-006")
	{
		if (window.opener.document.MYFORM.SUPPLIERCONTACT!=undefined)
		{
			window.opener.document.MYFORM.SUPPLIERCONTACT.value="";
		}
		window.opener.document.MYFORM.CURRENCYCODE.value = Currency;
		if (window.opener.document.getElementById("td1")!=undefined)
		{
			if (window.opener.document.MYFORM.WIPTYPE.value =="01" || window.opener.document.MYFORM.WIPTYPE.value =="04" || window.opener.document.MYFORM.WIPTYPE.value =="05") //add 05-CP by Peggy 20220316
			{
					window.opener.document.MYFORM.PRICE_UOM.value = PriceUom;
			}
			else
			{
				if (Currency==="USD" || window.opener.document.MYFORM.WIPTYPE.value ==="03" || window.opener.document.MYFORM.WIPTYPE.value === "02")  //modify by Peggy 20120705,重工的單價單位為K
				{
					//window.opener.document.getElementById("td1").innerHTML = Currency+"/k";
					window.opener.document.MYFORM.PRICE_UOM.value = "k";
				}
				else
				{
					window.opener.document.MYFORM.PRICE_UOM.value = "ea";
					//window.opener.document.getElementById("td1").innerHTML = Currency+"/ea";
				}
			}
			window.opener.document.getElementById("td1").innerHTML = Currency+"/"+PriceUom;
			if (PriceUom=="片")
			{
				window.opener.document.getElementById("td2").innerHTML = "("+PriceUom+")";
			}
			else
			{
				window.opener.document.getElementById("td2").innerHTML = "(KPC)";
			}
		}
		//add by Peggy 20120622
		if (window.opener.document.MYFORM.SUPPLIERSITE!=undefined)
		{
			window.opener.document.MYFORM.SUPPLIERSITE.value=VendorSite;
		}
	}
	if (document.SITEFORM.ITEMID.value!="" || document.SITEFORM.FUNCNAME.value!="F2001")
	{
		window.opener.document.MYFORM.submit();
	}
  	this.window.close();
}
</script>
<title>Page for choose Supplier List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCPMDSupplierInfoFind.jsp" NAME="SITEFORM">
<font size="-1"><jsp:getProperty name="rPH" property="pgVendor"/><jsp:getProperty name="rPH" property="pgName"/>: 
	<input type="text" name="SEARCHSTRING" size=30 value="<%=SearchStr%>" STYLE="font-family:ARIAL">
  	</font> 
  	<INPUT TYPE="submit" NAME="submit1" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
<BR>
<%  
	Statement statement=con.createStatement();
	try
    { 
		String sql = " SELECT DISTINCT a.SEGMENT1 VENDOR_CODE,b.VENDOR_SITE_CODE VENDOR_SITE, a.VENDOR_NAME,replace(replace(c.VENDOR_CONTACT,'''r',''),'''','') VENDOR_CONTACT,NVL(b.PAYMENT_CURRENCY_CODE,b.INVOICE_CURRENCY_CODE) CURRENCY_CODE,b.VENDOR_SITE_ID  ";
		//if (!WIPTYPE.equals("04"))
		//{
			sql += " ,avl.package_spec,avl.test_spec";//add by Peggy 20130719
		//}
		//else
		//{
		//	sql += " ,'N/A' package_spec,'N/A' test_spec";//add by Peggy 20130719
		//}
		sql +=" FROM AP.ap_suppliers a ,AP.ap_supplier_sites_all b,(select VENDOR_SITE_ID,vendor_contact from (SELECT VENDOR_SITE_ID,LAST_NAME|| FIRST_NAME vendor_contact, row_number() over (partition by VENDOR_SITE_ID order by LAST_UPDATE_DATE desc) rownumber"+
                     " FROM AP.ap_supplier_contacts) where rownumber=1) c ";
		//if (!WIPTYPE.equals("04"))
		//{
			sql += ",(select VENDOR_CODE,PACKAGE_SPEC,TEST_SPEC from oraddman.tspmd_item_avl x where x.INVENTORY_ITEM_ID ='"+ITEMID+"' and nvl(x.ACTIVE_FLAG,'') ='Y') avl";  //add by Peggy 20130719
		//}
        sql += " where a.vendor_id= b.vendor_id and b.vendor_site_id= c.vendor_site_id(+) and  A.ENABLED_FLAG='Y' and  (b.INACTIVE_DATE IS NULL or trunc(b.INACTIVE_DATE)>trunc(sysdate)) and b.PURCHASING_SITE_FLAG='Y'";
		if (WIPTYPE.equals("01"))
		{
			sql +=" and a.segment1 = avl.VENDOR_CODE"; //add by Peggy 20130719 
		}
		//else if (!WIPTYPE.equals("04"))
		//{
			sql +=" and a.segment1 = avl.VENDOR_CODE(+)"; //add by Peggy 20130719 
		//}
		if (SearchStr != null && !SearchStr.equals(""))
		{
			sql += " AND (a.SEGMENT1 like '"+SearchStr+"%' or a.VENDOR_NAME like '"+SearchStr+"%')"; 
		}
		else if (SupplierNo != null && !SupplierNo.equals(""))
		{
			sql += " AND a.SEGMENT1 like '"+SupplierNo+"%'"; 
		}
		else if (SupplierName != null && !SupplierName.equals(""))
		{
			sql += " AND a.VENDOR_NAME like '%"+SupplierName+"%'"; 
		}
		if (WIPTYPE.equals("01") || WIPTYPE.equals("04") || WIPTYPE.equals("05"))
		{
			sql += " and exists (select 1 from oraddman.tspmd_item_quotation x where x.VENDOR_SITE_ID=b.vendor_site_id)"; //add by Peggy 20220316
		}	
		//out.println(sql);
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
		for (int i=1;i<=colCount-3;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
		} //end of for 
		out.println("</TR>");
		String VendorCode="";
		String VendorName="";
		String VendorContact="";
		String CurrencyCode="";
		String VendorSite="";   //add by Peggy 20120622
		String Price="0";       //add by Peggy 20120627
		String VendorSiteID=""; //add by Peggy 20120705
		String PriceUom="";     //add by Peggy 20120726
		String PACKAGE_SPEC=""; //add by Peggy 20130719
		String TEST_SPEC="";    //add by Peggy 20130719
		String MARKING="";      //add by Peggy 20130722
		int queryCount=0;
		String buttonContent=null;
		while (rs.next())
		{
			VendorCode=rs.getString("VENDOR_CODE");
			VendorName=rs.getString("VENDOR_NAME");
			VendorContact=rs.getString("VENDOR_CONTACT");
			CurrencyCode=rs.getString("CURRENCY_CODE");
			VendorSite=rs.getString("VENDOR_SITE");
			VendorSiteID=rs.getString("VENDOR_SITE_ID");
			PACKAGE_SPEC=rs.getString("PACKAGE_SPEC");  //add by Peggy 20130719
			if (PACKAGE_SPEC==null) PACKAGE_SPEC="";
			TEST_SPEC=rs.getString("TEST_SPEC");    //add by Peggy 20130719
			if (TEST_SPEC==null) TEST_SPEC="";
			MARKING="";
			if (!ITEMID.equals(""))
			{
				//sql = " SELECT  a.unit_price  FROM oraddman.tspmd_item_quotation a  "+
				//      " where vendor_code ='"+VendorCode+"'  and inventory_item_id='"+ITEMID+"' and VENDOR_SITE_ID='"+ VendorSiteID+"'"+
				//	  " and '"+ QTY + "' between a.start_qty and a.end_qty";
				sql = " SELECT distinct decode( LOWER(a.uom),'kpcs','k',LOWER(a.uom)) UOM,(select b.unit_price  from  oraddman.tspmd_item_quotation b"+
                      " where b.vendor_code =a.vendor_code  and b.inventory_item_id=a.inventory_item_id and b.VENDOR_SITE_ID=a.VENDOR_SITE_ID"+
                      " and '"+ QTY + "' between decode(LOWER(b.uom),'ea',b.start_qty/1000,b.start_qty) and decode(LOWER(b.uom),'ea',b.end_qty/1000,b.end_qty)) unit_price"+
                      " FROM oraddman.tspmd_item_quotation a  "+
                      " where a.vendor_code ='"+VendorCode+"' and a.inventory_item_id='"+ITEMID+"' and a.VENDOR_SITE_ID='"+ VendorSiteID+"'";
				Statement statement1=con.createStatement();
				//out.println(sql);
				ResultSet rs1=statement1.executeQuery(sql);
				if (rs1.next())
				{
					PriceUom = rs1.getString("uom");
					if (rs1.getString("unit_price") != null) Price = (new DecimalFormat("####0.0##")).format(Float.parseFloat(rs1.getString("unit_price")));
				}
				rs1.close();
				statement1.close();
			}
			
			//add by Peggy 20130722
			if (WIPTYPE.equals("01"))
			{
				sql = " select MARKING from (SELECT a.INVENTORY_ITEM_NAME,a.VENDOR_CODE, a.MARKING,row_number() over (partition by a.VENDOR_CODE,a.INVENTORY_ITEM_NAME order by a.CREATION_DATE desc) ROW_CNT"+
					  //" FROM oraddman.tspmd_oem_headers_all a  where STATUS='Approved' AND case when  '"+VendorCode+"'='4056' and a.VENDOR_CODE='3083' then '"+VendorCode+"' else a.VENDOR_CODE end ='"+VendorCode+"' AND a.INVENTORY_ITEM_ID='"+ITEMID+"') a where row_cnt =1";
					  " FROM oraddman.tspmd_oem_headers_all a  where STATUS='Approved' AND a.WIP_TYPE_NO='"+WIPTYPE+"' AND a.INVENTORY_ITEM_ID='"+ITEMID+"') a where row_cnt =1";
				//out.println(sql);	  
				Statement statement5=con.createStatement();
				ResultSet rs5=statement5.executeQuery(sql);
				while (rs5.next())
				{
					MARKING = rs5.getString("MARKING");
				}
				rs5.close();
				statement5.close();
			}
			
			//buttonContent="this.value=sendToMainWindow("+'"'+VendorCode+'"'+','+'"'+VendorName+'"'+","+'"'+VendorContact+'"'+","+'"'+CurrencyCode+'"'+","+'"'+VendorSite+'"'+","+'"'+Price+'"'+","+'"'+VendorSiteID+'"'+","+'"'+PriceUom+'"'+","+'"'+PACKAGE_SPEC+'"'+","+'"'+TEST_SPEC+'"'+","+'"'+MARKING+'"'+")";				
			buttonContent="this.value=sendToMainWindow("+'"'+VendorCode+'"'+','+'"'+VendorName+'"'+","+'"'+VendorContact+'"'+","+'"'+CurrencyCode+'"'+","+'"'+VendorSite+'"'+","+'"'+Price+'"'+","+'"'+VendorSiteID+'"'+","+'"'+PriceUom+'"'+","+'"'+PACKAGE_SPEC+'"'+","+'"'+TEST_SPEC+'"'+","+'"'+(queryCount+1)+'"'+","+'"'+FUNCNAME+'"'+")";							
			//out.println(buttonContent);
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount-3;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				out.println("<TD align='left'><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT></TD>");
			} //end of for
			out.println("</TR>");
			out.println("<input type='hidden' name='VENDORNO' value='"+VendorCode+"' >");
			out.println("<input type='hidden' name='VENDORNAME' value='"+VendorName+"' >");
			out.println("<input type='hidden' name='VENDORCONTACT' value='"+VendorContact+"' >");
			out.println("<input type='hidden' name='CURRENCYCODE' value='"+CurrencyCode+"' >");
			out.println("<input type='hidden' name='VENDORSITE' value='"+VendorSite+"' >"); //add by Peggy 20120622
			out.println("<input type='hidden' name='VENDORSITEID' value='"+VendorSiteID+"' >"); //add by Peggy 20120705
			out.println("<input type='hidden' name='PRICE' value='"+Price+"'>");
			out.println("<input type='hidden' name='PRICEUOM' value='"+PriceUom+"'>");
			out.println("<input type='hidden' name='PACKAGESPEC' value='"+PACKAGE_SPEC+"'>");
			out.println("<input type='hidden' name='TESTSPEC' value='"+TEST_SPEC+"'>");
			out.println("<input type='hidden' name='MARKING_"+(queryCount+1)+"' value='"+MARKING+"'>");
			queryCount++;	
		} //end of while
		out.println("</TABLE>");						
		rs.close();  
		%>
		<input type="hidden" name="ITEMID" value="<%=ITEMID%>">
		<input type="hidden" name="FUNCNAME" value="<%=FUNCNAME%>">
		<input type="hidden" name="WIPTYPE" value="<%=WIPTYPE%>">
		<%     
	    if (queryCount==1) //若取到的查詢數 == 1
	    {
			out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+VendorCode+'"'+','+'"'+VendorName+'"'+","+'"'+VendorContact+'"'+","+'"'+CurrencyCode+'"'+","+'"'+VendorSite+'"'+","+'"'+Price+'"'+","+'"'+VendorSiteID+'"'+","+'"'+PriceUom+'"'+","+'"'+PACKAGE_SPEC+'"'+","+'"'+TEST_SPEC+'"'+","+'"'+queryCount+'"'+","+'"'+FUNCNAME+'"'+")</script>"); 
	     %>
		    <!--<script LANGUAGE="JavaScript">		
			    window.opener.document.MYFORM.SUPPLIERNO.value = document.SITEFORM.VENDORNO.value;	   
				window.opener.document.MYFORM.SUPPLIERNAME.value = document.SITEFORM.VENDORNAME.value;
				window.opener.document.MYFORM.VENDOR_SITE_ID.value= document.SITEFORM.VENDORSITEID.value;        //add by Peggy 20120705
				if (document.SITEFORM.FUNCNAME.value=="F1001")
				{
					if (window.opener.document.MYFORM.WIPTYPE.value =="01" || window.opener.document.MYFORM.WIPTYPE.value =="03")  //modify by Peggy 20170712,add 重工
					{
						if (document.SITEFORM.VENDORNO.value=="2012") //昇陽科無封裝,add by Peggy 20141110
						{
							window.opener.document.MYFORM.CHKASSEMBLY.checked =false;
						}	
						else if (document.SITEFORM.VENDORNO.value =="3867")  //北新科只有測試,add by Peggy 20150317
						{
							window.opener.document.MYFORM.CHKASSEMBLY.checked=false;
							window.opener.document.MYFORM.CHKTESTING.checked=true;
							window.opener.document.MYFORM.CHKTAPING.checked=false;
							window.opener.document.MYFORM.CHKLAPPING.checked=false;
							window.opener.document.MYFORM.CHKOTHERS.checked=false;
							window.opener.document.MYFORM.OTHERS.value="";
						}								
						window.opener.document.MYFORM.PACKAGESPEC.value=document.SITEFORM.PACKAGESPEC.value;             //add by Peggy 20130719
						window.opener.document.MYFORM.TESTSPEC.value=document.SITEFORM.TESTSPEC.value;                   //add by Peggy 20130719
						window.opener.document.MYFORM.MARKING.value=document.getElementById("MARKING_1").value;          //add by Peggy 20130722
					}
				}
				//add by Peggy 20120627
				if (document.SITEFORM.ITEMID.value!="")
				{
					if (document.SITEFORM.PRICE.value ==null || document.SITEFORM.PRICE.value == "" || document.SITEFORM.PRICE.value =="null" || (window.opener.document.MYFORM.WIPTYPE.value !="01" && window.opener.document.MYFORM.WIPTYPE.value !="04"  && window.opener.document.MYFORM.WIPTYPE.value !="05")) //add 05-CP by Peggy 20220316
					{
						window.opener.document.MYFORM.UNITPRICE.value="";
						//window.opener.document.MYFORM.UNITPRICE.readOnly = true;
					}
					else
					{
						window.opener.document.MYFORM.UNITPRICE.value=document.SITEFORM.PRICE.value;
						window.opener.document.MYFORM.UNITPRICELIST.options.length = 0;
						//window.opener.document.MYFORM.UNITPRICE.readOnly = false;
					}
				}
				if (document.SITEFORM.FUNCNAME.value!="F1-006")
				{
					if (window.opener.document.MYFORM.SUPPLIERCONTACT!=undefined)
					{
						//if (document.SITEFORM.VENDORCONTACT.value != null && document.SITEFORM.VENDORCONTACT.value!="null")
						//{
							//window.opener.document.MYFORM.SUPPLIERCONTACT.value=document.SITEFORM.VENDORCONTACT.value;
						//}
						//else
						//{
							window.opener.document.MYFORM.SUPPLIERCONTACT.value="";
						//}
					}
					window.opener.document.MYFORM.CURRENCYCODE.value = document.SITEFORM.CURRENCYCODE.value;
					if (window.opener.document.getElementById("td1")!=undefined)
					{
						if (window.opener.document.MYFORM.WIPTYPE.value =="01" || window.opener.document.MYFORM.WIPTYPE.value =="04" || window.opener.document.MYFORM.WIPTYPE.value =="05")
						{
							window.opener.document.MYFORM.PRICE_UOM.value = document.SITEFORM.PRICEUOM.value;
						}
						else
						{
							if (document.SITEFORM.CURRENCYCODE.value =="USD" || window.opener.document.MYFORM.WIPTYPE.value=="03")  //modify by Peggy 20120705,重工的單價單位為K
							{
								//window.opener.document.getElementById("td1").innerHTML = document.SITEFORM.CURRENCYCODE.value+"/k";
								window.opener.document.MYFORM.PRICE_UOM.value = "k";
							}
							else
							{
								window.opener.document.MYFORM.PRICE_UOM.value = "ea";
								//window.opener.document.getElementById("td1").innerHTML = document.SITEFORM.CURRENCYCODE.value+"/ea";
							}
						}
						window.opener.document.getElementById("td1").innerHTML = document.SITEFORM.CURRENCYCODE.value+"/"+document.SITEFORM.PRICEUOM.value;
						if (document.SITEFORM.PRICEUOM.value =="片")
						{
							window.opener.document.getElementById("td2").innerHTML = "Q'ty("+document.SITEFORM.PRICEUOM.value+")";
						}
						else
						{
							window.opener.document.getElementById("td2").innerHTML = "Q'ty(KPC)";
						}
					}
					//add by Peggy 20120622
					if (window.opener.document.MYFORM.SUPPLIERSITE!=undefined)
					{
						window.opener.document.MYFORM.SUPPLIERSITE.value=document.SITEFORM.VENDORSITE.value;
					}
				}
				if (document.SITEFORM.ITEMID.value!="" || document.SITEFORM.FUNCNAME.value!="F2001")
				{
					window.opener.document.MYFORM.submit();
				}
				window.close(); 
            </script>-->
		 <%
	    }
		
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
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
