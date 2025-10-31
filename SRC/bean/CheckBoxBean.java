package bean;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class CheckBoxBean implements Serializable {
    ResultSet rs = null;
    private String fieldName = "";
    private int column = 1;
    private String rsString = "";
    private String checked = "";

    public CheckBoxBean() {
    }

    public String getChecked() {
        return this.checked;
    }

    public void setChecked(String var1) {
        this.checked = var1;
    }

    public int getColumn() {
        return this.column;
    }

    public void setColumn(int var1) {
        this.column = var1;
    }

    public String getFieldName() {
        return this.fieldName;
    }

    public void setFieldName(String var1) {
        this.fieldName = var1;
    }

    public void setRs(ResultSet var1) {
        this.rs = var1;
    }

    public ResultSet getRs() {
        return this.rs;
    }

    public void setRsString(String var1) {
        this.rsString = new String(var1);
    }

    public String getRsString() throws Exception {
        ResultSetMetaData var1 = this.rs.getMetaData();
        StringBuffer var2 = new StringBuffer();
        int var3 = 1;
        var2.append("<TABLE>");

        while(this.rs.next()) {
            String var4 = this.rs.getString(1);
            String var5 = this.rs.getString(2);
            if (var3 == 1) {
                var2.append("<TR>");
            }

            if (this.checked.indexOf(var4) >= 0) {
                var2.append("<TD><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var4 + "' CHECKED>" + var5 + "</TD>");
            } else {
                var2.append("<TD><INPUT TYPE=checkbox NAME=" + this.fieldName + " VALUE='" + var4 + "'>" + var5 + "</TD>");
            }

            if (var3 == this.column) {
                var3 = 1;
            } else {
                ++var3;
            }

            if (var3 == 1) {
                var2.append("</TR>");
            }
        }

        var2.append("</TABLE>");
        this.checked = "";
        return var2.toString();
    }
}
