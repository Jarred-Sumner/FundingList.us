$(document).ready ->
  $("#update_me_modal").modal()
  $("#update_me_modal").modal('hide')
  $("#update_me").click ->
    $("#update_me_modal").modal("show")
    $("#update_email").focus()
  $(".hide_modal").click ->
    $("#update_me_modal").modal('hide')
  $("#keep_updated_button").click ->
    $("#success_alert").removeClass("hidden").children("#success_alert_text").text("We'll keep you updated on this company's funding!")
    $.getJSON location.pathname + '/subscribe?&email=' + $("#update_email").val()
  $("#success_alert").removeClass('hidden') unless $("#success_alert_text").text() == ''
