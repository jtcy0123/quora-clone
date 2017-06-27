$(document).ready(function() {

  // flash messages
  $('.alert').hide().slideDown(500);
  setTimeout(function(){$('#danger').fadeTo(1000,0.4);}, 5000);
  setTimeout(function(){$('#alert').fadeOut();}, 4000);
  $(window).click(function(){$('.alert').fadeOut();});

  // when new question submitted
  $('#ask_question').on('submit', function(event) {
    event.preventDefault()
    $.ajax({
      url: '/questions',
      method: 'post',
      data: $(this).serialize(),

      success: function(data) {
        res = JSON.parse(data)
        
        $('#noQmsg').hide()

        num1 = parseInt($('#badge1').text()) + 1
        num2 = parseInt($('#badge2').text()) + 1
        $('#badge1').text(num1)
        $('#badge2').text(num2)

        $('#ask_question')[0].reset();

        $('<div class="panel panel-default"><div class="panel-heading">Subject:&ensp;<a href="/questions/'+ res.id +'/edit"><i class="w3-small fa fa-pencil-square-o" aria-hidden="true">edit</i></a>&ensp;<a href="/questions/'+ res.id +'/answers"><span class="badge">see all answers</span></a><br><b>'+ res.subject +'</b></div><div class="panel-body"><i style="color: #ccc">DESCRIPTION:</i><br>'+ res.description +'</div><table><tr><td><form style="margin-bottom: -3px" action="/questions/'+ res.id +'" method="post"><input id="hidden" type="hidden" name="_method" value="delete"><button type="submit" id="deleteBtn" class="btn btn-danger"><i class="fa fa-trash"></i></button></form></td><td><a href="/questions/'+ res.id +'/answers/new"><button id="ansBtn" class="btn btn-default"><i class="fa fa-pencil">Answer</i></button></a></td></tr></table></div>').hide().insertAfter('#ask_question').fadeIn(1000);
      },
      error: function(data) {
        $('#error').html(data.responseText)
        $('#ask_question')[0].reset();
      }
    })
  })
  
  // for editing names
  $('#edit_name').click(function() {
    val1 = $('#fname').text()
    val2 = $('#lname').text()
    $('#fullname').hide()
    $('#nameform').html('First name:<input type=text placeholder="First Name" name="user[first_name]" value="'+val1+'" required><br>Last name:<input type=text placeholder="Last Name" name="user[last_name]" value="'+val2+'" required><input type=submit value="Save">')
  })

  // for editing email
  $('#edit_email').click(function() {
    value = $('#uemail').text()
    $('#hideemail').hide()
    $('#emailform').html('<input type=text placeholder="Email" name="user[email]" value="'+value+'" required><input type=submit value="Save">')
  })

  // for voting using ajax
  $('.voteForm').on('submit',function(event) {
    event.preventDefault()
    $.ajax({
      url: $(this).attr('action'),
      method: 'post',
      data: $(this).serialize(),

      success: function(data) {
        res = JSON.parse(data)

        a = parseInt($('#vote' + res.id).text())
        if (res.vote == 0) {
          a -= 1
          $('#voteBtn:focus').removeClass('btn-primary').addClass('btn-info')
          $('#like' + res.id).text('like')
        }
        else {
          a += 1
          $('#voteBtn:focus').removeClass('btn-info').addClass('btn-primary')
          $('#like' + res.id).text('liked')
        }
        $('#vote' + res.id).text(' '+ a)
      },

      error: function(data) {
        $('#errormsg').html('<div id="alert" class="alert alert-info"><strong>'+data.responseText+'</strong></div>')
      }
    })
  })


  // $('#voteBtn i').click(function(e) {
  //   var voted = $(this).data('clicks');
  //   if (voted) {
  //     $('#voteBtn:focus').removeAttr('style')
  //     ele = $(e.target)
  //     vote = parseInt(ele.text()) - 1
  //     ele.text('  ' + vote)
  //   } else {
  //     $('#voteBtn:focus').css({'background':'#428bda', 'border-color':'#428bda', 'font-size':'18px'})
  //     ele = $(e.target)
  //     vote = parseInt(ele.text()) + 1
  //     ele.text('  ' + vote)
  //   }
  //   $(this).data("clicks", !voted);
  // })

})
