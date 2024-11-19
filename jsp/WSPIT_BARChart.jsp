<%@ page contentType="image/jpeg; charset=MS950" language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.util.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*" %>
<%@ page import="DateBean"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
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
      //===============�����o�`��
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
  chart = ChartFactory.createVerticalBarChart("����:"+version, "�\��", "��v(%)", dataSet, true); 
  //�]�w�I���C��,GradientPaint�����h��,�Y�n�]�w��@�C��,�i��
 chart.setBackgroundPaint(new GradientPaint(0, 0, new Color(163,202,214), 0, 300,new Color(252,203,252)));
  
  CategoryPlot plot = chart.getCategoryPlot();
  
  plot.setNoDataMessage("�S��������T");
  
  plot.setSeriesPaint(0,new Color(208,185,102));
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
  ChartUtilities.writeChartAsJPEG(ostream, chart, 416, 260);
  //ChartUtilities.saveChartAsJPEG(new File("c:\\time_chart"+"003"+".jpg"), chart, 400, 300);
  ostream.close();

  } // End of Try
  catch (Exception e)
  {  out.println("Exception:"+e.getMessage());   }   
  
%>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
