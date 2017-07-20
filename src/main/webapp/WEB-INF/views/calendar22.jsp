<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<title>풀캘린더</title>
<style type="text/css">
    body {
        margin: 40px 10px;
        padding: 0;
        font-family: "Lucida Grande",Helvetica,Arial,Verdana,sans-serif;
        font-size: 16px;
    }

    #calendar {
        max-width: 70%;
        margin: 0 auto;
    }

    .fc-day-number.fc-sat.fc-past { color:#0000FF; }
    .fc-day-number.fc-sun.fc-past { color:#FF0000; }
</style>
<link href="./css/fullcalendar.css" rel="stylesheet"/>
<link href="./css/fullcalendar.print.css" rel="stylesheet" media="print"/>
<script type="text/javascript" src="./js/moment.min.js"></script>
<script type="text/javascript" src="./js/jquery.min.js"></script>
<script type="text/javascript" src="./js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="./js/locale-all.js"></script>
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
<body>
<br><br>
    <div id="calendar"></div>
</body>