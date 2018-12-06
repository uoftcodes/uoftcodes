$(document).ready(function() {
  var events = gon.events;

  console.log(events);

  $('#calendar').fullCalendar({
    editable: false,
    themeSystem: 'standard',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,list'
    },
    events: events,
    eventClick: function(calEvent, jsEvent, view) {
      showEventModal(calEvent.id);
    }
  });
});

$(document).ready(function() {
  var urlParams = new URLSearchParams(window.location.search);
  var eventId = parseInt(urlParams.get('eventId'));

  if (!isNaN(eventId)) {
    showEventModal(eventId);
  }
});

function getEvents() {

}

function showEventModal(eventId) {
  $('#event_modal_loader').addClass('active');
  $('#event_modal_content').text('');
  $('#event_modal_header').text('Loading...');
  $('#event_modal_date_label').hide();
  $('#event_modal').modal({
    onHide: function() {
      if (history.pushState) {
        var newurl = window.location.protocol + "//" + window.location.host +
         window.location.pathname;
         window.history.pushState({path:newurl},'',newurl);
       }
    }
  }).modal('show');

  var eventUrl = location.protocol + '//' + window.location.host +
    '/events/' + eventId;

  if (history.pushState) {
    var newurl = window.location.protocol + "//" + window.location.host +
     window.location.pathname + '?eventId=' + eventId;
     window.history.pushState({path:newurl},'',newurl);
   }

  $.get({
    url: eventUrl,
    success: function(data, status){
      $('#event_modal_loader').removeClass('active');
      if (status == 'success') {
        $('#event_modal_date_label').html(
          "<i class=\"calendar outline icon\"></i>" +
          parseTime(data.start_time) + " - " + parseTime(data.end_time)
        );
        $('#event_modal_date_label').show();
        $('#event_modal_header').text(data.title);
        $('#event_modal_content').text(data.description);
      } else {
        $('#event_modal_content').text('Error loading content');
      }
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $('#event_modal_loader').removeClass('active');
      $('#event_modal_content').text('Error loading content');
    }
  });
}

function parseTime(t) {
  var time = new Date(Date.parse(t));
  var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  var year = time.getFullYear();
  var month = months[time.getMonth()];
  var date = time.getDate();
  var hour = time.getHours();
  var minute = time.getMinutes();
  return month + " " + date + ", " + year + " " + hour + ":" + minute;
}
