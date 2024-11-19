<%@ page language="java" import="java.sql.*"%>
<%@ page import="java.text.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String WIP_TYPE=request.getParameter("WIP_TYPE");
if (WIP_TYPE == null) WIP_TYPE = "";
String VSID=request.getParameter("VSID");
if (VSID == null) VSID = "";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME == null) ITEMNAME = "";
String ITEMDESC=request.getParameter("ITEMDESC");
if (ITEMDESC == null) ITEMDESC = "";
String ITYPE=request.getParameter("ITYPE");
if (ITYPE==null) ITYPE="";
String v_trans_flag="",v_pcetok_flag="";
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(i_row)
{ 
	if (document.SITEFORM.ITYPE.value=="OLD")
	{
		window.opener.document.MYFORM.ITEMID.value=document.SITEFORM.elements["COL10_"+i_row].value;
		window.opener.document.MYFORM.ITEMNAME.value=document.SITEFORM.elements["COL1_"+i_row].value;
		window.opener.document.MYFORM.ITEMDESC.value=document.SITEFORM.elements["COL2_"+i_row].value;
		window.opener.document.MYFORM.PACKAGE.value=document.SITEFORM.elements["COL3_"+i_row].value;
		//if (document.SITEFORM.WIP_TYPE.value=="BGBM" || (document.SITEFORM.ITEMNAME.value !="MQ-W033NB0408DVN" && document.SITEFORM.ITEMNAME.value !="MQ-W050NB0608DVN" && document.SITEFORM.ITEMNAME.value !="MQ-W070NB0408DVN"))
		if (document.SITEFORM.WIP_TYPE.value=="BGBM" || document.SITEFORM.KPCTOK_FLAG.value=="N")  //改用變數判斷 BY PEGGY 20240612
		{
			window.opener.document.MYFORM.DIEID.value=document.SITEFORM.elements["COL11_"+i_row].value;
			window.opener.document.MYFORM.DIENAME.value=document.SITEFORM.elements["COL12_"+i_row].value;
			window.opener.document.MYFORM.DIEDESC.value=document.SITEFORM.elements["COL4_"+i_row].value;
			window.opener.document.MYFORM.DIEQTY.value=document.SITEFORM.elements["COL13_"+i_row].value;
			window.opener.document.MYFORM.VENDORITEMNAME.value="";
			window.opener.document.MYFORM.NEWITEMNAME.value="";
			window.opener.document.MYFORM.NEWITEMID.value="";
			window.opener.document.MYFORM.NEWITEMDESC.value="";
			if (window.opener.document.MYFORM.ITEMNAME.value=="MQ-W050NB0608DVN")
			{
				window.opener.document.MYFORM.REMARKS.value=window.opener.document.MYFORM.REMARKS.value.replace("007N4_AUSL.02","002N6_AUSL.02");
			}			
		}
		else
		{
			window.opener.document.MYFORM.DIEID.value=document.SITEFORM.elements["COL10_"+i_row].value;
			window.opener.document.MYFORM.DIENAME.value="N/A";
			window.opener.document.MYFORM.DIEDESC.value="N/A";
			window.opener.document.MYFORM.DIEQTY.value="1";
			window.opener.document.MYFORM.VENDORITEMNAME.value=document.SITEFORM.elements["COL15_"+i_row].value;
			window.opener.document.MYFORM.NEWITEMNAME.value=document.SITEFORM.elements["COL16_"+i_row].value;
			window.opener.document.MYFORM.NEWITEMDESC.value=document.SITEFORM.elements["COL17_"+i_row].value;
			window.opener.document.MYFORM.NEWITEMID.value=document.SITEFORM.elements["COL18_"+i_row].value;
		}
		window.opener.document.MYFORM.BILLSEQID.value=document.SITEFORM.elements["COL14_"+i_row].value;
		window.opener.document.MYFORM.QTY.value="";
		window.opener.document.MYFORM.UNITPRICE.value=document.SITEFORM.elements["COL5_"+i_row].value;
		window.opener.document.MYFORM.PACKING.value=document.SITEFORM.elements["COL7_"+i_row].value;
		window.opener.document.MYFORM.PACKAGESPEC.value=document.SITEFORM.elements["COL8_"+i_row].value;
		window.opener.document.MYFORM.TESTSPEC.value=document.SITEFORM.elements["COL9_"+i_row].value;
		if (document.SITEFORM.elements["TRANS_FLAG_"+i_row].value=="Y")
		{
			window.opener.document.getElementById("cp1").style.visibility="visible";
			window.opener.document.getElementById("cp11").style.visibility="visible";
		}
		else
		{
			window.opener.document.getElementById("cp1").style.visibility="hidden";
			window.opener.document.getElementById("cp11").style.visibility="hidden";
		}		
	}
	else if (document.SITEFORM.ITYPE.value=="NEW")
	{
		window.opener.document.MYFORM.NEWITEMNAME.value=document.SITEFORM.elements["COL1_"+i_row].value;
		window.opener.document.MYFORM.NEWITEMDESC.value=document.SITEFORM.elements["COL2_"+i_row].value;
		window.opener.document.MYFORM.NEWITEMID.value=document.SITEFORM.elements["COL3_"+i_row].value;
	}
  	this.window.close();
}
</script>
<title>Page for choose Supplier List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSA01OEMItemInfo.jsp" NAME="SITEFORM">
<input type="hidden" name="WIP_TYPE" value="<%=WIP_TYPE%>">
<input type="hidden" name="VSID" value="<%=VSID%>">
<input type="hidden" name="ITYPE" value="<%=ITYPE%>">
<input type="hidden" name="ITEMNAME" value="<%=ITEMNAME%>">

