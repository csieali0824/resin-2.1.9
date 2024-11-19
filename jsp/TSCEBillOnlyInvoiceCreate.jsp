<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSCE BillOnly Invoice Creation</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<STYLE TYPE='text/css'>  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL,ms1)
{
	if (document.MYFORM.INVNO.value==null || document.MYFORM.MONO.value==null || document.MYFORM.INVNO.value=="" || document.MYFORM.MONO.value=="")
  	{
    	alert("發票號或銷售訂單號不得為空值,請再確認!!!");
  	} 
	else 
	{
		flag=confirm(ms1);      
        if (flag==false) return(false);
	    else
        {   // 若確認送出再檢查
			document.MYFORM.action=URL;
            document.MYFORM.submit();
			return (true);
		}
	}
}
</script>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<BR>
<div align="center"><font color="#003399" size="4">1151 Bill Only Invoice Create</font></div>
<form name="MYFORM" method="post" action="../jsp/TSCEBillOnlyInvoiceInsert.jsp">
<%
  String invoiceNo=request.getParameter("INVNO");
  if (invoiceNo==null) invoiceNo="";  //add by Peggy 20140808
  invoiceNo=invoiceNo.trim(); 
  String salesMONo=request.getParameter("MONO");
  String taxCode=request.getParameter("TAX_CODE");
  String currCode=request.getParameter("CURR_CODE");
  
  if (invoiceNo==null || invoiceNo.equals("")) invoiceNo="";
  if (salesMONo==null || salesMONo.equals("")) salesMONo="";

	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
	cs1.execute();
	cs1.close();
	
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="50%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99">
	 <td width="18%" nowrap><font color="#000066">Invoice No.</font></td> 
	 <td width="82%" nowrap><font color="#000066">
      <input type="text" name="INVNO" value="<%=invoiceNo%>"></font></td> 
	</tr>
	<tr bgcolor="#CCCC99">
	 <td width="18%" nowrap><font color="#000066">Sales Order No.</font></td> 
	 <td width="82%" nowrap><font color="#000066">
      <input type="text" name="MONO" value="<%=salesMONo%>"></font></td> 
	</tr>
	<tr bgcolor="#CCCC99">
	 <td width="18%" nowrap><font color="#000066">Tax Code</font></td> 
	 <td width="82%" nowrap><font color="#000066">
	    <%
		         try
                 {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       //String sqlTypeItem = "select DISTINCT TAX_CODE, TAX_CODE  "+
			       //                     "  from TSC_INVOICE_HEADERS ";
			       //String whereTypeItem = "where TAX_CODE is NOT NULL  ";								  
				   //String orderTypeItem = "order by 1 ";        
				  			   
				   //sqlTypeItem = sqlTypeItem + whereTypeItem+orderTypeItem;
				   //String sqlTypeItem = " select distinct tcc.tax_classification_code TAX_CODE, NVL (rvl.tax_rate_name, lkp.lookup_code) tax_code_name"+
				   String sqlTypeItem = " select distinct tcc.tax_classification_code TAX_CODE, tcc.tax_classification_code"+
                                 " from zx_id_tcc_mapping_all tcc,(select * from ZX_RATES_TL where LANGUAGE='US') rvl, "+
                                 " (select lookup_code,  enabled_flag, start_date_active, end_date_active,"+
                                 " lookup_type, leaf_node  from fnd_lookup_values lkp  where   lkp.view_application_id = 0"+
                                 " AND security_group_id = 0  AND LANGUAGE ='US'  AND lookup_type = 'ZX_OUTPUT_CLASSIFICATIONS') lkp"+
                                 " where tcc.org_id=41    "+
								 " and (tcc.tax_class='OUTPUT' or tcc.tax_class IS NULL)"+
                                 " and tcc.tax_classification_code = lkp.lookup_code(+)"+
                                 " AND tcc.tax_rate_code_id = rvl.tax_rate_id(+)"+
                                 " and NVL (tcc.effective_to,TO_DATE ('31/12/4712', 'DD/MM/YYYY')) - sysdate > 0"+
								 " and tcc.TAX_CLASS='OUTPUT'"+ //add by Peggy 20161124
								 " order by tcc.tax_classification_code desc";
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlTypeItem);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(taxCode);
	               comboBoxBean.setFieldName("TAX_CODE");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rs.close();   
					statement.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		  %>
	 </font></td> 	 
	</tr>
	<tr bgcolor="#CCCC99">
	 <td width="18%" nowrap><font color="#000066">Currency</font></td> 
	 <td width="82%" nowrap><font color="#000066">
	    <%
		         try
                 {   
		           Statement stateCurr=con.createStatement();
                   ResultSet rsCurr=null;	
			       String sqlCurrItem = "select DISTINCT CURRENCY_CODE, CURRENCY_CODE  "+
			                            "  from qp_list_headers_b ";
			       String whereCurrItem = "where CURRENCY_CODE > '0'  and orig_org_id=41  ";								  
				   String orderCurrItem = "order by 1 ";        
				 
				  			   
				   sqlCurrItem = sqlCurrItem + whereCurrItem+orderCurrItem;
				   //out.println(sqlCurrItem);
                   rsCurr=stateCurr.executeQuery(sqlCurrItem);
		           comboBoxBean.setRs(rsCurr);
		           comboBoxBean.setSelection(currCode);
	               comboBoxBean.setFieldName("CURR_CODE");	   
                   out.println(comboBoxBean.getRsString());
				   	  		  
		            rsCurr.close();   
					stateCurr.close();     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		  %>
	 </font></td> 	 
	</tr>
	<tr bgcolor="#CCCC99">
	 <td width="18%" colspan="2"><font color="#000066"><div align="center"><input type="button" name="Submit" value="Submit" onClick='setSubmit("../jsp/TSCEBillOnlyInvoiceInsert.jsp","確認新增BillOnly發票嗎?")'></div></font></td> 	 
	</tr>
</table>	
<%
  String documentID = request.getParameter("DOCUMENTID");
  
  //out.println("documentID="+documentID);
   
  String getActHistory = "";
  String getDocumentType = "POAPPRV";
           try
		   {	/*
		                  java.sql.Date commentDate = null; 
						  
		                  CallableStatement cs5 = con.prepareCall("{call PO_WF_PO_NOTIFICATION.get_action_history(?,?,?,?)}");	
						  cs5.setString(1,documentID);      // documentID 						     
					      cs5.setString(2,"text/html"); 
						  cs5.setString(3, documentID);    
						  cs5.setString(4, "PO");  
						              // disptype 
						  cs5.registerOutParameter(3, Types.VARCHAR);    //  傳回值 document 	
						  cs5.registerOutParameter(4, Types.VARCHAR);    //  傳回值 document_type                   // document_type 						  				 					      						   	 					     
					      cs5.execute();					      
					      getActHistory = cs5.getString(3);					
						  getDocumentType = cs5.getString(4);	
					      //out.println(" <a href="+getOEOLURL+">"+getOEOLURL+"</a>");   					    
					      cs5.close();
				*/
           }	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
  //out.println(getActHistory);
  
%>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
