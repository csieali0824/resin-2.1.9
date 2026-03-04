<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>IT JOB Chart</title>
    <script src="../../js/jquery-3.6.0.min.js"></script>
    <script src="../../js/bootstrap.bundle.min.js"></script>
    <script src="../../js/bootstrap-table.min.js"></script>
    <script src="../../js/highcharts.js"></script>
    <script src="../../js/highcharts_drilldown.js"></script>
</head>
<body>
<!-- Loading 遮罩 -->
<div id="loading" class="loadingOverlay">
    <div class="spinner-border" role="status"></div>
</div>

<h2>月份 × Owner × Status (圓餅圖)</h2>
<div id="monthPieChart" style="width: 90%; height: 500px; margin: 0 auto;"></div>

<h2>月份 × Owner × Status (堆疊長條圖)</h2>
<div id="monthStackedChart" style="width: 90%; height: 500px; margin: 0 auto;"></div>

<script>
    $(function () {
        let list = [];
        $(".loadingOverlay").css('display', 'flex');
        $.ajax({
            url: "<%=request.getContextPath()%>/task?action=search", // 送到 Servlet
            method: 'POST',
            data: {
                dates: '',
                status: '',
                owner: ''
                // dates: dateValue || '',
                // status: status || '',
                // owner: owner || ''
            },
            traditional: true,
            dataType: 'json',
            beforeSend: function() {
                $(".loadingOverlay").show();
            },
            success: function (res) {
                console.log('parse=',JSON.parse(res))
                list = JSON.parse(res);
                generateChart(list);
                // if (dateValue === null && status === null && owner === null) {
                //     initQuery(JSON.parse(res));
                // } else {
                //     $('#table').bootstrapTable('load', JSON.parse(res)); // 更新表格
                // }
            },
            error: function (xhr) {
                let res = JSON.parse(xhr.responseText);
                alert("查詢失敗：" + res.error);
            },
            complete: function() {
                // 無論成功或失敗，都隱藏 overlay
                $(".loadingOverlay").hide();
            }
        });
        // === Step 1: 按月份、Owner、Status 統計 ===
        function generateChart(list) {
            let dataByMonth = {};
            list.forEach(item => {
                // console.log(''+item.no+'=', item.closedDate)
                // if (item.closedDate !== null) {
                //     console.log('ffff=',item.closedDate.lastIndexOf("/"))
                // }
                let idx = item.requestDate.lastIndexOf("/");
                // console.log('xxx=',item.requestDate);
                // console.log('indexof=',idx);
                // console.log('xxx1=',item.requestDate.substring(0, idx));
                // console.log('xxx2=',item.requestDate.substring(0, idx));
                // console.log('xxx3=',item.requestDate.substring(0, idx));
                let month = item.requestDate.substring(0, idx); // yyyy/MM
                if (!dataByMonth[month]) dataByMonth[month] = {};
                if (!dataByMonth[month][item.owner]) dataByMonth[month][item.owner] = {};
                dataByMonth[month][item.owner][item.status] = (dataByMonth[month][item.owner][item.status] || 0) + 1;
            });

            // === Step 2: 準備圓餅圖資料 (三層 drilldown) ===
            let pieData = [];
            let pieDrilldown = [];

            Object.keys(dataByMonth).forEach(month => {
                let ownerCounts = {};
                Object.keys(dataByMonth[month]).forEach(owner => {
                    let total = Object.values(dataByMonth[month][owner]).reduce((a, b) => a + b, 0);
                    ownerCounts[owner] = total;
                });

                pieData.push({
                    name: month,
                    y: Object.values(ownerCounts).reduce((a, b) => a + b, 0),
                    drilldown: month
                });

                let monthSeries = {id: month, name: month + " Owner 分布", data: []};

                Object.keys(ownerCounts).forEach(owner => {
                    monthSeries.data.push({name: owner, y: ownerCounts[owner], drilldown: month + "_" + owner});

                    // 再 drilldown 到 status
                    let statusSeries = {id: month + "_" + owner, name: owner + " 的 Status 分布", data: []};
                    Object.keys(dataByMonth[month][owner]).forEach(status => {
                        statusSeries.data.push([status, dataByMonth[month][owner][status]]);
                    });
                    pieDrilldown.push(statusSeries);
                });

                pieDrilldown.push(monthSeries);
            });

            Highcharts.chart('monthPieChart', {
                credits: {
                    enabled: false
                },
                accessibility: {
                    enabled: false
                },
                chart: {type: 'pie'},
                title: {text: '月份 × Owner × Status (圓餅圖 Drilldown)'},
                series: [{name: '月份', colorByPoint: true, data: pieData}],
                drilldown: {series: pieDrilldown}
            });

            // === Step 3: 堆疊長條圖 + drilldown ===
            let categories = Object.keys(dataByMonth);
            let owners = [...new Set([].concat(...Object.values(dataByMonth).map(m => Object.keys(m))))];

            let stackedSeries = [];
            let drillSeries = [];

            owners.forEach(owner => {
                let data = [];
                categories.forEach(month => {
                    let total = 0;
                    if (dataByMonth[month][owner]) {
                        total = Object.values(dataByMonth[month][owner]).reduce((a, b) => a + b, 0);
                    }
                    data.push({
                        y: total,
                        drilldown: total > 0 ? month + "_" + owner + "_stack" : null
                    });

                    // 準備 drilldown: owner → status
                    if (total > 0) {
                        let statusSeries = {
                            id: month + "_" + owner + "_stack",
                            name: owner + " (" + month + ")",
                            data: []
                        };
                        Object.keys(dataByMonth[month][owner]).forEach(status => {
                            statusSeries.data.push([status, dataByMonth[month][owner][status]]);
                        });
                        drillSeries.push(statusSeries);
                    }
                });
                stackedSeries.push({name: owner, data: data});
            });

            Highcharts.chart('monthStackedChart', {
                credits: {
                    enabled: false
                },
                accessibility: {
                    enabled: false
                },
                chart: {type: 'column'},
                title: {text: '月份 × Owner × Status (堆疊長條圖 Drilldown)'},
                xAxis: {categories: categories},
                yAxis: {
                    min: 0,
                    title: {text: '任務數量'},
                    stackLabels: {enabled: true}
                },
                tooltip: {
                    shared: true,
                    formatter: function () {
                        return this.x + '<br/>' + this.points.map(p => p.series.name + ': ' + p.y).join('<br/>');
                    }
                },
                plotOptions: {column: {stacking: 'normal'}},
                series: stackedSeries,
                drilldown: {series: drillSeries}
            });
        }
    });
</script>
</body>
</html>
