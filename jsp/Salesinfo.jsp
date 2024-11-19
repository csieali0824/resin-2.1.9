<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,DateBean" %>
<!--=============To get the Authentication==========-->
<!--< include file="/jsp/include/AuthenticationPage.jsp"%>-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Salesinfo.jsp</title>
</head>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/>
<jsp:useBean id="tempDateBean" scope="page" class="DateBean"/>
<body>
<%
    String comSql="";
	PreparedStatement pstmt=null;		
    String ilprod="",ccoun="",siprf="",cmprcc="",modelNo="";	
    String tdate=""; //當天日期
	String wthbeg=""; //當週開始日期
	String wk12beg=""; //12週前當週開始日期
    String monthBegin="";		
	int qty=0,net=0;
	int wtotalqty=0;
	long wtotalnet=0;
    int mtotalqty=0;
	int wk12avgqty=0;//12週前累計平均銷售量
	long mtotalnet=0;    
	int dayaverage=0;
    int monthaverage=0;
	int weekaverage=0;
	int qtyFromLaunch=0; //該成品之累積銷售(到今天之前)
	    
	dateBean.setDate(2004,7,1);

  try
  {   
   Statement statement=bpcscon.createStatement();  
   ResultSet rs=null;   
   Statement modelStat=dmcon.createStatement(); 
   ResultSet modelRs=null;
   String thisDay=thisDateBean.getYearMonthDay();
   while (!thisDay.equals(dateBean.getYearMonthDay()))
   {           
   //取當天日期和取,當月01日期,當週開始日期
    tdate=dateBean.getYearMonthDay(); //當天日期
    wthbeg=dateBean.getWeekBeginDate(); //當週開始日期
    monthBegin=dateBean.getYearString()+dateBean.getMonthString()+"01";
	String isMonthEnd="";
	if (dateBean.getDay()==dateBean.getMonthMaxDay()) isMonthEnd="Y";
	String isWeekEnd="";		
	if (dateBean.getDayOfWeek()==7) isWeekEnd="Y"; //7代表禮拜六			 		  	 	  	  	  	  			  	  
	tempDateBean.setDate(dateBean.getYear(),dateBean.getMonth(),dateBean.getDay()); 
	tempDateBean.setAdjWeek(-12); //設為前12週
	wk12beg=tempDateBean.getWeekBeginDate(); //之前第12週之當週開始日期
//////////////////////////////////////////////////////////////////////////////////////////////	  
  
    
    //String sql ="select ilprod,ilcust,ccoun,siprf,cmprcc,sum(ilqty)  qty,sum(ilnet) net from sih h,sil a,iim b,rcm c  where a.ilprod=b.iprod and b.iityp='F' and ilcust=ccust and ildate ='"+tdate+"' and ctype =11 and ihodyr=ilodyr and ihodpx =ilodpx and siinvn=ilinvn  group by 1,2,3,4,5 order by 1,2,3";		 
	String sql ="select ilprod,'5' as ccoun,ilwhs as siprf,'886' as cmprcc,sum(ilqty)  qty,sum(ilnet) net from sih h,sil a,iim b,rcm c  where a.ilprod=b.iprod and b.iityp='F' and ilcust=ccust and ildate ="+tdate+" and ctype =11 and ihodyr=ilodyr and ihodpx =ilodpx and siinvn=ilinvn  group by 1,2,3,4 order by 1,2";
    rs=statement.executeQuery(sql);
      while(rs.next())		 
	 { 
	  qty=0;//歸零
	  net=0;//歸零
      dayaverage=0;//歸零
	 
	  ilprod = rs.getString("ilprod"); 	   
	  modelRs=modelStat.executeQuery("select unique MODELNO from PRODSTRUC where trim(PRODNUM)='"+ilprod.trim()+"'");
	  if (modelRs.next()) 
	  {
	    modelNo=modelRs.getString("MODELNO");	  
	  } else {
	    modelNo="";
	  }	  
	  modelRs.close();
	  ccoun = rs.getString("ccoun"); 
	  siprf = rs.getString("siprf"); 
	  cmprcc = rs.getString("cmprcc"); 
	  qty = rs.getInt("qty"); 
	  net = rs.getInt("net"); 
	  if ( qty!=0) dayaverage=Math.round(net/qty); //日平均售價	 
	 	  	comSql="insert into SALESINFOR(PRODNUM,SALESDIV,SALESTO,SALESOFF,SALESDQTY,SALEDATE,SALESWQTY,SALESMQTY,SALEDPRIC,SALEWPRIC,SALEMPRIC,SALEWCPRIC,SALEMCPRIC,WEEKEND,MONTHEND,TOTSALESQTY,MODELNO,AVG12WKQTY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            pstmt=dmcon.prepareStatement(comSql);
			pstmt.setString(1,ilprod.trim());
			pstmt.setString(2,ccoun);
	        pstmt.setString(3,cmprcc);
	        pstmt.setString(4,siprf);
	        pstmt.setInt(5,qty);
	        pstmt.setString(6,tdate);
	        pstmt.setInt(7,0); //當週累計銷售量
	        pstmt.setInt(8,0); //當月累計銷售量
	        pstmt.setInt(9,dayaverage);
	        pstmt.setInt(10,0);
	        pstmt.setInt(11,0);
	        pstmt.setLong(12,0);//當週累計售價
		    pstmt.setLong(13,0);//當月累計售價
			pstmt.setString(14,isWeekEnd);
			pstmt.setString(15,isMonthEnd);
			pstmt.setInt(16,0);//該成品之累積銷售(到今天之前)
			pstmt.setString(17,modelNo);
			pstmt.setInt(18,0); //前12週平均週累計銷售量
		    pstmt.executeUpdate(); 
			pstmt.close();						
	 }		 
     rs.close();
	
	//計算週的累計 
	 sql ="select ilprod,'5' as ccoun,ilwhs as siprf,'886' as cmprcc,sum(ilqty)  qty,sum(ilnet) net from sih h,sil a,iim b,rcm c  where a.ilprod=b.iprod and b.iityp='F' and ilcust=ccust and ildate between "+wthbeg+" And "+tdate+" and ctype =11 and ihodyr=ilodyr and ihodpx =ilodpx and siinvn=ilinvn  group by 1,2,3,4 order by 1,2";
     rs=statement.executeQuery(sql);
     while(rs.next())
	 {		
	  wtotalqty=0; //歸零
	  wtotalnet=0; //歸零
	  weekaverage=0; //歸零
	  	  
	  ilprod = rs.getString("ilprod");
	  modelRs=modelStat.executeQuery("select unique MODELNO from PRODSTRUC where trim(PRODNUM)='"+ilprod.trim()+"'");
	  if (modelRs.next()) 
	  {
	    modelNo=modelRs.getString("MODELNO");	  
	  } else {
	    modelNo="";
	  }	   	   
	  modelRs.close();
	  ccoun = rs.getString("ccoun"); 
	  siprf = rs.getString("siprf"); 
	  cmprcc = rs.getString("cmprcc"); 
	  wtotalqty = rs.getInt("qty"); 
	  wtotalnet= rs.getInt("net"); 
	  if ( wtotalqty!=0) weekaverage=Math.round(wtotalnet/wtotalqty); //週平均售價	 
	 	  	comSql="insert into SALESINFOR(PRODNUM,SALESDIV,SALESTO,SALESOFF,SALESDQTY,SALEDATE,SALESWQTY,SALESMQTY,SALEDPRIC,SALEWPRIC,SALEMPRIC,SALEWCPRIC,SALEMCPRIC,WEEKEND,MONTHEND,TOTSALESQTY,MODELNO,AVG12WKQTY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            pstmt=dmcon.prepareStatement(comSql);
			pstmt.setString(1,ilprod.trim());
			pstmt.setString(2,ccoun);
	        pstmt.setString(3,cmprcc);
	        pstmt.setString(4,siprf);
	        pstmt.setInt(5,0);
	        pstmt.setString(6,tdate);
	        pstmt.setInt(7,wtotalqty); //當週累計銷售量
	        pstmt.setInt(8,0); //當月累計銷售量
	        pstmt.setInt(9,0);//當日平均售價
	        pstmt.setInt(10,weekaverage);//當週平圴售價
	        pstmt.setInt(11,0);
	        pstmt.setLong(12,wtotalnet);//當週累計售價
		    pstmt.setLong(13,0);//當月累計售價
			pstmt.setString(14,isWeekEnd);
			pstmt.setString(15,isMonthEnd);
			pstmt.setInt(16,0);//該成品之累積銷售(到今天之前)
			pstmt.setString(17,modelNo);
			pstmt.setInt(18,0); //前12週平均週累計銷售量
		    pstmt.executeUpdate(); 
			pstmt.close();						  	  
	 }
	 rs.close();
	 
	 //計算月的累計 
	 sql ="select ilprod,'5' as ccoun,ilwhs as siprf,'886' as cmprcc,sum(ilqty)  qty,sum(ilnet) net from sih h,sil a,iim b,rcm c  where a.ilprod=b.iprod and b.iityp='F' and ilcust=ccust and ildate between "+monthBegin+" And "+tdate+" and ctype =11 and ihodyr=ilodyr and ihodpx =ilodpx and siinvn=ilinvn  group by 1,2,3,4 order by 1,2";
     rs=statement.executeQuery(sql);
     while(rs.next())
	 {		
	  mtotalqty=0; //歸零
	  mtotalnet=0; //歸零
	  monthaverage=0; //歸零
	  
	  ilprod = rs.getString("ilprod"); 	 
	  modelRs=modelStat.executeQuery("select unique MODELNO from PRODSTRUC where trim(PRODNUM)='"+ilprod.trim()+"'");
	  if (modelRs.next()) 
	  {
	    modelNo=modelRs.getString("MODELNO");	  
	  } else {
	    modelNo="";
	  }	    
	  modelRs.close();
	  ccoun = rs.getString("ccoun"); 
	  siprf = rs.getString("siprf"); 
	  cmprcc = rs.getString("cmprcc"); 
	  mtotalqty = rs.getInt("qty"); 
	  mtotalnet = rs.getInt("net"); 
	  if ( mtotalqty!=0)  monthaverage=Math.round(mtotalnet/mtotalqty); //月平均售價	 
	 	  	comSql="insert into SALESINFOR(PRODNUM,SALESDIV,SALESTO,SALESOFF,SALESDQTY,SALEDATE,SALESWQTY,SALESMQTY,SALEDPRIC,SALEWPRIC,SALEMPRIC,SALEWCPRIC,SALEMCPRIC,WEEKEND,MONTHEND,TOTSALESQTY,MODELNO,AVG12WKQTY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            pstmt=dmcon.prepareStatement(comSql);
			pstmt.setString(1,ilprod.trim());
			pstmt.setString(2,ccoun);
	        pstmt.setString(3,cmprcc);
	        pstmt.setString(4,siprf);
	        pstmt.setInt(5,0);
	        pstmt.setString(6,tdate);
	        pstmt.setInt(7,0); //當週累計銷售量
	        pstmt.setInt(8,mtotalqty); //當月累計銷售量
	        pstmt.setInt(9,0);//當日平均售價
	        pstmt.setInt(10,0);
	        pstmt.setInt(11,monthaverage); //當月平圴售價
	        pstmt.setLong(12,0);//當週累計售價
		    pstmt.setLong(13,mtotalnet);//當月累計售價
			pstmt.setString(14,isWeekEnd);
			pstmt.setString(15,isMonthEnd);
			pstmt.setInt(16,0);//該成品之累積銷售(到今天之前)
			pstmt.setString(17,modelNo);
			pstmt.setInt(18,0); //前12週平均週累計銷售量
		    pstmt.executeUpdate(); 
			pstmt.close();							  	  
	 }
	 rs.close();
	 
	  //計算成品之累積銷售(到今天之前)
	 sql ="select ilprod,'5' as ccoun,ilwhs as siprf,'886' as cmprcc,sum(ilqty) qty from sil a,iim b,rcm c  where a.ilprod=b.iprod and b.iityp='F' and ilcust=ccust and ildate <"+tdate+" and ctype =11 and trim(ilprod) in (select trim(ilprod) from sih a,sil b,iim c,rcm d where b.ilprod=c.iprod and c.iityp='F' and b.ilcust=d.ccust and b.ildate ="+tdate+" and d.ctype =11 and a.ihodyr=b.ilodyr and a.ihodpx =b.ilodpx and a.siinvn=b.ilinvn) group by 1,2,3,4 order by 1,2";
     rs=statement.executeQuery(sql);
     while(rs.next())
	 {		
	  qtyFromLaunch=0;//歸零 
	  
	  ilprod = rs.getString("ilprod"); 	  
	  modelRs=modelStat.executeQuery("select unique MODELNO from PRODSTRUC where trim(PRODNUM)='"+ilprod.trim()+"'");
	  if (modelRs.next()) 
	  {
	    modelNo=modelRs.getString("MODELNO");	  
	  } else {
	    modelNo="";
	  }	   
	  modelRs.close();
	  ccoun = rs.getString("ccoun"); 
	  siprf = rs.getString("siprf"); 
	  cmprcc = rs.getString("cmprcc"); 
	  qtyFromLaunch = rs.getInt("qty"); 	  
	 	  	comSql="insert into SALESINFOR(PRODNUM,SALESDIV,SALESTO,SALESOFF,SALESDQTY,SALEDATE,SALESWQTY,SALESMQTY,SALEDPRIC,SALEWPRIC,SALEMPRIC,SALEWCPRIC,SALEMCPRIC,WEEKEND,MONTHEND,TOTSALESQTY,MODELNO,AVG12WKQTY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            pstmt=dmcon.prepareStatement(comSql);
			pstmt.setString(1,ilprod.trim());
			pstmt.setString(2,ccoun);
	        pstmt.setString(3,cmprcc);
	        pstmt.setString(4,siprf);
	        pstmt.setInt(5,0);
	        pstmt.setString(6,tdate);
	        pstmt.setInt(7,0); //當週累計銷售量
	        pstmt.setInt(8,0); //當月累計銷售量
	        pstmt.setInt(9,0);//當日平均售價
	        pstmt.setInt(10,0);
	        pstmt.setInt(11,0); //當月平圴售價
	        pstmt.setLong(12,0);//當週累計售價
		    pstmt.setLong(13,0);//當月累計售價
			pstmt.setString(14,isWeekEnd);
			pstmt.setString(15,isMonthEnd);
			pstmt.setInt(16,qtyFromLaunch);//該成品之累積銷售(到今天之前)
			pstmt.setString(17,modelNo);
			pstmt.setInt(18,0); //前12週平均週累計銷售量
		    pstmt.executeUpdate(); 
			pstmt.close();			  	  				   
	 }
	 rs.close();
	 
	 //計算前12週的累計銷售平均 
	 sql ="select ilprod,'5' as ccoun,ilwhs as siprf,'886' as cmprcc,sum(ilqty) qty from sil a,iim b,rcm c  where a.ilprod=b.iprod and b.iityp='F' and ilcust=ccust and ildate >="+wk12beg+" And ildate<"+wthbeg+" and ctype =11 group by 1,2,3,4 order by 1,2";
     rs=statement.executeQuery(sql);
     while(rs.next())
	 {		
	  wk12avgqty=0; //歸零	  
	  	  
	  ilprod = rs.getString("ilprod");
	  modelRs=modelStat.executeQuery("select unique MODELNO from PRODSTRUC where trim(PRODNUM)='"+ilprod.trim()+"'");
	  if (modelRs.next()) 
	  {
	    modelNo=modelRs.getString("MODELNO");	  
	  } else {
	    modelNo="";
	  }	   	   
	  modelRs.close();
	  ccoun = rs.getString("ccoun"); 
	  siprf = rs.getString("siprf"); 
	  cmprcc = rs.getString("cmprcc"); 
	  wk12avgqty = rs.getInt("qty"); 		 
	 	  	comSql="insert into SALESINFOR(PRODNUM,SALESDIV,SALESTO,SALESOFF,SALESDQTY,SALEDATE,SALESWQTY,SALESMQTY,SALEDPRIC,SALEWPRIC,SALEMPRIC,SALEWCPRIC,SALEMCPRIC,WEEKEND,MONTHEND,TOTSALESQTY,MODELNO,AVG12WKQTY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            pstmt=dmcon.prepareStatement(comSql);
			pstmt.setString(1,ilprod.trim());
			pstmt.setString(2,ccoun);
	        pstmt.setString(3,cmprcc);
	        pstmt.setString(4,siprf);
	        pstmt.setInt(5,0);
	        pstmt.setString(6,tdate);
	        pstmt.setInt(7,0); //當週累計銷售量
	        pstmt.setInt(8,0); //當月累計銷售量
	        pstmt.setInt(9,0);//當日平均售價
	        pstmt.setInt(10,0);//當週平圴售價
	        pstmt.setInt(11,0);
	        pstmt.setLong(12,0);//當週累計售價
		    pstmt.setLong(13,0);//當月累計售價
			pstmt.setString(14,isWeekEnd);
			pstmt.setString(15,isMonthEnd);
			pstmt.setInt(16,0);//該成品之累積銷售(到今天之前)
			pstmt.setString(17,modelNo);
			pstmt.setInt(18,wk12avgqty); //前12週平均週累計銷售量
		    pstmt.executeUpdate(); 
			pstmt.close();						  	  
	 }
	 rs.close();
	dateBean.setAdjDate(1);//增加一天
   } //end of Main Loop	 
   statement.close();	        
   modelStat.close();
   out.println("Calculation Successful!!");
  }
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
%>
</body>
<!--=============釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
