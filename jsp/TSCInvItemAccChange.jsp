<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>Work Order Information List</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function submitCheck(ms1,ms2,ms3)
{         
  return(true);  
}
function setSubmit1(URL)
{ //alert(); 
  document.DISPLAYREPAIR.action=URL;
  document.DISPLAYREPAIR.submit();
}
function setSubmit2(URL)
{ 
  var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  document.DISPLAYREPAIR.submit();    
}
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
    String actionID = request.getParameter("ACTIONID"); 
	String invItem=request.getParameter("INVITEM");
	String itemId=request.getParameter("ITEMID");	
	String itemDesc=request.getParameter("ITEMDESC");		
	String organizationId=request.getParameter("ORGANIZATION_ID");	
    String userName=request.getParameter("USER_NAME");
    String colorStr="#FFFFFF";

   String expenseDept="",newExpDept="",newExpAcc="",expSeg1="",expSeg2="";
   String cstDept="",newCstDept="",newCstAcc="",cstSeg1="",cstSeg2="";
   String salesDept="",newSalesDept="",newSalesAcc="",salesSeg1="",salesSeg2="";
   int expCCID=0,cstCCID=0,salesCCID=0;
   

    int lineIndex = 1;
	int k=1;	


%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="../jsp/TSCINVItemAccChange.jsp" METHOD="post" NAME="DISPLAYREPAIR">
<!--=============以下區段為取得工令設立基本資料==========-->
<!--%@ include file="/jsp/include/TSCMfgWoBasicInfoPageV2.jsp"%-->
<!--=================================-->
<%
if (actionID=="1" || actionID.equals("1"))
{
//產生新的會計科目組合,insert into 至temp table
   try
   {

     out.print("Start Update Account****<br>");  
     String sqlOp = " select ORGANIZATION_ID,INVENTORY_ITEM_ID,EXPENSE_ACCOUNT_O,substr(EXPENSE_ACCOUNT_O,7,3) EXPENSE_DEPT, "+
                    "       substr(EXPENSE_ACCOUNT_O,1,6) EXP_SEG1,substr(EXPENSE_ACCOUNT_O,10) EXP_SEG2 , "+
                    "       substr(COST_OF_SALES_ACCOUNT_O,7,3) CST_DEPT, substr(COST_OF_SALES_ACCOUNT_O,1,6) CST_SEG1,substr(COST_OF_SALES_ACCOUNT_O,10) CST_SEG2, "+
                    "       substr(SALES_ACCOUNT_O,7,3) SALES_DEPT, substr(SALES_ACCOUNT_O,1,6) SALES_SEG1,substr(SALES_ACCOUNT_O,10) SALES_SEG2 "+
 				    "   from TSC_ITEM_ACCOUNT_CHANGE_TEMP where (  substr(SALES_ACCOUNT_O,11,1) in (4,5,6,7,8)   or   "+
                   "     substr(EXPENSE_ACCOUNT_O,11,1) in (4,5,6,7,8) or substr(COST_OF_SALES_ACCOUNT_O,11,1) in (4,5,6,7,8) ) ";

	 out.print("<br>sqlOp ="+sqlOp);
	 Statement stateOp=con.createStatement();
     ResultSet rsOp=stateOp.executeQuery(sqlOp);
	 while (rsOp.next())
	 { 	
		    organizationId  = rsOp.getString("ORGANIZATION_ID"); 
	        itemId          = rsOp.getString("INVENTORY_ITEM_ID");
			expenseDept     = rsOp.getString("EXPENSE_DEPT");
	        expSeg1         = rsOp.getString("EXP_SEG1");
			expSeg2         = rsOp.getString("EXP_SEG2");

			cstDept     = rsOp.getString("CST_DEPT");
	        cstSeg1         = rsOp.getString("CST_SEG1");
			cstSeg2         = rsOp.getString("CST_SEG2");

			salesDept     = rsOp.getString("SALES_DEPT");
	        salesSeg1         = rsOp.getString("SALES_SEG1");
			salesSeg2         = rsOp.getString("SALES_SEG2");

   //抓取新的部門代號
       String rlsqlb= " select dp1.NEW_DEPT as NEW_EXP_DEPT ,dp2.NEW_DEPT as  NEW_CST_DEPT, dp3.NEW_DEPT as  NEW_SALES_DEPT "+
                      "   from tsc_dept_refence dp1 ,tsc_dept_refence dp2,tsc_dept_refence dp3 "+
                	  "  where dp1.old_dept= '"+expenseDept+"' and dp2.old_dept= '"+cstDept+"' and dp3.old_dept= '"+salesDept+"' ";
         out.print("<br>org="+organizationId+"item="+itemId+" "+rlsqlb);

        Statement rlid=con.createStatement();	   
	    ResultSet rsId=rlid.executeQuery(rlsqlb);
	    if (rsId.next())
	     {
	         newExpDept   = rsId.getString("NEW_EXP_DEPT");
             newCstDept   = rsId.getString("NEW_CST_DEPT");
             newSalesDept   = rsId.getString("NEW_SALES_DEPT");

        	 newExpAcc = expSeg1+newExpDept+expSeg2;  //新的expense會計科目
 	         newCstAcc = cstSeg1+newCstDept+cstSeg2;  //新的cost_sales會計科目
 			 newSalesAcc = salesSeg1+newSalesDept+salesSeg2;  //新的sales acc會計科目

         out.print("<br>org="+organizationId+"item="+itemId+" expacc"+newExpAcc);

	         String rcSqla="  update TSC_ITEM_ACCOUNT_CHANGE_TEMP  set EXPENSE_ACCOUNT_N=?,COST_OF_SALES_ACCOUNT_N=?,SALES_ACCOUNT_N=?  "+
    	                   "   where organization_id = '"+organizationId+"' and inventory_item_id= '"+itemId+"' "; 	
    	     PreparedStatement rcStmta=con.prepareStatement(rcSqla);           
		     rcStmta.setString(1,newExpAcc); 
    	     rcStmta.setString(2,newCstAcc);
    	     rcStmta.setString(3,newSalesAcc);	   	  
    	     rcStmta.executeUpdate();   
    	     rcStmta.close(); 
	     } 
         else {out.print("<br>"+rlsqlb);}
		 rsId.close();
		 rlid.close();
      k=k+1;
    out.print("<br>k="+k);
	 } //end of while
	 rsOp.close();
     stateOp.close(); 
   }// end of try
   catch (Exception e)
   {
     out.println("Exception 3:"+e.getMessage());
   }		

out.print("<br>******update EXPENSE_ACCOUNT_N success!!*********<br>");
}//enf of actionID=1
if (actionID=="2" || actionID.equals("2"))
{
//更新CCID至TEMP TABLE
k=1;
   try
   {
    out.print("Start Update CCID****<br>");
     String sqla = " select  ORGANIZATION_ID,INVENTORY_ITEM_ID,EXPENSE_ACCOUNT_N,COST_OF_SALES_ACCOUNT_N,SALES_ACCOUNT_N from TSC_ITEM_ACCOUNT_CHANGE_TEMP " +
                   "  where  STEP='A'  ";

	 out.print("sqla ="+sqla);
	 Statement stateOpa=con.createStatement();
     ResultSet rsOpa=stateOpa.executeQuery(sqla);
	 while (rsOpa.next())
	 { 	
		    organizationId  = rsOpa.getString("ORGANIZATION_ID"); 
	        itemId          = rsOpa.getString("INVENTORY_ITEM_ID");
			newExpAcc       = rsOpa.getString("EXPENSE_ACCOUNT_N");
            newCstAcc       = rsOpa.getString("COST_OF_SALES_ACCOUNT_N");
            newSalesAcc       = rsOpa.getString("SALES_ACCOUNT_N");


      String rlsqlbb= "   SELECT  Gl_Code_Combinations_Pkg.Get_Ccid(chart_of_accounts_id, SYSDATE, '"+newExpAcc+"') EXP_CCID, "+
                      "    Gl_Code_Combinations_Pkg.Get_Ccid(chart_of_accounts_id, SYSDATE, '"+newCstAcc+"') CST_CCID, "+
                      "    Gl_Code_Combinations_Pkg.Get_Ccid(chart_of_accounts_id, SYSDATE, '"+newSalesAcc+"') SALES_CCID "+
    				 "     FROM hr_operating_units hou, gl_sets_of_books gsob  "+
   					 "    WHERE hou.set_of_books_id = gsob.set_of_books_id  AND hou.organization_id = 41 ";

         out.print("<br>org="+organizationId+" item="+itemId+"  newExpAcc="+newExpAcc+"  newCstAcc="+newCstAcc+" newSalesAcc="+newSalesAcc);

        Statement rlidb=con.createStatement();	   
	    ResultSet rsIdb=rlidb.executeQuery(rlsqlbb);
	    if (rsIdb.next())
	     {
	        expCCID   = rsIdb.getInt("EXP_CCID");  
            cstCCID   = rsIdb.getInt("CST_CCID");
            salesCCID   = rsIdb.getInt("SALES_CCID");

            String rcSqlb="  update TSC_ITEM_ACCOUNT_CHANGE_TEMP  set EXPENSE_ACCOUNT_ID=? , COST_OF_SALES_ACCOUNT_ID=? , SALES_ACCOUNT_ID = ? ,step=2 "+
                          "   where organization_id = '"+organizationId+"' and inventory_item_id= '"+itemId+"' "; 	
            PreparedStatement rcStmtb=con.prepareStatement(rcSqlb);           
	        rcStmtb.setInt(1,expCCID); 
            rcStmtb.setInt(2,cstCCID);
            rcStmtb.setInt(3,salesCCID);
	   	  
            rcStmtb.executeUpdate();   
            rcStmtb.close();
            out.print("updated!!");

	     } 
		 rsIdb.close();
		 rlidb.close();
      k=k+1;
    out.print("<br>k="+k);
	 } //end of while
	 rsOpa.close();
     stateOpa.close(); 

   }// end of try
   catch (Exception e)
   {
     out.println("Exception CCID:"+e.getMessage());
   }
out.print("<br>******update EXPENSE_ACCOUNT_ID success!!*********");
}//end of actionID=2
%>
<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->
<BR>
<!-- 表單參數 --> 
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
