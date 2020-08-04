$(function(){

  function buildHTML_tooltip(contents){
    let html = `<div>
                  ${contents}
                </div>`;
    return html;
  }

  $(".ShowField__line").tooltip({
    content: function() {
      return buildHTML_tooltip($(this).parent().data("contents"));
    },
    position: {
      my: "right bottom+30",
      at: "bottom",
      collision: "flipfit"
    }
  });

  $.ajax({
    type: 'GET',
    url: '/tweets',
    dataType: 'json',
    data: ""
  })
  .done(function(data){
    let background = "#ffffff"
    if (data.bgc == 1){
      background = "#202030"
    }
    else if (data.bgc == 2){
      background = "#202050"
    }
    else if (data.bgc == 3){
      background = "#e0e0e0"
    }
    let root = document.documentElement;
    root.style.setProperty("--back-color", background);    
  })
  .fail(function(){
    console.log("bgc-error")
  })


});
