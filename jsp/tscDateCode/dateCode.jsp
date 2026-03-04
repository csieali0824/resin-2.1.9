<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../../css/bootstrap.min.css">
    <link rel="stylesheet" href="../../jsp/css/bootstrap-icons.min.css">
    <script src="../../js/jquery-3.6.0.min.js"></script>
    <script src="../../js/bootstrap.bundle.min.js"></script>
</head>
<body>

<div class="container-fluid">
    <ul class="nav nav-tabs" style="margin-left: 10px; margin-top: 15px;" id="myTab" role="tablist">
        <li class="nav-item">
            <a class="nav-link active" id="dateCodeRule-tab" data-toggle="tab"
               href="#dateCodeRule" role="tab" aria-controls="dateCodeRule">Date Code Rule
            </a>
        </li>

        <li class="nav-item">
            <a class="nav-link" id="dc_yyww-tab" data-toggle="tab"
               href="#dc_yyww" role="tab" aria-controls="dc_yyww">D/C YYWW</a>
        </li>

        <li class="nav-item" style="margin-left: auto; padding-right: 10px; display: flex; align-items: center;">
            <a class="btn btn-outline-primary btn-sm border-0" href="/oradds/ORADDSMainMenu.jsp" role="button" title="Home">
                <i class="bi bi-house fs-5"></i>
            </a>
        </li>

    </ul>

    <div class="tab-content" id="myTabContent">
        <div class="tab-pane fade show active" id="dateCodeRule" role="tabpanel">
            <iframe id="frameSetting"
                    src="dateCodeSetting.jsp"
                    style="width: 100%; height: 630px; border: none; overflow: hidden;"
                    scrolling="no">
            </iframe>
        </div>
        <div class="tab-pane fade" id="dc_yyww" role="tabpanel">
            <iframe id="frameYYWW"
                    src="dateCodeYYWW.jsp"
                    style="width: 100%; height: 630px; border: none; overflow: hidden;"
                    scrolling="no">
            </iframe>
        </div>
    </div>
</div>

</body>
<%--<script>--%>
<%--    $(function () {--%>
<%--        $('#myTab li:last-child a').tab('show')--%>
<%--    })--%>
<%--</script>--%>
</html>