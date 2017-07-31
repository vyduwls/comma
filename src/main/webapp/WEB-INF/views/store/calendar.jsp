<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gcal.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function() {
        $("#calendar").fullCalendar({
              defaultDate : Date()
            , locale : "ko"
            , editable : false
            , eventLimit : true
            , googleCalendarApiKey : "AIzaSyDcnW6WejpTOCffshGDDb4neIrXVUA1EAE"      // Google API KEY
            , eventSources : [
                    // 대한민국의 공휴일
                    {
                          googleCalendarId : "ko.south_korea#holiday@group.v.calendar.google.com"
                        , className : "koHolidays"
                        , color : "red"
                        , textColor : "#FFFFFF" 
                    }
              ],
              events: function(start, end,timezone, callback) {
        		$.ajax({
        		    url: 'fullSchedule.do',
        		    data: {
                        // our hypothetical feed requires UNIX timestamps
                        start: start.unix(),
                        end: end.unix()
                    },
        		    dataType: 'json',
        		    error:function(request,status,error){
        		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
       		        },
       		        success:function(doc) {
       	                var events = [];
       	                $(doc).each(function() {
       	                    events.push({
       	                        title: $(this).attr('title'),
       	                        start: $(this).attr('start') // will be parsed
       	                    });
       	                });
       	                callback(events);
       	            },
       	         loading: function(bool) {
       	            $('#loading').toggle(bool);
       	        }
        		});
            }
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