<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,javax.swing.*,net.sourceforge.barbecue.BarcodeFactory.*,net.sourceforge.barbecue.Barcode.*,java.awt.image.BufferedImage.*,java.awt.*,java.io.*" %>

<%  //text/html //image/jpeg
       String data=request.getParameter("DATA"); 
	   String codeType=request.getParameter("CODE");
	   String barWidth=request.getParameter("WIDTH");
       String barHeight=request.getParameter("HEIGHT");  
	   
	   float barCodeWidth = 1;
	   float barCodeHeight = 40;
	   
	   if (barWidth!=null) barCodeWidth = Float.parseFloat(barWidth);
	   if (barHeight!=null) barCodeHeight = Float.parseFloat(barHeight);
	    
		try {
		        javax.swing.JPanel panel = new javax.swing.JPanel();

                net.sourceforge.barbecue.Barcode barcode = null;
				net.sourceforge.barbecue.linear.code39.Code39Barcode barcode39 = null;
             //   barcode = net.sourceforge.barbecue.BarcodeFactory.createCode39q("*123456*",false); // 只能寫一般數字0 ~ 9 的簡單39碼模式
			//	barcode = net.sourceforge.barbecue.BarcodeFactory.createCode128B("123456"); // 128碼 B類				
			/*  不能變型,才能用 SetWidth的方法*/  
			    barcode39 = new net.sourceforge.barbecue.linear.code39.Code39Barcode(data,true,true); // 擴展模式可寫任何文數字0 ~ 9 ,A~Z 的39碼模式
                
			// 1	
			    //int barWidth = barcode39.getWidth(); 
				//int barHeight = barcode39.getHeight();
				
				barcode39.setBarWidth(barCodeWidth);
				barcode39.setBarHeight(barCodeHeight);
				
				//barcode39.barHeight(80);
				
				//out.println("barWidth="+barWidth);
				//out.println("barHeight="+barHeight);
				
				//panel.add(barcode);
				panel.add(barcode39);
				
			// 2	
				java.awt.image.BufferedImage image = new java.awt.image.BufferedImage(80, 55, java.awt.image.BufferedImage.TYPE_BYTE_GRAY);
				java.awt.Graphics2D g = (Graphics2D) image.getGraphics();
				
				//barcode.draw(g, 10, 56);				
				barcode39.draw(g, 10, 56); 
				
		    // 3.
			    try {
                      // We need an output stream to write the image to...
				      //   java.io.FileOutputStream fos = new FileOutputStream("d:\\mybarcode.jpg");
					  if (codeType.equals("1")) // MO單號
					  {
                         java.io.FileOutputStream fos = new FileOutputStream("..\\resin-2.1.9\\webapps\\oradds\\report\\MONO.jpg");
                         // Let the barcode image handler do the hard work
                         //   net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode, fos);
					     net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode39, fos); 
						 
						   response.reset();
                           response.setContentType("image/jpg");	
						   response.sendRedirect("/oradds/report/MONO.jpg");
					  } else if (codeType.equals("2"))	 // 客戶編號
					         {
							    java.io.FileOutputStream fos = new FileOutputStream("..\\resin-2.1.9\\webapps\\oradds\\report\\CUSTNO.jpg");
                                // Let the barcode image handler do the hard work
                                //   net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode, fos);
					            net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode39, fos); 
						 
						        response.reset();
                                response.setContentType("image/jpg");	
						        response.sendRedirect("/oradds/report/CUSTNO.jpg");
							 } else if (codeType.equals("3")) // 流程卡號
					                {
							           java.io.FileOutputStream fos = new FileOutputStream("..\\resin-2.1.9\\webapps\\oradds\\report\\RUNCARDNO.jpg");
                                       // Let the barcode image handler do the hard work
                                       //   net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode, fos);
					                   net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode39, fos); 
						 
						               response.reset();
                                       response.setContentType("image/jpg");	
						               response.sendRedirect("/oradds/report/RUNCARDNO.jpg");
							        } 
						  				
					  /* 
					   out.clearBuffer();					  
					   OutputStream ostream = response.getOutputStream();
                       //org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 480, 320); 					  
                       ostream.close();       
					  */ 
                    } catch (IOException e) {
                                               out.println("Barcode Error !!!"+e);// Error handling
                                            }		
				
			    } 
				catch (net.sourceforge.barbecue.BarcodeException e) 
				{
                  out.println("Barcode Error !!!"+e);// Error handling
                }	

%>


