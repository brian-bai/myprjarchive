// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function viewDialog(ele, x){ 
  $('#comment'+x).toggle();
  $(ele).text($(ele).text() == 'Write comment' ? 'Hide comment box' : 'Write comment');
}

