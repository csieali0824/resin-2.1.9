<%@page contentType="image/jpeg;charset=big5"%> 
<!--�]���n��ܹϧ�,�]�wcontentType��image/jpeg --> 
<%@page import="java.util.*,java.io.*,java.awt.*"%> 
<%@page import="org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*"%> 
<% 

Integer[] Number ={new Integer(23),new Integer(70),new Integer(50),new Integer(50),new Integer(50),new Integer(70),new Integer(90)}; 
 DefaultPieDataset dataSet = new DefaultPieDataset(Number); 
// �ΰ}�C���]�w�覡�A�ΥΥH�U���]�w�覡���i 2��1 
	//org.jfree.data.jdbc.JDBCCategoryDataset dataSet= new 
	
	//org.jfree.data.jdbc.JDBCCategoryDataset(con);   

//org.jfree.data.DefaultPieDataset //to org.jfree.data.general.PieDataset.

//org.jfree.data.general.DefaultPieDataset dataSet = new DefaultPieDataset(); 
//dataSet.setValue("11",new Integer(15)); 
//dataSet.setValue("12",new Integer(15)); 
//dataSet.setValue("13",new Integer(20)); 
//dataSet.setValue("14",new Integer(16)); 
//dataSet.setValue("15",new Integer(34)); 

 
 
 

//�]�w�ϧΪ����D��r 
JFreeChart chart=null; 
chart = ChartFactory.createPieChart("FACTORY",dataSet,false,false,false); 
//chart = ChartFactory.createPie3DChart( "100" , dataSet , true); 
//�H�W�p�G�O createPie3DChart�N�O3D�j��� �t�@�ӬO2D�j��� 


// PiePlot Plot = (PiePlot)chart.getPlot(); 
// Plot.setOutlineStroke(null); 
//out.clearBuffer(); 


//OutputStream ostream = response.getOutputStream(); 
//���oresponse��OutputStream 
//ChartUtilities.writeChartAsJPEG(ostream, chart, 350, 250); 
//reder�έp�ϡA�]�w���ɪ��e��300,����200,�ÿ�X��ostream 
//ostream.close(); 
//����ostream 
%> 