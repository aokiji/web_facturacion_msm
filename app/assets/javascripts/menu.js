function initialize_menu(){
   $(".menu01").click(function(){
       if(false == $(this).next().is(":visible")) {
           $(".menu02").slideUp(300);
       }
       $(this).next().slideToggle("normal");
   });     
}
$(document).ready(initialize_menu);
$(document).on('page:load', initialize_menu);
