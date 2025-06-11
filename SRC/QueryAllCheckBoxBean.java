import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class QueryAllCheckBoxBean implements java.io.Serializable
{
    ResultSet rs=null;
    private String fieldName="";
    private String rsString="";
    public QueryAllCheckBoxBean()
    {}

    public String getFieldName()
    {
        return fieldName;
    }

    public void setFieldName(String fieldName)
    {
        this.fieldName=fieldName;
    } //end of setFieldName

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
        StringBuffer sb=new StringBuffer();
        String bgColor="E3E3CF";

        sb.append("<TABLE cellSpacing='0' bordercolordark='#3366FF' cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>");
        sb.append("<TR bgcolor='#6699FF'>");
        sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");
        for (int i=1;i<=colCount;i++)
        {
            colLabel[i]=md.getColumnLabel(i);
            sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1 FACE='ARIAL'>"+colLabel[i]+"</TH>");
        } //end of for
        sb.append("</TR>");

        while (rs.next())
        {
            sb.append("<TR BGCOLOR="+bgColor+"><TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE="+(String)rs.getString(1)+"></TD>");
            for (int i=1;i<=colCount;i++)
            {
                String s=(String)rs.getString(i);
                sb.append("<TD><FONT SIZE=2 FACE='ARIAL'>"+s+"</TD>");
            } //end of for
            sb.append("</TR>");
            if (bgColor.equals("E3E3CF")) //間隔列顏色改換
            {
                bgColor="E3E3B0";
            } else {
                bgColor="E3E3CF";
            }
        } //end of while
        sb.append("</TABLE>");
        return sb.toString();
    } // end of getRsString
} //end of this class