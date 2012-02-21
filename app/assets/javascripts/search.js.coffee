//= require jquery.textchange.min

$("#companies").ready ->
  url = null
  search_results = []
  update_search = ->
    if $("#search").val()
      $.getJSON '/companies/search.json?&query=' + $("#search").val(), (data) ->
        search_results = data
        load_results()

  load_results = ->
    $("#companies_list").children().remove()
    for result in search_results
      html = "<li class='company unselectable'><h3><a class='unselectable' href='/#{result.kind}/#{result.id}'>#{result.name}</a></h3></li>"
      $("#companies_list").append(html)


  $("#search").bind 'textchange', ->
    update_search()
  
  update_search() unless $("#search").val() == ''

  $('.company').live 'click', ->
    location.pathname = $(this).children().first().children("a").attr('href')
  
  $("#search").focus()

