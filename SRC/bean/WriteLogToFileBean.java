package bean;

import java.io.*;

/**  This is Write Text/Html/Log to file Program created by Kerwin Chen
 * @author Kerwin Chen
 * @version 1.0
 * @see CopyFileSimpleDemo
*/
public class WriteLogToFileBean implements Serializable
{
    public WriteLogToFileBean()
    {
    }

    public void setTextString(String s)
    {
        textStr = s;
    }

    public void setFileName(String fname)
    {
       dirFileName=fname;
    }

    public String getTextString()
    {
        try
        {
          stbuff.append(textStr);
          //System.out.println(textStr);
        }//end of try
        catch (Exception e)
        {
         System.err.println(e.getMessage());
        }
        return stbuff.toString();
    }

    public void StrSaveToFile() throws Exception
    {
      //WriteLogToFileBean getText = new WriteLogToFileBean();
      String getHtmlStr = this.getTextString();
      String s = "";
      //System.out.println(getHtmlStr);
      BufferedReader htmlbr = new BufferedReader(new StringReader(getHtmlStr));
      PrintWriter outpw = new PrintWriter(new BufferedWriter(new FileWriter(dirFileName)));

      int lineCount = 1;
      while((s = htmlbr.readLine()) != null )
      //outpw.println(lineCount++ + ": " + s);
      outpw.println(s);
      outpw.close();
      System.out.println(s);

    }

  private StringBuffer stbuff = new StringBuffer();
  private String textStr="";
  private String dirFileName="";

}