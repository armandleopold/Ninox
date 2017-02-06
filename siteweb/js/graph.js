$(document).ready(function(){

    setInterval(getMongoValues, 3000);
});

function getMongoValues(){
    
    var dates = [];
    var values = [];

    $.ajax({
        type: "GET",
        url: "getdata.php",
        async: false,
        timeout: 10000,
        dataType: "json",
        success: function(data){
            if (data !== null) {
                $.each(data, function(key, line){
                    dates.push(line["timePredicted"]);
                    values.push(line["value"]);
                });
            }
        }, 
        error: function() {
            console.log("ERROR");
        }
    });

    var data = [{
        x: dates,
        y: values,
        fill: 'tozeroy',
        type: 'scatter'
    }];

    var layout = {
        title: 'Sales Predictions',
        width: 1000,
        height: 600,
        xaxis: {
            title: 'Year',
        },
        yaxis: {
            title: 'Week Sales',
        }
    };
    Plotly.newPlot('divGraph', data, layout);
}