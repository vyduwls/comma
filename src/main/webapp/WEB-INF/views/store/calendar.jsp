<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function() {
        jQuery("#calendar").fullCalendar({
              defaultDate : Date()
            , locale : "ko"
            , editable : true
            , eventLimit : true
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
        
        $(".fc-content").click(function(){
        	var content=$(this).children("span[class=fc-time]").text()+" "+$(this).children("span[class=fc-title]").text()
        	alert(content);
        	
        });
    });
</script>

<div class="container">
	<div id="calendar">
	</div>
</div>