<BR>
<%  
	try
    { 
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();	
		String sql = "";
		PreparedStatement statement=null;
		
		sql = " SELECT DISTINCT ? FROM oraddman.tsa01_oem_data_type a"+
              " WHERE DATA_TYPE=? AND DATA_CODE=? AND STATUS_FLAG=?"+
              " AND DATA_NAME =?";
		PreparedStatement statement6=con.prepareStatement(sql);
		statement6.setString(1,"Y");
		statement6.setString(2,"PCETOKPCS");
		statement6.setString(3,"CP");
		statement6.setString(4,"A");	
		statement6.setString(5,ITEMNAME);				
		ResultSet rs6=statement6.executeQuery();
		if (rs6.next())
		{
			v_pcetok_flag = rs6.getString(1);
		}	
		else
		{
			v_pcetok_flag = "N";
		}
		rs6.close();  
		statement6.close();		
		//out.println(sql);		  
			  
		if (ITYPE.equals("OLD"))
		{
			sql = " select msi.segment1 item_name"+   //1
                     ",msi.description"+                 //2
                     ",tsc_inv_category(msi.inventory_item_id,msi.organization_id,?) tsc_package"+  //3
                     ",msii.description die_desc"+        //4
                     ",nvl(po.UNIT_PRICE,0) UNIT_PRICE"+  //5
                     ",po.UNIT_MEAS_LOOKUP_CODE UOM"+     //6
                     ",tsc_get_item_packing_code(msi.organization_id,msi.inventory_item_id) tsc_packing_code"+  //7
                     ",aoem.package_spec"+               //8
                     ",aoem.test_spec"+                  //9
                     ",msi.inventory_item_id"+           //10
                     ",msii.inventory_item_id die_item_id"+  //11
                     ",msii.segment1 die_name"+              //12
                     ",bic.component_quantity die_qty"+      //13
                     ",bom.bill_sequence_id"+                //14
					 ",aoem.vendor_item_name"+           //15
					 ",po.new_item_name"+              //16
					 ",po.new_item_desc"+              //17
					 ",po.new_item_id"+                //18
                     " from bom_bill_of_materials bom"+     
                     ",bom_inventory_components bic"+            
                     ",inv.mtl_system_items_b msi"+
                     ",inv.mtl_system_items_b msii"+
                     ",(select * from (select x.inventory_item_id,x.organization_id,package_spec,test_spec"+
					 "                 ,x.new_item_id, x.new_item_name, x.new_item_desc, x.vendor_item_name"+
					 "                 ,row_number() over (partition by x.inventory_item_id,x.organization_id order by x.creation_date desc,decode(x.status,'Approved',1,2)) row_rank"+
					 "                 from oraddman.tsa01_oem_headers_all x "+
					 "                 where x.wip_type_no=?"+
					 "                 and x.inventory_item_name=NVL(?,x.inventory_item_name)"+
					 "                 and x.item_description=NVL(?,x.item_description)"+
					 "                 and x.STATUS in (?,?)) where row_rank=1) aoem"+
                     ",(SELECT F.INVENTORY_ITEM_ID NEW_ITEM_ID,F.SEGMENT1 NEW_ITEM_Name,F.DESCRIPTION NEW_ITEM_DESC,D.PURCHASE_ITEM_ID,E.UNIT_PRICE,E.UNIT_MEAS_LOOKUP_CODE FROM BOM_OPERATIONAL_ROUTINGS_V A,BOM_OPERATION_SEQUENCES_V B,BOM_OPERATION_RESOURCES_V C,BOM_RESOURCES_V D"+
                     "   ,(SELECT B.ITEM_ID,B.UNIT_PRICE,B.UNIT_MEAS_LOOKUP_CODE"+
                     "     FROM PO_HEADERS_ALL A,PO_LINES_ALL B"+
                     "     WHERE A.TYPE_LOOKUP_CODE=?"+
                     "     AND A.VENDOR_SITE_ID=?"+
                     "     AND A.PO_HEADER_ID=B.PO_HEADER_ID"+
                     "     AND NVL(A.END_DATE,TO_DATE('20990101','YYYYMMDD')) >TRUNC(SYSDATE)) E"+
					 "   ,INV.MTL_SYSTEM_ITEMS_B F"+
                     "  WHERE  F.ORGANIZATION_ID=?";
			//if (WIP_TYPE.equals("BGBM") || (!ITEMNAME.equals("MQ-W033NB0408DVN") && !ITEMNAME.equals("MQ-W050NB0608DVN") && !ITEMNAME.equals("MQ-W070NB0408DVN")))
			if (WIP_TYPE.equals("BGBM") || v_pcetok_flag.equals("N")) //改用變數判斷 BY PEGGY 20240612
			{					 
				sql +="  AND F.SEGMENT1=NVL(?,F.SEGMENT1)"+
				 	  "  AND F.DESCRIPTION=NVL(?,F.DESCRIPTION)";
			}
			else
			{
				sql += " and f.inventory_item_id=?";
				//sql +=" and f.inventory_item_id in (select x.assembly_item_id from  bom_bill_of_materials x,bom_inventory_components y ,inv.mtl_system_items_b z "+
				//       " where x.organization_id=606"+
				//	   " and x.bill_sequence_id=y.bill_sequence_id"+
                //       " and y.component_item_id=z.inventory_item_id"+
				//	   " and x.organization_id=z.organization_id"+
                //      " and z.SEGMENT1=NVL(?,z.SEGMENT1)"+
				// 	   " and z.DESCRIPTION=NVL(?,z.DESCRIPTION))";					   
			}
				
			sql +=   "  AND A.ASSEMBLY_ITEM_ID=F.INVENTORY_ITEM_ID"+
					 "  AND A.ORGANIZATION_ID=F.ORGANIZATION_ID"+
                     "  AND A.ROUTING_SEQUENCE_ID=B.ROUTING_SEQUENCE_ID"+
                     "  AND B.OPERATION_SEQUENCE_ID=C.OPERATION_SEQUENCE_ID"+
                     "  AND C.RESOURCE_ID=D.RESOURCE_ID"+
                     "  AND A.ORGANIZATION_ID=D.ORGANIZATION_ID"+
                     "  AND NVL(B.DISABLE_DATE,TO_DATE('20990101','YYYYMMDD')) > TRUNC(SYSDATE)"+
                     "  AND D.PURCHASE_ITEM_ID=E.ITEM_ID(+)) po"+
                     " where bom.assembly_item_id=msi.inventory_item_id"+
                     " and bom.organization_id=msi.organization_id"+
                     " and msi.organization_id=?"+
                     " and bom.bill_sequence_id=bic.bill_sequence_id"+
                     " and bic.component_item_id=msii.inventory_item_id"+
                     " and bom.organization_id=msii.organization_id"+
                     " and bom.assembly_item_id=aoem.inventory_item_id(+)"+
                     " and bom.organization_id=aoem.organization_id(+)"+
					 " and msi.segment1=NVL(?,msi.SEGMENT1)"+
                     " and msi.description=NVL(?,msi.description)";
			//out.println(sql);
			statement = con.prepareStatement(sql);
			statement.setString(1,"23");
			statement.setString(2,WIP_TYPE);
			statement.setString(3,ITEMNAME);
			statement.setString(4,ITEMDESC);
			statement.setString(5,"Submit");
			statement.setString(6,"Approved");
			statement.setString(7,"BLANKET");
			statement.setString(8,VSID);
			statement.setInt(9,606);
			//if (WIP_TYPE.equals("BGBM") || (!ITEMNAME.equals("MQ-W033NB0408DVN") && !ITEMNAME.equals("MQ-W050NB0608DVN") && !ITEMNAME.equals("MQ-W070NB0408DVN")))
			if (WIP_TYPE.equals("BGBM") || v_pcetok_flag.equals("N"))  //改用變數判斷 BY PEGGY 20240612
			{	
				statement.setString(10,ITEMNAME);
				statement.setString(11,ITEMDESC);
				statement.setInt(12,606);
				statement.setString(13,ITEMNAME);
				statement.setString(14,ITEMDESC);				
			}
			else
			{
				sql = " select x.assembly_item_id from  bom_bill_of_materials x,bom_inventory_components y ,inv.mtl_system_items_b z "+
				       " where x.organization_id=?"+
					   " and x.bill_sequence_id=y.bill_sequence_id"+
                       " and y.component_item_id=z.inventory_item_id"+
					   " and x.organization_id=z.organization_id"+
                       " and z.SEGMENT1=NVL(?,z.SEGMENT1)"+
				 	   " and z.DESCRIPTION=NVL(?,z.DESCRIPTION)";
				PreparedStatement statement1=con.prepareStatement(sql);
				statement1.setInt(1,606);
				statement1.setString(2,ITEMNAME);
				statement1.setString(3,ITEMDESC);
				ResultSet rs1=statement1.executeQuery();
				if (rs1.next())
				{
					statement.setInt(10,rs1.getInt(1));
				}	
				else
				{
					statement.setInt(10,0);
				}
				rs1.close();  
				statement1.close();	
					
				statement.setInt(11,606);
				statement.setString(12,ITEMNAME);
				statement.setString(13,ITEMDESC);											 
			}

		}
		else if (ITYPE.equals("NEW"))
		{
			sql =" select segment1,description,inventory_item_id from inv.mtl_system_items_b msi"+
                 " where msi.segment1=NVL(?,msi.SEGMENT1)"+
                 " and msi.description=NVL(?,msi.description)"+
                 " and msi.organization_id=?";
			statement = con.prepareStatement(sql);
			statement.setString(1,ITEMNAME);
			statement.setString(2,ITEMDESC);
			statement.setInt(3,606);				 
		}
		
		ResultSet rs=statement.executeQuery();
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE bordercolor='#CCCCCC'>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
		for (int i=1;i<=colCount-(ITYPE.equals("NEW")?1:5);i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
		} //end of for 
		out.println("</TR>");
		int queryCount=0;
		String buttonContent=null;
		while (rs.next())
		{
			v_trans_flag="N";
			sql = "select ? from  oraddman.tsa01_oem_data_type a where a.data_type=? and a.data_code=? and a.data_name=? and a.status_flag=?";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,"Y");
			statement1.setString(2,"PCETOKPCS");
			statement1.setString(3,WIP_TYPE);
			statement1.setString(4,rs.getString(1));
			statement1.setString(5,"A");
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{
				v_trans_flag=rs1.getString(1);
			}
			rs1.close();
			statement1.close();			
						
			queryCount++;	
			buttonContent="this.value=sendToMainWindow("+queryCount+")";							
			//out.println(buttonContent);
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				if (i<=colCount-(ITYPE.equals("NEW")?1:5))out.println("<TD align='left'><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT>");
				out.println("<input type='hidden' name='COL"+i+"_"+queryCount+"' value='"+((s==null)?"N/A":s)+"'>");
				if (i==colCount) out.println("<input type='hidden' name='TRANS_FLAG_"+queryCount+"' value='"+((v_trans_flag==null)?"N":v_trans_flag)+"'>");
				if (i<=colCount-(ITYPE.equals("NEW")?1:5)) out.println("</TD>");
			} 
			out.println("</TR>");
		} 
		out.println("</TABLE>");						
		rs.close();  
		statement.close();

	    if (queryCount==1) //若取到的查詢數 == 1
	    {
	     %>
		    <script LANGUAGE="JavaScript">	
				sendToMainWindow(1);	
            </script>
		 <%
	    }
		
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>
 <BR>
<!--%表單參數%-->
<input type="hidden" name="KPCTOK_FLAG" value="<%=v_pcetok_flag%>">
</FORM>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
