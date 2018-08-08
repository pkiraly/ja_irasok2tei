var old_clicked_note = null;
function display_note(id) {
  if (old_clicked_note != null) {
    old_clicked_note.removeClass('selected');
  }

  var clicked_note = $('#note-ref-' + id);
  clicked_note.addClass('selected');
  var offset = clicked_note.offset();

  var floating_note = $('#floating-note');
  if (floating_note.css('display') == 'none') {
    floating_note.css('display', 'block');
  }
  floating_note.offset({top: offset.top, left: 900});
  var floating_note_content = $('#floating-note .content');

  floating_note_content.html($('#note-' + id + ' .content').html());

  $('#floating-note .type').html(
    '<a href="#note-' + id + '">#' + id + '</a>'
    + ' (' + $('#note-' + id + ' .type').html() + ')'
    + ' <a href="#" onclick="return hide_note();" class="close-note">&#xd7;</a>'
  );

  old_clicked_note = clicked_note;
}

function hide_note() {
  var floating_note = $('#floating-note');
  if (floating_note.css('display') == 'block') {
    floating_note.css('display', 'none');
  }
  return false;
}
