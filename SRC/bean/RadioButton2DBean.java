package bean;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class RadioButton2DBean implements Serializable {
    ResultSet rs = null;
    private String fieldName = "";
    private String rsString = "";
    private String selection = "";

    public RadioButton2DBean() {
    }

    public String getSelection() {
        return this.selection;
    }

    public void setSelection(String var1) {
        this.selection = var1;
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
        boolean var3 = true;

        while(this.rs.next()) {
            String var4 = this.rs.getString(1);
            String var5 = this.rs.getString(2);
            if (var4.equals(this.selection)) {
                var2.append("<INPUT TYPE= 'radio' NAME=" + var4 + " VALUE=" + var5 + " CHECKED>" + var5);
            } else {
                var2.append("<INPUT TYPE= 'radio' NAME=" + var4 + " VALUE=" + var5 + ">" + var5);
            }
        }

        this.selection = "";
        return var2.toString();
    }
}
