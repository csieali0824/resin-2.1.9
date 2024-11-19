<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=======To get Connection from different DB======-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp" %>
<%@ page import="DateBean" %>
<jsp:useBean  class="DateBean" id="dateBean" scope="page"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BPCS 財務部門費用(管報)--結轉程式</title>
<script language="JavaScript" type="text/javascript">
function setSubmit(URL) 
 {
   sYn="Y";
   document.MYFORM.action=URL;
   document.MYFORM.submit();
 }
</script>
</head>


<body>
<form action="../jsp/BPCSFinExpMonthClose.jsp" method="post" name="MYFORM">
<p><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font> 
      <font face="Arial Black" size="+2" color="#000000"><strong>BPCS 財務部門費用管報--結轉程式</strong></font> 

<%

  String sYn="Y";
  String sToday=dateBean.getYearMonthDay();
  int nYearToday=Integer.parseInt(sToday.substring(0,4));
  int nMonthToday=Integer.parseInt(sToday.substring(4,6)) -1;
  if (nMonthToday==0) {
    nYearToday=nYearToday-1;
	nMonthToday=12;
   } 
  out.println("月結年/月: "+nYearToday+"/"+nMonthToday);
   
  String sSqlBuDesc="",sSqlDeptDesc="",sSqlSubDept2="",sSqlSubDept3="",sSqlJou="",sSqlInsert="",sSqlJou1="",sSqlInsert1="";
  String sBu="",sBuDesc="",sDept="",sDeptDesc="",sDeptItem="",sSubDept2="",sSubDept3="",sClass="",sClass4="";
  int nGroup,nYear,nPerd,nAmount;
  ResultSet rsBuDesc,rsDeptDesc,rsSubDept2,rsSubDept3,rsJou,rsJou1;
 
  try
    {
	 if (sYn.equals("Y")) {
      String sSqlDel="DELETE FROM monthexp WHERE myear="+nYearToday+" AND mperd="+nMonthToday+" ";
	  PreparedStatement ptbpcsment1=bpcscon.prepareStatement(sSqlDel);
	  ptbpcsment1.executeUpdate();
	  ptbpcsment1.close();
	
	  String sSqlDept ="SELECT busi as BUSI, dept as DEPT,group as GROUP FROM ac7  ORDER BY group ";
	  PreparedStatement ptbpcsment=bpcscon.prepareStatement(sSqlDept);
	  ResultSet rsDept =ptbpcsment.executeQuery();
	  while(rsDept.next()) {
		 sBu=(rsDept.getString("BUSI")).trim();
		 sDept=(rsDept.getString("DEPT")).trim();
		 nGroup=rsDept.getInt("GROUP");
		 sDeptItem="\'"+sDept+"\'";
		 
		 //抓 Bu Desc
		 sBuDesc="";
		 sSqlBuDesc="SELECT svldes as BUDESC FROM gsvbu WHERE  svsgvl='"+sBu+"' ";
		 ptbpcsment1=bpcscon.prepareStatement(sSqlBuDesc);
		 rsBuDesc=ptbpcsment1.executeQuery();
		 if (rsBuDesc.next()) {
		     sBuDesc=rsBuDesc.getString("BUDESC");
		   }
		 ptbpcsment1.close();
		 rsBuDesc.close();
		
		 //抓 Dept Desc
		 sDeptDesc="";
		 sSqlDeptDesc="SELECT svldes as DEPTDESC FROM gsvdept WHERE  svsgvl='"+sDept+"' ";
		 ptbpcsment1=bpcscon.prepareStatement(sSqlDeptDesc);
		 rsDeptDesc=ptbpcsment1.executeQuery();
		 if (rsDeptDesc.next()) {
		    sDeptDesc=rsDeptDesc.getString("DEPTDESC");
	      }
		 ptbpcsment1.close();
		 rsDeptDesc.close();
		
		//查詢此bu,dept是否有第二階部門
	     sSqlSubDept2 ="SELECT DISTINCT  dept2 as DEPT2 FROM ac3 a3,al2 WHERE a3.ledger3=al2.ledger2 AND a3.book3=al2.book2 "+
		                          "AND a3.busi=al2.busi1 AND a3.dept=al2.dept1 AND a3.ledger3='DBELGR'  AND a3.book3='DBEACT' "+
		  					  	  "AND a3.busi='"+sBu+"' AND a3.dept='"+sDept+"' ";
	     //out.println(sSqlSubDept2);
         ptbpcsment1=bpcscon.prepareStatement(sSqlSubDept2);
	     rsSubDept2 =ptbpcsment1.executeQuery();
	     while (rsSubDept2.next()) {
		     sSubDept2=(rsSubDept2.getString("DEPT2"));
			 sDeptItem=sDeptItem+","+"\'"+sSubDept2+"\'";
		   }
		 ptbpcsment1.close();
		 rsSubDept2.close();
		 
		 //查詢此bu,dept是否有第三階部門
	     sSqlSubDept3 ="SELECT DISTINCT  dept3 as DEPT3 FROM ac3 a3,al3 WHERE a3.ledger3=al3.ledger3 AND a3.book3=al3.book3 "+
		                          "AND a3.busi=al3.busi1 AND a3.dept=al3.dept1 AND a3.ledger3='DBELGR'  AND a3.book3='DBEACT' "+
								  "AND a3.busi='"+sBu+"' AND a3.dept='"+sDept+"' ";
	     //out.println(sSqlSubDept3);
		 ptbpcsment1=bpcscon.prepareStatement(sSqlSubDept3);
	     rsSubDept3 =ptbpcsment1.executeQuery();
		 while (rsSubDept3.next()) {
		     sSubDept3=(rsSubDept3.getString("DEPT3"));
			 sDeptItem=sDeptItem+","+"\'"+sSubDept3+"\'";
		   }
		 ptbpcsment1.close();
		 rsSubDept3.close();
		 //out.println("sDeptItem"+sDeptItem);

		 sSqlJou ="SELECT jxyear as YEAR,jxperd as PERD,desc2[1,2] as CLASS,class4 as CLASS4,SUM(j.jeamt-jbamt) as AMOUNT FROM jou j,ac2 a2,ac3 a3,ac4 WHERE j.jxldgr='DBELGR' AND j.jxbook='DBEACT' "+
		                 "AND j.jxyear ="+nYearToday+" AND  j.jxperd="+nMonthToday+" AND j.jxldgr=a2.ledger2 AND a2.ledger2=a3.ledger3 "+
		                 "AND j.jxbook=a2.book2 AND a2.book2=a3.book3 AND a2.code2=a3.code2  AND j.jxsg02=a3.code3 AND j.jxsg02[1,1]='6' "+
						 "AND j.jxsg03=a3.busi AND a3.dept ='"+sDept+"' AND j.jxsg03='"+sBu+"' AND j.jxsg04 IN("+sDeptItem+") "+
						 "AND j.jxsg02=ac4.code4 GROUP BY jxyear,jxperd,desc2,class4"  ;
		//out.println("sSqlJou"+sSqlJou);
		ptbpcsment1=bpcscon.prepareStatement(sSqlJou);
		rsJou=ptbpcsment1.executeQuery();
		while (rsJou.next()) {
		    nYear=rsJou.getInt("YEAR");
			nPerd=rsJou.getInt("PERD");
		    sClass=rsJou.getString("CLASS");
			sClass4=rsJou.getString("CLASS4");
			nAmount=rsJou.getInt("AMOUNT");
			
			if (sBu.equals("3") && sDept.equals("31")) {
			    sDeptDesc="製造費用";
			  }//end of if 
			
			sSqlInsert="INSERT INTO monthexp (myear,mperd,mbu,mbudesc,mdept,mdeptdesc,mdgroup,mclass,mclass4,mamt) VALUES (?,?,?,?,?,?,?,?,?,?)";
			//out.println("sSqlInsert"+sSqlInsert);
			ptbpcsment1=bpcscon.prepareStatement(sSqlInsert);
			ptbpcsment1.setInt(1,nYear);
			ptbpcsment1.setInt(2,nPerd);
			ptbpcsment1.setString(3,sBu);
			ptbpcsment1.setString(4,sBuDesc);
			ptbpcsment1.setString(5,sDept);
			ptbpcsment1.setString(6,sDeptDesc);
			ptbpcsment1.setInt(7,nGroup);
			ptbpcsment1.setString(8,sClass);
			ptbpcsment1.setString(9,sClass4);
			ptbpcsment1.setInt(10,nAmount);
			ptbpcsment1.executeUpdate();
		  }
		ptbpcsment1.close();
		rsJou.close();
		
	    if (sBu.equals("3") && sDept.equals("31")) {
		   sSqlJou1 ="SELECT jxyear as YEAR,jxperd as PERD,class4 as CLASS4,SUM(j.jeamt-jbamt) as AMOUNT FROM jou j,ac2 a2,ac4 WHERE j.jxldgr='DBELGR' AND j.jxbook='DBEACT' "+
		                    "AND j.jxyear="+nYearToday+" AND  j.jxperd="+nMonthToday+" AND j.jxldgr='DBELGR' AND j.jxbook='DBEACT' "+
		                    "AND j.jxldgr=a2.ledger2  AND j.jxbook=a2.book2  AND j.jxsg02[1,2]='54' and j.jxsg02 not in('549800','549900') "+
						    "AND j.jxsg02=a2.code2 AND j.jxsg02=ac4.code4 GROUP BY jxyear,jxperd,class4"  ;
		   //out.println("sSqlJou"+sSqlJou1);
		   PreparedStatement ptbpcsment2=bpcscon.prepareStatement(sSqlJou1);
		   rsJou1 =ptbpcsment2.executeQuery();
		   while (rsJou1.next()) {
		        nYear=rsJou1.getInt("YEAR");
			    nPerd=rsJou1.getInt("PERD");
		        sClass4=rsJou1.getString("CLASS4");
		    	nAmount=rsJou1.getInt("AMOUNT");
	
		        sSqlInsert1="INSERT INTO monthexp (myear,mperd,mbu,mbudesc,mdept,mdeptdesc,mdgroup,mclass,mclass4,mamt) VALUES (?,?,?,?,?,?,?,?,?,?)";
		        //out.println("sSqlInsert"+sSqlInsert1);
		        ptbpcsment2=bpcscon.prepareStatement(sSqlInsert1);
		        ptbpcsment2.setInt(1,nYear);
		        ptbpcsment2.setInt(2,nPerd);
		        ptbpcsment2.setString(3,sBu);
		        ptbpcsment2.setString(4,sBuDesc);
		        ptbpcsment2.setString(5,sDept);
		        ptbpcsment2.setString(6,"直接人工");
		        ptbpcsment2.setInt(7,nGroup);
		        ptbpcsment2.setString(8,"製");
		        ptbpcsment2.setString(9,sClass4);
		        ptbpcsment2.setInt(10,nAmount);
		        ptbpcsment2.executeUpdate();
			  }
		   ptbpcsment2.close();
		   rsJou1.close();
		  }//end of if bu=3 and dept=31
		   
	    }//end of if rsDept
	  ptbpcsment.close();
	  rsDept.close();
      out.println("<br>Finished!!</br>");
	 }//end of if sYn
	 else {sYn="Y";}
	}//end of try
  

  catch (Exception e) {
      out.println("Exception :"+e.getMessage());
	}

%>

<p><input type="submit" name="Submit" value="執行結轉" onClick="'return Submit("../jsp/BPCSFinExpMonthClose.jsp")'" ></p></form>
</body>
</html>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp" %>