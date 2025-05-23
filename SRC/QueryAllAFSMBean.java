import java.sql.ResultSet;
import java.sql.ResultSetMetaData;


public class QueryAllAFSMBean implements java.io.Serializable
{
    ResultSet rs=null;
    private String [] headerArray;
    private String rsString="";
    private String hiddenField="";
    private String searchKey="";
    private String pageURL="";
    private String sessionID="";
    private String userID="";
    private int scrollRowNumber=0; //設定頁面資料數
    int rowNumber=0;//設定現在資料列游標在第幾筆
    private String headColor=null;//to set the background color of table head
    private String headFontColor=null;//to set the font color of table head
    private int headFontSize=1; //to set the font size of table head
    private String warningMessage=""; //警示訊息

    public QueryAllAFSMBean()
    {}

    public void setWarningMessage(String s)
    {
        this.warningMessage=s;
    } //end of setWarningMessage

    public String getWarningMessage()
    {
        return warningMessage;
    }

    public void setHeaderArray(String asStr[])
    {
        headerArray=asStr;
    } //end of headerArray

    public int getHeadFontSize()
    {
        return headFontSize;
    }

    public void setHeadFontSize(int hfs)
    {
        this.headFontSize=hfs;
    } //end of setHeadFontSize

    public int getScrollRowNumber()
    {
        return scrollRowNumber;
    }

    public void setScrollRowNumber(int scrollRowNumber)
    {
        this.scrollRowNumber=scrollRowNumber;
    } //end of setScrollRowNumber

    public int getRowNumber()
    {
        return rowNumber;
    }

    public void setRowNumber(int rowNumber)
    {
        this.rowNumber=rowNumber;
    } //end of setRowNumber


    public String getPageURL()
    {
        return pageURL;
    }

    public void setSessionID(String s)
    {
        this.sessionID=s.toUpperCase();
    } //end of setSessionID

    public void setHiddenField(String s)
    {
        this.hiddenField=s;
    } //end of setHiddenField

    public void setUserID(String s)
    {
        this.userID=s.toUpperCase();
    } //end of setUserID

    public void setPageURL(String pageURL)
    {
        this.pageURL=pageURL;
    } //end of setpageURL

    public String getSearchKey()
    {
        return searchKey;
    }

    public void setSearchKey(String searchKey)
    {
        this.searchKey=searchKey;
    } //end of setSearchKey

    public void setRs(ResultSet rs)
    {
        this.rs=rs;
    }

    public ResultSet getRs()
    {
        return rs;
    }//enf of ResultSet

    public void setRsString(String rsStr)
    {
        rsString=new String(rsStr);
    } //end of setRsString

    public String getRsString() throws Exception
    {
        ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];
        for (int i=1;i<=colCount;i++)
        {
            colLabel[i]=md.getColumnLabel(i);
        } //end of for
        StringBuffer sb=new StringBuffer();

        String headBgColor="BLACK";
        if (headColor!=null) headBgColor=headColor; //若有設定table header background color
        String hFontColor="WHITE";
        if (headFontColor!=null) hFontColor=headFontColor;//若有設定table header font color

        sb.append("<TABLE>");
        sb.append("<TR>");
        if (headerArray!=null && headerArray.length>0) //若有table header,就置入之
        {
            for (int i=0;i<headerArray.length;i++)
            {
                String h1=(String)headerArray[i];
                sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE="+headFontSize+">"+h1+"</TH>");
            }
        } else {
            sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");
            for (int i=1;i<=colCount;i++)
            {
                if (hiddenField.indexOf(colLabel[i])<0) //若有設定要隱藏欄位,則不顯示
                {
                    sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
                }
            } //end of for
        } //end of headerArray if
        sb.append("</TR>");

        int j=0;
        while (rs.next())
        {
            int onhand=rs.getInt("ONHAND");
            int minbalance=rs.getInt("MINBALANCE");
            if (j==scrollRowNumber && scrollRowNumber>0) break;
            j++;
            sb.append("<TR BGCOLOR=E3E3CF><TD><A HREF='"+pageURL+"?"+searchKey+"="+CodeUtil.stringToHex(sessionID)+CodeUtil.stringToHex(rs.getString(searchKey))+CodeUtil.stringToHex(userID)+"'><img src='../image/docicon.gif'></A></TD>");
            for (int i=1;i<=colCount;i++)
            {
                String s=(String)rs.getString(i);
                if (s==null) s="";
                if (hiddenField.indexOf(colLabel[i])<0) //若有設定要隱藏欄位,則不顯示
                {
                    sb.append("<TD><FONT SIZE=2>"+s+"</TD>");
                }
            } //end of for
            if (onhand<minbalance) //若庫存不足則另外SHOW 訊息
            {
                sb.append("<TD BGCOLOR='RED'><FONT SIZE=2 COLOR='WHITE'>"+warningMessage+"</TD>");
            }
            sb.append("</TR>");
        } //end of while
        sb.append("</TABLE>");
        return sb.toString();
    } // end of getRsString
} //end of this class