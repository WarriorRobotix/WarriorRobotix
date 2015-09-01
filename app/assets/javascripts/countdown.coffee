(($, window) ->
  # Define the plugin
  $.fn.extend countdown: ->
    @each ->
      $this = $(this)
      unless $this.data('distance')?
        now = new Date()
        end = new Date($this.data('datetime'))
        $this.data('distance', end - now)
      else
        $this.data('distance', $this.data('distance') - 1000 )

      distance = Math.max( $this.data('distance'), 0 );

      _day = 86400000
      _hour = 3600000
      _minute = 60000
      _second =  1000

      $this.find('.days').text(~~(distance / _day))
      $this.find('.hours').text(~~((distance % _day) / _hour))
      $this.find('.minutes').text(~~((distance % _hour) / _minute))
      $this.find('.seconds').text(~~((distance % _minute) / _second))
      unless distance == 0
        setTimeout ->
          $this.countdown()
          console.log('lol')
        , 1000

) window.jQuery, window
