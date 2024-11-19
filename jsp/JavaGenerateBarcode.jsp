<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,javax.swing.*,net.sourceforge.barbecue.BarcodeFactory.*,net.sourceforge.barbecue.Barcode.*,java.awt.image.BufferedImage.*,java.awt.*,java.io.*" %>

<%  
       String data=request.getParameter("DATA"); 
           
		try {
		        javax.swing.JPanel panel = new javax.swing.JPanel();

                net.sourceforge.barbecue.Barcode barcode = null;
				net.sourceforge.barbecue.Barcode barcode39 = null;
             //   barcode = net.sourceforge.barbecue.BarcodeFactory.createCode39("*123456*",false); // 糶计0 ~ 9 虏虫39絏家Α
			//	barcode = net.sourceforge.barbecue.BarcodeFactory.createCode128B("123456"); // 128絏 B摸				
				barcode39 = new net.sourceforge.barbecue.linear.code39.Code39Barcode(data,true,true); // 耎甶家Α糶ヴゅ计0 ~ 9 ,A~Z 39絏家Α
                
			// 1	
				//panel.add(barcode);
				panel.add(barcode39);
				
			// 2	
				java.awt.image.BufferedImage image = new java.awt.image.BufferedImage(500, 500, java.awt.image.BufferedImage.TYPE_BYTE_GRAY);
				java.awt.Graphics2D g = (Graphics2D) image.getGraphics();
				
				//barcode.draw(g, 10, 56);
				barcode39.draw(g, 10, 56);
				
		    // 3.
			    try {
                      // We need an output stream to write the image to...
				  //   java.io.FileOutputStream fos = new FileOutputStream("d:\\mybarcode.jpg");
                       java.io.FileOutputStream fos = new FileOutputStream("..\\resin-2.1.9\\webapps\\oradds\\report\\mybarcode39.jpg");
                        // Let the barcode image handler do the hard work
                    //   net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode, fos);
					     net.sourceforge.barbecue.BarcodeImageHandler.outputBarcodeAsJPEGImage(barcode39, fos); 
						 
						  response.reset();
                          response.setContentType("image/jpg");	
						  response.sendRedirect("/oradds/report/mybarcode39.jpg");
						  
						  				
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


