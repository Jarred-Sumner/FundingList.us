//= require bootstrap-modal
//= require accounting.min

start_page = $(document).ready ->
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
  $("#update_me_modal").modal()
  $("#update_me_modal").modal('hide')
  $("#update_me").click ->
    $("#update_me_modal").modal("show")
    $("#update_email").focus()
  $("#update_me_modal").keyup (evt) ->
    $("#keep_updated_button").trigger("click") if evt.keyCode == 13
  $(".hide_modal").click ->
    $("#update_me_modal").modal('hide')
  $("#keep_updated_button").click ->
    $("#success_alert").removeClass("hidden").children("#success_alert_text").text("We'll keep you updated on this company's funding!")
    $.getJSON location.pathname + '/subscribe.json?&email=' + $("#update_email").val()
  $("#success_alert").removeClass('hidden') unless $("#success_alert_text").text() == ''
  create_chart()
