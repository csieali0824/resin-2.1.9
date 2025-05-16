package modelN;

import java.io.Serializable;
import java.sql.SQLException;

public abstract class AbstractModelNUtils implements Serializable {
    public abstract String[] getGroupBy(String salesNo);
    public abstract String[] getRFQType(String salesNo);
    public abstract void setShippingFobOrderTypeInfo() throws SQLException;
    public abstract void setExtraRuleInfo() throws SQLException;
    public abstract void setShippingMethod() throws SQLException;
    public abstract void setCrd() throws SQLException;
    public abstract void setFob() throws SQLException;
    public abstract void setDetailHeaderColumns();
    public abstract void setDetailHeaderHtmlWidth() throws Exception;
}
