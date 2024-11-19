<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<%@ page import="java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>




<!--=================================-->
</head>

<body>
<%
    String prodnum=null;
	   int genqty=0; 
	   String sgendate=null; 
	   String sgendatebeg=null; 	  
	   float genplan=0; 
	   float genwqty=0; 
	   float genmqty=0; 	      
	   float prodstk=0; 
	   String weekend=null; 
	   String monthend=null;			

	 try 
         {		
	     String sqld="delete from Genprod";   
         PreparedStatement dstmt=dmcon.prepareStatement(sqld);      
         dstmt.executeUpdate();           
         dstmt.close();
		  
		  Statement statement=bpcscon.createStatement();
	      ResultSet rs=statement.executeQuery("select TPROD,TQTY,TTDTE from ith where ttype='R' and TPROD like '%0%' and TPROD like '0%' ");
	      while(rs.next())
	   {
	       prodnum=rs.getString("TPROD");
		   genqty= rs.getInt("TQTY");
		   sgendate= rs.getString("TTDTE");	   
		    //out.println(sgendate); 		  
		 
		   sgendatebeg=sgendate.substring(0,6)+"01";  	   
		    int  yy = dateBean.getYear();
			//out.println(yy+"currentYear"); 
            int  mm = dateBean.getMonth();
			//out.println(mm+"currentMonth"); 
            int diff_y = 0;
            int diff_m = 0;
            int  iweek = 0;
			int  dd = dateBean.getDay();
		    int gendate=Integer.parseInt(sgendate); 
			//String[] w={"日","一","二","三","四","五","六"}; 
			String sYear=sgendate.substring(0,4); 
			String sMonth=sgendate.substring(4,6); 
			String sDay=sgendate.substring(6); 			
			int nYear=Integer.parseInt(sYear); 			
			int nMonth=Integer.parseInt(sMonth);
			int nMonth2=Integer.parseInt(sMonth)-1;
			int nDay=Integer.parseInt(sDay);
		       
			    //out.println(diff_y+"adyear"); 
			    //out.println(diff_m+"admonth"); 
	       /* if (diff_yy == 0)  //同年
                { 
				   dateBean.setAdjMonth(diff_mm);
		           day=dateBean.getMaxDay();
				   //dateBean.setAdjMonth(0-diff_mm);
				 } 
			else if (diff_yy < 0)  //前 xx 年
                  {
                  dateBean.setAdjYear(diff_yy);
                  dateBean.setAdjMonth(diff_mm);
		          day=dateBean.getMaxDay();
				  //dateBean.setAdjMonth(0-diff_mm);
				  }		
			
			out.println(day); 			
			if(nDay==day)
			{monthend="Y";}*/			
			Calendar calendar=new GregorianCalendar(nYear,nMonth2,nDay); 						
	        int dayofweek=calendar.get(Calendar.DAY_OF_WEEK);
			if(dayofweek==7)
			{weekend="Y";} 
			//out.println(dayofweek); 			
	        //out.println(w[dayofweek-1]); 
			int nMinDay=nDay- (dayofweek-1); 
			String sMinDay=null; 
			String sWeekBeginDate=null; 
			//out.println(nMinDay+"week"); 
			if (nMinDay<10  & nMinDay>0)
			{
			 sMinDay= "0"+ Integer.toString(nMinDay);
			}
			else if(nMinDay>=10)
			{
			 sMinDay=  Integer.toString(nMinDay);
			}
			else if(nMinDay<=0)
		    {  //out.println(nYear+"dbYear"); 			
	        	diff_y = nYear - yy;  // 年度與目前差異數
            	diff_m =nMonth - mm-1;  //月份與目前月份差異數            
			    //out.println(diff_y+"adyear"); 
			    //out.println(diff_m+"admonth"); 
	            if (diff_y == 0)  //同年
                {  
				   
				   dateBean.setAdjMonth(diff_m);
		           dd=dateBean.getMaxDay();
		           dateBean.setAdjMonth(0-diff_m);
				    //out.println(dd+"day"); 
				   if (nMonth==1)
					{nYear=nYear-1; }
					 nMonth=nMonth-1; 
					 if(nMonth==0)
					 {nMonth=12; }
					 nMinDay=dd+nMinDay; 
					 //out.println(nMinDay+"8888888"); 
					 sMinDay=  Integer.toString(nMinDay);
		          }
                 
                 else  if (diff_y < 0)  //前 xx 年
                  {
                  //dateBean.setAdjYear(diff_y);
                  dateBean.setAdjMonth(diff_m);
		          dd=dateBean.getMaxDay();
		          dateBean.setAdjMonth(0-diff_m);
				   if (nMonth==1)
					{nYear=nYear-1; }
					 nMonth=nMonth-1; 
					  if(nMonth==0)
					 {nMonth=12; }
					 nMinDay=dd+nMinDay; 
					// out.println(nMinDay+"666666"); 
					 sMinDay=  Integer.toString(nMinDay);
		          }
		 }
	       
			  sYear=Integer.toString(nYear); 
			  sMonth=Integer.toString(nMonth); 
			  sDay=Integer.toString(nDay); 
			  if (nMonth<10 &nMonth>0)
			  {sMonth="0"+sMonth; }
			  sWeekBeginDate=sYear+sMonth+sMinDay; 
			  //out.println(sWeekBeginDate+"***********"); 
			//out.println(sMinDay); 			
	        //out.println(sWeekBeginDate); 
			//int gendate=Integer.parseInt(sgendate); 
		   
		  Statement statement2=bpcscon.createStatement();
		  String sSql="select SUM(SQREQ)  as genplan "+" "+
		                    "from fso  "; 
		  String sWhere="where  SPROD='"+prodnum+"'  AND SRDTE BETWEEN '"+sgendatebeg+"' AND '"+sgendate+"'  "; 
		  String sOrderTC = "order by 1";
	      sSql=sSql+sWhere+sOrderTC; 
	     // out.println(sSql);      					 
	      ResultSet rs2=statement2.executeQuery(sSql);
		  if(rs2.next())
		  { 
		    genplan= rs2.getFloat("genplan");
			Statement statement3=bpcscon.createStatement();
			String sSql2="select sum(lopb-lissu+ladju+lrct)  as prodstk "+" "+
		                    "from ili  "; 
		    String sWhere2="where lprod='"+prodnum+"' and  LLCC<='"+sgendate+"' "; 
		    String sOrderTC2 = "order by 1";
	         sSql2=sSql2+sWhere2+sOrderTC2; 
	        // out.println(sSql);      					 
	        ResultSet rs3=statement3.executeQuery(sSql2);
			if(rs3.next())
			{
			prodstk= rs3.getFloat("prodstk");
			Statement statement4=bpcscon.createStatement();
			String sSql3="select Sum(TQTY) as genmqty "+" "+
		                       "from ith " ; 
		    String sWhere3="where ttype='R'  and TPROD like '0%' and  TPROD='"+prodnum+"' and  TTDTE BETWEEN '"+sgendatebeg+"' AND '"+sgendate+"' "; 
		    String sOrderTC3 = "order by 1";
	         sSql3=sSql3+sWhere3+sOrderTC3; 
	        //out.println(sSql3);      					 
	        ResultSet rs4=statement4.executeQuery(sSql3);
			if(rs4.next())
			{		
			genmqty=rs4.getFloat("genmqty");
			Statement statement5=bpcscon.createStatement();
			String sSql4="select Sum(TQTY) as genwqty "+" "+
		                       "from ith " ; 
		    String sWhere4="where ttype='R'  and TPROD like '0%' and  TPROD='"+prodnum+"' and  TTDTE BETWEEN '"+sWeekBeginDate+"' AND '"+sgendate+"' "; 
		    String sOrderTC4 = "order by 1";
	         sSql4=sSql4+sWhere4+sOrderTC4; 
	        out.println(sSql4);      					 
	        ResultSet rs5=statement5.executeQuery(sSql4);
			if(rs5.next())
			{		
			genwqty=rs5.getFloat("genwqty");
			 
			//out.println(genwqty); 
		   String sql="insert into Genprod(prodnum,genplan,genqty,gendate,genwqty,genmqty,prodstk,weekend,monthend) values(?,?,?,?,?,?,?,?,?)";
		   //out.println(genplan); 
		    //out.println(prodstk); 
            PreparedStatement genstmt=dmcon.prepareStatement(sql);   
            genstmt.setString(1,prodnum);
            genstmt.setFloat(2,genplan);
            genstmt.setInt(3,genqty); 
            genstmt.setInt(4,gendate); 
			genstmt.setFloat(5,genwqty);
			genstmt.setFloat(6,genmqty);			
            genstmt.setFloat(7,prodstk);      
			genstmt.setString(8,weekend);
			genstmt.setString(9,monthend);      
            genstmt.executeUpdate();		  
		    genstmt.close();   
		    	}
			 statement5.close();
	         rs5.close();
			}
			 statement4.close();
	         rs4.close();		 
		   }
		   statement3.close();
	       rs3.close();
         }
		statement2.close();
	    rs2.close();	
        }
	   statement.close();
	   rs.close();

 } //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>

<!--=================================-->
</html>
