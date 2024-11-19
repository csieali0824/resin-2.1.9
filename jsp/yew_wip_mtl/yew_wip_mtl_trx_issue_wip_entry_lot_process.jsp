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
String sql="";
int i, j;

int orgid=Integer.parseInt(request.getParameter("orgid"));
int item_id=Integer.parseInt(request.getParameter("item_id"));
int trx_id=Integer.parseInt(request.getParameter("trx_id"));
int lot_num= Integer.parseInt(request.getParameter("lot_num"));

String[]  lot;
lot = new String[lot_num];
float[]  lot_qty;
lot_qty = new float[lot_num];

for (i=0;i<lot_num;i++)
{
	lot[i]=request.getParameter("lot"+(i+1));
	lot_qty[i]=Float.parseFloat(request.getParameter("lot_qty"+(i+1)));
}

//檢查傳遞值
out.println("orgid="+orgid+"<br>");
out.println("item_id="+item_id+"<br>");
out.println("lot_num="+lot_num+"<br>");
for (i=0;i<lot_num;i++)
{
	out.println("lot"+(i+1)+"="+lot[i]+"<br>");
	out.println("lot_qty"+(i+1)+"="+lot_qty[i]+"<br>");
}
out.println("userMfgUserID="+userMfgUserID+"<br>");

try
{
	//先刪除yew_wip_mtl_trx_temp
	sql="";
	sql=sql+"DELETE FROM YEW_WIP_MTL_LOTS_TEMP WHERE CREATED_BY = "+Integer.parseInt(userMfgUserID)+" ";
	prestatement=con.prepareStatement(sql); 
	prestatement.executeUpdate();
	prestatement.close();	      	
	
	for (i=0;i<lot_num;i++)
	{
		if (lot_qty[i]>0)
		{
			//建立yew_wip_mtl_trx_temp
			sql="";
			sql=sql+"INSERT INTO YEW_WIP_MTL_LOTS_TEMP ";
			sql=sql+"	(TRX_ID, LOT_NUMBER, INVENTORY_ITEM_ID, ORGANIZATION_ID, LAST_UPDATE_DATE,   ";
			sql=sql+"		LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, TRANSACTION_QUANTITY) ";
			sql=sql+"	VALUES(?,?,?,?,sysdate,?,sysdate,?,?) ";
			prestatement=con.prepareStatement(sql); 
			prestatement.setInt(1,trx_id);    //TRX_ID
			prestatement.setString(2,lot[i]);    //LOT_NUMBER
			prestatement.setInt(3,item_id);      //INVENTORY_ITEM_ID
			prestatement.setInt(4,orgid); //ORGANIZATION_ID
			prestatement.setInt(5,Integer.parseInt(userMfgUserID));      //LAST_UPDATED_BY
			prestatement.setInt(6,Integer.parseInt(userMfgUserID));      //CREATED_BY    
			prestatement.setFloat(7,-lot_qty[i]); //TRANSACTION_QUANTITY        	   
			prestatement.executeUpdate();
			prestatement.close();	   
		}   	
	}
}
catch(Exception e)
{
	e.printStackTrace();
	out.println("<script language='javascript'>alert('"+e.getMessage()+"');</script>");
}

%>
<script language="javascript">
	window.close();
</script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->


