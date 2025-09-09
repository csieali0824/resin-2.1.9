<%@ page contentType="text/html; charset=utf-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="jxl.*" %>
<%@ page import="WorkingDateBean" %>
<%@ page import="java.lang.Math.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="modelN.ModelNCommonUtils" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.util.Date" %>
<%@ page import="modelN.dto.DetailDto" %>
<%@ page import="modelN.SalesArea" %>
<%@ page import="tscc.dto.TsccOrderToRfqDto" %>
<%@ page import="tscc.TsccOrderToRfq" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp" %>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
    <title>TSCC To D1-001</title>
    <jsp:useBean id="dateBean" scope="page" class="DateBean"/>
    <jsp:useBean id="tsccOrderToRfq" class="tscc.TsccOrderToRfq"/>
    <jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
    <link rel="stylesheet" href="../jsp/css/tsccOrderToRfq.css">
</head>
<script>
    let detailObj = {
        column: '',
        value: '',
        index: '',
        requestObj: {
            index: '',
            salesNo: '',
            custId: '',
            custNo: '',
            custName: '',
            custPo: '',
            shipToOrgId: '',
            tempId: '',
            orderType: '',
            otypeId: '',
            salesPerson: '',
            salesPersonId: '',
            rfqType: '',
            uploadBy: '',
            insertFlag: ''
        }
    };

    function renderDetail(detailObj) {
        let detail = detailObj;
        let request = detail.requestObj;
        let trRow = document.getElementById('trRow' + request.index);
        let newCell = document.createElement('td');
        newCell.id = detail.column + request.index;

        newCell.addEventListener('mouseover', function () {
            if (['Customer Name', 'RFQ Type', 'Ship to ID', 'Customer PO'].includes(detail.column)) {
                document.getElementById('Customer Name' + request.index).style.backgroundColor = '#66e2ece2';
                document.getElementById('RFQ Type' + request.index).style.backgroundColor = '#66e2ece2';
                document.getElementById('Ship to ID' + request.index).style.backgroundColor = '#66e2ece2';
                document.getElementById('Customer PO' + request.index).style.backgroundColor = '#66e2ece2';
            }
        });
        newCell.addEventListener('mouseout', function () {
            if (['Customer Name', 'RFQ Type', 'Ship to ID', 'Customer PO'].includes(detail.column)) {
                document.getElementById('Customer Name' + request.index).style.backgroundColor = '#ffffff';
                document.getElementById('RFQ Type' + request.index).style.backgroundColor = '#ffffff';
                document.getElementById('Ship to ID' + request.index).style.backgroundColor = '#ffffff';
                document.getElementById('Customer PO' + request.index).style.backgroundColor = '#ffffff';
            }
        });

        newCell.addEventListener('click', function () {
            window.location.href = 'TSCCIntermediate.jsp?' +
                'headerId=' + request.headerId +
                '&salesNo=' + request.salesNo +
                '&customerId=' + request.custId +
                '&customerNo=' + request.custNo +
                '&customerName=' + request.custName +
                '&customerPo=' + request.custPo +
                '&shipToOrgId=' + request.shipToOrgId +
                '&orderType=' + request.orderType +
                '&otypeId=' + request.otypeId +
                '&salesPerson=' + request.salesPerson +
                '&salesPersonId=' + request.salesPersonId +
                '&rfqType=' + request.rfqType +
                '&uploadBy=' + request.uploadBy +
                '&insertFlag=' + request.insertFlag;
        });

        if (['Customer Name', 'RFQ Type'].includes(detail.column)) {
            newCell.textContent = ('Customer Name' === detail.column) ? "(" + request.custNo + ")" + detail.value : detail.value;
        } else {
            if (('Qty' === detail.column)) {
                newCell.textContent = Number.parseFloat(detail.value).toLocaleString('en-US', {
                    minimumFractionDigits: 0, maximumFractionDigits: 3
                });
            } else if (('Selling Price' === detail.column)) {
                newCell.textContent = Number.parseFloat(detail.value).toLocaleString('en-US', {
                    minimumFractionDigits: 0, maximumFractionDigits: 6
                });
            } else {
                newCell.textContent = detail.value;
            }
        }
        trRow.appendChild(newCell);
    }
