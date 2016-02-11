var DibujarGraficaFacturas = function(canvas) {
    $.ajax({
        url: '/facturas/summary.json',
        method: 'GET',
        dataType: 'json',
        success: function (d) {
            chartData = {
                labels: d.meses,
                datasets: [
                    {
                        fillColor: "rgba(220,220,220,0.5)",
                        strokeColor: "rgba(220,220,220,1)",
                        pointColor: "rgba(220,220,220,1)",
                        pointStrokeColor: "#fff",
                        data: d.valores
                    }
                ]
            };
            
            var options = {
                maintainAspectRatio: true,
                responsive: true
            };

            myNewChart = new Chart($(canvas).get(0).getContext("2d")).Bar(chartData,options);
        }
    });
};
