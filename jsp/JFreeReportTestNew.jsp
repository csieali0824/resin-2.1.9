<%@ page import="javax.swing.*,org.jfree.report.JFreeReport,javax.swing.table.DefaultTableModel,javax.swing.table.TableModel,org.jfree.report.elementfactory.TextFieldElementFactory,org.jfree.report.modules.gui.base.PreviewDialog,org.jfree.report.ReportProcessingException,org.jfree.report.TextElement"%>
<%@ page import="org.jfree.report.ext.servletdemo.AbstractPageableReportServletWorker,java.sql.*,                 
				  org.jfree.report.ext.servletdemo.StaticPageableReportServletWorker,java.util.*,
				  org.jfree.report.ext.servletdemo.DefaultPageableReportServletWorker,
                 org.jfree.report.demo.SwingIconsDemoTableModel,java.net.URL,
                 org.jfree.report.modules.output.pageable.graphics.G2OutputTarget,                 
				 org.jfree.report.ext.servletdemo.StaticTableModelProvider,
				 org.jfree.report.PageHeader,java.awt.Image,java.awt.Toolkit,org.jfree.report.util.WaitingImageObserver,
                 org.jfree.report.ext.servletdemo.DemoModelProvider,java.awt.Graphics2D,java.awt.Color,
				 java.awt.image.BufferedImage,java.awt.print.PageFormat,com.keypoint.PngEncoder,
				 java.awt.geom.Rectangle2D,org.jfree.report.ElementAlignment,
				 org.jfree.report.util.CloseableTableModel,
				 org.jfree.report.modules.misc.tablemodel.ResultSetTableModelFactory,
				 org.jfree.report.elementfactory.LabelElementFactory,
				 org.jfree.report.style.FontDefinition,
				 org.jfree.report.Element,org.jfree.report.elementfactory.ElementFactory"%>
<html>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<head>
<title>Jfree Report Demo</title>
</head>
<body>
<%
int pageNumber=0;
BufferedImage image = null;
PngEncoder encoder;
byte data[];
PageFormat pageFormat;
Graphics2D g2;
G2OutputTarget target;

/*
Object[] columnNames = new String[] { "Column1", "Column2", "Column3" };
DefaultTableModel result = new DefaultTableModel(columnNames, 2);
//TableModel result = new DefaultTableModel(columnNames, 1);
result.setValueAt("Hello", 0, 0);
result.setValueAt("World!", 0, 1);
result.setValueAt(" Oh ! Oh!", 0, 2);
result.setValueAt("YSE", 1, 0);
result.setValueAt("WONDERFUL!", 1, 1);
result.setValueAt("Hi! Hi!", 1, 2);
*/
Statement statement=con.createStatement();
 ResultSet rs=statement.executeQuery("select ROLENAME,ROLEDESC from WsROLE");
CloseableTableModel result=ResultSetTableModelFactory.getInstance().createTableModel(rs);

//==below is the table definition=====
JFreeReport report = new JFreeReport();
report.setName("A Very Simple Report");

//??????????
FontDefinition fd=new FontDefinition("??? & ????",12);

ResultSetMetaData md=rs.getMetaData();
int colCount=md.getColumnCount();
TextElement te = null;
double beginPosition=0.0;
for (int i=1;i<=colCount;i++)
{
  te = TextFieldElementFactory.createStringElement(md.getColumnLabel(i),new Rectangle2D.Double(beginPosition, 0.0, 150.0, 20.0),Color.black,ElementAlignment.LEFT,ElementAlignment.MIDDLE,fd,"-",md.getColumnLabel(i));
  report.getItemBand().addElement(te);
  beginPosition=beginPosition+100;
}

