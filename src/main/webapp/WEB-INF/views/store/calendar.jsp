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
            , events: [
                {
                      title : "All Day Event"
                    , start : "2017-07-01"
                },
                {
                      title : "Long Event"
                    , start : "2017-07-07"
                    , end : "2017-07-10"
                },
                {
                      id : 999
                    , title : "Repeating Event"
                    , start : "2017-07-09T16:00:00"
                },
                {
                      id : 999
                    , title : "Repeating Event"
                    , start : "2017-07-16T16:00:00"
                },
                {
                      title : "Conference"
                    , start : "2017-07-11"
                    , end : "2017-07-13"
                },
                {
                      title : "Meeting"
                    , start : "2017-07-12T10:30:00"
                    , end : "2017-07-12T12:30:00"
                },
                {
                      title : "Lunch"
                    , start : "2017-07-12T12:00:00"
                },
                {
                      title : "Meeting"
                    , start : "2017-07-12T14:30:00"
                },
                {
                      title : "Happy Hour"
                    , start : "2017-07-12T17:30:00"
                },
                {
                      title : "Dinner"
                    , start : "2017-07-12T20:00:00"
                },
                {
                      title : "Birthday Party"
                    , start : "2017-07-13T07:00:00"
                },
                {
                      title : "Click for Google"
                    , url : "http://google.com/"
                    , start : "2017-07-28"
                }
            ]
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
	<a href="edit_Schedule.do" class="btn btn-default" style="margin: 3% 0% 0% 90%">스케줄 등록/변경</a>
	<div id="calendar">
	</div>
</div>