<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/moment.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/fullcalendar.js" charset="UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/locale-all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/gcal.js"></script>
<script type="text/javascript">
    jQuery(document).ready(function() {
    	
    	$("#storeName").text("${storeInfo.name}"+" Schedule");
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
                        end: end.unix(),
                        sid: "${storeInfo.sid}"
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

/*     	$('#calendar').on('click','.fc-day-top',function(){
    	     var date=$(this).attr('data-date');
			 alert(date);
    	});  */
        
    });
    

   
</script>

<div class="container">
	
	<div class="col-lg-12">
	<h2 id="storeName" style="margin-top: 40px;text-align: center;font-size: 60;"></h2>
	</div>
	<div class="col-lg-4"></div>
	<div class="col-lg-4">
	<c:if test="${checkPosition==1}">
		<form action="calendar.do" method="get">
		<select class="select_Store form-control" name="sid"  style="margin:20px 0px 0px 40px;width:200px">
				<c:forEach items="${storeList}" var="n">
					<c:if test="${n.sid==storeInfo.sid}">
						<option value="${n.sid}" selected="selected">${n.name}</option>
					</c:if>
					<c:if test="${n.sid!=storeInfo.sid}">
						<option value="${n.sid}">${n.name}</option>
					</c:if>
				</c:forEach>
		</select>
		<button type="submit" class="btn btn-default changeStorebtn"  style="margin-top: 20px;">변경</button>
		</form>
	</c:if>
	</div>
	<div class="col-lg-4">
	<c:if test="${checkPosition=='1'}">
	<a href="editSchedule.do" class="btn btn-default"  style="margin:20px 0px 0px 70%;">스케줄 등록/변경</a>
	</c:if>
	<c:if test="${checkPosition!='1'}">
	<a href="editSchedule.do" class="btn btn-default"  style="margin:20px 0px 0px 70%;">스케줄 조회</a>
	</c:if>
	</div>
	
	<div id="calendar" style="margin-top: 190px;">
	</div>
</div>