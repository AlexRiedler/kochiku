Kochiku = {};
Kochiku.graphBuildTimes = function(projectName) {
  $.getJSON('/projects/' + projectName + '/build_time_history.json', function(dataseries) {
    $.plot($('#plot'),
      [{color: '#52585D', data: dataseries}],
      {
      grid: { hoverable: true, clickable: true },
      yaxis: {
        min: 0, max: 100
      }
    });
    function showTooltip(x, y, contents) {
      $('<div id="tooltip">' + contents + '</div>').css( {
         position: 'absolute',
         display: 'none',
         top: y + 5,
         left: x + 5,
         border: '1px solid #52585D',
         padding: '2px',
         'background-color': '#B8BEC3',
         'font-size': '130%',
         'font-family': "agb",
         opacity: 0.80
      }).appendTo("body").fadeIn(10);
    }
    var previousPoint = null;
    $("#plot").bind("plothover", function (event, pos, item) {
      if (item) {
        if (previousPoint != item.dataIndex) {
          previousPoint = item.dataIndex;
          $("#tooltip").remove();
          var buildNum = item.datapoint[0].toFixed(), duration = item.datapoint[1].toFixed();
          showTooltip(item.pageX, item.pageY, "Build " + buildNum + ": " + duration + " min");
        }
      }
    });
    $("#plot").bind("plotclick", function (event, pos, item) {
      if (item) {
        window.location = '/projects/' + projectName + '/builds/' + item.datapoint[0].toFixed();
      }
    });
  });
}
