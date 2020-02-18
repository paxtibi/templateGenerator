+ function ($) {
  'use strict';

  // PUBLIC CLASS DEFINITION
  // ==============================

  var <%class-name%> = function (element, options) {
    this.$element = $(element);
    this.options = $.extend({}, <%class-name%>.DEFAULTS, options);
    this.isLoading = false;
    console.log(this.$element);
    console.log('<%plugin-name%>');
  }   


  <%class-name%>.VERSION = '<%version%>';

  <%class-name%>.DEFAULTS = {
    loadingText: 'loading...'
  }
     
  <%class-name%>.prototype.toggle = function(){
	}

  // <%class-name%> PLUGIN DEFINITION
  // ========================

  function Plugin(option) {
    return this.each(function () {
      var $this = $(this)
      var data = $this.data('bs.<%plugin-name%>')
      var options = typeof option == 'object' && option

      if (!data) $this.data('bs.<%plugin-name%>', (data = new <%class-name%> (this, options)))

      if (option == 'toggle') data.toggle()
      else if (option) data.setState(option)
    })
  }

  var old = $.fn.<%plugin-name%>

  $.fn.<%plugin-name%> = Plugin
  $.fn.<%plugin-name%>.Constructor = <%class-name%>


  // <%class-name%> NO CONFLICT
  // ==================

  $.fn.<%plugin-name%>.noConflict = function () {
    $.fn.<%plugin-name%> = old;
    return this;
  }
  // <%class-name%> DATA-API
  
  $('<%selector%>').<%plugin-name%>();
}(jQuery);