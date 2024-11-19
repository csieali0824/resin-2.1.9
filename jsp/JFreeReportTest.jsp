<%@ page import="java.net.URL,
                 org.jfree.report.ext.servletdemo.AbstractPageableReportServletWorker,
                 org.jfree.report.ext.servletdemo.DefaultPageableReportServletWorker,
                 org.jfree.report.demo.SwingIconsDemoTableModel,
                 org.jfree.report.modules.output.pageable.graphics.G2OutputTarget,
                 org.jfree.report.JFreeReport,
                 org.jfree.report.ext.servletdemo.DemoModelProvider"%>

<%
  // initalize the report if not already done ...
  URL in = getClass().getResource("/com/jrefinery/report/demo/swing-icons.xml");
  if (in == null)
  {
    throw new ServletException("Missing Resource: /com/jrefinery/report/demo/swing-icons.xml");
  }

  URL base = getServletConfig().getServletContext().getResource("/WEB-INF/lib/jlfgr-1_0.jar");
  AbstractPageableReportServletWorker worker =
      new DefaultPageableReportServletWorker(null,
                                             in,
                                             new DemoModelProvider(base));
  JFreeReport report = worker.getReport();
  G2OutputTarget target = new G2OutputTarget(G2OutputTarget.createEmptyGraphics(), report.getDefaultPageFormat());
  worker.setOutputTarget(target);
  int numberOfPages = worker.getNumberOfPages();
%>

<html>
<head><title>PNG Servlet Fontend</title></head>
<body>

<%
if (numberOfPages == 0)
{
  %>
  The report could not be loaded, the number of pages property is invalid.
  <%
}
else
{
  for (int i = 0; i < numberOfPages; i++)
  {
%>
  <img src="pngreport?page=<%=i%>" alt="Page <%=i%>">
  <p>
<%
  }
}
%>
</body>
</html>
