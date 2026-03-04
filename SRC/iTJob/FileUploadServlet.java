package iTJob;

import com.jspsmart.upload.SmartUpload;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

public class FileUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        SmartUpload smartUpload = new SmartUpload();
        smartUpload.initialize(getServletConfig(), request, response);

        try {
            // 限制只能上傳 xls
            smartUpload.setAllowedFilesList("xls");
            smartUpload.upload();

            com.jspsmart.upload.File file = smartUpload.getFiles().getFile(0);
            String fileName = file.getFileName();
//            System.out.println("file="+file.getFileName());
//            System.out.println("getServletContext="+getServletContext());
//            System.out.println("upload="+getServletContext().getRealPath("/jsp/upload_exl/jobList"));
       // /resin-2.1.9/webapps/oradds/jsp/upload_exl/jobList
            if (fileName == null || fileName.trim().isEmpty()) {
                // 沒選檔案，回到 upload.jsp
                RequestDispatcher rd = request.getRequestDispatcher("/jsp/iTJob/upload.jsp");
                rd.forward(request, response);
                return;
            }

            // 存檔路徑 (依實際情況調整)
            String savePath = getServletContext().getRealPath("/jsp/upload_exl/jobList");
            File dir = new File(savePath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

//            System.out.println("url="+request.getRequestURL().toString());
            String filePath = savePath + File.separator + fileName;
            file.saveAs(filePath, SmartUpload.SAVE_PHYSICAL);

            // 存放檔名在 request，轉交 success.jsp
            request.setAttribute("uploadedFile", fileName);
            RequestDispatcher rd = request.getRequestDispatcher("/jsp/iTJob/success.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            throw new ServletException("檔案上傳失敗", e);
        }
    }
}