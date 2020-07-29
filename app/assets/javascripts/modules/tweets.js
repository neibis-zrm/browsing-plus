$(function(){

  function buildHTML_tooltip(contents){
    let html = `<div>
                  ${contents}
                </div>`;
    return html;
  }

  $(".ShowField__line").on('click', function(e){
    console.log("click")
  });

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

});