</script>
<body>
<%
    String headerId = StringUtils.isNullOrEmpty(request.getParameter("headerId")) ? "" : request.getParameter("headerId");
    String requestHeaderId = StringUtils.isNullOrEmpty(request.getParameter("requestHeaderId")) ? "" : request.getParameter("requestHeaderId");
    headerId = StringUtils.isNullOrEmpty(headerId) ? requestHeaderId : headerId;
    String salesNo = StringUtils.isNullOrEmpty(request.getParameter("salesNo")) ? "" : request.getParameter("salesNo");
    String customerId = StringUtils.isNullOrEmpty(request.getParameter("customerId")) ? "" : request.getParameter("customerId");
    String customerNo = StringUtils.isNullOrEmpty(request.getParameter("customerNo")) ? "" : request.getParameter("customerNo");
    String requestCustomerNo = StringUtils.isNullOrEmpty(request.getParameter("requestCustomerNo")) ? "" : request.getParameter("requestCustomerNo");
    customerNo = StringUtils.isNullOrEmpty(customerNo) ? requestCustomerNo : customerNo;
    String customerName = StringUtils.isNullOrEmpty(request.getParameter("customerName")) ? "" : request.getParameter("customerName");
    String customerPo = StringUtils.isNullOrEmpty(request.getParameter("customerPo")) ? "" : request.getParameter("customerPo");
    String shipToOrgId = StringUtils.isNullOrEmpty(request.getParameter("shipToOrgId")) ? "" : request.getParameter("shipToOrgId");
    String strRemark = "Order Import from file";
    String insertFlag = StringUtils.isNullOrEmpty(request.getParameter("insertFlag")) ? "" : request.getParameter("insertFlag");
    String uploadBy = StringUtils.isNullOrEmpty(request.getParameter("uploadBy")) ? UserName : request.getParameter("uploadBy");
    String orderType = StringUtils.isNullOrEmpty(request.getParameter("orderType")) ? "" : request.getParameter("orderType");//request.getParameter("orderType");
    String otypeId = request.getParameter("otypeId");
    String salesPerson = StringUtils.isNullOrEmpty(request.getParameter("salesPerson")) ? "" : request.getParameter("salesPerson");
    String salesPersonId = StringUtils.isNullOrEmpty(request.getParameter("salesPersonId")) ? "" : request.getParameter("salesPersonId");
    String rfqType = request.getParameter("rfqType");
    if (insertFlag.equals("Y")) {
        tsccOrderToRfq.getTsccToRfqData(con, headerId, salesNo, orderType);
        String isEmptyRow = TsccOrderToRfq.detailMap.size() == TsccOrderToRfq.filterDtoMap.size() ? "Y" : "N";
        String[][][] result = tsccOrderToRfq.buildStringAndCheckMatrix();
        String[][] values = result[0];
        String[][] checks = result[1];
        arrayRFQDocumentInputBean.setArray2DString(values);
        arrayRFQDocumentInputBean.setArray2DCheck(checks);

        Map drqCreateArg = new HashMap();
        drqCreateArg.put("customerId", customerId);
        drqCreateArg.put("customerNo", customerNo);
        drqCreateArg.put("customerName", customerName);
        drqCreateArg.put("salesNo", salesNo);
        drqCreateArg.put("customerPo", customerPo);
        drqCreateArg.put("shipToOrgId", shipToOrgId);
        drqCreateArg.put("orderType", orderType);
        drqCreateArg.put("otypeId", otypeId);
        drqCreateArg.put("salesPerson", salesPerson);
        drqCreateArg.put("salesPersonId", salesPersonId);
        drqCreateArg.put("rfqType", rfqType);
        drqCreateArg.put("curr", "");
        drqCreateArg.put("remark", "Workflow to RFQ");
        drqCreateArg.put("isEmptyRow", isEmptyRow);

        tsccOrderToRfq.redirect2DRQCreate(session, response, drqCreateArg);
    }
