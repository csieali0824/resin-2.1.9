<%@page contentType="image/jpeg;charset=big5"%> 
<!--因為要顯示圖形,設定contentType為image/jpeg --> 
<%@page import="java.util.*,java.io.*,java.awt.*"%> 
<%@page import="org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*"%> 
<% 

Integer[] Number ={new Integer(23),new Integer(70),new Integer(50),new Integer(50),new Integer(50),new Integer(70),new Integer(90)}; 
 DefaultPieDataset dataSet = new DefaultPieDataset(Number); 
// 用陣列的設定方式，或用以下的設定方式都可 2選1 
	//org.jfree.data.jdbc.JDBCCategoryDataset dataSet= new 
	
	//org.jfree.data.jdbc.JDBCCategoryDataset(con);   

//org.jfree.data.DefaultPieDataset //to org.jfree.data.general.PieDataset.

//org.jfree.data.general.DefaultPieDataset dataSet = new DefaultPieDataset(); 
//dataSet.setValue("11",new Integer(15)); 
//dataSet.setValue("12",new Integer(15)); 
//dataSet.setValue("13",new Integer(20)); 
//dataSet.setValue("14",new Integer(16)); 
//dataSet.setValue("15",new Integer(34)); 

 
 
 

//設定圖形的標題文字 
JFreeChart chart=null; 
chart = ChartFactory.createPieChart("FACTORY",dataSet,false,false,false); 
//chart = ChartFactory.createPie3DChart( "100" , dataSet , true); 
//以上如果是 createPie3DChart就是3D大餅圖 另一個是2D大餅圖 


// PiePlot Plot = (PiePlot)chart.getPlot(); 
// Plot.setOutlineStroke(null); 
//out.clearBuffer(); 


//OutputStream ostream = response.getOutputStream(); 
//取得response的OutputStream 
//ChartUtilities.writeChartAsJPEG(ostream, chart, 350, 250); 
//reder統計圖，設定圖檔的寬為300,高為200,並輸出至ostream 
//ostream.close(); 
//關閉ostream 
%> 