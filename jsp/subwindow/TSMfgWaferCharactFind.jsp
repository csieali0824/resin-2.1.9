<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/> 
<jsp:useBean id="arrayWODocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<%

 String woType=request.getParameter("WOTYPE"); 
 String marketType=request.getParameter("MARTETTYPE"); 
 String organizationId = request.getParameter("ORGANIZATIONID");
 String invItem=request.getParameter("INVITEM"); 
 String itemDesc=request.getParameter("ITEMDESC");
 String waferResist=request.getParameter("WFRESIST"); 
 String diceSize=request.getParameter("DICESIZE");
 String waferLot=request.getParameter("WAFERLOT"); 
 String supplierLot=request.getParameter("SUPPLIERLOT");
 String searchString=request.getParameter("SEARCHSTRING");
 String waferVendor=null,waferQty=null,waferUom=null,waferIqcNo=null,waferYld=null,waferKind=null,waferElect=null ;
 String woUom=null,itemId=null ,woWaferIqcNo=null,woWaferQty=null,waferLineNo=null,waferAmp=null;
 String defaultWoQty=null,frontRunCard=null,cutterRCNo=null;
 String result=null;
 float avaibleQty=0;
 
 float accWoQty = 0;
 float leftAddQty = 0;
 String IQC_GRAINQTY=null;
 if (supplierLot==null || supplierLot.equals("") || supplierLot.equals("undefined")) supplierLot = "";
 
   String orgID = "";
   Statement stateID=con.createStatement();   
   ResultSet rsID=stateID.executeQuery("select ORGANIZATION_ID from YEW_MFG_DEFDATA where DEF_TYPE ='MARKETTYPE' and  CODE= '"+marketType+"' ");
   if (rsID.next())
   {
     organizationId = rsID.getString(1);
   }
   rsID.close();
   stateID.close();

//�P�_��lot �O�_�����}_____start  //20091205 liling add
     String iqcRemark="";
     String sqliqc=" SELECT INSPECT_REMARK  FROM ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD "+
			   // "  WHERE TLD.ORGANIZATION_ID = '"+organizationId+"' AND TLD.SUPPLIER_LOT_NO= '"+supplierLot+"'  ";
			    "  WHERE TLD.ORGANIZATION_ID = '"+organizationId+"' AND TLD.SUPPLIER_LOT_NO= '"+supplierLot+"' and  INSPECT_REMARK is not null ";	//20111223 LILING			
	 Statement stateLot=con.createStatement();
	 ResultSet rsLot=stateLot.executeQuery(sqliqc);
	 if (rsLot.next())
	  {  
		iqcRemark  = rsLot.getString("INSPECT_REMARK");
        if ( iqcRemark == "N/A" || iqcRemark.equals("N/A"))
         { }
        else{
          %>
           <input type="hidden" name="IQCREMARK" value="<%=iqcRemark%>">
		    <script language="javascript">
			    alert("�Ъ`�N����IQC�Ƶ����}");
			 </script>
         <% }
	  }
	  rsLot.close();
 	  stateLot.close();						 
//�P�_��lot �O�_�����}_____start   
		
	  //add by Peggy 20170612
	  sqliqc=" select distinct WAIVE_REMARK from oraddman.tsciqc_lotinspect_history a where a.WAIVE_REMARK is not null and a.WAIVE_REMARK <>'N/A' and exists (select 1 from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD where tld.INSPLOT_NO=a.INSPLOT_NO and tld.line_no=a.line_no and  TLD.ORGANIZATION_ID = '"+organizationId+"' AND TLD.SUPPLIER_LOT_NO= '"+supplierLot+"')";
	  stateLot=con.createStatement();
	  rsLot=stateLot.executeQuery(sqliqc);
	  if (rsLot.next())
	  {
	  	iqcRemark += (iqcRemark.length()>0?",":"")+rsLot.getString("WAIVE_REMARK");	   		
	  }
	  rsLot.close();
 	  stateLot.close();	
	  
 if (woType==null || woType.equals("")) woType="1";
 
 String q[][]=arrayWODocumentInputBean.getArray2DContent();//���o�ثe�}�C���e	
 
 String runCardDesc = null; // ItemDesc
 String runCardGet = "";  // itemCodeGet
 int runCardGetLength = 0;   // itemCodeGetLength

     if (q!=null) 
	 {	// �Ѱ}�C���e�@���U�@�������J���󪺨̾�		   
      //out.println(shpArray2DPageBean.getArray2DTempString());
	   out.println(arrayWODocumentInputBean.getArray2DString());
	   if (q.length>0)
	   {
	      for (int i=0;i<q.length;i++)
	      {
		     out.println(q[i][18]+"<BR>");
			 runCardDesc = q[i][18];
			 runCardGet = runCardGet+"'"+runCardDesc+"'"+",";
			 
			 if (q[i][3]!=null && !q[i][3].equals(""))
			 { 			   
			   accWoQty = accWoQty + Float.parseFloat(q[i][3]);  // �֥[���e��w�ƶq		
			 } else {
			          q[i][3] = "0";
					  accWoQty = accWoQty + Float.parseFloat(q[i][3]);  // �֥[���e��w�ƶq
			        }
			 
		  }
		  out.println(accWoQty); 
			
		    // ���onot in ����_�_
		    if (runCardGet.length()>0)
            {   out.println(runCardGet);     
             runCardGetLength = runCardGet.length()-1;
             runCardGet = runCardGet.substring(0,runCardGetLength); 
            } 
		    // ���onot in ����_��
	   }
     } else {
	          //out.println("No get!");
	         }
  //out.println("supplierLot="+supplierLot);
 try
 {
  if (searchString==null)
   {
    if (waferResist!=null && !waferResist.equals(""))
	{ searchString= waferResist.toUpperCase(); }	
    else { searchString="%"; //out.println("NULL input");
	%>
	      <script LANGUAGE="JavaScript"> 
          <!-- 
		    //alert("test");           
            flag=confirm("This query could take a long time. Do you wish to continue?");
            if (flag==false)  { this.window.close(); } //alert("test");}//
            //else  return(false);           
          // --> 
          </script> 
	<%   }
   
   } //end if
 }
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
 
 //out.println("supplierLot="+supplierLot);
%>
<html>
<head>
<title>Page for choose IQC Wafer Lot List</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
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
.style1 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
}
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
//function sendToMainWindow(waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind)
function sendToMainWindow(jNo,waferLot,invItem,itemDesc,waferVendor,waferQty,waferUom,waferYld,waferElect,waferIqcNo,waferKind,itemId,woUom,waferLineNo,defaultWoQty,woType,frontRunCard,chkCutAsbFlag,chkSubAsbFlag,waferAmp)
{ 

           window.opener.document.MYFORM.WAFERLOT.value=waferLot;            
           window.opener.document.MYFORM.WAFERVENDOR.value=waferVendor; 
           window.opener.document.MYFORM.WAFERQTY.value=waferQty; 
           window.opener.document.MYFORM.WAFERUOM.value=waferUom;
           window.opener.document.MYFORM.WAFERYLD.value=waferYld; 
           window.opener.document.MYFORM.WAFERELECT.value=waferElect;  
           window.opener.document.MYFORM.WAFERIQCNO.value=waferIqcNo;
           window.opener.document.MYFORM.WAFERKIND.value=waferKind;            
           window.opener.document.MYFORM.WOUOM.value=woUom;  
           window.opener.document.MYFORM.WAFERLINENO.value=waferLineNo; 
		   window.opener.document.MYFORM.WOQTY.value=defaultWoQty;
		   window.opener.document.MYFORM.TSCAMP.value=waferAmp;
		   if (woType=="1")
		   {
		      if (chkCutAsbFlag=="N")
			  {
			    alert("�䤣����δ������������ɻs���~��\n �Ь����H����Oracle�]�w��BOM��!!!");
				return false;
			  } else {
			            window.opener.document.MYFORM.ITEMID.value=itemId; 
			            window.opener.document.MYFORM.INVITEM.value=invItem; 
                        window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
			          }
		   }
		   else if (woType=="2")
		        { 
				   // �Y�O�e�q�u�O,�A�N���������Τu�O���a�^
		           if (frontRunCard==null || frontRunCard=="null") frontRunCard="";
		           window.opener.document.MYFORM.FRONTRUNCARD.value=frontRunCard;
				   				
				   if (chkSubAsbFlag=="N")
			       {
			         alert("�䤣����δ����������e�q�b���~��\n �Ь����H����Oracle�]�w��BOM��!!!");
					 return false;
			       } else {
			                window.opener.document.MYFORM.ITEMID.value=itemId; 
			                window.opener.document.MYFORM.INVITEM.value=invItem; 
                            window.opener.document.MYFORM.ITEMDESC.value=itemDesc;
			               }
				   
		        }
           //alert(waferLineNo);
		  
           this.window.close();
	// }  End of ���i���X
}

