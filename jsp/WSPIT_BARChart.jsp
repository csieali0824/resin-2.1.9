<%@ page contentType="image/jpeg; charset=MS950" language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.util.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%	
  String product=request.getParameter("PRODUCT"); 
  String model=request.getParameter("MODEL"); 
  String object1=request.getParameter("OBJECT"); 
  String version=request.getParameter("VERSION"); 
try
 {
   String sWhere = "PRODUCT='"+product+"'";
   	if (version!=null && !version.equals("--")) sWhere=sWhere+" and T_VERSION='"+version+"'";
	if (model!=null && !model.equals("--")) sWhere=sWhere+" and MODEL='"+model+"'";
	if (object1!=null && !object1.equals("--")) sWhere=sWhere+" and T_OBJECT='"+object1+"'";
      //===============先取得總數
   int totalQty=1;
   Statement statement=statement=con.createStatement();
   String rsSql="select count(*) AS CNT from pit_master  WHERE " + sWhere  +"";
   ResultSet rs=statement.executeQuery(rsSql);
   if (rs.next())
   {
     totalQty=rs.getInt("CNT");
   }   
   rs.close();
   statement.close();
   //===================================================   

  JdbcCategoryDataset dataSet=new JdbcCategoryDataset(con);

  String sql="select mfunction,ROUND((count(mfunction)/"+totalQty+")*100,1) AS CNT from pit_master a WHERE " + sWhere +
			 " GROUP BY mfunction ORDER BY mfunction DESC ";
 
  dataSet.executeQuery(sql);
  
  JFreeChart chart=null;
  chart = ChartFactory.createVerticalBarChart("版本:"+version, "功能", "比率(%)", dataSet, true); 
  //設定背景顏色,GradientPaint為漸層色,若要設定單一顏色,可用
 chart.setBackgroundPaint(new GradientPaint(0, 0, new Color(163,202,214), 0, 300,new Color(252,203,252)));
  
  CategoryPlot plot = chart.getCategoryPlot();
  
  plot.setNoDataMessage("沒有相關資訊");
  
  plot.setSeriesPaint(0,new Color(208,185,102));
  //plot為統計圖中的bar,用setSeriesPaint設定每個bar的顏色,也可用漸層色

  plot.setLabelFont(new Font("sansserif",Font.PLAIN,10));
  plot.setLabelPaint(Color.red);
  plot.setLabelsVisible(true);
  //設定每根棒棒上面是否要出現數字,以及設定字形及顏色

  ValueAxis va=plot.getRangeAxis();
  va.setUpperMargin(0.1);
  plot.setRangeAxis(va);
  //設定棒棒的上方邊界,以免沒有空間出現數字標籤

  plot.setCategoryGapsPercent(0.4);
  //設定每根棒棒的寬度,以免棒棒太胖了
  out.clearBuffer();
  OutputStream ostream = response.getOutputStream();
  ChartUtilities.writeChartAsJPEG(ostream, chart, 416, 260);
  //ChartUtilities.saveChartAsJPEG(new File("c:\\time_chart"+"003"+".jpg"), chart, 400, 300);
  ostream.close();

  } // End of Try
  catch (Exception e)
  {  out.println("Exception:"+e.getMessage());   }   
  
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