//??????????
//TextElement lt = null;
Element lt=null;
double beginPosition_label=0.0;
for (int i=1;i<=colCount;i++)
{
  //lt = LabelElementFactory.createLabelElement(md.getColumnLabel(i),new Rectangle2D.Double(beginPosition_label, 0.0, 150.0, 20.0),Color.gray,ElementAlignment.LEFT,fd,md.getColumnLabel(i));
  lt = LabelElementFactory.createElement().createLabelElement(md.getColumnLabel(i),new Rectangle2D.Double(beginPosition_label, 0.0, 150.0, 20.0),Color.gray,ElementAlignment.LEFT,fd,md.getColumnLabel(i));
  lt.setName(md.getColumnLabel(i));
  report.getItemBand().addElement(lt);
  beginPosition_label=beginPosition_label+100;
}
//TextElement t1 = TextFieldElementFactory.createStringElement("T1",new Rectangle2D.Double(0.0, 0.0, 150.0, 20.0),Color.black,ElementAlignment.LEFT,ElementAlignment.MIDDLE,null,"-","Column1");
//TextElement t1 = TextFieldElementFactory.createStringElement("T1",new Rectangle2D.Double(0.0, 0.0, 150.0, 20.0),Color.black,ElementAlignment.LEFT,ElementAlignment.MIDDLE,fd,"-","ROLENAME");
//report.getItemBand().addElement(t1);
//TextElement t2 = TextFieldElementFactory.createStringElement("T2",new Rectangle2D.Double(100.0, 0.0, 150.0, 20.0),Color.black,ElementAlignment.LEFT,ElementAlignment.MIDDLE,null,"-","Column2");
//TextElement t2 = TextFieldElementFactory.createStringElement("T2",new Rectangle2D.Double(100.0, 0.0, 150.0, 20.0),Color.black,ElementAlignment.LEFT,ElementAlignment.MIDDLE,fd,"-","ROLEDESC");
//t2.setUnderline(true);
//report.getItemBand().addElement(t2);
//TextElement t3 = TextFieldElementFactory.createStringElement("T3",new Rectangle2D.Double(200.0, 0.0, 150.0, 20.0),Color.red,ElementAlignment.LEFT,ElementAlignment.MIDDLE,null,"-","Column3");
//report.getItemBand().addElement(t3);

report.setData(result);

//以下為設定page Header
report.setProperty("page.header", "PAGE HEADER");
report.setPropertyMarked("page.header", true);
TextElement t0 = TextFieldElementFactory.createStringElement("T0",new Rectangle2D.Double(45.0, 0.0, 150.0, 20.0),Color.blue,ElementAlignment.LEFT,ElementAlignment.MIDDLE,null,"-","page.header");
report.getPageHeader().addElement(t0);


AbstractPageableReportServletWorker worker =new StaticPageableReportServletWorker(null,report,result);
		 
try
{ 
  pageFormat = worker.getReportPageFormat();
  double width = pageFormat.getWidth();
  double height = pageFormat.getHeight();
  image = new BufferedImage((int)width, (int)height, 13);
  g2 = image.createGraphics();
  g2.setPaint(Color.white);
  g2.fillRect(0, 0, (int)pageFormat.getWidth(), (int)pageFormat.getHeight());
  target = new G2OutputTarget(g2, pageFormat);  
  worker.setOutputTarget(target);     
  
  pageNumber=worker.getNumberOfPages();
  //System.out.println(worker.getNumberOfPages());
  if (pageNumber>0)  
  {	 
	  worker.processPage(0);	     
	  
	  encoder = new PngEncoder(image, true, 0, 9);
	  data = encoder.pngEncode();	
	   out.clearBuffer(); 
       response.setContentType("image/png");  
      response.setHeader("Content-Type", "image/png"); 	 
	  response.getOutputStream().write(data) ;   	  	 	    
    
   response.getOutputStream().flush(); 
   out.close(); 
  }  
rs.close();
statement.close();
result.close();  
}  catch (Exception ee)  {
  System.out.println(ee);
  %>
  <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
  <%
}
%>
JFree Report Test
</body>
</html>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>