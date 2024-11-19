<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="BpcsBean" %>
<jsp:useBean id="bpcsBean" scope="page" class="BpcsBean"/>
<%@ page import="RsCountBean" %>
<jsp:useBean id="rsCountBean" scope="page" class="RsCountBean"/>

<%
String modelNo = request.getParameter("MODELNO");
String prodNo = request.getParameter("PRODNO");
String tableItem="tmpitem";
String tableModel="tmpmodel";
PreparedStatement stItem = null;
PreparedStatement stModel = null;
try {
	
	String sql ="";
	stItem = dmcon.prepareStatement("CREATE GLOBAL TEMPORARY TABLE "+tableItem+" (tmodel varchar2(15),titem varchar2(15)) ON COMMIT DELETE ROWS");
	stItem.executeUpdate();
	stItem.close();

	stModel = dmcon.prepareStatement("CREATE GLOBAL TEMPORARY TABLE "+tableModel+" (tmodel varchar2(15),titem varchar2(15)) ON COMMIT DELETE ROWS");
	stModel.executeUpdate();
	stModel.close();
	
/*	stModel = dmcon.prepareStatement("DELETE FROM "+tableModel);
	stModel.executeUpdate();
	stModel.close();
*/
	//取得全系列機種
	sql = "";
	if (modelNo!=null) {
	sql = " AND mproj='"+modelNo+"' ";
	}
	PreparedStatement stM = con.prepareStatement("SELECT DISTINCT mproj AS mproj FROM prodmodel "+
	" WHERE rflag=1 AND mcountry='886' "+sql+" ORDER BY mproj ");
	ResultSet rsM = stM.executeQuery();
	while (rsM.next()) {
		stItem = dmcon.prepareStatement("DELETE FROM "+tableItem);
		stItem.executeUpdate();
		stItem.close();

		sql = "";
		if (prodNo!=null) {
			sql = " AND mitem='"+prodNo+"' ";
		}
		PreparedStatement stN = con.prepareStatement("SELECT mproj,mitem FROM prodmodel "+
		" WHERE rflag=1 AND mcountry='886' AND mproj='"+rsM.getString("mproj")+"' "+sql+
		" ORDER BY mproj,mitem ");
		ResultSet rsN = stN.executeQuery();
		while (rsN.next()) {
			String model = rsN.getString("mproj");
			String item = rsN.getString("mitem");
			out.println("<br>"+"MODEL="+model+" ITEM="+item);
			//展BOM, 取採購件的電子料
			bpcsBean.setConnection(bpcscon);
			String a[][] = bpcsBean.getStructure(item,"","","1");
			stItem = dmcon.prepareStatement("INSERT INTO "+tableItem+" (tmodel,titem) VALUES (?,?)");
			for (int j=0;j<a.length;j++) {
				if ( (a[j][13].equals("R")||a[j][13].equals("C")) && a[j][14].equals("EX")) {
					//out.println("<br>"+a[j][4]+" "+a[j][9]+" "+a[j][12]);
					stItem.setString(1,model);
					stItem.setString(2,a[j][4]);
					stItem.executeUpdate();				
				}
			}
			stItem.close();
		} // end while rsN
		rsN.close();
		rsN.close();
		//同一機種取一筆
		stModel = dmcon.prepareStatement("INSERT INTO "+tableModel+" (tmodel,titem) VALUES (?,?)");
		stItem = dmcon.prepareStatement("SELECT DISTINCT tmodel,titem FROM "+tableItem+" ");
		ResultSet rsItem = stItem.executeQuery();
		while (rsItem.next()) {
			//out.println();
			stModel.setString(1,rsItem.getString("tmodel"));
			stModel.setString(2,rsItem.getString("titem"));
			stModel.executeUpdate();
		} // end while rsItem
		stItem.close();
		rsItem.close();
		stModel.close();
		
	} // end while rsM
	rsM.close();
	stM.close();
	
	//找唯一值
	stModel = dmcon.prepareStatement("SELECT titem FROM "+tableModel+" GROUP BY titem HAVING count(*)=1",ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
	ResultSet rsModel = stModel.executeQuery();
	rsCountBean.setRs(rsModel);
	int cnt =rsCountBean.getRsCount();
	out.println("<br>"+"Record Count="+cnt);
	String a[] = new String [cnt];
	int i=0;
	while (rsModel.next()) {
		a[i] = rsModel.getString("titem").trim();
		//out.println("<br>"+" "+a[i]);
		i++;
	} // end while rsModel
	rsModel.close();
	stModel.close();

	String today = dateBean.getYearMonthDay();
	stItem = dmcon.prepareStatement("DELETE FROM matestockdif");
	stItem.executeUpdate();
	stItem.close();


	if (a.length>0) {
		String where = "";
		for (int j=0;j<cnt;j++) {
			//out.println("<br>"+" "+a[j]);
			where = where + ",'"+a[j]+"'";
		}
		
		where = "  (" + where.substring(1,where.length()) + ") ";
		//out.println("<br>"+where);
		stItem = dmcon.prepareStatement("INSERT INTO matestockdif (fmodelno,fitemno,fdate,fcst,famt,fqty) VALUES (?,?,?,?,?,?)");
		stModel = dmcon.prepareStatement("SELECT tmodel,titem FROM "+tableModel+" WHERE titem IN "+where);
		rsModel = stModel.executeQuery();
		while (rsModel.next()) {
			String cst = "0";
			String amt = "0";
			String qty = "0";
			
			PreparedStatement st = bpcscon.prepareStatement("SELECT cftlvl+cfplvl AS cst FROM cmf WHERE cffac='' AND cfcset=2 AND cfcbkt=1 AND cfprod='"+rsModel.getString("titem")+"' ");
			ResultSet rs = st.executeQuery();
			if (rs.next()) {
				cst = rs.getString("cst");
			}
			rs.close();
			st.close();
			
			st = bpcscon.prepareStatement("SELECT wopb+wrct-wiss+wadj as qty,(wopb+wrct-wiss+wadj)*"+cst+" AS amt FROM iwi WHERE wwhs='01' AND wprod='"+rsModel.getString("titem")+"' ");
			rs = st.executeQuery();
			if (rs.next()) {
				qty = rs.getString("qty");
				amt = rs.getString("amt");
			}
			rs.close();
			st.close();
			
			stItem.setString(1,rsModel.getString("tmodel"));
			stItem.setString(2,rsModel.getString("titem"));
			stItem.setString(3,today);
			stItem.setString(4,cst);
			stItem.setString(5,amt);
			stItem.setString(6,qty);
			stItem.executeUpdate();
		} // end while
		rsModel.close();
		stModel.close();
		stItem.close();
		

	} // end if
	


	
	stModel = dmcon.prepareStatement("DROP TABLE "+tableModel);
	stModel.executeUpdate();
	stModel.close();
	
	stItem = dmcon.prepareStatement("DROP TABLE "+tableItem);
	stItem.executeUpdate();
	stItem.close();


}
catch (Exception e) { out.println("Exception:"+e.getMessage());
	stModel = dmcon.prepareStatement("DROP TABLE "+tableModel);
	stModel.executeUpdate();
	stModel.close();
	
	stItem = dmcon.prepareStatement("DROP TABLE "+tableItem);
	stItem.executeUpdate();
	stItem.close();
}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>差異料統計</title>
</head>

<body>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
