<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,java.io.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<!--=============Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<title>Title</title>
</head>
<body>
<%
     String modelNo = request.getParameter("MODELNO");  
     String comp=request.getParameter("COMP"); 
     String region=request.getParameter("REGION"); 
     String country=request.getParameter("COUNTRY");                                
     String locale=request.getParameter("LOCALE");                
     String smode=request.getParameter("SMODE"); 
     String repLvl=request.getParameter("REPLVL");                 

     String webID="";    
     String sqlGlobal = "";
     
     if (comp==null || comp.equals("")) comp = "01";
     if (region==null || region.equals("")) region = "ASIA";
     if (country==null || country.equals("")) country = "886";
     if (smode==null || smode.equals("")) smode = "WK"; 
     if (repLvl==null || repLvl.equals("")) repLvl = "--"; 
     if (modelNo==null || modelNo.equals("")) modelNo = "2052C";  
	 
	workingDateBean.setAdjWeek(-1); // --
 
     String thisYear = workingDateBean.getYearString();  
     String thisMonth = workingDateBean.getMonthString();
     String thisWeek = workingDateBean.getWeekString();
            workingDateBean.setDefineWeekFirstDay(1);  // --    
            String weekBelongYear = workingDateBean.getLastDateOfWorkingWeek().substring(0,4);  // -- 
	String strFirstDWeekP12 = workingDateBean.getFirstDateOfWorkingWeek();   // --
	String strLastDWeekP12 = workingDateBean.getLastDateOfWorkingWeek();  // --
	
	 workingDateBean.setAdjWeek(1);  // --	
    
