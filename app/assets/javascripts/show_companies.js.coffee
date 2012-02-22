//= require bootstrap-modal
//= require accounting.min

$(document).ready ->
  change_to_round = (date, raised, company) ->
    console.log(company)
    # While this is O(n), the highest is probably going to be around 16, so it really doesn't matter.
    for round in company.rounds
      location.pathname = "/round/#{round.id}" if Date.parse(round.end_date) == date and round.raised == raised
  create_chart = ->
    $.getJSON location.pathname + '.json', (data) ->
      rounds_data = []
      for round in data.rounds
        rounds_data.push
          y: round.raised
          x: Date.parse(round.end_date)
      new Highcharts.Chart
        chart:
          renderTo: 'chart'
          defaultSeriesType: 'column'
          event:
            click: (event) ->
              console.log(event)
        title:
          text: "#{data.name}'s Funding"
        xAxis:
          type: 'datetime'
          title:
            text: 'Round End Date'
        yAxis:
          title:
            text: '$ Raised (USD)'
          type: 'dollar'
        series: [
          name: "Amount Raised (USD)"
          data: rounds_data
          # The server already orders the rounds by their end_date in descending order, so I can just call the first and last elements
        ]
        legend:
          enabled: false
        plotOptions:
          series:
            cursor: 'pointer' # Shows that the points are clickable, it still feels too subtle though
            color: '#CCCCCC'
            events:
              click: (event) ->
                console.log(event)
                change_to_round(event.point.x, event.point.y, data)
        tooltip:
          formatter: ->
            "<strong>Raised: #{accounting.formatMoney(@point.y)}</strong>"
  
  create_chart()