</script>
<body > 
<FORM METHOD="post" ACTION="TSMfgWaferCharactFind.jsp">
  <font size="-1" color="#000099">�Ͳ����ȩδ��ɤؤo:</font> 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="�d��"><BR>  
  <a href="TSMfgIQCLotImplBOMList.jsp?LOT=<%=supplierLot%>&ORGANIZATIONID=<%=organizationId%>" onMouseOver='this.T_WIDTH=120;this.T_OPACITY=80;return escape("��J�帹:<%=supplierLot%>�d�ߥi�I���˵�BOM���T")'>�帹���BOM���T</a><BR>
  <font size="-1" color="#000099">-----Wafer Inspection Lot Find-------------------------------------------</font>     
  <BR>
  <% 

    if (woType.equals("2")) // �e�q�u�O�ӷ��Ѥ��Τu�O
    {
  %>
  <span class="style1">�}�߫e�q�u�O��IQC�����</span><BR>
  <%  
    } 
      if(iqcRemark=="N/A" || iqcRemark.equals("N/A")) {} else {out.print("      <span class=style1>IQC���}��]: "+iqcRemark+"</span>");}  //20091205 liling add
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	
	      String sqlCNT = "";
		  String sql = "";
		  String where= "";
		  String order = "";
		  String sqlOld = "";
		  String whereOld = "";
	      if (woType.equals("1")) // ���Τu�O
		  {
		     //  **** 2006/12/30 ���N�Ȯɬd���ɼg�J

	             sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY ICQ���Ƽƶq,IQCD.GRAINQTY, IQCD.INV_ITEM, IQCD.INV_ITEM_ID, REPLACE(IQCD.INV_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC,IQCH.INSPLOT_NO as WAFERIQCNO , "+
		                     "           IQCH.SUPPLIER_SITE_NAME,decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME,IQCH.WF_RESIST , "+
	   				         "           IQCD.UOM, IQCD.INV_ITEM_ID,IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                         " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, "+
			                 "      ORADDMAN.TSCIQC_WAFER_TYPE IQCWT ";
	      	     where=" where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                      "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 �[�J�w�g�禬�J�w�θg�S�ĤJ�w�������							  
							  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "+ // Clone ��PO�観�s�b
							  "   and IQCD.ORGANIZATION_ID = '"+organizationId+"' ";
		         order = "order by IQCD.INV_ITEM, INSPECT_DATE, WAFERLOT ";		
		         if (runCardGet!=null && !runCardGet.equals(""))	 where = where + " and IQCD.SUPPLIER_LOT_NO not in ("+runCardGet+") "; // ���e�w�b�M�椺��WaferLot���o�X�{ 
		
		         if (invItem!=null && !invItem.equals("")) where = where + " and ( IQCD.INV_ITEM = '"+invItem+"' or IQCD.INV_ITEM like '%"+invItem+"%' ) ";

		         if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--")) where = where + "and ( IQCH.WF_RESIST = '"+waferResist+"' or IQCH.WF_RESIST like '%"+waferResist+"%' )   ";
		         if (diceSize!=null && !diceSize.equals("")  && !diceSize.equals("--")) where = where + "and ( IQCD.DICE_SIZE= '"+diceSize+"' and IQCD.DICE_SIZE like '%"+diceSize+"%' ) ";
				 
				 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) where = where + "and ( IQCD.SUPPLIER_LOT_NO= '"+supplierLot+"' or IQCD.SUPPLIER_LOT_NO like '%"+supplierLot+"%' ) ";
		

		         // �ݭn�אּ���S�w���� SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		         if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		         {  
		           where = where + " and (IQCD.SUPPLIER_LOT_NO like '%') ";
		         }
		         else 
		            { 
		              where = where + "  and ( upper(IQCD.INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                  "         OR upper(IQCD.INV_ITEM_DESC) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM_DESC) like '"+searchString.toUpperCase()+"%' "+									  
									  "         OR upper(IQCD.SUPPLIER_LOT_NO) = '"+searchString.toUpperCase()+"' or upper(IQCD.SUPPLIER_LOT_NO) like '"+searchString.toUpperCase()+"%' ) ";
	                } 		  
					
				     sql = sql + where + order;	
					 //out.println(sql); 
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sql);				   
				     while (rsPrev.next())
					 {			
					     // �� Item Where Use�� Procedure_�_
				         String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
			  
			             CallableStatement csBOMInfo = con.prepareCall("{call TSC_BOM_IMPLODER_PARENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	                     csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			             csBOMInfo.setString(2,woType);
	                     csBOMInfo.setInt(3,rsPrev.getInt("INV_ITEM_ID")); 
	                     csBOMInfo.setString(4,prevSubItem);                 // ��l���Ƹ��e�T�X( �P�w 11-, 10- �� 1A- )
	                     csBOMInfo.registerOutParameter(5, Types.INTEGER);   // �^�� Parent Item ID
	                     csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // �^�� Parent Inv Item
	                     csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // �^�� Parent Item Desc
	                     csBOMInfo.registerOutParameter(8, Types.VARCHAR);   // �^�� Error Message
	                     csBOMInfo.registerOutParameter(9, Types.VARCHAR);   // �^�� Error Code
				         csBOMInfo.registerOutParameter(10, Types.INTEGER);  // �^�� ���� SEQUENCE ID
				         csBOMInfo.setString(11,"");                         // ����, 
				         csBOMInfo.setString(12,rsPrev.getString("WAFERLOT"));   // ��Wafer Lot
				         csBOMInfo.setString(13,rsPrev.getString("WAFERIQCNO")); // ��IQC No.
				         csBOMInfo.setInt(14,rsPrev.getInt("LINE_NO"));          // ��IQC Line No.
				         csBOMInfo.setString(15,"FAKE");                     // �����d��
	                     csBOMInfo.execute();
			             int parentInvItemID = csBOMInfo.getInt(5);
	                     String parentInvItem = csBOMInfo.getString(6);       //  �^�� REQUEST ���檬�p
	                     String parentItemDesc = csBOMInfo.getString(7);
	                     String errorMessage = csBOMInfo.getString(8);      //  �^�� REQUEST ���檬�p
	                     String errorCode = csBOMInfo.getString(9);         //  �^�� REQUEST ���檬�p�T��
	                     int seqID = csBOMInfo.getInt(10);	                 //  �^�� ���� SEQUENCE ID
	                     csBOMInfo.close(); 
					 }
					 rsPrev.close();
					 statePrev.close();
					 
					// ******** Step2. �A�զX�@��SQL���Q�i�}ITEM Where Used ���M��
					sql = " select DISTINCT decode(YBI.ORGANIZATION_ID,'326','���P','327','�~�P') as ���~�P, IQC_RESULT as RESULT, IQC_WAFER_LOT as WAFERLOT, IQC_RECEPT_QTY as IQC���Ƽƶq, IQC_GRAINQTY as IQC������,IQC_INV_ITEM as INV_ITEM, IQC_ITEM_ID as INV_ITEM_ID, MSI.DESCRIPTION as INV_ITEM_DESC, IQC_INSP_NO as WAFERIQCNO ,  "+					       
							"               IQC_VENDOR_NAME as SUPPLIER_SITE_NAME, IQC_YIELD as TOTAL_YIELD, IQC_WAFER_TYPE as WF_TYPE_NAME, IQC_WAFER_RESIST as WF_RESIST , "+
							"               IQC_UOM as UOM, IQC_ITEM_ID as INV_ITEM_ID, IQC_LINE_NO as LINE_NO, IQC_INSPDATE as INSPECT_DATE, IQC_WAFER_AMP as WAFER_AMP, "+
						 	"               PARENT_ITEM_ID, PARENT_INV_ITEM, PARENT_ITEM_DESC "+
							"   from YEW_BOM_IMPL_TEMP1 YBI, MTL_SYSTEM_ITEMS MSI ";
					where =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+	
					        "    and YBI.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+	
							"    and YBI.IQC_ITEM_ID = MSI.INVENTORY_ITEM_ID "+														 
							"    and YBI.QUERY_TYPE = 'FAKE' and YBI.WO_TYPE = 1 "+ // �u����Τu�O��
							"    and substr(YBI.PARENT_INV_ITEM,1,3) in ('1A-','1B-' ) ";  //20151225 liling add 1B-
					order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT "; 
					
					if (runCardGet!=null && !runCardGet.equals("")) where = where + " and IQC_WAFER_LOT not in ("+runCardGet+") "; // ���e�w�b�M�椺��WaferLot���o�X�{ 		
		            if (invItem!=null && !invItem.equals("")) where = where + " and ( QRY_INV_ITEM = '"+invItem+"' or QRY_INV_ITEM like '%"+invItem+"%' ) ";		                 
		            if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--")) where = where + "and ( IQC_WAFER_RESIST = '"+waferResist+"' or IQC_WAFER_RESIST like '%"+waferResist+"%' )   ";
		            if (diceSize!=null && !diceSize.equals("") && !diceSize.equals("--")) where = where + "and ( IQC_DICE_SIZE= '"+diceSize+"' and IQC_DICE_SIZE like '%"+diceSize+"%' ) ";
		
		            if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) where = where + "and ( IQC_WAFER_LOT= '"+supplierLot+"' or IQC_WAFER_LOT like '%"+supplierLot+"%' ) ";

		             // �ݭn�אּ���S�w���� SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  /			 
		             if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		             {  
		                    where = where + " and ( IQC_WAFER_LOT like '%' ) ";
		                    //sql = sql + "and (a.SEGMENT1 = '%') ";   
		             }
		             else 
		                 { 
		                    where = where + "  and ( upper(IQC_INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQC_INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                        "         OR upper(QRY_INV_ITEM) =  '"+searchString.toUpperCase()+"' or upper(QRY_INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+
									        "         OR upper(IQC_WAFER_LOT) = '"+searchString.toUpperCase()+"' or upper(IQC_WAFER_LOT) like '"+searchString.toUpperCase()+"%' ) ";
	                     } 
					  
				   // *********** Step2. �A�ѼȦs���@�����s_��
					 
		  } else if (woType.equals("2")) // �e�q�u�O
		         {				 
				         //sqlCNT = "select count(IQCH.INSPLOT_NO) from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD,ORADDMAN.TSCIQC_WAFER_TYPE IQCWT, "+
						 //     "    BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, MTL_SYSTEM_ITEMS MSI";
/* //20091124 liling update performance issue
	              sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY IQC���Ƽƶq,IQCD.GRAINQTY,  "+		   
				                      "          MSI.SEGMENT1 as INV_ITEM, REPLACE(MSI.DESCRIPTION,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
		                              "          IQCH.SUPPLIER_SITE_NAME, decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST , "+	   	   
		                              //"          IQCD.UOM, BSB.ASSEMBLY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
									  "          IQCD.UOM, IQCD.INV_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                                  " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, ORADDMAN.TSCIQC_WAFER_TYPE IQCWT, "+
			                         "       MTL_SYSTEM_ITEMS MSI ";					                 
	      	             where=       " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                              "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 �[�J�w�g�禬�J�w�θg�S�ĤJ�w�������
									  "   and IQCD.INV_ITEM_ID = MSI.INVENTORY_ITEM_ID and IQCD.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+
									  "   and MSI.ORGANIZATION_ID = "+organizationId+" "+
									  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "; // Clone ��PO�観�s�b									 
		                 order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
	*/
	              sql = " select DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.RECEIPT_QTY IQC���Ƽƶq,IQCD.GRAINQTY,  "+		   
				                      "          IQCD.INV_ITEM, REPLACE(IQCD.INV_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
		                              "          IQCH.SUPPLIER_SITE_NAME, decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST , "+	   	   
		                              //"          IQCD.UOM, BSB.ASSEMBLY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
									  "          IQCD.UOM, IQCD.INV_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(IQCH.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                                  " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, ORADDMAN.TSCIQC_WAFER_TYPE IQCWT ";					                 
	      	             where=       " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                              "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 �[�J�w�g�禬�J�w�θg�S�ĤJ�w�������
									  "   and IQCD.ORGANIZATION_ID = "+organizationId+" "+
									  "   and substr(IQCH.CREATION_DATE,0,8) >= '20061120' "; // Clone ��PO�観�s�b									 
		                 order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
	
		                 if (runCardGet!=null && !runCardGet.equals("")) where = where + " and IQCD.SUPPLIER_LOT_NO not in ("+runCardGet+") "; // ���e�w�b�M�椺��WaferLot���o�X�{ 
		
		                 if (invItem!=null && !invItem.equals("")) where = where + " and ( IQCD.INV_ITEM = '"+invItem+"' or IQCD.INV_ITEM like '%"+invItem+"%' ) ";
		                  //if (itemDesc!=null && !itemDesc.equals("")) where = where + "and INV_ITEM_DESC = '"+itemDesc+"' ";
		                 // out.println("waferResist="+waferResist);
		                 if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--") && !waferResist.equals("0")) where = where + "and ( IQCH.WF_RESIST = '"+waferResist+"' or IQCH.WF_RESIST like '%"+waferResist+"%' )   ";
		                 if (diceSize!=null && !diceSize.equals("") && !diceSize.equals("--") && !diceSize.equals("0")) where = where + "and ( IQCD.DICE_SIZE= '"+diceSize+"' and IQCD.DICE_SIZE like '%"+diceSize+"%' ) ";
		
		                 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) 
						 { 
						 
						   where = where +  " and ( IQCD.SUPPLIER_LOT_NO= '"+supplierLot+"' or IQCD.SUPPLIER_LOT_NO like '%"+supplierLot+"%' "+
						                    "         OR upper(IQCD.INV_ITEM) = '"+supplierLot.toUpperCase()+"' or upper(IQCD.INV_ITEM) like '"+supplierLot.toUpperCase()+"%'  "+ 
					                        "         OR upper(IQCD.INV_ITEM_DESC) = '"+supplierLot.toUpperCase()+"' or upper(IQCD.INV_ITEM_DESC) like '"+supplierLot.toUpperCase()+"%' "+
						                    " ) ";
						 }

		                 // �ݭn�אּ���S�w���� SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */			 
		                 if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		                 {  
		                    where = where + " and ( IQCD.SUPPLIER_LOT_NO like '%' ) ";
		                   //sql = sql + "and (a.SEGMENT1 = '%') ";   
		                 }
		                 else 
		                 { 
						    		
	                     } 					 							
					
				     //  �����Ʀs�ܼȦs��_�_ 	
					 // *********** Step1. ���ѲĤ@��������զX�g�J�Ȧs��					 
					 sql = sql + where + order;	 // 2007/01/17 �]�®w�s�|�����ɧ�
					 //out.println("sql="+sql);
					
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sql);				   
				     while (rsPrev.next())
					 {					 
					      // �� Item Where Use�� Procedure_�_
				          String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
			              //out.println("prevSubItem ="+prevSubItem);			  
			              CallableStatement csBOMInfo = con.prepareCall("{call TSC_BOM_IMPLODER_PARENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	                      csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			              csBOMInfo.setString(2,woType);
	                      csBOMInfo.setInt(3,rsPrev.getInt("INV_ITEM_ID")); 
	                      csBOMInfo.setString(4,prevSubItem);                 // ��l���Ƹ��e�T�X( �P�w 11-, 10- �� 1A- )
	                      csBOMInfo.registerOutParameter(5, Types.INTEGER);   // �^�� Parent Item ID
	                      csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // �^�� Parent Inv Item
	                      csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // �^�� Parent Item Desc
	                      csBOMInfo.registerOutParameter(8, Types.VARCHAR);   // �^�� Error Message
	                      csBOMInfo.registerOutParameter(9, Types.VARCHAR);   // �^�� Error Code
						  csBOMInfo.registerOutParameter(10, Types.INTEGER);  // �^�� ���� SEQUENCE ID
						  csBOMInfo.setString(11,"");                         // ������Sort Code���^ ������T
						  csBOMInfo.setString(12,rsPrev.getString("WAFERLOT"));   // ��Wafer Lot
						  csBOMInfo.setString(13,rsPrev.getString("WAFERIQCNO")); // ��IQC No.
						  csBOMInfo.setInt(14,rsPrev.getInt("LINE_NO"));          // ��IQC Line No.
						  csBOMInfo.setString(15,"FAKE");                         // �w���d��
	                      csBOMInfo.execute();
			              int parentInvItemID = csBOMInfo.getInt(5);
	                      String parentInvItem = csBOMInfo.getString(6);       //  �^�� REQUEST ���檬�p
	                      String parentItemDesc = csBOMInfo.getString(7);
	                      String errorMessage = csBOMInfo.getString(8);      //  �^�� REQUEST ���檬�p
	                      String errorCode = csBOMInfo.getString(9);         //  �^�� REQUEST ���檬�p�T��
						  int seqID = csBOMInfo.getInt(10);	                 // �^�� ���� SEQUENCE ID
	                      //out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	                      csBOMInfo.close(); 
					 } // End of while
					 rsPrev.close();
					 statePrev.close();
				    //  �����Ʀs�ܼȦs��_��
					// *********** Step2. �A�ѼȦs���@�����s_�_						
					
					  //out.println("organizationId="+organizationId);
					  sql = " select DISTINCT decode(YBI.ORGANIZATION_ID,'326','���P','327','�~�P') as ���~�P, IQC_RESULT as RESULT, IQC_WAFER_LOT as WAFERLOT, IQC_RECEPT_QTY as IQC���Ƽƶq, IQC_GRAINQTY as IQC������,"+
					        "        QRY_INV_ITEM as INV_ITEM, REPLACE(QRY_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQC_INSP_NO as WAFERIQCNO, "+
							"        IQC_VENDOR_NAME as SUPPLIER_SITE_NAME, IQC_YIELD as TOTAL_YIELD, IQC_WAFER_TYPE as WF_TYPE_NAME, IQC_WAFER_RESIST as WF_RESIST , "+
							"        IQC_UOM as UOM, QRY_ITEM_ID as INV_ITEM_ID, IQC_LINE_NO as LINE_NO, IQC_INSPDATE as INSPECT_DATE, IQC_WAFER_AMP as WAFER_AMP, "+
						 	"        PARENT_ITEM_ID, PARENT_INV_ITEM, PARENT_ITEM_DESC "+
							"   from YEW_BOM_IMPL_TEMP1 YBI ";
					where =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+																 
							"    and YBI.QUERY_TYPE = 'FAKE'  and YBI.WO_TYPE = 2 "+ // �u��e�q�u�O
						//	"    and length(YBI.PARENT_INV_ITEM) = 13 and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151224 liling add 1B
                            "    and length(YBI.PARENT_INV_ITEM) IN (13, 16, 17, 20) and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151224 liling add 1B, 20170922 ADD 16	,20171005 ADD 20						
					order = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
					     if (runCardGet!=null && !runCardGet.equals("")) where = where + " and IQC_WAFER_LOT not in ("+runCardGet+") "; // ���e�w�b�M�椺��WaferLot���o�X�{ 		
		                 if (invItem!=null && !invItem.equals("")) where = where + " and ( QRY_INV_ITEM = '"+invItem+"' or QRY_INV_ITEM like '%"+invItem+"%' ) ";		                 
		                 if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--") && !waferResist.equals("0")) where = where + "and ( IQC_WAFER_RESIST = '"+waferResist+"' or IQC_WAFER_RESIST like '%"+waferResist+"%' )   ";
		                 if (diceSize!=null && !diceSize.equals("") && !diceSize.equals("--") && !diceSize.equals("0")) where = where + "and ( IQC_DICE_SIZE= '"+diceSize+"' and IQC_DICE_SIZE like '%"+diceSize+"%' ) ";
		
                         if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) 
						 {  
						   where = where + " and ( IQC_WAFER_LOT= '"+supplierLot+"' or IQC_WAFER_LOT like '%"+supplierLot+"%'  "+
						                    "         OR upper(IQC_INV_ITEM) = '"+supplierLot.toUpperCase()+"' or upper(IQC_INV_ITEM) like '"+supplierLot.toUpperCase()+"%'  "+ 
						                    " ) ";
						   
						 }

		                 // �ݭn�אּ���S�w���� SELECT / + ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  /			 
		                 if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		                 {  
		                    where = where + " and ( IQC_WAFER_LOT like '%' ) ";		                     
		                 }
		                 else 
		                 { 
						   /*
		                    where = where + "  and ( upper(IQC_INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQC_INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                        "         OR  upper(QRY_INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(QRY_INV_ITEM) like '"+searchString.toUpperCase()+"%' "+
									        "         OR upper(IQC_WAFER_LOT) = '"+searchString.toUpperCase()+"' or upper(IQC_WAFER_LOT) like '"+searchString.toUpperCase()+"%' ) ";
						   */				
	                     } 					  
				   // *********** Step2. �A�ѼȦs���@�����s_��
				   
				     sqlOld = "select decode(a.ORGANIZATION_ID,'326','���P','327','�~�P') as  ���~�P,'01' as RESULT, a.LOT_NUMBER as WAFERLOT, a.PRIMARY_TRANSACTION_QUANTITY as IQC���Ƽƶq, "+
					                 "       b.SEGMENT1 as INV_ITEM, REPLACE(b.DESCRIPTION,'"+"\""+"',' inch ') as INV_ITEM_DESC, 'IQC0120070101-106' as WAFERIQCNO, "+
									 "       'SUPPLIER' as SUPPLIER_SITE_NAME, 'N/A' as TOTAL_YIELD, 'N/A' as WF_TYPE_NAME, 'N/A' as WF_RESIST, "+
									 "       a.TRANSACTION_UOM_CODE as UOM, a.INVENTORY_ITEM_ID as INV_ITEM_ID, 1 as LINE_NO,to_char(a.DATE_RECEIVED,'YYYY/MM/DD HH24:MI:SS')  as INSPECT_DATE, 'N/A' as WAFER_AMP, "+
									 "       a.INVENTORY_ITEM_ID as PARENT_ITEM_ID, b.SEGMENT1 as PARENT_INV_ITEM, b.DESCRIPTION as PARENT_ITEM_DESC  "+
					                 " from MTL_ONHAND_QUANTITIES_DETAIL a, MTL_SYSTEM_ITEMS b ";
					 whereOld =" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
									  "   and a.ORGANIZATION_ID = b.ORGANIZATION_ID and a.ORGANIZATION_ID = "+organizationId+" ";
					 if (supplierLot!=null && !supplierLot.equals("")  && !supplierLot.equals("--")) whereOld = whereOld + "and ( a.LOT_NUMBER= '"+supplierLot+"' or a.LOT_NUMBER like '%"+supplierLot+"%' ) ";			
				   
				   
				 } // End of else if (woType.equals("2"))	           	
		sql = sql + where + order;
        //out.println("sql="+sqlOld+whereOld); 		 
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='center' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>����</TD>");        
        for (int i=1;i<=colCount;i++) // ����ܲĤ@����, �G for �� 2�}�l
        {
		  if (i==5)
		  {
		    if (woType.equals("1"))
			{
			 out.println("<TD nowrap><FONT COLOR=BROWN>�Ѿl��"+"</TD>");
		     out.println("<TD nowrap><FONT COLOR=BLUE><strong>�s�����ɫ~��"+"</strong></TD>");
			 out.println("<TD nowrap><FONT COLOR=BROWN>�i�δ�����"+"</TD>");
			} else if (woType.equals("2")) // �e�q�u�O�A�h�a�@���άy�{�d��
		           {
				     out.println("<TD nowrap><FONT COLOR=BROWN>�Ѿl��"+"</TD>");
		             //out.println("<TD nowrap><FONT COLOR=BLUE><strong>���άy�{�d��"+"</strong></TD>");
			         out.println("<TD nowrap><FONT COLOR=BLUE><strong>�s���b���~��"+"</strong></TD>");
					 out.println("<TD nowrap><FONT COLOR=BROWN>�i�δ�����"+"</TD>");
		           }
		  }
		 //if (i==11) out.println("<TD nowrap><FONT COLOR=BROWN>�Ѿl��"+"</TD>");
         colLabel[i]=md.getColumnLabel(i);
		 out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");
		  
        } //end of for 
        out.println("</TR>");
		String description=null;
      		
        String buttonContent=null;
		String trBgColor = "";
		int j = 0; //������
		float sumWOCretedQty = 0;
		float accAvailQty = 0;
		float sumWOCretedQty1 = 0;
		float accAvailQty1 = 0;
		    String cutAsbItemId = "";
			String cutAsbInvItem = "";
			String cutAsbItemDesc = "";
			
			String subAsbItemId = "";
			String subAsbInvItem = "";
			String subAsbItemDesc = "";
			String waferLotTmp = null; // �C�����쪺Lot ���Ȧs
			String cutAsbInvItemTmp = null; // �C�����쪺�s���~���Ȧs
			float cutterWoQty = 0; // ���άq�u�O���X��
        while (rs.next())
        {
			String chkCutAsbFlag = "N";
			String chkSubAsbFlag = "N";		
			String cutWoList = "�w�}���Τu�O<BR>";
			String frontWoList = "�w�}���ΡB�e�q�u�O<BR>";	
			String IQCItemList = "IQC�Ƹ���T<BR>"; 		
		 
		 // �����Τu�O�����~���Ƹ���T_�_
		 if (woType.equals("1")) // �p�����Τu�O
		 {	    
			int parentInvItemID = rs.getInt("PARENT_ITEM_ID");
	        String parentInvItem = rs.getString("PARENT_INV_ITEM");      //  �^�� REQUEST ���檬�p
	        String parentItemDesc = rs.getString("PARENT_ITEM_DESC"); 					  
				 
			// �� Item Where Use�� Procedure_�� 
		 
		   result=rs.getString("RESULT");
		   waferLot=rs.getString("WAFERLOT");		
		   invItem=rs.getString("INV_ITEM");
		   itemDesc=rs.getString("INV_ITEM_DESC");	
		   waferVendor=rs.getString("SUPPLIER_SITE_NAME");
 		   waferQty=rs.getString(4); //rs.getString("RECEIPT_QTY");
		   IQC_GRAINQTY = rs.getString(5);
		   waferUom=rs.getString("UOM");  // 2007/01/30 ���������,�p��PCE, �h�p�⦩���w�}�ƻݥH�������Ƭ����
		   waferYld=rs.getString("TOTAL_YIELD");
		   waferElect=rs.getString("WF_RESIST");
		   waferIqcNo=rs.getString("WAFERIQCNO");	
		   waferKind=rs.getString("WF_TYPE_NAME");
		   itemId=rs.getString("INV_ITEM_ID");	
		   waferLineNo=rs.getString("LINE_NO");
		   waferAmp=rs.getString("WAFER_AMP");     

			 if (parentInvItemID!=0)
			 {
			   cutAsbItemId = Integer.toString(parentInvItemID);
			   cutAsbInvItem = parentInvItem;;
			   cutAsbItemDesc = parentItemDesc;
			   itemId = cutAsbItemId;
			   invItem = cutAsbInvItem; //out.println("cutAsbInvItem="+cutAsbInvItem);
			   itemDesc = cutAsbItemDesc;	
			   chkCutAsbFlag = "Y";
			 }
			 else if (parentInvItemID==0 || parentInvItem=="" || parentInvItem.equals(""))
	         {
	                 cutAsbInvItem="<font color=#CC0033><em>�L�������Χ��u�~��</em></font>";
			         chkCutAsbFlag = "N";
	         }
            Statement stateWOCr1=con.createStatement();
		             String sqlWoCr1 = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr1 = sqlWoCr1+ " and WORKORDER_TYPE in ('1','2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		             ResultSet rsWOCr1=stateWOCr1.executeQuery(sqlWoCr1);
		             if (rsWOCr1.next()) sumWOCretedQty1 = rsWOCr1.getFloat(1);
					 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1;
		             rsWOCr1.close();
		             stateWOCr1.close(); 
		   if (waferUom.equals("KPC")) // 2007/01/30 ���������,�p��PCE, �h�p�⦩���w�}�ƻݥH�������Ƭ����
		   {		   
		     // �֥[���ΡB�e�q�w�}�u�O���w�}��_�_(�]��IQC �����ӷ����@�Ω���ΤΫe�q)
		     Statement stateWOCr=con.createStatement();
		     String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                    "   where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
							"     and WAFER_IQC_NO in ( select ORDER_NO from YEW_MFG_TRAVELS_ALL where ( PRIMARY_NO='"+rs.getString("WAFERIQCNO")+"' ) )  ";
		     if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1','2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		     ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		     if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		     rsWOCr.close();
		     stateWOCr.close(); 	 
		     // �֥[���ΡB�e�q�w�}�u�O���w�}��_��(�]��IQC �����ӷ����@�Ω���ΤΫe�q)
		   } else if (waferUom.equals("PCE")) // �ӮƬ�����,�H���Ʀ����w�}��
		          {
				     Statement stateWOCr=con.createStatement();
		             String sqlWoCr = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1','2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		             ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		             if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		             rsWOCr.close();
		             stateWOCr.close(); 	
				  }
			 
			  // �C��̼t�ӧ帹_�_			   
			   Statement stateWOLst=con.createStatement();
		       String sqlWoLst = "select DISTINCT WO_NO||'(�ƶq='||WO_QTY||',��Ӷq='||WO_UNIT_QTY||')' from YEW_WORKORDER_ALL "+
		                         " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
		                         "   and WORKORDER_TYPE in ('1','2') "; // �̤��Τu�O�μt�ӧ帹��X�֭p�w�}�ƶq	 
		       ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		       while (rsWOLst.next()) 
			   {
			     cutWoList = cutWoList + rsWOLst.getString(1)+"<BR>";
			   }
		       rsWOLst.close();
		       stateWOLst.close();
			   
			   if (cutWoList.equals("�w�}���Τu�O<BR>"))  cutWoList = "�w�}���Τu�O<BR>�L";
			// �C��̼t�ӧ帹_��
			
			// �C���IQC���ʶR�Ƹ�_�_			   
			   Statement stateIQCLst=con.createStatement();
		       String sqlIQCLst = "select INV_ITEM_ID||'(�Ƹ�='||INV_ITEM||')' from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL  "+
		                         " where SUPPLIER_LOT_NO = '"+rs.getString("WAFERLOT")+"' and INSPLOT_NO='"+rs.getString("WAFERIQCNO")+"' "+
								 "   and LINE_NO= '"+rs.getString("LINE_NO")+"' ";		                      
		       ResultSet rsIQCLst=stateIQCLst.executeQuery(sqlIQCLst);
		       if (rsIQCLst.next()) 
			   {
			     IQCItemList = rsIQCLst.getString(1);
			   }
		       rsIQCLst.close();
		       stateIQCLst.close();			   
			   //if (IQCItemList.equals("IQC���ƮƸ�<BR>")) IQCItemList = "�w�}���Τu�O<BR>�L";
			// �C���IQC���ʶR�Ƹ�_��

		   // ���Τu�O���֭p�i�ξl�B
		   accAvailQty = Float.parseFloat(waferQty) - sumWOCretedQty; // �i�}��� = IQC���Ƽ� - �ֿn�u��}�߼�
		  
		   defaultWoQty=Float.toString(accAvailQty); // ���o���i�}�߼�    		   
		   
		   
		 } // �����Τu�O�����~���Ƹ���T_��
		 else if (woType.equals("2")) // �p���e�q�u�O,�h��Item Master��ItemType�����o���ɮƸ�(1A-XXX),�A�������o�b���~(15�X)�Ƹ�
		      {

				  String prevSubItem = rs.getString("INV_ITEM").substring(0,3);			  

			  // �� Item Where Use�� Procedure_�� 
			      int parentInvItemID = rs.getInt("PARENT_ITEM_ID");
	              String parentInvItem = rs.getString("PARENT_INV_ITEM");      //  �^�� REQUEST ���檬�p
	              String parentItemDesc = rs.getString("PARENT_ITEM_DESC"); 			      
			    
				  // Step1. ���������ɮƸ�(1A-XXXX)
				  
				  result=rs.getString("RESULT");
		          waferLot=rs.getString("WAFERLOT");		
		          invItem=rs.getString("INV_ITEM");
		          itemDesc=rs.getString("INV_ITEM_DESC");	
		          waferVendor=rs.getString("SUPPLIER_SITE_NAME");
 		          waferQty=rs.getString(4); //rs.getString("RECEIPT_QTY"); // IQC ���Ƽƶq
				  //out.println("waferQty="+waferQty);
				  IQC_GRAINQTY = rs.getString(5);
		          waferUom=rs.getString("UOM"); // 2007/01/30 ���������,�p��PCE, �h�p�⦩���w�}�ƻݥH�������Ƭ����
		          waferYld=rs.getString("TOTAL_YIELD");
		          waferElect=rs.getString("WF_RESIST");
		          waferIqcNo=rs.getString("WAFERIQCNO");	
		          waferKind=rs.getString("WF_TYPE_NAME");
		          itemId=rs.getString("INV_ITEM_ID");	
		          waferLineNo=rs.getString("LINE_NO");
		          waferAmp=rs.getString("WAFER_AMP");		
		
		        // 2006/12/16 Fix By Kerwin  �H Item Where Used ��Procedure ���s���~����T
		        if (parentInvItemID!=0)
			    {
				    subAsbItemId = Integer.toString(parentInvItemID) ; 
			        subAsbInvItem = parentInvItem;
			        subAsbItemDesc = parentItemDesc;
			        itemId = subAsbItemId;
			        invItem = subAsbInvItem;
			        itemDesc = subAsbItemDesc;	
					chkSubAsbFlag = "Y";	
					//out.println("parentInvItemID="+parentInvItemID);			 
			      } 
				    else if (parentInvItemID==0 || parentInvItem=="" || parentInvItem.equals(""))
				         {				  
				            chkSubAsbFlag = "N";
							//out.println("parentInvItemID="+parentInvItemID);		
						 }    
						 
			   // �C��̼t�ӧ帹_�_
			 //out.println("RRRR2<BR>");   
			 
			   Statement stateWOLst=con.createStatement();
		       String sqlWoLst = " select DISTINCT WO_NO||'(�ƶq='||WO_QTY||',��Ӷq='||WO_UNIT_QTY||')' "+
			                     " from YEW_WORKORDER_ALL "+
		                         " where STATUSID !='050'  AND WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
								// " and INV_ITEM= '"+parentInvItem+"' "+  // �������C��w�}���Τu�O��
		                         " and WORKORDER_TYPE in ('1', '2') "; // �̤��Τu�O�μt�ӧ帹��X�֭p�w�}�ƶq	 
		        //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		       while (rsWOLst.next()) 
			   {
			     frontWoList = frontWoList + rsWOLst.getString(1)+"<BR>";
			   }
		       rsWOLst.close();
		       stateWOLst.close();
			   
			   if (frontWoList.equals("�w�}�e�q�u�O<BR>")) frontWoList = "�w�}�e�q�u�O<BR>�L";			   
		// �C��̼t�ӧ帹_��		
		
		// �C���IQC���ʶR�Ƹ�_�_			   
			   Statement stateIQCLst=con.createStatement();
		       String sqlIQCLst = "select INV_ITEM_ID||'(�Ƹ�='||INV_ITEM||')' from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL  "+
		                          " where SUPPLIER_LOT_NO = '"+rs.getString("WAFERLOT")+"' and INSPLOT_NO='"+rs.getString("WAFERIQCNO")+"' "+
								  "   and LINE_NO= '"+rs.getString("LINE_NO")+"' ";		                      
		       //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsIQCLst=stateIQCLst.executeQuery(sqlIQCLst);
		       if (rsIQCLst.next()) 
			   {
			     IQCItemList = rsIQCLst.getString(1);
			   }
		       rsIQCLst.close();
		       stateIQCLst.close();			   
			   //if (IQCItemList.equals("IQC���ƮƸ�<BR>")) IQCItemList = "�w�}���Τu�O<BR>�L";
		// �C���IQC���ʶR�Ƹ�_�� 
			  
				//out.println("RRRR3<BR>");	  	
	//out.println("RRRR3<BR>");		
				//  �Y���e�q�u�O,�h���եh�M����άy�{�d��(�u�O)_�_
			    if (woType.equals("2")) // �Y���e�q�u�O,�h���եh�M����άy�{�d��(�u�O)
		        {
		           Statement stateFront=con.createStatement();
		           String sqlFront = " select b.RUNCARD_NO, a.WO_QTY, b.COMPLETION_QTY, a.WO_UNIT_QTY "+
		                     "  from YEW_WORKORDER_ALL a,YEW_RUNCARD_ALL b, YEW_MFG_TRAVELS_ALL c "+ 
							 "  where a.WO_NO = b.WO_NO and a.WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"' "+
							 "    and a.WO_NO = c.EXTEND_NO and c.PRIMARY_TYPE = '0' "+
							 "    and c.PRIMARY_NO = '"+rs.getString("WAFERLOT")+"' and c.EXTEND_TYPE = '1' "+							
		                     "    and a.WORKORDER_TYPE = '1' and b.STATUSID = '048' "; // ����άy�{�d��(�u�O)	

		           ResultSet rsFront=stateFront.executeQuery(sqlFront);
		           if (rsFront.next()) 
		           { 
		              frontRunCard = rsFront.getString(1);
			          cutterWoQty = rsFront.getFloat(3);// �����άq�u�O���u�� 
			          if (cutterWoQty==0) cutterWoQty = rsFront.getFloat(2);// �p�G���άq�����u,�h�H�u�O�Ƨ@���p���¦			 
			          cutterRCNo=frontRunCard; 
					  
			          if (waferUom.equals("KPC")) // 2007/01/30 ���������,�p��PCE, �h�p�⦩���w�}�ƻݥH�������Ƭ����
		              {	
			             // �֥[���ΡB�e�q�w�}�u�O���w�}��_�_
		                 Statement stateWOCr=con.createStatement();
		                 String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                                  " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+
							              "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+									  
									      "   and WAFER_IQC_NO in ( select ORDER_NO from YEW_MFG_TRAVELS_ALL where ( PRIMARY_NO='"+rs.getString("WAFERIQCNO")+"' ) ) "; // RuncardNo
		                 if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE ='2' "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		                 //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                 ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                 if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                 rsWOCr.close();
		                 stateWOCr.close(); 	 
		                 // �֥[���ΡB�e�q�w�}�u�O���w�}��_��	
					   } else if (waferUom.equals("PCE")) // �ӮƬ�����,�h�H���Ʋ֭p���p���¦
					          {
					            // �֥[���ΡB�e�q�w�}�u�O���w�}��_�_
		                        Statement stateWOCr=con.createStatement();
		                        String sqlWoCr = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                                         " where STATUSID!='050' "+
							                     "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+									  
									             "   and WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"'  "; // RuncardNo
		                        if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1','2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		                        //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                        ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                        if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                        rsWOCr.close();
		                        stateWOCr.close(); 	 
		                        // �֥[���ΡB�e�q�w�}�u�O���w�}��_��  
					          }	
					Statement stateWOCr1=con.createStatement();
		             String sqlWoCr1 = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr1 = sqlWoCr1+ " and WORKORDER_TYPE in ('1','2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		             ResultSet rsWOCr1=stateWOCr1.executeQuery(sqlWoCr1);
		             if (rsWOCr1.next()) sumWOCretedQty1 = rsWOCr1.getFloat(1);
					 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1;
		             rsWOCr1.close();
		             stateWOCr1.close(); 
                              //out.println("RRRR3.22<BR>");			 
		            }
		            else 
		            {  // �䤣��,�h�i��O�������IQC ����帹,�G�Ǧ^�����NIQC���X�@���l���Ǹ�
		   
		                     frontRunCard =rs.getString("WAFERIQCNO");
			                 cutterRCNo="";
							 Statement stateWOCr1=con.createStatement();
		             String sqlWoCr1 = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                              " where STATUSID!='050' and WAFER_LOT_NO = '"+rs.getString("WAFERLOT")+"' "+							          
							          "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"'  ";
		             if (woType!=null) sqlWoCr1 = sqlWoCr1+ " and WORKORDER_TYPE in ('1','2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		             ResultSet rsWOCr1=stateWOCr1.executeQuery(sqlWoCr1);
		             if (rsWOCr1.next()) sumWOCretedQty1 = rsWOCr1.getFloat(1);
					 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1;
		             rsWOCr1.close();
		             stateWOCr1.close(); 
			             if (waferUom.equals("KPC")) // 2007/01/30 ���������,�p��PCE, �h�p�⦩���w�}�ƻݥH�������Ƭ����
						 {
			                 // �֥[���ΡB�e�q�w�}�u�O���w�}��_�_
		                     Statement stateWOCr=con.createStatement();
		                     String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                                      " where STATUSID!='050' and WAFER_IQC_NO = '"+rs.getString("WAFERIQCNO")+"' "+
											  "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+
											  "   and WAFER_IQC_NO in ( select ORDER_NO from YEW_MFG_TRAVELS_ALL where PRIMARY_NO='"+rs.getString("WAFERIQCNO")+"' )";
		                      if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE ='2' "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		                      //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                      ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                      if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                      rsWOCr.close();
		                      stateWOCr.close(); 	 
		                      // �֥[���ΡB�e�q�w�}�u�O���w�}��_��	
						} else if (waferUom.equals("PCE"))
						       {
							      Statement stateWOCr=con.createStatement();
		                          String sqlWoCr = "select SUM(WAFER_USED_PCE) from YEW_WORKORDER_ALL "+
		                                           " where STATUSID!='050' "+
											       "   and WAFER_LINE_NO = '"+rs.getString("LINE_NO")+"'  "+							                      
											       "   and WAFER_IQC_NO ='"+rs.getString("WAFERIQCNO")+"' ";
		                          if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('1', '2') "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	 
		                          //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		                          ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		                          if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		                          rsWOCr.close();
		                          stateWOCr.close(); 
							   } // End of else if (PCE)		 
                      //out.println("RRRR3.33<BR>");			 
		             } // End of else 
		             rsFront.close();
		             stateFront.close();	 
		   
		          }	// End of if (woType.equals("2")) // �Y���e�q�u�O,�h���եh�M����άy�{�d��(�u�O)
 //out.println("RRRR4<BR>");		
				// �Y���e�q�u�O,�h���եh�M����άy�{�d��(�u�O)_��
				 //  ******#$$$$&&&&&$$$$$$ �p��i�ξl�B $$$$$$$$$$$$&&&&&&&&77 ********* //
		       
				     accAvailQty = Float.parseFloat(waferQty) - sumWOCretedQty;    // �i�}��Ѿl�� = IQC���Ƽ� - �ֿn�u��}�߼�
		             defaultWoQty=Float.toString(accAvailQty); // ���o���i�}�߼�		
				  	 accAvailQty1 = Float.parseFloat(IQC_GRAINQTY) - sumWOCretedQty1; 	 
		         //  ******#$$$$&&&&&$$$$$$ �p��i�ξl�B $$$$$$$$$$$$&&&&&&&&77 ********* //	
					  
			  } //End of else if (line 568) �p���e�q�u�O,�h��Item Master��ItemType���o�b���~(15�X)�Ƹ�
		
		 
		 //out.print("invItem="+invItem);
      
		//-----����s�b�u���ɸ̪������ ------
		String sqla2= "  select wafer_lot_no, wafer_qty from APPS.YEW_WORKORDER_ALL  where STATUSID !='050' and WAFER_LOT_NO = '"+waferIqcNo+"' and WAFER_LINE_NO= '"+waferLineNo+"'";
		if (woType!=null) sqla2 = sqla2+ " and WORKORDER_TYPE = '"+woType+"' "; // �̤��ΩΫe�q�u�O�ϧO��X�w�}�ƶq��IQC�帹	    
	    Statement statea2=con.createStatement();
		//out.print("sqla1="+sqla2);
        ResultSet rsa2=statea2.executeQuery(sqla2);
		//out.print("sqla1="+sqla2);
    	 if (rsa2.next())
		 { 
		    	woWaferIqcNo   = rsa2.getString("WAFER_LOT_NO");   
	   		    woWaferQty     = rsa2.getString("WAFER_QTY");
		 }
		 else {woWaferQty="0";}  
	    rsa2.close();
        statea2.close();
		
		//��p�q���
		String sqla1= " select PRIMARY_UNIT_OF_MEASURE WOUOM  from apps.mtl_system_items_b "+
					  "  where Organization_id=43  and segment1= '"+invItem +"'";

	    Statement statea1=con.createStatement();
        ResultSet rsa1=statea1.executeQuery(sqla1);
		//out.print("sqla1="+sqla1);
    	if (rsa1.next())
		{ 	woUom   = rsa1.getString("WOUOM");   }
	    rsa1.close();
        statea1.close();
		
		%>
		<INPUT TYPE="hidden" NAME="WAFERLOT" SIZE=10 value="<%=waferLot%>" >
		<INPUT TYPE="hidden" NAME="INVITEM" SIZE=10 value="<%=invItem%>" >
		<INPUT TYPE="hidden" NAME="ITEMDESC" SIZE=10 value="<%=itemDesc%>" >
		<INPUT TYPE="hidden" NAME="WAFERVENDOR" SIZE=10 value="<%=waferVendor%>" >
		<INPUT TYPE="hidden" NAME="WAFERQTY" SIZE=10 value="<%=waferQty%>" >
		<INPUT TYPE="hidden" NAME="WAFERUOM" SIZE=10 value="<%=waferUom%>" >
		<INPUT TYPE="hidden" NAME="WAFERYLD" SIZE=10 value="<%=waferYld%>" >
		<INPUT TYPE="hidden" NAME="WAFERELECT" SIZE=10 value="<%=waferElect%>" >
		<INPUT TYPE="hidden" NAME="WAFERIQCNO" SIZE=10 value="<%=waferIqcNo%>" >
		<INPUT TYPE="hidden" NAME="WAFERKIND" SIZE=10 value="<%=waferKind%>" >
		<INPUT TYPE="hidden" NAME="ITEMID" SIZE=10 value="<%=itemId%>" >
		<INPUT TYPE="hidden" NAME="WOUOM" SIZE=10 value="<%=woUom%>" >
		<INPUT TYPE="hidden" NAME="WAFERLINENO" SIZE=10 value="<%=waferLineNo%>" >		
<%
		
		//buttonContent="this.value=sendToMainWindow("+'"'+waferLot+'"'+","+'"'+invItem+'"'+","+'"'+itemDesc+'"'+","+'"'+waferVendor+'"'+","+'"'+waferQty+'"'+","+'"'+waferUom+'"'+","+'"'+waferYld+'"'+","+'"'+waferElect+'"'+","+'"'+waferIqcNo+'"'+","+'"'+waferKind+'"'+","+'"'+itemId+'"'+","+'"'+woUom+'"'+","+'"'+waferLineNo+'"'+")";
		
		
//	if (accAvailQty>0)  // if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦ��C(��Ƥ]�����)
//	{
		out.print("<TR BGCOLOR='"+"#D2D0AA"+"'><TD nowrap>");
		
		
		if (accAvailQty<0) accAvailQty = 0;
		if (accAvailQty1<0) accAvailQty1 = 0;
		if (accAvailQty>0)  // if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦ��C(������,���L�k�I���a�J�s)
	    { 
		  if (waferLot!=waferLotTmp && !waferLot.equals(waferLotTmp) && cutAsbInvItem!=cutAsbInvItemTmp && cutAsbInvItem.equals(cutAsbInvItemTmp)) // �C�����쪺�s���~���Ȧs)// �i��BOM ���@�ӥH�W���s���~��,�Y�O,�h�Ǹ����֥[
		  {
		     j++; // ������
		  }
		%>
		<INPUT TYPE=button NAME='button' VALUE='�a�J' onClick='sendToMainWindow("<%=j%>","<%=waferLot%>","<%=invItem%>","<%=itemDesc%>","<%=waferVendor%>","<%=waferQty%>","<%=waferUom%>","<%=waferYld%>","<%=waferElect%>","<%=waferIqcNo%>","<%=waferKind%>","<%=itemId%>","<%=woUom%>","<%=waferLineNo%>","<%=defaultWoQty%>","<%=woType%>","<%=waferIqcNo%>","<%=chkCutAsbFlag%>","<%=chkSubAsbFlag%>","<%=waferAmp%>")'>
		<%
		}  // end of if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦC(������,���L�k�I���a�J�s)
		else { 
		     // j--; //���p�J
		      out.println("<em><font color='#FF0000'>�L�l�B</font></em>");
			 }
		if (accAvailQty1<0)  // if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦ��C(������,���L�k�I���a�J�s)
	 
	         { 
		     // j--; //���p�J
		      out.println("<em><font color='#FF0000'>�L�l�B</font></em>");
			 }
		 out.print("</TD>");		
		 out.print("<TD>"+j+"</TD>");
         for (int i=1;i<=colCount;i++) // ����ܲĤ@����, �G for �� 2�}�l
         {
		    if (i==5) //�e�q�u�O�A�h�a�@���άy�{�d��_�_
		    {			  
			  if (woType.equals("1"))
			  {
			    out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
			    out.println("<TD nowrap><FONT COLOR=BLUE><strong>"+cutAsbInvItem+"</strong></TD>");
				out.println("<TD nowrap><FONT>"+accAvailQty1+"</TD>");
			  }
			  else if (woType.equals("2")) // �e�q�u�O�A�h�a�@���άy�{�d��
		           {
				     out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");		            
					 out.println("<TD nowrap><FONT COLOR=BLUE face='Georgia'><strong>"+subAsbInvItem+"</strong></TD>");					                     out.println("<TD nowrap><FONT>"+accAvailQty1+"</TD>");
		           }
		    } // �e�q�u�O�A�h�a�@���άy�{�d��_��		 
		 
		   //if (i==11) out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
		   
           String s=(String)rs.getString(i);
		   if (i==3)
		   { 
		      if (woType.equals("1"))
			  {
			    s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("+'"'+cutWoList+'"'+")'>"+s+"</a></strong></font>";
			  } else if (woType.equals("2"))
			         {
					   s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("+'"'+frontWoList+'"'+")'>"+s+"</a></strong></font>";
					 } 
		   } else if (i==7)
		          {
				     if (woType.equals("2"))
			         {
					   s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+IQCItemList+'"'+")'>"+s+"</a></strong></font>";
					 } 					  
				  }	 else if (i==8)
				          {
						     if (woType.equals("1"))
			                 {
					           s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+IQCItemList+'"'+")'>"+s+"</a></strong></font>";
					         } 
						  }
           out.println("<TD nowrap><FONT>"+s+"</TD>");// �C�L�U�����
         } //end of for
          out.println("</TR>");	
		  
	      //	 }  // end of if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦC(��Ƥ]�����)
		  // %%%%%%%%%%%%%%%%%%%%%%
		  waferLotTmp = waferLot; // �����帹���Ȧs
		  cutAsbInvItemTmp = cutAsbInvItem; // �s���~�����Ȧs
		  // %%%%%%%%%%%%%%%%%%%%%%
        } //end of while
        out.println("</TABLE>");						
		
        rs.close(); 	
	   }//end of while
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
	  statement.close();
  %>
  <BR>
 <hr>
  <% 
    if (woType.equals("2")) // �e�q�u�O�ӷ��Ѥ��Τu�O
    {
  %>
  <span class="style1">�}�߫e�q�u�O�Ѥ��άy�{�d</span><BR>
  <%
    } // end of if (woType.equals("2"))
    // �N�Ӧ۩������P�Ӧۤ��άy�{�d���Ϥ��}��
	  // �����Ӧ۩�WIP ���Χ��u�u�O���M��
	  try
	  {
	        //String sqlCNT = "";
		   String sqlCutRC = "";
		   String whereCutRC= "";
		   String orderCutRC = "";
		   
	       Statement stateCutRC=con.createStatement();
           if (woType.equals("2")) // �e�q�u�O
		   {	   
		    // ************* Step1. �����o�Ȧs�����e
	                     sqlCutRC = " select  DISTINCT IQCD.RESULT, IQCD.SUPPLIER_LOT_NO WAFERLOT, IQCD.GRAINQTY,YRA.RUNCARD_NO as ���άy�{�d��, YRA.COMPLETION_QTY as ���άy�{�d���u��, "+
						           // "       ASI.SEGMENT1 as INV_ITEM, REPLACE(ASI.DESCRIPTION,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
								      "       YRA.INV_ITEM as INV_ITEM, REPLACE(YRA.ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQCH.INSPLOT_NO as WAFERIQCNO, "+
		                              "       IQCH.SUPPLIER_SITE_NAME, decode(IQCH.TOTAL_YIELD,null,'N/A','null','N/A',IQCH.TOTAL_YIELD) as TOTAL_YIELD, IQCWT.WF_TYPE_NAME, IQCH.WF_RESIST , "+
	   				               // "       IQCD.UOM, ASI.INVENTORY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(YRA.CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
									  "       IQCD.UOM, YRA.PRIMARY_ITEM_ID as INV_ITEM_ID, IQCD.LINE_NO, to_char(to_date(YRA.CLOSED_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, decode(IQCH.WAFER_AMP,null,'N/A','null','N/A',IQCH.WAFER_AMP) as WAFER_AMP  "+
	                                  " from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQCH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD, ORADDMAN.TSCIQC_WAFER_TYPE IQCWT, "+
			                          "      BOM_COMPONENTS_B BCB, BOM_STRUCTURES_B BSB, MTL_SYSTEM_ITEMS MSI, "+
									  "      YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA, "+
									  "    ( select /* + orderCutRCED index(a BOM_COMPONENTS_B_N2)  */ COMPONENT_ITEM_ID, b.ASSEMBLY_ITEM_ID, MSIT.SEGMENT1, MSIT.DESCRIPTION, MSIT.INVENTORY_ITEM_ID, MSIT.ITEM_TYPE "+
				                      "        from BOM_COMPONENTS_B a, BOM_STRUCTURES_B b, MTL_SYSTEM_ITEMS MSIT "+
					                  "       where a.BILL_SEQUENCE_ID = b.BILL_SEQUENCE_ID and b.ASSEMBLY_ITEM_ID = MSIT.INVENTORY_ITEM_ID "+									  
							          "         and MSIT.ITEM_TYPE = 'SA' "+ // ItemType �O subassembly
							         // "         and COMPONENT_ITEM_ID = "+cutAsbItemId+" "+ // �촹�ɮƸ�(1A-XXXXXX)
							          "         and b.ORGANIZATION_ID = MSIT.ORGANIZATION_ID "+
					 		          // "         and b.ORGANIZATION_ID = "+organizationId+"  "+ // 2006/11/10 BOM Resource�����Organization Id
									  "     ) ASI ";					                 
	      	             whereCutRC= " where IQCWT.WF_TYPE_ID=IQCH.WAFER_TYPE and IQCH.INSPLOT_NO=IQCD.INSPLOT_NO "+
		                              "   and IQCD.RESULT in ('ACCEPT','WAIVE','01','03') and IQCD.LSTATUSID = '010' "+ // 2006/11/01 �[�J�w�g�禬�J�w�θg�S�ĤJ�w�������
									  "   and YWA.WAFER_IQC_NO = IQCH.INSPLOT_NO and YWA.WAFER_LOT_NO = IQCD.SUPPLIER_LOT_NO "+
									  "   and YWA.WO_NO = YRA.WO_NO "+
									  "   and YRA.STATUSID = '048' and YWA.WORKORDER_TYPE = '1' "+  // �w�g�J�w�����Τu�O
									  "   and BCB.BILL_SEQUENCE_ID = BSB.BILL_SEQUENCE_ID and BSB.ASSEMBLY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+
							         //    "   and substr(MSI.SEGMENT1,3,LENGTH(MSI.SEGMENT1)) = substr(IQCD.INV_ITEM,3,LENGTH(IQCD.INV_ITEM)) "+
							          "   and BCB.COMPONENT_ITEM_ID = IQCD.INV_ITEM_ID "+ // ��IQC ���ƴ����Ƹ�(11-XXXXXX)
							          "   and BSB.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+									
					 		          //  "   and BSB.ORGANIZATION_ID = "+organizationId+" "+ // 2006/11/10 BOM Resource�����Organization Id
									  "   and ASI.COMPONENT_ITEM_ID = BSB.ASSEMBLY_ITEM_ID ";
		                     //   "   and IQCH.INSPLOT_NO = YWA.WAFER_IQC_NO(+) and IQCD.RECEIPT_QTY > ( select sum(WO_QTY) from YEW_WORKorderCutRC_ALL where WAFER_IQC_NO = YWA.WAFER_IQC_NO) "+  //"and IQCD.RECEIPT_QTY > DECODE(YWA.WO_QTY,null,0,YWA.WO_QTY) ";
		                 orderCutRC = "order by INSPECT_DATE ";
		
		                 if (runCardGet!=null && !runCardGet.equals(""))	 whereCutRC = whereCutRC + " and IQCD.SUPPLIER_LOT_NO not in ("+runCardGet+") "; // ���e�w�b�M�椺��WaferLot���o�X�{ 
		
		                 // if (invItem!=null && !invItem.equals("")) whereCutRC = whereCutRC + "and IQCD.INV_ITEM = '"+invItem+"' ";
		                 // if (itemDesc!=null && !itemDesc.equals("")) whereCutRC = whereCutRC + "and INV_ITEM_DESC = '"+itemDesc+"' ";
		                 // out.println("waferResist="+waferResist);
		                 if (waferResist!=null && !waferResist.equals("") && !waferResist.equals("--")) whereCutRC = whereCutRC + "and ( IQCH.WF_RESIST = '"+waferResist+"' or IQCH.WF_RESIST like '%"+waferResist+"%' )   ";
		                 if (diceSize!=null && !diceSize.equals("")  && !diceSize.equals("--")) whereCutRC = whereCutRC + "and ( IQCD.DICE_SIZE= '"+diceSize+"' or IQCD.DICE_SIZE like '%"+diceSize+"%' ) ";
		            
					     if (supplierLot!=null && !supplierLot.equals("")) whereCutRC = whereCutRC + "and ( IQCD.SUPPLIER_LOT_NO= '"+supplierLot+"' or IQCD.SUPPLIER_LOT_NO like '%"+supplierLot+"%' ) ";

		                 // �ݭn�אּ���S�w���� SELECT /*+ ORDERED index(a QP_PRICING_ATTRIBUTES_N8)  */						  	 
		                 if (searchString =="%" || searchString.equals("%") || searchString.equals("--"))			
		                 {  
		                    whereCutRC = whereCutRC + " and (IQCD.SUPPLIER_LOT_NO like '%') ";		                   
		                 }
		                 else 
		                 { 						   		                   
						   whereCutRC = whereCutRC + "  and ( upper(IQCD.INV_ITEM) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM) like '"+searchString.toUpperCase()+"%'  "+ 
					                                 "         OR upper(IQCD.INV_ITEM_DESC) = '"+searchString.toUpperCase()+"' or upper(IQCD.INV_ITEM_DESC) like '"+searchString.toUpperCase()+"%' "+
									                 "         OR upper(IQCD.SUPPLIER_LOT_NO) = '"+searchString.toUpperCase()+"' or upper(IQCD.SUPPLIER_LOT_NO) like '"+searchString.toUpperCase()+"%' ) ";
	                     } 		
						 
					 //  �����Ʀs�ܼȦs��_�_ 	
					 // *********** Step2. ���ѲĤ@��������զX�g�J�Ȧs��					 
					 sqlCutRC = sqlCutRC + whereCutRC + orderCutRC;	 
					 //out.println("sqlCutRC"+sqlCutRC);
					 
					 Statement statePrev=con.createStatement();
				     ResultSet rsPrev=statePrev.executeQuery(sqlCutRC);				   
				     while (rsPrev.next())
					 {					 
					      // �� Item Where Use�� Procedure_�_
				          String prevSubItem = rsPrev.getString("INV_ITEM").substring(0,3);			  
			              //out.println("prevSubItem ="+prevSubItem);			  
			              CallableStatement csBOMInfo = con.prepareCall("{call TSC_BOM_IMPLODER_PARENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
	                      csBOMInfo.setInt(1,Integer.parseInt(organizationId)); 
			              csBOMInfo.setString(2,woType);
	                      csBOMInfo.setInt(3,rsPrev.getInt("INV_ITEM_ID")); 
	                      csBOMInfo.setString(4,prevSubItem);                 // ��l���Ƹ��e�T�X( �P�w 11-, 10- �� 1A- )
	                      csBOMInfo.registerOutParameter(5, Types.INTEGER);   // �^�� Parent Item ID
	                      csBOMInfo.registerOutParameter(6, Types.VARCHAR);   // �^�� Parent Inv Item
	                      csBOMInfo.registerOutParameter(7, Types.VARCHAR);   // �^�� Parent Item Desc
	                      csBOMInfo.registerOutParameter(8, Types.VARCHAR);   // �^�� Error Message
	                      csBOMInfo.registerOutParameter(9, Types.VARCHAR);   // �^�� Error Code
						  csBOMInfo.registerOutParameter(10, Types.INTEGER);  // �^�� ���� SEQUENCE ID
						  csBOMInfo.setString(11,"");                         // ������Sort Code���^ ������T
						  csBOMInfo.setString(12,rsPrev.getString("WAFERLOT"));   // ��Wafer Lot
						  csBOMInfo.setString(13,rsPrev.getString("WAFERIQCNO")); // ��IQC No.
						  csBOMInfo.setInt(14,rsPrev.getInt("LINE_NO"));          // ��IQC Line No.
						  csBOMInfo.setString(15,"FAKE");                         // �w���d��
	                      csBOMInfo.execute();
			              int parentInvItemID = csBOMInfo.getInt(5);
	                      String parentInvItem = csBOMInfo.getString(6);     //  �^�� REQUEST ���檬�p
	                      String parentItemDesc = csBOMInfo.getString(7);
	                      String errorMessage = csBOMInfo.getString(8);      //  �^�� REQUEST ���檬�p
	                      String errorCode = csBOMInfo.getString(9);         //  �^�� REQUEST ���檬�p�T��
						  int seqID = csBOMInfo.getInt(10);	                 // �^�� ���� SEQUENCE ID
	                      //out.println("Procedure : Execute Success Procedure Get Item Where Used !!!<BR>");
	                      csBOMInfo.close(); 
					 } // End of while
					 rsPrev.close();
					 statePrev.close();
				    //  �����Ʀs�ܼȦs��_��   	 
					
					// Step3. �A�զX�@��sql�ѼȦs���o�쪺���s���_�_
					   
					// Step3. �A�զX�@��sql�ѼȦs���o�쪺���s���_��	 		      
		            sqlCutRC = " select DISTINCT decode(YBI.ORGANIZATION_ID,'326','���P','327','�~�P') as ���~�P, IQC_RESULT as RESULT, IQC_WAFER_LOT as WAFERLOT, YRA.RUNCARD_NO as ���άy�{�d��, YRA.COMPLETION_QTY as ���άy�{�d���u��, "+
					           "        QRY_INV_ITEM as INV_ITEM, REPLACE(QRY_ITEM_DESC,'"+"\""+"',' inch ') as INV_ITEM_DESC, IQC_INSP_NO as WAFERIQCNO, "+
							   "        IQC_VENDOR_NAME as SUPPLIER_SITE_NAME, IQC_YIELD as TOTAL_YIELD, IQC_WAFER_TYPE as WF_TYPE_NAME, IQC_WAFER_RESIST as WF_RESIST , "+
							   "        IQC_UOM as UOM, QRY_ITEM_ID as INV_ITEM_ID, IQC_LINE_NO as LINE_NO, IQC_INSPDATE as INSPECT_DATE, IQC_WAFER_AMP as WAFER_AMP, "+
						 	   "        PARENT_ITEM_ID, PARENT_INV_ITEM, PARENT_ITEM_DESC "+
							   "   from YEW_BOM_IMPL_TEMP YBI,  YEW_WORKORDER_ALL YWA, YEW_RUNCARD_ALL YRA ";
					whereCutRC =	"  where YBI.ORGANIZATION_ID = "+organizationId+" "+	
					                "    and YWA.WAFER_LOT_NO = YBI.IQC_WAFER_LOT  "+	
									"    and YWA.WO_NO = YRA.WO_NO "+  // �u�O�άy�{�d
									"    and YRA.STATUSID >= '048' and YWA.WORKORDER_TYPE = '1' "+  // �w�g�J�w�����Τu�O														 
							        "    and YBI.QUERY_TYPE = 'FAKE'  "+ //
							     //   "    and length(YBI.PARENT_INV_ITEM) = 13 and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151225 liling add 1B
							        "    and length(YBI.PARENT_INV_ITEM) IN (13, 16,17 ,20) and substr(YBI.PARENT_INV_ITEM,1,3) not in ('11-','10-','1A-','1B-')  ";   //20151225 liling add 1B 	,20170922 ADD 16	 ,20171005 ADD 20							 
					orderCutRC = "order by INV_ITEM, INSPECT_DATE, WAFERLOT ";
		sqlCutRC = sqlCutRC + whereCutRC + orderCutRC;	
		//out.println("<BR>sqlCutRC="+sqlCutRC); 		 
        ResultSet rsCutRC=stateCutRC.executeQuery(sqlCutRC);
		//out.println("sqlCutRC="+sqlCutRC);       		
	    ResultSetMetaData md=rsCutRC.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE cellSpacing='1' bordercolordark='#996666' cellPadding='1' width='97%' align='left' borderColorLight='#ffffff' border='0'>");      
        out.println("<TR BGCOLOR='#CCCC99'><TD nowrap><FONT>&nbsp;</TD><TD nowrap><FONT COLOR=BROWN>����</TD>");        
        for (int i=1;i<=colCount;i++) // ����ܲĤ@����, �G for �� 2�}�l
        {
		  if (i==6)
		  {
		     if (woType.equals("2")) // �e�q�u�O�A�h�a�@���άy�{�d��
		     {
		      //out.println("<TD nowrap><FONT COLOR=BLUE><strong>���άy�{�d��"+"</strong></TD>");
			     out.println("<TD nowrap><FONT COLOR=BROWN>�Ѿl��"+"</TD>");
			     out.println("<TD nowrap><FONT COLOR=BLUE><strong>�s���b���~��"+"</strong></TD>");
				 out.println("<TD nowrap><FONT COLOR=BROWN>�i�δ�����"+"</TD>");
		     }
		  }
		 //if (i==11) out.println("<TD nowrap><FONT COLOR=BROWN>�Ѿl��"+"</TD>");
         colLabel[i]=md.getColumnLabel(i);
		 if (i==4) colLabel[i]="<font color=BLUE face='Georgia'><strong>"+colLabel[i]+"</strong></font>";
		 out.println("<TD nowrap><FONT COLOR=BROWN>"+colLabel[i]+"</TD>");
		  
        } //end of for 
        out.println("</TR>");
		String description=null;      		
        String buttonContent=null;
		String trBgColor = "";
		String GRAINQTY = null;
		int j = 0; //������
		float sumWOCretedQty = 0;
		float accAvailQty = 0;
		float sumWOCretedQty1 = 0;
		float accAvailQty1 = 0;
		    String cutAsbItemId = "";
			String cutAsbInvItem = "";
			String cutAsbItemDesc = "";
			String subAsbItemId = "";
			String subAsbInvItem = "";
			String subAsbItemDesc = "";
			String waferLotTmp = null; // �C�����쪺Lot ���Ȧs
			String cutAsbInvItemTmp = null; 
			float cutterWoQty = 0; // ���άq�u�O���X��
        while (rsCutRC.next())
		{ 
		    String chkCutAsbFlag = "N";
			String chkSubAsbFlag = "N";		
			String IQCItemList = "IQC�Ƹ���T<BR>"; 
			
			// �C��̼t�ӧ帹_�_
			   String cutWoList = "�w�}�e�q�u�O<BR>";			   
			   Statement stateWOLst=con.createStatement();
		       String sqlWoLst = "select DISTINCT WO_NO||'(�ƶq='||WO_QTY||',��Ӷq='||WO_UNIT_QTY||')' from YEW_WORKORDER_ALL "+
		                         " where STATUSID!='050' and WAFER_LOT_NO = '"+rsCutRC.getString("WAFERLOT")+"' "+
								//  " and INV_ITEM= '"+rsCutRC.getString("INV_ITEM")+"' "+  // �������C��w�}���Τu�O��(���ި��h�@���@�ӻs���~,�u�n�Ω�e�q�u�O)
								 " and WO_NO in (select EXTEND_NO from YEW_MFG_TRAVELS_ALL where PRIMARY_NO='"+rsCutRC.getString(3)+"') "+
		                         " and WORKORDER_TYPE = '2' "; // �̤��Τu�O�μt�ӧ帹��X�֭p�w�}�ƶq	 
		        //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsWOLst=stateWOLst.executeQuery(sqlWoLst);
		       while (rsWOLst.next()) 
			   {
			     cutWoList = cutWoList + rsWOLst.getString(1)+"<BR>";
			   }
		       rsWOLst.close();
		       stateWOLst.close();
			   if (cutWoList.equals("�w�}�e�q�u�O<BR>"))  cutWoList = "�w�}�e�q�u�O<BR>�L";
			// �C��̼t�ӧ帹_��
			
			// �C���IQC���ʶR�Ƹ�_�_			   
			   Statement stateIQCLst=con.createStatement();
		       String sqlIQCLst = "select INV_ITEM_ID||'(�Ƹ�='||INV_ITEM||')' from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL  "+
		                         " where SUPPLIER_LOT_NO = '"+rsCutRC.getString("WAFERLOT")+"' and INSPLOT_NO='"+rsCutRC.getString("WAFERIQCNO")+"' "+
								 "   and LINE_NO= '"+rsCutRC.getString("LINE_NO")+"' ";		                      
		       //out.println("sqlWoCr="+sqlWoCr+"<BR>");
		       ResultSet rsIQCLst=stateIQCLst.executeQuery(sqlIQCLst);
		       if (rsIQCLst.next()) 
			   {
			     IQCItemList = rsIQCLst.getString(1);
			   }
		       rsIQCLst.close();
		       stateIQCLst.close();			   
			   //if (IQCItemList.equals("IQC���ƮƸ�<BR>")) IQCItemList = "�w�}���Τu�O<BR>�L";
	    	// �C���IQC���ʶR�Ƹ�_�� 
			
				  int parentInvItemID = rsCutRC.getInt("PARENT_ITEM_ID");
	              String parentInvItem = rsCutRC.getString("PARENT_INV_ITEM");      //  �^�� REQUEST ���檬�p
	              String parentItemDesc = rsCutRC.getString("PARENT_ITEM_DESC"); 			
			
			      result=rsCutRC.getString("RESULT");
		          waferLot=rsCutRC.getString("WAFERLOT");
				  GRAINQTY=rsCutRC.getString("GRAINQTY");		
		          invItem=rsCutRC.getString("INV_ITEM");
		          itemDesc=rsCutRC.getString("INV_ITEM_DESC");	
		          waferVendor=rsCutRC.getString("SUPPLIER_SITE_NAME");
				  frontRunCard=rsCutRC.getString(5);
 		          cutterWoQty=rsCutRC.getFloat(6); //rsCutRC.getFloat("COMPLETION_QTY"); // WO RUNCARD_NO ���u�ƶq
		          waferUom=rsCutRC.getString("UOM");
		          waferYld=rsCutRC.getString("TOTAL_YIELD");
		          waferElect=rsCutRC.getString("WF_RESIST");
		          waferIqcNo=rsCutRC.getString("WAFERIQCNO");	
		          waferKind=rsCutRC.getString("WF_TYPE_NAME");
		          itemId=rsCutRC.getString("INV_ITEM_ID");	
		          waferLineNo=rsCutRC.getString("LINE_NO");
		          waferAmp=rsCutRC.getString("WAFER_AMP");		  
				  
				 
				   // 2006/12/16 Fix By Kerwin  �H Item Where Used ��Procedure ���s���~����T
		         if (parentInvItemID!=0)
				 {
				    subAsbItemId = Integer.toString(parentInvItemID) ; 
			        subAsbInvItem = parentInvItem;
			        subAsbItemDesc = parentItemDesc;
			        itemId = subAsbItemId;
			        invItem = subAsbInvItem;
			        itemDesc = subAsbItemDesc;	
					chkSubAsbFlag = "Y";				 
			      } else if (parentInvItemID==0 || parentInvItem=="" || parentInvItem.equals(""))
				         {				  
				            chkSubAsbFlag = "N";		
						 }    	
						 
						 
				  // �֥[���Τw�}�u�O���w�}��_�_
				  
		          Statement stateWOCr=con.createStatement();
		          String sqlWoCr = "select SUM(WO_QTY*WO_UNIT_QTY) from YEW_WORKORDER_ALL "+
		                           " where STATUSID!='050' and WAFER_LOT_NO = '"+rsCutRC.getString("WAFERLOT")+"' "+
							       //"   and INV_ITEM= '"+subAsbInvItem+"' "+  // �������H��u�O�ɶ}���֭p�ƶq
							       "   and WO_NO in (select EXTEND_NO from YEW_MFG_TRAVELS_ALL where PRIMARY_NO='"+rsCutRC.getString(3)+"')"; // "RUNCARD_NO"
		          if (woType!=null) sqlWoCr = sqlWoCr+ " and WORKORDER_TYPE in ('2') "; // �̤��Τu�O�μt�ӧ帹��X�֭p�w�}�ƶq	 
			              
		          //out.println("<BR>sqlWoCr="+sqlWoCr+"<BR>");
		          ResultSet rsWOCr=stateWOCr.executeQuery(sqlWoCr);
		          if (rsWOCr.next()) sumWOCretedQty = rsWOCr.getFloat(1);
		          rsWOCr.close();
		          stateWOCr.close(); 	 
		          // �֥[���Τw�}�u�O���w�}��_��	
				  
				 //  ******#$$$$&&&&&$$$$$$ �p��i�ξl�B $$$$$$$$$$$$&&&&&&&&77 ********* //
				   accAvailQty =  cutterWoQty - sumWOCretedQty;  // �i�}��Ѿl�� = ���Χ��u(�u�O)�� - �ֿn�u��}�߼�
				   //out.println("cutterWoQty="+cutterWoQty+"<BR>");
				   //out.println("sumWOCretedQty="+sumWOCretedQty+"<BR>");
				   //out.println("accAvailQty="+accAvailQty+"<BR>");
				 //  ******#$$$$&&&&&$$$$$$ �p��i�ξl�B $$$$$$$$$$$$&&&&&&&&77 ********* //  
				 
				 defaultWoQty=Float.toString(accAvailQty); // ���o���i�}�߼�	
				 waferQty = Float.toString(cutterWoQty);// ����Τu�O�Ʒ��������ɼ�		 
									 
				 //��p�q���
		         String sqla1= " select PRIMARY_UNIT_OF_MEASURE WOUOM  from apps.mtl_system_items_b "+
					           "    where Organization_id=43  and segment1= '"+invItem +"'";
	             Statement statea1=con.createStatement();
                 ResultSet rsa1=statea1.executeQuery(sqla1);
		         //out.print("sqla1="+sqla1);
    	         if (rsa1.next())
		         { 	woUom   = rsa1.getString("WOUOM");   }
	             rsa1.close();
                 statea1.close();		 
				
				 out.print("<TR BGCOLOR='"+"#D2D0AA"+"'><TD nowrap>");		
		
		         if (accAvailQty>0)  // if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦ��C(������,���L�k�I���a�J�s)
	             { 
		            if ( (waferLot!=waferLotTmp && !waferLot.equals(waferLotTmp) ) || (cutAsbInvItem!=cutAsbInvItemTmp && !cutAsbInvItem.equals(cutAsbInvItemTmp)) )// �i��BOM ���@�ӥH�W���s���~��,�Y�O,�h�Ǹ����֥[
		            {
		                j++; // ������
		            }
		            %>
		             <INPUT TYPE=button NAME='button' VALUE='�a�J' onClick='sendToMainWindow("<%=j%>","<%=waferLot%>","<%=invItem%>","<%=itemDesc%>","<%=waferVendor%>","<%=waferQty%>","<%=waferUom%>","<%=waferYld%>","<%=waferElect%>","<%=waferIqcNo%>","<%=waferKind%>","<%=itemId%>","<%=woUom%>","<%=waferLineNo%>","<%=accAvailQty%>","<%=woType%>","<%=frontRunCard%>","<%=chkCutAsbFlag%>","<%=chkSubAsbFlag%>","<%=waferAmp%>")'>
		            <%
		         }  // end of if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦC(������,���L�k�I���a�J�s)
		         else { 
		                 // j--; //���p�J
		                out.println("<em><font color='#FF0000'>�L�l�B</font></em>");
			          }
		if (accAvailQty1<0)
		        out.println("<em><font color='#FF0000'>�L�l�B</font></em>");
		        out.print("</TD>");		
		        out.print("<TD>"+j+"</TD>");
                for (int i=1;i<=colCount;i++) // ����ܲĤ@����, �G for �� 2�}�l
                {
				   			
		            if (i==6) //�e�q�u�O�A�h�a�@���άy�{�d��_�_
		            {
			          if (woType.equals("2")) // �e�q�u�O�A�h�a�@���άy�{�d��
		              { 
					    if (accAvailQty<0) accAvailQty = 0;
		                // out.println("<TD nowrap><FONT COLOR=BLUE face='Georgia'><strong>"+cutterRCNo+"</strong></TD>");
						 out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
					     out.println("<TD nowrap><FONT COLOR=BLUE face='Georgia'><strong>"+subAsbInvItem+"</strong></TD>");
						 out.println("<TD nowrap><FONT>"+accAvailQty1+"</TD>");
		              }
		            } // �e�q�u�O�A�h�a�@���άy�{�d��_��		 
		 
		           //if (i==11) out.println("<TD nowrap><FONT>"+accAvailQty+"</TD>");
                   String s=(String)rsCutRC.getString(i);
				   if (i==3)
				   {
					  s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=200;this.T_OPACITY=80;return escape("+'"'+cutWoList+'"'+")'>"+s+"</a></strong></font>";
				   }
				   if (i==4) s="<font color=BLUE face='Georgia'><strong>"+s+"</strong></font>";
				   else if (i==8)
				        {
						   s="<font color=BLUE face='Georgia'><strong><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+IQCItemList+'"'+")'>"+s+"</a></strong></font>";
						}
                   out.println("<TD nowrap><FONT>"+s+"</TD>");
               } //end of for
          out.println("</TR>");	
		  
	      //	 }  // end of if (accAvailQty>0) �p�G�Ѿl�i�}�߼� > 0�~��ܦC(��Ƥ]�����)
		  // %%%%%%%%%%%%%%%%%%%%%%
		  waferLotTmp = waferLot; // �����帹���Ȧs
		  cutAsbInvItemTmp = cutAsbInvItem; // �s���~�����Ȧs 
		  // %%%%%%%%%%%%%%%%%%%%%%       
        
		 
	   } // end of while
	   out.println("</TABLE>");		        			 
	   rsCutRC.close();  	
	  } // End of if (woType.equals("2"))	   	 
      stateCutRC.close();
    } //end of try
    catch (Exception e)
    {
       out.println("Exception:"+e.getMessage());
    }
  
  %>
  
 <%
     // �@���d�ߧR����ITEM WHERE USER �g�J��TEMP Table_�_	         
	    PreparedStatement stmtDelTmp=con.prepareStatement("delete from APPS.YEW_BOM_IMPL_TEMP ");  			        
	           stmtDelTmp.executeUpdate();
               stmtDelTmp.close();	 
     // �@���d�ߧR����ITEM WHERE USER �g�J��TEMP Table_��
 %>
<!--%���Ѽ�%-->
<input type="hidden" name="WOTYPE" value="<%=woType%>">
<input type="hidden" name="ORGANIZATIONID" value="<%=organizationId%>">
<input type="hidden" name="MARKETTYPE" value="<%=marketType%>">
<input type="hidden" name="WFRESIST" value="<%=waferResist%>">
<input type="hidden" name="DICESIZE" value="<%=diceSize%>">
</FORM>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
</body>
</html>
