<%@page contentType="image/jpeg;charset=BIG5" import="java.sql.*,java.util.*,java.io.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*"%><% 
Class.forName("sun.jdbc.odbc.JdbcOdbcDriver"); 
String url="jdbc:odbc:chart"; 
String usr="root"; 
String pwd="123"; 
Connection con=DriverManager.getConnection(url,usr,pwd); 
//以上請依您個人的資料庫種類建立連結 

JdbcCategoryDataset dataSet=new JdbcCategoryDataset(con); 
dataSet.executeQuery("select month,counts as 2002年 from data1"); 
//將con丟進JdbcCategoryDataset內，並執行select敘述 

JFreeChart chart=null; 
chart = ChartFactory.createVerticalBarChart("2002年前半年數量", "", "", dataSet, true); 
chart.setBackgroundPaint(new GradientPaint(0, 0, new Color(163,202,214), 0, 300,new Color(252,203,252))); 
//設定背景顏色,GradientPaint為漸層色,若要設定單一顏色,可用 
//chart.setBackgroundPaint(new Color(100,100,100)); 

CategoryPlot plot = chart.getCategoryPlot(); 
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

OutputStream ostream = response.getOutputStream(); 
ChartUtilities.writeChartAsJPEG(ostream, chart, 400, 300); 
ostream.close(); 