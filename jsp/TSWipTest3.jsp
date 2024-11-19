<%@page contentType="image/jpeg;charset=BIG5" import="java.sql.*,java.util.*,java.io.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*"%><% 
Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
String url="jdbc:odbc:chart"; 
String usr="root"; 
String pwd="123"; 
Connection con=DriverManager.getConnection(url,usr,pwd); 
//�H�W�Ш̱z�ӤH����Ʈw�����إ߳s�� 

JdbcCategoryDataset dataSet=new JdbcCategoryDataset(con); 
dataSet.executeQuery("select month,counts as 2002�~ from data1"); 
//�Ncon��iJdbcCategoryDataset���A�ð���select�ԭz 

JFreeChart chart=null; 
chart = ChartFactory.createVerticalBarChart("2002�~�e�b�~�ƶq", "", "", dataSet, true); 
chart.setBackgroundPaint(new GradientPaint(0, 0, new Color(163,202,214), 0, 300,new Color(252,203,252))); 
//�]�w�I���C��,GradientPaint�����h��,�Y�n�]�w��@�C��,�i�� 
//chart.setBackgroundPaint(new Color(100,100,100)); 

CategoryPlot plot = chart.getCategoryPlot(); 
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

OutputStream ostream = response.getOutputStream(); 
ChartUtilities.writeChartAsJPEG(ostream, chart, 400, 300); 
ostream.close(); 