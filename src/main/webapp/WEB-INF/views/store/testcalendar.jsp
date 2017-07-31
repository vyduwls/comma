<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gcal.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery("#calendar").fullCalendar({
              defaultDate : Date()
            , locale : "ko"
            , editable : false
            , eventLimit : false
            , googleCalendarApiKey : "AIzaSyDcnW6WejpTOCffshGDDb4neIrXVUA1EAE"      // Google API KEY
            , eventSources : [
                    // 대한민국의 공휴일
                    {
                          googleCalendarId : "ko.south_korea#holiday@group.v.calendar.google.com"
                        , className : "koHolidays"
                        , color : "red"
                        , textColor : "#FFFFFF" 
                    }
              ]
            , events: function(start, end, timezone, callback) {
                $.ajax({
                    url: 'doCalendar.do',
                    type : 'post',
                    data : {EVENT_CODE : '11', LANG : lang_cd, startDate : start.format(), endDate : end.format() },
                    dataType: 'json',
                    success: function(data) {
                        var events = [];
                        $(data).each(function() {
                            events.push({
                                title: $(this).attr('title'),
                                start: $(this).attr('start'),
                                end: $(this).attr('end'),
                                url: "/test/eventDetail.do?id="+$(this).attr('id')+"&amp;lang="+$(this).attr('lang')+"&amp;start="+$(this).attr('start')+"&amp;end="+$(this).attr('end'),
                                lang : $(this).attr('lang')
                            });
                        });
                        callback(events);
                    }
                });
  
        });
        
/*          $(".fc-day").click(function(){
    	     var date=$(this).attr("data-date");
			 alert(date);
        }); */
    	$('#calendar').on('click','.fc-day-top',function(){
    	     var date=$(this).attr('data-date');
			 alert(date);
    	}); 
        
    });
</script>

<div class="container">
	<a href="editSchedule.do" class="btn btn-default" style="margin: 3% 0% 0% 90%">스케줄 등록/변경</a>
	<div id="calendar">
	</div>
</div>