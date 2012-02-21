//= require accounting.min
$ ->
  chart = new Highcharts.Chart
    chart:
      renderTo: "chart"

    title:
      text: "Funding (USD)"

    tooltip:
      formatter: ->
        "<strong>#{@point.name}: #{accounting.formatMoney(@point.y)}</strong>"
    plotOptions:
      pie:
        dataLabels:
          enabled: true
          formatter: ->
            "<strong>#{@point.name}: #{accounting.formatMoney(@point.y)}</strong>"

    series: [
      type: "pie"
      data: [ ["Raised", FundingList.round.raised], ['Remaining Target', FundingList.round.tried_to_raise - FundingList.round.raised] ]

    ]
