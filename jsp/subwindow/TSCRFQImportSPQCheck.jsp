<!-- 20110316 liling �ץ�TSC_PROD_GROUP���P�_�Ϥ��UPROD��MOQ�ƶq���P -- >
<!-- 20110330 Marvie : Fairchild MOQ -->
<!-- 20150715 Peggy,�[SAMPLEORDER�P�_-->
<!-- 20151122 Peggy,add TSC_PROD_FAMILY column-->
<!-- 20160114 Peggy,call function TSC_GET_ITEM_SPQ_MOQ get spq,moq,sample_spq  value-->
<!-- 20160303 Peggy,add shipto�ܼ�-->
<!-- 20160623 Peggy,�ץ����O��remarks-->
<!-- 20180720 Peggy,�s�WSHIPTOORG�ѥ[for TSCA CUSTOMER DIGIKEY ISSUE-->
<html>
<head>
<title>Order Import SPQ Check</title>

</head>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ page language="java" import="java.io.*" %>
<%@ page contentType="text/html; charset=big5"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<% 
String uploadFlag=request.getParameter("UPLOADFLAG");
%>
<SCRIPT language=JavaScript>
function win(URL)
{
	window.opener.location.href=URL;
  	self.close();
}
function winnoclose(URLSQP,lineNo)
{
	qty = document.SPQFORM.elements["NSPQTY_"+lineNo].value;
	if ( qty =="" || qty ==null)
	{
 		alert("Please Input Order Quantity!!");   
        document.SPQFORM.elements["NSPQTY_"+lineNo].focus();  
  		return(false);	 
	}
	else
	{	    
 		//document.SPQFORM.action=URLSQP+"&LINE="+lineNo+"&NSPQTY="+qty;
		document.SPQFORM.action=URLSQP+"&LINE="+lineNo+"&NSPQTY="+qty+"&REMARKS="+document.SPQFORM.elements["REMARKS_"+lineNo].value;  //add by Peggy 20160623
 		document.SPQFORM.submit();
	}
}
</SCRIPT>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<% //TSCEBufferImportTwo.jsp?UPLOADFLAG=Y
try 
{
	String invItem         = null;
  	String itemDesc        = null;
  	String searchString    = null;
  	String SPQChecked      = "Y";
  	int    iNo             = Integer.parseInt((String)session.getAttribute("MAXLINENO"));
  	String CustomerId      = (String)session.getAttribute("CUSTOMERID");
  	String CustomerNo      = (String)session.getAttribute("CUSTOMERNO");
  	String SalesAreaNo     = (String)session.getAttribute("SALESAREANO");
  	String temp_p          = (String)session.getAttribute("CUSTOMERNAME");
  	byte[] temp_t          = temp_p.getBytes("ISO8859-1");
  	String CustomerName    = new String(temp_t);
	if (SalesAreaNo.equals("012"))
	{
		CustomerName    = (String)session.getAttribute("CUSTOMERNAME");
	}
  	String CustomerPo      = (String)session.getAttribute("CUSTOMERPO");
  	String Curr            = (String)session.getAttribute("CURR");
  	String CustActive      = (String)session.getAttribute("CUSTACTIVE");
  	String SalesPersonId   = (String)session.getAttribute("SALESPERSONID");
	if (SalesPersonId==null) SalesPersonId=""; //add by Peggy 20151223
  	String SalesPerson     = (String)session.getAttribute("SALESPERSON");
  	String Remark          = (String)session.getAttribute("REMARK");
  	String PreOrderType    = (String)session.getAttribute("PREORDERTYPE");
  	String IsModelSelected = (String)session.getAttribute("ISMODELSELECTED");
 	String CustomerIdTmp   = (String)session.getAttribute("CUSTOMERIDTMP");
  	String Insert          = (String)session.getAttribute("INSERT");
  	String sProgramName    = (String)session.getAttribute("PROGRAMNAME");
	String SHIPTO          = (String)session.getAttribute("SHIPTO");	        //add by Peggy 20160303
	if (SHIPTO==null) SHIPTO="";
	String TEMP_ID         = (String)session.getAttribute("UPLOAD_TEMP_ID");	//add by Peggy 20160303
	if (TEMP_ID==null) TEMP_ID="";
	String modelN = (String)session.getAttribute("modelN");
	String groupByType = (String)session.getAttribute("groupByType");
	if (modelN==null) modelN="";
	if (groupByType==null) groupByType="";
	String RFQTYPE         = request.getParameter("RFQTYPE");
	String SAMPLEORDER     = request.getParameter("SAMPLEORDER");   //add by Peggy 20150715
	if (SAMPLEORDER==null) SAMPLEORDER="";
	String PCODE           = request.getParameter("PCODE");
	if (PCODE==null) PCODE="";
	String SHIPTOORGID = request.getParameter("SHIPTOORGID");  //add by Peggy 20180720
	if (SHIPTOORGID==null) SHIPTOORGID=""; 
	//out.println("RFQTYPE="+RFQTYPE);
	if (RFQTYPE ==null) RFQTYPE ="FORECAST";
  	session.setAttribute("NONSPQEXIST","N");
  	String tscProdGroup="";
  	String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//���o�ثe�}�C���e
  	boolean bUpdate=false;
	String URLstr = "";
	String matched_flag =""; //add by Peggy 20130310
	//if (RFQTYPE.equals("NORMAL"))
	if (PCODE.equals("D1001"))
	{
  		URLstr = "../TSSalesDRQ_Create.jsp?"+"SPQCHECKED="+java.net.URLEncoder.encode(SPQChecked)+
		            "&CUSTOMERID="+java.net.URLEncoder.encode(CustomerId)+
					"&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
                   // "&CUSTOMERNAME="+java.net.URLEncoder.encode(CustomerName)+
					"&CUSTACTIVE="+java.net.URLEncoder.encode(CustActive)+
					"&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
					"&SALESPERSON="+java.net.URLEncoder.encode(SalesPerson)+
				    "&SALESPERSONID="+java.net.URLEncoder.encode(SalesPersonId)+
					"&CUSTOMERPO="+java.net.URLEncoder.encode(CustomerPo)+
					"&CURR="+java.net.URLEncoder.encode(Curr)+
					"&ORIGCURR="+java.net.URLEncoder.encode(Curr)+
					"&REMARK="+java.net.URLEncoder.encode(Remark)+
				    "&PREORDERTYPE="+java.net.URLEncoder.encode(PreOrderType)+
					"&ISMODELSELECTED="+java.net.URLEncoder.encode(IsModelSelected)+
					"&CUSTOMERIDTMP="+java.net.URLEncoder.encode(CustomerIdTmp)+
				    "&INSERT="+java.net.URLEncoder.encode(Insert)+
					"&PROGRAMNAME="+java.net.URLEncoder.encode(sProgramName)+
					"&RFQTYPE="+java.net.URLEncoder.encode(RFQTYPE)+
					"&RFQTYPE="+java.net.URLEncoder.encode(RFQTYPE)+
			        "&UPLOAD_TEMP_ID="+java.net.URLEncoder.encode(TEMP_ID)+
					"&SHIPTO="+java.net.URLEncoder.encode(SHIPTO)+	//add by Peggy 20160303
					"&SHIPTOORGID="+java.net.URLEncoder.encode(SHIPTOORGID)+  //add by Peggy 20180720
					"&modelN=" + modelN+
					"&groupByType=" + groupByType;
	}
	else
	{
  		URLstr = "../TSSalesDRQCreateImport.jsp?"+"SPQCHECKED="+java.net.URLEncoder.encode(SPQChecked)+
		            "&CUSTOMERID="+java.net.URLEncoder.encode(CustomerId)+
					"&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
                    "&CUSTOMERNAME="+java.net.URLEncoder.encode(CustomerName)+
					"&CUSTACTIVE="+java.net.URLEncoder.encode(CustActive)+
					"&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
					"&SALESPERSON="+java.net.URLEncoder.encode(SalesPerson)+
				    "&SALESPERSONID="+java.net.URLEncoder.encode(SalesPersonId)+
					"&CUSTOMERPO="+java.net.URLEncoder.encode(CustomerPo)+
					"&CURR="+java.net.URLEncoder.encode(Curr)+
					"&ORIGCURR="+java.net.URLEncoder.encode(Curr)+					
					"&REMARK="+java.net.URLEncoder.encode(Remark)+
				    "&PREORDERTYPE="+java.net.URLEncoder.encode(PreOrderType)+
					"&ISMODELSELECTED="+java.net.URLEncoder.encode(IsModelSelected)+
					"&CUSTOMERIDTMP="+java.net.URLEncoder.encode(CustomerIdTmp)+
				    "&INSERT="+java.net.URLEncoder.encode(Insert)+
					"&PROGRAMNAME="+java.net.URLEncoder.encode(sProgramName);
	}
  	String URLSPQChk = "TSCRFQImportSPQCheckChqQty.jsp?PCODE="+PCODE+"&RFQTYPE="+RFQTYPE+"&SAMPLEORDER="+SAMPLEORDER;
  	out.println("<FORM ACTION='TSCRFQImportSPQCheck.jsp' METHOD='post' NAME='SPQFORM'>");
  	out.println("<TABLE BORDER=1>");
  	out.println("<TR>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>No.</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>Inventory Item</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>Item Description</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>TSC_PROD_GROUP</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>Org. Order Qty.(KPC)</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>New Order Qty.(KPC)</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>SPQ(KPC)</font></TD>");
	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>MOQ(KPC)</font></TD>");
  	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>Remark</font></TD>");
  	out.println("<TD BGCOLOR=#C0C0C0><font size=1 color=#454589 face='Verdana, Arial, Helvetica, sans-serif'>Change Button</font></TD>");
	out.println("</TR>");

  	for( int i=0 ; i< q.length ; i++ ) 
	{
    	if (q[i][0] != null) 
		{
      		try 
			{   
        		int queryCount = 0, querySPQCount = 0;

        		if (q[i][1]!=null && !q[i][1].equals("")) 
				{ 
	      			searchString= q[i][1].toUpperCase();
				}
	    		else if (q[i][2] != null && !q[i][2].equals("")) 
				{  
	      			searchString = q[i][2].toUpperCase();
				}

       			String sqlCNT = "select count(a.SEGMENT1) from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b, APPS.MTL_ITEM_CATEGORIES_V c ";
	    		String sql = "select a.SEGMENT1, a.DESCRIPTION, b.SEGMENT1 as TSC_PACKAGE, c.SEGMENT1 AS TSC_FAMILY "+
                             "       ,decode(TSC_OM_CATEGORY(A.INVENTORY_ITEM_ID,A.ORGANIZATION_ID,'TSC_PROD_GROUP'),null,'&nbsp;',TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_PROD_GROUP')) as TSC_PROD_GROUP  "+	
							 "       ,TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_PROD_FAMILY') as TSC_PROD_FAMILY "+ //add by Peggy 20151122
							 ", tsc_get_item_packing_code(A.ORGANIZATION_ID ,A.INVENTORY_ITEM_ID) tsc_packing_code"+ //add by Peggy 20150715
							 ", a.INVENTORY_ITEM_ID"+
	                         "  from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b, APPS.MTL_ITEM_CATEGORIES_V c ";
	    		String where="where a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
                             "  and a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
	                         "  and b.CATEGORY_SET_ID = 23 "+
		                     "  and a.ORGANIZATION_ID = c.ORGANIZATION_ID "+
		                     "  and a.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
		                     "  and c.CATEGORY_SET_ID = 21 "+
		                     "  and a.ORGANIZATION_ID = '49' "+
		                     "  and a.DESCRIPTION not like '%Disable%' "; //// �� TSC_Package �� TSC_Family ������, �B���]�t�w�Q�]�w�� Disable���ƶ�
	    		where = where + "and (a.SEGMENT1 like '"+searchString.toUpperCase()+"' or DESCRIPTION like '"+searchString.toUpperCase()+"%') ";
	    		Statement stateCNT=con.createStatement();
	    		sqlCNT=sqlCNT+where;
	    		ResultSet rsCNT = stateCNT.executeQuery(sqlCNT);
	    		if (rsCNT.next()) queryCount = rsCNT.getInt(1);
        		rsCNT.close();
	    		stateCNT.close();
				if (queryCount==0) 
				{ 
					//add by Peggy 20130225,I1 read����,�Aread IM
					where =" where a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
						   "  and a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
						   "  and b.CATEGORY_SET_ID = 23 "+
						   "  and a.ORGANIZATION_ID = c.ORGANIZATION_ID "+
						   "  and a.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
						   "  and c.CATEGORY_SET_ID = 21 "+
						   "  and a.ORGANIZATION_ID = '43' "+
						   "  and a.DESCRIPTION not like '%Disable%' "+
						   "  and (a.SEGMENT1 like '"+searchString.toUpperCase()+"' or DESCRIPTION like '"+searchString.toUpperCase()+"%') ";
					Statement stateCNT1=con.createStatement();
					sqlCNT=sqlCNT+where;
					ResultSet rsCNT1 = stateCNT1.executeQuery(sqlCNT);
					if (rsCNT1.next()) queryCount = rsCNT1.getInt(1);
					rsCNT1.close();
					stateCNT1.close();

					if (queryCount==0) 
					{ 
						//�Y���쪺�d�߼� == 0 ,�Y�䤣��b��,�h�i��O�L�]�w��]��Category��(��s���L�]�˲��~),����,�N�ˮ֮ƥ�D�ɧY�i
						sql = "select a.SEGMENT1, a.DESCRIPTION, 'NO PACKAGE' as TSC_PACKAGE, 'NO FAMILY' as TSC_FAMILY ,'NO PROD GROUP' as TSC_PROD_GROUP,'NO PACKING CODE' AS tsc_packing_code,'NO PROD FAMILY' as TSC_PROD_FAMILY"+
						      ",a.INVENTORY_ITEM_ID"+
							  "  from APPS.MTL_SYSTEM_ITEMS a ";
						where=" where a.ORGANIZATION_ID = '49' and a.DESCRIPTION not like '%Disable%' and a.DESCRIPTION not like '%disable%' ";
						where = where + "and (a.SEGMENT1 like '"+searchString.toUpperCase()+"' or DESCRIPTION like '"+searchString.toUpperCase()+"%') ";		   
					}
        		} // End of if (queryCount==0)

	    		sql = sql + where;
				//out.println(sql);
        		Statement statement=con.createStatement();
        		ResultSet rs=statement.executeQuery(sql);
        		ResultSetMetaData md=rs.getMetaData();
        		int colCount=md.getColumnCount();
        		String colLabel[]=new String[colCount+1];        

        		for (int k=1;k<=colCount;k++) 
				{
          			colLabel[k]=md.getColumnLabel(k);
       			} //end of for 
	
        		String tscPacking=null,tscFamily=null,tscProdFamily="";
       		 	String sPQP[] =new String[iNo];
        		String sMOP[] =new String[iNo];
        		String buttonContent=null;
		
        		while (rs.next()) 
				{
		  			invItem=rs.getString("SEGMENT1");
		  			itemDesc=rs.getString("DESCRIPTION");
		  			tscPacking=rs.getString("TSC_PACKAGE");	
		  			tscFamily=rs.getString("TSC_FAMILY");	
	      			tscProdGroup=rs.getString("TSC_PROD_GROUP");
					String packMethodCode =rs.getString("tsc_packing_code"); //modify by Peggy 20150715
					tscProdFamily=rs.getString("TSC_PROD_FAMILY"); //add by Peggy 20151122
					if (!tscProdGroup.equals("PMD") && !tscProdGroup.equals("SSP") && !tscProdGroup.equals("SSD"))
					{
						tscProdFamily="XX";		
					}			
		  			//String packMethodCode = invItem.substring(8,10);   
		  			//if (tscProdGroup.equals("PMD")) 
					//{
		    		//	if (invItem.substring(3,4).equals("G"))  
			  		//	packMethodCode = packMethodCode + "G";
		  			//} 
					//else 
					//{
		    		//	if (invItem.substring(10,11).equals("1")) 
			  		//	packMethodCode = packMethodCode + "G";
		  			//}
			  		String sqlSPQ= "";
		  			if (CustomerId.equals("1220")) 
					{
            			//sqlSPQ = "  SELECT SPQ/1000 as SPQ,MOQ /1000 as MOQ,(CASE WHEN x.MOQ >0 THEN CASE WHEN x.QUANTITY <= x.MOQ THEN x.MOQ ELSE CEIL(x.QUANTITY/x.SPQ)*x.SPQ END ELSE x.QUANTITY END)/1000 AS RFQ_QTY"+
						//         " from (select (MOQ / 1000) SPQ"+
						//        ",(MOQ / 1000) MOQ "+
						//		 ",("+q[i][3]+"*1000) QUANTITY"+						
						//         " from ORADDMAN.TSITEM_PACKING_CATE a "+
		    		 	//		 " where a.INT_TYPE = 'FSC' "+
					    //         " and a.TSC_OUTLINE = '"+tscPacking+"' "+
					    //         " and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b "+
					   	//						" where b.INT_TYPE = a.INT_TYPE "+
						//						  " and b.TSC_OUTLINE = a.TSC_OUTLINE) "+
						//		 ") x";	
						sqlSPQ = "  SELECT SPQ/1000 as SPQ,MOQ /1000 as MOQ,(CASE WHEN x.MOQ >0 THEN CASE WHEN x.QUANTITY <= x.MOQ THEN x.MOQ ELSE CEIL(x.QUANTITY/x.SPQ)*x.SPQ END ELSE x.QUANTITY END)/1000 AS RFQ_QTY"+
						         " from (SELECT  MOQ as SPQ, MOQ ,("+q[i][3]+"*1000) QUANTITY from table(TSC_GET_ITEM_SPQ_MOQ("+rs.getString("inventory_item_id")+",'FSC',NULL))) x";										 											  
		  			} 
					else 
					{
						sqlSPQ = " SELECT SPQ/1000 as SPQ,MOQ /1000 as MOQ,(CASE WHEN case when upper('"+SAMPLEORDER+"')='TRUE' then x.SPQ else x.MOQ end >0 THEN CASE WHEN x.QUANTITY <= case when upper('"+SAMPLEORDER+"')='TRUE' then x.SPQ else x.MOQ end THEN case when upper('"+SAMPLEORDER+"')='TRUE' then x.SPQ else x.MOQ end ELSE CEIL(x.QUANTITY/x.SPQ)*x.SPQ END ELSE x.QUANTITY END)/1000 AS RFQ_QTY"+
						         " from (SELECT  case when upper('"+SAMPLEORDER+"')='TRUE' THEN SAMPLE_SPQ ELSE SPQ END as SPQ"+
								 //" , case when upper('"+SAMPLEORDER+"')='TRUE' THEN SAMPLE_SPQ ELSE MOQ END as MOQ"+
								 " ,MOQ"+ //modify by Peggy 20210108
								 " ,("+q[i][3]+"*1000) QUANTITY from table(TSC_GET_ITEM_SPQ_MOQ("+rs.getString("inventory_item_id")+",'TS',null))) x";
            			//sqlSPQ = " SELECT SPQ/1000 as SPQ,MOQ /1000 as MOQ,(CASE WHEN x.MOQ >0 THEN CASE WHEN x.QUANTITY <= x.MOQ THEN x.MOQ ELSE CEIL(x.QUANTITY/x.SPQ)*x.SPQ END ELSE x.QUANTITY END)/1000 AS RFQ_QTY"+
						//        " FROM (select (case when upper('"+SAMPLEORDER+"')='TRUE' THEN SAMPLE_SPQ ELSE SPQ END) AS SPQ"+
						//        ",(case when upper('"+SAMPLEORDER+"')='TRUE' THEN SAMPLE_SPQ ELSE MOQ END) AS MOQ"+
						//		",("+q[i][3]+"*1000) QUANTITY"+
						//		" from ORADDMAN.TSITEM_PACKING_CATE a "+
		             	//		" where a.INT_TYPE in ('TS','NBU') "+
					   	//		" and a.TSC_OUTLINE = '"+tscPacking+"' "+
					   	//		" and a.PACKAGE_CODE = '"+packMethodCode+"' "+
					   	//		" and a.TSC_FAMILY = '"+tscFamily+"' "+
						//		" and nvl(a.TSC_PROD_FAMILY,'XX')='"+tscProdFamily+"'"+
					   	//		" and a.CREATION_DATE = (select MAX(CREATION_DATE) from ORADDMAN.TSITEM_PACKING_CATE b " +
					    //                       " where b.INT_TYPE = a.INT_TYPE "+
						//					     " and b.TSC_OUTLINE = a.TSC_OUTLINE "+        
						//					     " and b.PACKAGE_CODE = a.PACKAGE_CODE "+
						//					     " and b.TSC_FAMILY = a.TSC_FAMILY "+
						//					     " and NVL(b.TSC_PROD_FAMILY,'XX') = NVL(a.TSC_PROD_FAMILY,'XX') "+
						//					     " and b.TSC_PROD_GROUP = a.TSC_PROD_GROUP) ";
            			//if (tscProdGroup.equals("Rect-Subcon") || tscProdGroup.equals("Rect") || tscProdGroup.equals("SSP")) 
						//{
              			//	sqlSPQ+= " and a.TSC_PROD_GROUP = '"+tscProdGroup+"' ";
						//}
						//sqlSPQ +=") x";
		  			}
					//out.println(sqlSPQ);
		  			Statement stateSPQP=con.createStatement();
		  			ResultSet rsSPQP=stateSPQP.executeQuery(sqlSPQ); 														

		  			if (rsSPQP.next()) 
					{
		    			sPQP[i] = rsSPQP.getString("SPQ");
		    			sMOP[i] = rsSPQP.getString("MOQ");
						matched_flag = "Y";
		    			//double baseK = rsSPQP.getDouble("SPQ")*1000;
						if (rsSPQP.getDouble("RFQ_QTY")!=Double.valueOf(q[i][3]).doubleValue())
						{
							matched_flag = "N"; 
						}
            			out.println("<TR  BGCOLOR='#F0F0F0' style='color=#454589;font-size:11px;font-family: Tahoma,Georgia'><TD>"+q[i][0]+"</TD>");
						out.println("<TD>"+q[i][1]+"</TD>");
						out.println("<TD>"+q[i][2]+"</TD>");
						out.println("<TD>"+tscProdGroup+"</TD>");
						out.println("<TD>"+q[i][3]+"</TD>");
                   
            			//double base=Double.parseDouble(sPQP[i]);				  
                  
            			//if ((Double.parseDouble(q[i][3])*1000)%baseK!=0) 
						//if ((double)(Math.round((Double.parseDouble(q[i][3])*1000)*100000)/100000)%baseK !=0)   //modify by Peggy 20120504
						//if ((double)(Math.round((Double.parseDouble(q[i][3])*1000)*100000)/100000)%baseK !=0 || ( Double.parseDouble(q[i][3]) < Double.parseDouble(sMOP[i])))  //�W�[MOQ�ˬd,modify by Peggy 20130201
						//{
						if (matched_flag.equals("N"))
						{ 
	          				out.println("<TD><INPUT TYPE='TEXT'  NAME='NSPQTY_"+i+"' SIZE='8' value='"+rsSPQP.getString("RFQ_QTY")+"' style='font-size:11px;font-family: Tahoma,Georgia'></TD>");
              				//out.println("<INPUT TYPE='HIDDEN' NAME='NSPQTYLOOP' value='"+i+"' >");
              				session.setAttribute("NONSPQEXIST","Y");
	        			} 
						else 
						{
              				out.println("<TD>MATCHED</TD>");
            			}
            			out.println("<TD>"+sPQP[i]+"</TD>");
            			out.println("<TD>"+sMOP[i]+"</TD>");
						if (matched_flag.equals("N")) //add by Peggy 20140310
						{
	          				//out.println("<TD><INPUT TYPE='TEXT'  NAME='REMARKS' SIZE='10'></TD>");
							out.println("<TD><INPUT TYPE='TEXT'  NAME='REMARKS_"+i+"' SIZE='13' value='�Ȥ�ݨD"+(new DecimalFormat("######.###")).format(Double.valueOf(q[i][3]).doubleValue())+"K' style='font-size:11px;font-family: Tahoma,Georgia'></TD>");  //�۰ʼg�J�Ƶ�
              				out.println("<TD><INPUT TYPE=BUTTON value='Change Qty' onClick='winnoclose(\""+URLSPQChk+"\","+i+");' style='font-size:11px;font-family: Tahoma,Georgia'></TD>");
							out.println("</tr>");
							
						}
						else
						{
            				out.println("<TD>"+q[i][9]+"</TD>");
            				out.println("<TD>&nbsp;</TD>");
							out.println("</tr>");
						}
            			//if ((Double.parseDouble(q[i][3])*1000)%baseK!=0) 
						//if ((double)(Math.round((Double.parseDouble(q[i][3])*1000)*100000)/100000)%baseK !=0)  //modify by Peggy 20120504            			
						//if ((double)(Math.round((Double.parseDouble(q[i][3])*1000)*100000)/100000)%baseK !=0 || ( Double.parseDouble(q[i][3]) < Double.parseDouble(sMOP[i])))  //�W�[MOQ�ˬd,modify by Peggy 20130201
		  			} 
					else 
					{ 
            			sPQP[i] = "0"; 
            			sMOP[i] = "0";
            			out.println("<TR BGCOLOR='#F0F0F0' style='color=#454589;font-size:11px;font-family: Tahoma,Georgia'>");
						out.println("<TD>"+q[i][0]+"</TD>");
						out.println("<TD>"+q[i][1]+"</TD>");
						out.println("<TD>"+q[i][2]+"</TD>");
						out.println("<TD>"+tscProdGroup+"</TD>");
						out.println("<TD>"+q[i][3]+"</TD>");
            			out.println("<TD>NO CONTROLED</TD>");
            			out.println("<TD>"+sPQP[i]+"</TD>");
            			out.println("<TD>"+sMOP[i]+"</TD>");
           	 			out.println("<TD>&nbsp;</TD>");
           	 			out.println("<TD>&nbsp;</TD>");
						out.println("</TR>");
          			} // �䤣��h�]�wmOQP = 0
		  			rsSPQP.close();
		  			stateSPQP.close();
 	    		}//end of while

        		rs.close();
	    		statement.close();

        		// 20110309 Marvie Add : update spq moq
        		if (q[i][11]!=sPQP[i] || q[i][12]!=sMOP[i]) 
				{
		  			q[i][11] = sPQP[i];
		  			q[i][12] = sMOP[i];
		  			bUpdate = true;
				}
      		} //end of try
      		catch (Exception e) 
			{
        		out.println("Exception:"+e.getMessage());
      		}   
    	}
  	}
  	if (bUpdate==true) 
	{
    	arrayRFQDocumentInputBean.setArray2DString(q);
  	}
  	out.println("</TABLE>");	
  	out.println("</FORM>");	    		    		  	   		   				   

    String NonSPQExist      = (String)session.getAttribute("NONSPQEXIST");
	if (NonSPQExist.equals("N"))
	{
		out.println("<INPUT TYPE='button' tabindex='25' value='SPQ Checked' onClick='win(\""+URLstr+"\");'>");
	//}
	//else
	//{
	//	out.println("<INPUT TYPE='button' tabindex='25' value='Change Qty' onClick='win(\""+URLSPQChk+"\");'>");
	}
	out.println("<input type='hidden' name='RFQTYPE' value='"+RFQTYPE+"'>"); //add by Peggy 20120327
}
catch(Exception e)
{
	out.println("Error:"+e.getMessage());
}
%>
<!--=============Release Database Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