/*				     

*/
        org.jfree.data.jdbc.JDBCCategoryDataset dataSet=new org.jfree.data.jdbc.JDBCCategoryDataset(con);     
		
					String sql =" Select A.Tsc_Package , B.Cap_Max , A.Wo_Qty/1000   From  "+
								" (	select A_Count.Tsc_Package,  Sum(A_Count.Wo_Qty*1000) Wo_Qty From     "+
								" (select  "+
								" Oe_A.Order_Number,oe_C.Wo_No, Oe_A.Line_Id , Cust_D.Customer_Name ,tog.Group_Name,  "+
								" Oe_A.Sold_To_Org_Id,  Oe_B.Sold_To_Org_Id , Oe_C.* ,cust_D.Attribute1  "+
								" From ( "+
								" select A.Order_Number , B.Header_Id ,a.Sold_To_Org_Id , B.Line_Id , B.Pricing_Quantity ,b.Pricing_Quantity_Uom   From  "+
								" oe_Order_Headers_All A,oe_Order_Lines_All B where  "+
								" a.Org_Id = Decode(Order_Type_Id,'1175','41','325') "+
								" and A.Order_Type_Id In ('1172','1165','1022','1021','1114','1175') "+
								" and A.Header_Id = B.Header_Id "+
								" and B.Packing_Instructions = 'Y' "+
								" and B.Schedule_Ship_Date Between To_Date('2007/01/01','yyyy/mm/dd') And To_Date('2007/01/31','yyyy/mm/dd') "+
								" ) Oe_A ,( Select Order_Number ,sold_To_Org_Id  From Oe_Order_Headers_All  Where  "+
								" ( Org_Id = Decode(Order_Type_Id,'1172','325','1165','325','41') "+
								" And Order_Type_Id In ('1172','1165','1022','1021','1114','1175') "+
								" )	) Oe_B , "+
								" (select C.Oe_Order_No , C.Order_Header_Id , C.Order_Line_Id , "+
								" C.Wo_Qty , C.Wo_No , C.Status , C.Tsc_Package , C.Tsc_Amp , C.Tsc_Family  "+
								" from yew_Workorder_All C ,wip_Entities We ,	wip_Discrete_Jobs Wdj  "+
								" where c.Status Not In ('CANCELED')	and We.Wip_Entity_Name = C.Wo_No "+
								" and C.Workorder_Type = '3' 	and We.Wip_Entity_Id = Wdj.Wip_Entity_Id "+
								" and We.Organization_Id In ('326','327')	and Wdj.Status_Type In (3,4,12) "+
								" and Wdj.Date_Completed  Between To_Date('2007/01/01','yyyy/mm/dd') And To_Date('2007/03/31','yyyy/mm/dd') "+
								" ) Oe_C	,	(	select  "+
								" e1.Cust_Account_Id Customer_Id ,b1.Payment_Term_Id Payment_Term_Id , "+
								" b1.Attribute1 ,	substr(D1.Party_Name,1,50) Customer_Name   "+
								" from apps.Hz_Cust_Acct_Sites_All A1, ar.Hz_Cust_Site_Uses_All B1, "+ 
								" ar.Hz_Parties D1, 	ar.Hz_Cust_Accounts E1                         "+       
								" where 	a1.Cust_Acct_Site_Id = B1.Cust_Acct_Site_Id     "+
								" and A1.Status = 'A' 	and A1.Status = B1.Status  "+
								" and A1.Org_Id = B1.Org_Id   and A1.Org_Id In ('41','325')  "+
								" and A1.Cust_Account_Id = E1.Cust_Account_Id  	and B1.Site_Use_Code ='BILL_TO'   "+
								" and B1.Primary_Flag ='Y' 	and E1.Party_Id = D1.Party_Id "+
								" order By Substrb(D1.Party_Name,1,50) "+
								" ) Cust_D ,	 Tsc_Om_Group  Tog	where Oe_A.Line_Id = Oe_C.Order_Line_Id(+) "+
								" and Oe_A.Order_Number = Oe_B.Order_Number 	and Oe_B.Sold_To_Org_Id = Cust_D.Customer_Id "+
								" and Tog.Group_Id = Cust_D.Attribute1 order By Oe_A.Order_Number "+
								" ) A_Count	group By A_Count.Tsc_Package "+
								" ) A ,  (Select Distinct Mfg_Dept_Name ,packages , Cap_Max  From Oraddman.Tsdnrfq_Capacity_Upload ) B  "+
								" Where  A.Tsc_Package =  B.Packages "+
								" and A.Tsc_Package = 'DO-15' ";


	    
       String sWhere = " ";
       
       sql = sql + sWhere;
       //out.println(sql);
       dataSet.executeQuery(sql);
  
         
  //       String filename = null;        
         org.jfree.chart.axis.CategoryAxis3D categoryAxis3D = new org.jfree.chart.axis.CategoryAxis3D("");
         org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
         org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
         renderer3D.setSeriesPaint(0,new Color(255,255,128)); 

         renderer3D.setItemLabelFont(new Font("Arial",java.awt.Font.ITALIC,10));
   //      renderer3D.setItemURLGenerator(new StandardCategoryURLGenerator("MyJFreeChart.jsp","series","section")); 
   //      renderer3D.setToolTipGenerator(new StandardCategoryToolTipGenerator());
         org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
               plot.setForegroundAlpha(1.00f);
               plot.setNoDataMessage("No Data Found");    

         //  
         org.jfree.chart.labels.StandardCategoryLabelGenerator labelGT = new org.jfree.chart.labels.StandardCategoryLabelGenerator(); 
         //org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = (org.jfree.chart.renderer.category.CategoryItemRenderer)plot.getRenderer(); 
         org.jfree.chart.plot.CategoryPlot catePlot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D); 
         org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = catePlot.getRenderer();        
         itemRenderer.setLabelGenerator(labelGT);
         itemRenderer.setItemLabelFont(new Font("SansSerif", Font.BOLD, 11));
         itemRenderer.setItemLabelPaint(new Color(0,0,150));
         itemRenderer.setSeriesItemLabelsVisible(0, true); 
		 
		 org.jfree.chart.axis.CategoryAxis domainAxis = catePlot.getDomainAxis();
		 domainAxis.setCategoryLabelPositions(org.jfree.chart.axis.CategoryLabelPositions.DOWN_45);
                
         org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("2007年第一個月的生產容積及生產實際數量", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plot, false);
  //               chart.setBackgroundPaint(java.awt.Color.white);
                   chart.setBackgroundPaint(new Color(220,255,166));      
                   chart.setBorderVisible(true);  
      
        org.jfree.chart.title.TextTitle subXTitle = new org.jfree.chart.title.TextTitle("產品類別", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,10) ) ; 
        chart.addSubtitle(subXTitle); 

        org.jfree.chart.title.TextTitle subYTitle = new org.jfree.chart.title.TextTitle("生產容積", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(15,15,150), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,10,0,0,0) ) ; 
        chart.addSubtitle(subYTitle);        
		
		org.jfree.chart.title.TextTitle subYTitle2 = new org.jfree.chart.title.TextTitle("實際生產量", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,10,0) ) ; 
        chart.addSubtitle(subYTitle2); 
 
            		
 
        //  Write the chart image to the temporary directory
 //        ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
 //        filename = ServletUtilities.saveChartAsPNG(chart, 500, 300, info, request);

        //  Write the image map to the PrintWriter
 //        ChartUtilities.writeImageMap(pw, filename, info);
 //        pw.flush();     


          
        out.clearBuffer();
        OutputStream ostream = response.getOutputStream();
        org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 300, 330);      
        ostream.close();      
  
%>

</body>
</html>
<!--=============Release Pool==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
