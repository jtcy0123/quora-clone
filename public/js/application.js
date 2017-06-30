$(document).ready(function() {


  // for header and content display
  var contentPlacement = $('#header').height() + 5;
  $('#content').css('margin-top',contentPlacement );

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

        $('<div class="panel panel-info"><div class="panel-body">Subject:&ensp;<a href="/questions/'+ res.id +'/edit"><i class="w3-small fa fa-pencil-square-o" aria-hidden="true">edit</i></a>&ensp;<a href="/questions/'+ res.id +'/answers"><span class="badge w3-grey">0 answers</span></a><br><b style="font-size: 20px">'+ res.subject +'</b><div style="text-align: right; font-size: 10px"><span class="badge">'+ res.tag +'</span>&nbsp;created on&nbsp;'+ res.created_at.split('T')[0] +'</div></div><table><tr><td><form id="deleteForm" style="margin-bottom: -3px" action="/questions/'+ res.id +'" method="post"><input id="hidden" type="hidden" name="_method" value="delete"><button type="submit" id="deleteBtn" class="btn btn-danger"><i class="fa fa-trash"></i></button></form></td><td><a href="/questions/'+ res.id +'/answers/new"><button id="ansBtn" class="btn btn-default"><i class="fa fa-pencil">Answer</i></button></a></td></tr></table></div>').hide().insertAfter('#newQ').fadeIn(1000);
        $('#askModal').modal('hide');
      },
      error: function(data) {
        $('#error').html(data.responseText)
        $('#ask_question')[0].reset();
      }
    })
  })

  // when new answer submitted
  $('#ans_question').on('submit', function(event) {
    event.preventDefault()
    $.ajax({
      url: $(this).attr('action'),
      method: 'post',
      data: $(this).serialize(),

      success: function(data) {
        res = JSON.parse(data)
        
        $('#noAmsg').hide()

        num3 = parseInt($('#badge3').text()) + 1
        $('#badge3').text(num3)

        $('#ans_question')[0].reset();

        $('<div class="panel panel-default"><div class="panel-body">A: <b>'+ res.content +'</b><div style="text-align: right; font-size: 10px">updated on&nbsp;'+ res.updated_at.split('T')[0] +'&nbsp;by&nbsp;by you</div></div><form style="display: inline" action="/answers/'+ res.id +'" method="post"><input id="hidden" type="hidden" name="_method" value="delete"><button type="submit" id="deleteBtn" class="btn btn-danger"><i class="fa fa-trash"></i></button></form></div>').hide().insertAfter('#ansList').fadeIn(1000);
      },
      error: function(data) {
        $('#aerror').html(data.responseText)
        $('#ans_question')[0].reset();
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

  // for up voting using ajax
  $('.upvoteForm').on('submit',function(event) {
    event.preventDefault()
    $.ajax({
      url: $(this).attr('action'),
      method: 'post',
      data: $(this).serialize(),

      success: function(data) {
        res = JSON.parse(data)
        c = $('#down' + res.id).parent()

        a = parseInt($('#upvote' + res.id).text())
        b = parseInt($('#downvote' + res.id).text())
        c = $('#down' + res.id)
        if (res.vote == 0) {
          a -= 1
          $('#uvoteBtn:focus').removeClass('btn-primary').addClass('btn-info')
          $('#up' + res.id).text('upvote')
        }
        else {
          a += 1
          $('#uvoteBtn:focus').removeClass('btn-info').addClass('btn-primary')
          $('#up' + res.id).text('upvoted')
          if (c.text() == 'downvoted') {
            c.parent().removeClass('btn-primary').addClass('btn-info')
            c.text('downvote')
            b -= 1
            $('#downvote' + res.id).text(' '+ b)
          }
        }
        $('#upvote' + res.id).text(' '+ a)
      },

      error: function(data) {
        $('#errormsg').html('<div id="alert" class="alert alert-info"><strong>'+data.responseText+'</strong></div>')
      }
    })
  })

  // for down voting using ajax
  $('.downvoteForm').on('submit',function(event) {
    event.preventDefault()
    $.ajax({
      url: $(this).attr('action'),
      method: 'post',
      data: $(this).serialize(),

      success: function(data) {
        res = JSON.parse(data)

        d = parseInt($('#downvote' + res.id).text())
        u = parseInt($('#upvote' + res.id).text())
        c = $('#up' + res.id)
        if (res.vote == 0) {
          d -= 1
          $('#dvoteBtn:focus').removeClass('btn-primary').addClass('btn-info')
          $('#down' + res.id).text('downvote')
        }
        else {
          d += 1
          $('#dvoteBtn:focus').removeClass('btn-info').addClass('btn-primary')
          $('#down' + res.id).text('downvoted')
          if (c.text() == 'upvoted') {
            c.parent().removeClass('btn-primary').addClass('btn-info')
            c.text('upvote')
            u -= 1
            $('#upvote' + res.id).text(' '+ u)
          }
        }
        $('#downvote' + res.id).text(' '+ d)
      },

      error: function(data) {
        $('#errormsg').html('<div id="alert" class="alert alert-info"><strong>'+data.responseText+'</strong></div>')
      }
    })
  })

  $('#selectTag').on('change', function(){
    if ($('#selectTag').val() == 'Choose category') {
      $('#createQBtn').css("color", "#aaa")
      $('#createQBtn').attr('disabled', true)
    }
    else {
      $('#createQBtn').removeAttr("style")
      $('#createQBtn').removeAttr('disabled')
    }
  })

  // confirm to delete
  $('#deleteForm').on('submit', function(event) {
    var c = confirm('Are you sure you want to delete this question?')
    if (c != true) {
      event.preventDefault();
    }
  })

})
