<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,com.lowagie.text.*,com.lowagie.text.pdf.PdfWriter"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Java PDF Generator</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
</head>
<body>
<%
      // step 1: creation of a document-object
	  com.lowagie.text.Document document = new com.lowagie.text.Document();
	  try {

      // step 2:
			// we create a writer that listens to the document
			// and directs a PDF-stream to a file
			com.lowagie.text.pdf.PdfWriter.getInstance(document,new FileOutputStream("HelloWorld.pdf"));
            // step 3: we open the document
			document.open();
			// step 4: we add a paragraph to the document
			document.add(new Paragraph("Hello World"));
			document.add(new Paragraph("This is Java(JSP) Generate PDF File Test !!!"));

		  } catch (DocumentException de) {
			      System.err.println(de.getMessage());
		  } catch (IOException ioe) {
			      System.err.println(ioe.getMessage());
	      }
          // step 5: we close the document
		  document.close();

%>
<!--=============以下區段為釋放連結池==========--> 
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