%>
<form name="form" method="post" accept-charset="utf-8">
    <div id='alpha' class='hidden'
         style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'>
    </div>
    <table width="100%" align="center" border="0">
        <tr>
            <td width="5%">&nbsp;</td>
            <td width="90%">
                <table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
                    <tr>
                        <td height="50" align="center">
                            <font color="#003399" size="+2"> <strong> TSCC To D1-001</strong></font>
                        </td>
                    </tr>
                </table>
            </td>
            <td width="5%">&nbsp;</td>
        </tr>
        <tr>
            <td width="5%">&nbsp;</td>
            <td width="90%">
                <table align="center" width="100%" cellspacing="0" cellpadding="0" style="margin-left: 65px;"
                       bordercolordark="#990000">
                    <td align="right" width="10%" title="回首頁!">
                        <a href="../ORAddsMainMenu.jsp"
                           style="font-size:13px;font-family:標楷體;text-decoration:none;color:#0000FF">
                            <strong>回首頁</strong>
                        </a>
                    </td>
                </table>
        </tr>
    </table>
    <div id="salesAreaRow"
         style="display: flex; justify-content: space-between; padding-left: 4px; padding-right: 80px;">
    </div>
    <!-- 重新整理-->
    <%
            tsccOrderToRfq.getTsccToRfqData(con, headerId, salesNo, orderType);
            TsccOrderToRfq.filterDtoMap = tsccOrderToRfq.filterOrderStatus();
    %>
        <table id="dataTable">
            <tr>
                <%
                    String[] columns = tsccOrderToRfq.getHeaderColumns();
                    for (int i = 0, n = columns.length; i < n; i++) {
                        int width = ((Integer) tsccOrderToRfq.getHeaderHtmlWidthMap().get(columns[i])).intValue();
                %>
                <td width="<%=width%>%"><%=columns[i]%></td>
                <%
                    }
                %>
            </tr>
        <%
            TsccOrderToRfqDto tsccOrderToRfqDto = new TsccOrderToRfqDto();
            for (Iterator it = TsccOrderToRfq.filterDtoMap.entrySet().iterator(); it.hasNext(); ) {
                Map.Entry entry = (Map.Entry) it.next();
                int index = ((Integer) entry.getKey()).intValue();
                List objectList = (LinkedList) entry.getValue();
                for (int i = 0, n = objectList.size(); i < n; i++) {
                    if (objectList.get(i) instanceof TsccOrderToRfqDto) {
                        tsccOrderToRfqDto = (TsccOrderToRfqDto) objectList.get(i);
        %>
        <script>
            var params = {
                index: "<%=index%>",
                headerId: "<%=tsccOrderToRfqDto.getHeaderId()%>",
                salesNo: "<%=tsccOrderToRfqDto.getSalesNo()%>",
                custId: "<%=tsccOrderToRfqDto.getSupplyCustomerId()%>",
                custNo: "<%=tsccOrderToRfqDto.getSupplyCustomerNumber()%>",
                custName: "<%=tsccOrderToRfqDto.getSupplyCustomerName()%>",
                custPo: "<%=tsccOrderToRfqDto.getCustPoNumber()%>",
                shipToOrgId: "<%=tsccOrderToRfqDto.getShipToOrgId()%>",
                orderType: "<%=tsccOrderToRfqDto.getOrderType()%>",
                otypeId: "<%=tsccOrderToRfqDto.getOtypeId()%>",
                salesPerson: "<%=tsccOrderToRfqDto.getSalesrepName()%>",
                salesPersonId: "<%=tsccOrderToRfqDto.getSalesrepId()%>",
                rfqType: "NORMAL",
                uploadBy: "<%=UserName%>",
                insertFlag: 'Y'
            };
        </script>
        <tr id="trRow<%=index%>" title="按下滑鼠左鍵,進入TSC 業務交期詢問單畫面" class="detailContent">
        <% } else if (objectList.get(i) instanceof HashMap) {
            HashMap map = (HashMap) objectList.get(i);
            for (Iterator iterator = map.entrySet().iterator(); iterator.hasNext(); ) {
                Map.Entry en = (Map.Entry) iterator.next();
                String column = (String) en.getKey();
                String value = en.getValue() == null ? "" : (String) en.getValue();
        %>
            <script>
                detailObj = {
                    column: "<%=column%>",
                    value: "<%=value%>",
                    requestObj: params
                };
                renderDetail(detailObj)
            </script>
            <%
                        }
                    }
                }
            %>
        </tr>
        <%
            }
        %>
    </table>
    <!--=============以下區段為釋放連結池==========-->
    <%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
</form>
</body>
<script>
    function mergeColumns() {
        const table = document.getElementById('dataTable');
        const rows = table.rows;
        let previousCustomerName = null;
        let previousRFQType = null;
        let previousCustomerPo = null;
        let previousShipToOrgId = null;
        let rowspanCount = 1;

        for (let i = 1; i < rows.length; i++) { // 從第一行資料開始（跳過標題）
            const currentCustomerName = rows[i].cells[0];
            const currentShipToOrgId = rows[i].cells[1];
            const currentRFQType = rows[i].cells[2];
            const currentCustomerPo = rows[i].cells[3];
            if (
                (previousCustomerName &&
                    previousCustomerName?.innerText == currentCustomerName.innerText &&
                    previousRFQType.innerText == currentRFQType.innerText)
            ) {
                // 合併欄位
                rowspanCount++;
                previousRFQType.rowSpan = rowspanCount;
                previousCustomerName.rowSpan = rowspanCount;
                previousShipToOrgId.rowSpan = rowspanCount;
                previousCustomerPo.rowSpan = rowspanCount;

                currentRFQType.style.display = 'none';
                currentCustomerName.style.display = 'none';
                currentShipToOrgId.style.display = 'none';
                currentCustomerPo.style.display = 'none';
            } else {
                // 重置計數
                previousRFQType = currentRFQType;
                previousShipToOrgId = currentShipToOrgId;
                previousCustomerName = currentCustomerName;
                previousCustomerPo = currentCustomerPo;
                rowspanCount = 1;
            }
        }
    }

    // 禁止鍵盤快捷鍵刷新：F5、Ctrl+R（Windows）、Cmd+R（Mac）
    document.addEventListener('keydown', function (e) {
        // 禁止 F5
        if (e.key === 'F5') {
            e.preventDefault();
            console.log('F5 被阻止');
        }

        // 禁止 Ctrl+R 或 Cmd+R
        if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'r') {
            e.preventDefault();
            console.log('Ctrl/Cmd + R 被阻止');
        }
    });

    mergeColumns();
</script>
</html>
