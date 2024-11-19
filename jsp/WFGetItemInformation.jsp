<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.util.*,java.sql.*,java.math.BigDecimal.*,oracle.sql.*,oracle.jdbc.driver.*,oracle.apps.fnd.common.*,oracle.apps.fnd.wf.engine.*,oracle.apps.fnd.wf.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<head>
<script language="JavaScript" type="text/JavaScript">
function setPassWF(URL)
{
   document.WFFORM.action=URL;
   document.WFFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>無標題文件</title>
</head>

<body>
<FORM NAME="WFFORM" ACTION="../jsp/WFGetItemInformation.jsp" METHOD="post">
<%
    String itemType=request.getParameter("ITEMTYPE");  // 傳入要處理的 ITEM TYPE
    String itemKey=request.getParameter("ITEMKEY");    // 傳入要處理的 ITEM KEY
	
	String passFlag = request.getParameter("PASSFLAG");
	//  java.math.BigDecimal myNid = new java.math.BigDecimal(notifyID);
	
	String getActionID = request.getParameter("GETACTIONID");
	
	if (getActionID==null || getActionID.equals("")) getActionID= "0"; 
	if (passFlag==null || passFlag.equals("")) passFlag = "N";
	
	
	  CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	  cs1.setString(1,"41");
	  cs1.execute();
      out.println("Procedure : Execute Success Set Client Info !!! ");
      cs1.close();
	
	 CallableStatement csFnfGlb = con.prepareCall("{call Fnd_Global.APPS_INITIALIZE(?,?,?,?)}");
	 csFnfGlb.setInt(1,3077); 
	 csFnfGlb.setInt(2,50124); 
	 csFnfGlb.setInt(3,660); 
	 csFnfGlb.setInt(4,0);	
	 csFnfGlb.execute();
	 out.println("Procedure : Execute Success Set GLOBAL INITIALIZE !!!<BR>");
	 csFnfGlb.close();	 
	 
	 
	
	 CallableStatement csWFItemInfo = con.prepareCall("{call WF_ENGINE.ItemInfo(?,?,?,?,?,?,?,?)}");
	 csWFItemInfo.setString(1,itemType); 
	 csWFItemInfo.setString(2,itemKey); 
	 csWFItemInfo.registerOutParameter(3, Types.VARCHAR);   //Status
	 csWFItemInfo.registerOutParameter(4, Types.VARCHAR);   //回傳 Result
	 csWFItemInfo.registerOutParameter(5, Types.INTEGER);   //回傳 Action ID
	 csWFItemInfo.registerOutParameter(6, Types.VARCHAR);   // Error Name
	 csWFItemInfo.registerOutParameter(7, Types.VARCHAR);   //回傳 ErrorMessage
	 csWFItemInfo.registerOutParameter(8, Types.VARCHAR);   // 回傳 Error Stack
	 csWFItemInfo.execute();
     
	 String wfStatus = csWFItemInfo.getString(3);
	 String wfResult = csWFItemInfo.getString(4);   //  回傳 REQUEST 執行狀況
	 int actionID = csWFItemInfo.getInt(5);
	 String errorName = csWFItemInfo.getString(6);      //  回傳 REQUEST 執行狀況
	 String errorMessage = csWFItemInfo.getString(7);   //  回傳 REQUEST 執行狀況訊息
	 String errorStack = csWFItemInfo.getString(8);   //  回傳 REQUEST 執行狀況訊息
	 out.println("Procedure : Execute Success Get WorkFlow Item ActionID Information !!!<BR>");
	 csWFItemInfo.close(); 
	 
	 out.println(wfStatus+"<BR>");
	 out.println(wfResult+"<BR>");
	 out.println(actionID+"<BR>");
	 out.println(errorName+"<BR>");
	 out.println(errorMessage+"<BR>");
	 out.println(errorStack+"<BR>"); 
	 
	 if (actionID!=0) getActionID = Integer.toString(actionID);	 
	 
%>
<input name="PassWorkflow" type="button" value="Start Ship" onclick='setPassWF("../jsp/WFGetItemInformation.jsp?ITEMTYPE=<%=itemType%>&ITEMKEY=<%=itemKey%>&GETACTIONID=<%=getActionID%>&PASSFLAG=Y")'/>
<%

   if (getActionID!="0" && passFlag!="N")
   {
    /*
     CallableStatement csWFStShip = con.prepareCall("{call OE_SHIPPING_WF.Start_Shipping(?,?,?,?,?)}");
	 csWFStShip.setString(1,itemType); 
	 csWFStShip.setString(2,itemKey); 
	 csWFStShip.setInt(3,Integer.parseInt(getActionID));
	 csWFStShip.setString(4,"RUN"); // 執行狀態 
	 csWFStShip.registerOutParameter(5, Types.VARCHAR);   //回傳 Result Out Message
	 csWFStShip.execute();
	 String resultMessage = csWFStShip.getString(5);   //  回傳 REQUEST 執行狀況訊息	
	 out.println("Procedure : Execute Success Run WorkFlow OM Shipping By Item !!!<BR>"); 
	 csWFStShip.close(); 
	 
	 out.println("<BR>resultMessage="+resultMessage+"<BR>");
	 */
	 
	 
	 
	 CallableStatement csWFPsShip = con.prepareCall("{call OE_Shipping_Integration_PVT.Process_Shipping_Activity(?,?,?,?,?,?)}");
	 csWFPsShip.setFloat(1,Float.parseFloat("1.0")); 
	 csWFPsShip.setInt(2,Integer.parseInt(itemKey)); 
	 csWFPsShip.registerOutParameter(3, Types.VARCHAR);   // x_result_out
	 csWFPsShip.registerOutParameter(4, Types.VARCHAR);   // x_return_status
	 csWFPsShip.registerOutParameter(5, Types.VARCHAR);   //回傳 Message Count
	 csWFPsShip.registerOutParameter(6, Types.VARCHAR);   //回傳 Message Data
	 csWFPsShip.execute();
	 String resultOut = csWFPsShip.getString(3);       //  回傳 REQUEST 執行狀況訊息
	 String resultStatus = csWFPsShip.getString(4);    //  回傳 Result Status
	 String resultCount = csWFPsShip.getString(5);    //  回傳 Result Status
	 String resultData = csWFPsShip.getString(6);     //  回傳 Result Data
	 out.println("Procedure : Execute Success Run WorkFlow OM Shipping Activity By Item !!!<BR>"); 
	 csWFPsShip.close(); 
	 
	 out.println("<BR>resultOut="+resultOut+"<BR>");
	 out.println("<BR>resultStatus="+resultStatus+"<BR>");
	 out.println("<BR>resultCount="+resultCount+"<BR>");
	 out.println("<BR>resultData="+resultData+"<BR>");
	 
	 CallableStatement csWFCfShip = con.prepareCall("{call OE_Shipping_Integration_PVT.Process_Ship_Confirm(?,?,?)}");	
	 csWFCfShip.setInt(1,Integer.parseInt(itemKey));  // OE_LINE_ID
	 csWFCfShip.setString(2,"STANDARD");  // Process STANDATD LINE
	 csWFCfShip.registerOutParameter(3, Types.VARCHAR);   // x_return_status	
	 csWFCfShip.execute();
	 String resultReturnStatus = csWFCfShip.getString(3);       //  回傳 REQUEST 執行狀況訊息	
	 out.println("Procedure : Execute Success Run WorkFlow OM Process Ship Confirm By Item !!!<BR>"); 
	 csWFCfShip.close(); 
	 
	 out.println("<BR>resultReturnStatus="+resultReturnStatus+"<BR>");
	 
   }
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
