<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>

<%   
Statement statement;
PreparedStatement prestatement;
ResultSet rs;
String sql="";
int trx_id=0;

int orgid=Integer.parseInt(request.getParameter("orgid"));
int item_id=Integer.parseInt(request.getParameter("item_id"));
int wipid=Integer.parseInt(request.getParameter("wipid"));
String wono=request.getParameter("wono");
String uom=request.getParameter("uom");
String num=request.getParameter("num");

//檢查傳遞值
//*
out.println("orgid="+orgid+"<br>");
out.println("item_id="+item_id+"<br>");
out.println("wipid="+wipid+"<br>");
out.println("wono="+wono+"<br>");
out.println("uom="+uom+"<br>");
out.println("num="+num+"<br>");
out.println("userMfgUserID="+userMfgUserID+"<br>");
//*/

try
{
		//建立yew_wip_mtl_trx_temp
		sql="";
		sql=sql+"INSERT INTO YEW_WIP_MTL_TRX_TEMP ";
		sql=sql+"	(TRX_ID, INVENTORY_ITEM_ID, ORGANIZATION_ID, LAST_UPDATE_DATE, LAST_UPDATED_BY, ";
		sql=sql+"		CREATION_DATE, CREATED_BY, WIP_ENTITY_ID, WIP_ENTITY_NAME, TRANSACTION_UOM, ";
		sql=sql+"		TRANSACTION_QUANTITY) ";
		sql=sql+"	VALUES(seq_yew_wip_mtl_trx.nextval,?,?,sysdate,?,sysdate,?,?,?,?,0) ";
		prestatement=con.prepareStatement(sql); 
		prestatement.setInt(1,item_id);    //INVENTORY_ITEM_ID
		prestatement.setInt(2,orgid);    //ORGANIZATION_ID
		prestatement.setInt(3,Integer.parseInt(userMfgUserID));      //LAST_UPDATED_BY
		prestatement.setInt(4,Integer.parseInt(userMfgUserID)); //CREATED_BY
		prestatement.setInt(5,wipid);      //WIP_ENTITY_ID
		prestatement.setString(6,wono);      //WIP_ENTITY_NAME    
		prestatement.setString(7,uom); //TRANSACTION_UOM        	   
		prestatement.executeUpdate();
		prestatement.close();	      	
	
		//抓取寫入yew_wip_mtl_trx_temp的transaction_id
		sql = "SELECT seq_yew_wip_mtl_trx.CURRVAL FROM DUAL";
		statement=con.createStatement();
		rs=statement.executeQuery(sql);
		if (rs.next())
		{
			trx_id = rs.getInt(1);
		}
		rs.close();
		statement.close();
}
catch(Exception e)
{
	e.printStackTrace();
	out.println("<script language='javascript'>alert('"+e.getMessage()+"');</script>");
}

%>
<script language="javascript">
	window.opener.MYFORM.trx_id<%=num%>.value = <%=trx_id%>;
	window.close();
</script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->


