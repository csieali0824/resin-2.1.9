<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.util.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*" %>
<%@ page import="DateBean"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ACpageByModelDb.jsp</title>
</head>
<body topmargin="0">
<%
     String MPROJ=request.getParameter("MPROJ");
     String YEARFR=request.getParameter("YEARFR");
     String MONTHFR=request.getParameter("MONTHFR");
     String RCTPSGet="";
     int RCTPlight=0;
     int COUNTnu=0;
	 String dateBeginString = "";
	 String dateEndString = "";
	 
	 dateBeginString =  YEARFR +  MONTHFR + "01";
	 dateEndString =  YEARFR +  MONTHFR + "31";
	
%>
<%
         
      try
     {     		
		    String sSqlTP = "select distinct MITEM from PRODMODEL where  MPROJ='"+MPROJ+"' ";
            Statement stment=con.createStatement();
            ResultSet rsRCTP = stment.executeQuery(sSqlTP);
			String RCTPString = "";
			while(rsRCTP.next())
			{
			   RCTPString =rsRCTP.getString("MITEM");
			   RCTPSGet = RCTPSGet+"'"+RCTPString+"'"+",";
			   //out.print(RCTPSGet);
			}
			 RCTPlight=RCTPSGet.length()-1;
			 RCTPSGet = RCTPSGet.substring(0, RCTPlight);
			//out.print(RCTPSGet);
			rsRCTP.close();
			stment.close();
 
          // Eod for Top 10
   
  
          JdbcCategoryDataset dataSet=new JdbcCategoryDataset(con);
 
          String sql = "select substr(MCARTON_NO,9,8) as MCARTON_NO, count(IMEI) as COUNT from MES_WIP_TRACKING  ";
          String sWhere = "where GROUP_NAME = 'AC_PACKING' "+
                                    "and to_char(IN_STATION_TIME,'YYYYMMDD') between '"+dateBeginString+"' and '"+dateEndString+"'  "+
								    "and MODEL_NAME in("+RCTPSGet+") ";
          String sOrder = "group by substr(MCARTON_NO,9,8) order by substr(MCARTON_NO,9,8) desc ";
   
          sql = sql + sWhere + sOrder;
  
          dataSet.executeQuery(sql);
		  
		  out.println(sql);
		    
          JFreeChart chart=null;
          chart = ChartFactory.createVerticalBarChart("MES AC LINE:"+MPROJ+"�C��Ͳ��ƶq��", "", "", dataSet, true);

 
          chart.setBackgroundPaint(new GradientPaint(0, 0, new Color(220,190,140), 0, 300,new Color(200,230,205)));
  
         CategoryPlot plot = chart.getCategoryPlot();
  
         plot.setNoDataMessage("�S��������T");
  
         plot.setSeriesPaint(0,new Color(80,120,140));
         //plot���έp�Ϥ���bar,��setSeriesPaint�]�w�C��bar���C��,�]�i�κ��h��

        plot.setLabelFont(new Font("sansserif",Font.PLAIN,10));
        plot.setLabelPaint(Color.red);
        plot.setLabelsVisible(true);
        //�]�w�C�ڴδΤW���O�_�n�X�{�Ʀr,�H�γ]�w�r�Τ��C��

       ValueAxis va=plot.getRangeAxis();
       va.setUpperMargin(0.1);
       plot.setRangeAxis(va);
       //�]�w�δΪ��W�����,�H�K�S���Ŷ��X�{�Ʀr����

       plot.setCategoryGapsPercent(0.4);
       //�]�w�C�ڴδΪ��e��,�H�K�δΤӭD�F
       out.clearBuffer();
      OutputStream ostream = response.getOutputStream();
      ChartUtilities.writeChartAsJPEG(ostream, chart, 540, 400);
       //ChartUtilities.saveChartAsJPEG(new File("c:\\time_chart"+"003"+".jpg"), chart, 400, 300);
       ostream.close();

      } // End of Try
      catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());   
     }   
  
%>
  <!--=============�H�U�Ϭq������s����==========-->
  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <!--=================================-->

  </p>
</body>
</html>