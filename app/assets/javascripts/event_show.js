$(document).ready(function() {
  var events = gon.events;
  var isMobile = window.matchMedia("only screen and (max-width: 760px)").matches;

  console.log(events);

  $('#calendar').fullCalendar({
    editable: false,
    themeSystem: 'standard',
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,listYear'
    },
    defaultView: isMobile ? 'listYear' : 'month',
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

function registerEvent() {
  var eventId = $('#event_id').val();

  var event_register_url = location.protocol + '//' + window.location.host +
    '/events/' + eventId + '/register';

  $.post({
    url: event_register_url,
    success: function(data, status) {
      if (data.errors) {
        $('#event_modal_negative_message_div').show();
        $('#event_modal_negative_message').text(data.errors);
      } else {
        $('#event_modal_success_message_div').show();
        var registerEventButton = $('#register_event_button');
        if (data.registered) {
          $('#event_modal_success_message').text('🎉Successfully registered to this event!');
          registerEventButton.removeClass();
          registerEventButton.addClass('ui red button');
          registerEventButton.text('Unregister');
        } else {
          $('#event_modal_success_message').text('😢 You\'re unregistered from this event.');
          registerEventButton.removeClass();
          registerEventButton.addClass('ui green button');
          registerEventButton.text('Register');
        }
      }
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $('#event_modal_negative_message_div').show();
      $('#event_modal_negative_message').text('Error occurred during registration/unregistration.');
    }
  });
}

function approveEvent() {
  var confirmation = confirm('Are you sure you want to approve/unapprove this event?');
  if (!confirmation) {
    return;
  }

  var eventId = $('#event_id').val();

  var event_approve_url = location.protocol + '//' + window.location.host +
    '/events/' + eventId + '/approve';

  $.post({
    url: event_approve_url,
    success: function(data, status) {
      if (data.errors) {
        $('#event_modal_negative_message_div').show();
        $('#event_modal_negative_message').text(data.errors);
      } else {
        $('#event_modal_success_message_div').show();
        var approveEventButton = $('#approve_event_button');
        if (data.approved) {
          $('#event_modal_success_message').text('This event is now publically visible.');
          approveEventButton.removeClass();
          approveEventButton.addClass('ui red button');
          approveEventButton.text('Unapprove');
        } else {
          $('#event_modal_success_message').text('This event is no longer publically visible.');
          approveEventButton.removeClass();
          approveEventButton.addClass('ui green button');
          approveEventButton.text('Approve');
        }
      }
    },
    error: function(XMLHttpRequest, textStatus, errorThrown) {
      $('#event_modal_negative_message_div').show();
      $('#event_modal_negative_message').text('Error occurred during approval.');
    }
  });
}

function showEventModal(eventId) {
  $('#event_id').val(eventId);
  $('#event_modal_loader').addClass('active');
  $('#event_modal_content').text('');
  $('#event_modal_header').text('Loading...');
  $('#event_modal_negative_message_div').hide();
  $('#event_modal_success_message_div').hide();
  $('#event_modal_date_label').hide();
  $('#event_modal_actions').hide();
  $('#event_modal').modal({
    onHide: function() {
      if (history.pushState) {
        var newUrl = window.location.protocol + "//" + window.location.host +
         window.location.pathname;
         window.history.pushState({path:newUrl},'',newUrl);
       }
    }
  }).modal('show');

  var eventUrl = location.protocol + '//' + window.location.host +
    '/events/' + eventId;

  // Update the URL in the navigation bar
  if (history.pushState) {
    var newUrl = window.location.protocol + "//" + window.location.host +
     window.location.pathname + '?eventId=' + eventId;
     window.history.pushState({path:newUrl},'',newUrl);
   }

  // Ajax call to get the event
  $.ajax({
    url: eventUrl,
    type: 'GET',
    success: function(data, status){
      // Set text in modal
      $('#event_modal_loader').removeClass('active');
      $('#event_modal_date_label').html(
        '<i class="calendar outline icon"></i>' +
        parseTime(data.start_time) + ' - ' + parseTime(data.end_time)
      );
      $('#event_modal_date_label').show();
      $('#event_modal_header').text(data.title);
      $('#event_modal_content').text(data.description);

      // Update modal actions
      $('#event_modal_actions').show();
      var editEventButton = $('#edit_event_button');
      if (editEventButton) {
        editEventButton.attr('href', window.location.protocol + "//" + window.location.host +
          '/events/' + eventId);
      }

      var approveEventButton = $('#approve_event_button');
      if (approveEventButton) {
        if (data.approved) {
          approveEventButton.removeClass();
          approveEventButton.addClass('ui red button');
          approveEventButton.text('Unapprove');
        } else {
          approveEventButton.removeClass();
          approveEventButton.addClass('ui green button');
          approveEventButton.text('Approve');
        }
      }

      var registrationButton = $('#register_event_button');
      if (registrationButton) {
        if (data.registered) {
          registrationButton.removeClass();
          registrationButton.addClass('ui red button');
          registrationButton.text('Unregister');
        } else {
          registrationButton.removeClass();
          registrationButton.addClass('ui green button');
          registrationButton.text('Register');
        }
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
