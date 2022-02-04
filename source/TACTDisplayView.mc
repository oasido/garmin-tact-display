using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.ActivityMonitor as Mon;


class watchfaceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        
        // SECONDS
        var viewSeconds = View.findDrawableById("SecondsLabel");
        var seconds = Lang.format("$1$", [ clockTime.sec.format("%02d") ]);
        view.setText(timeString);
        viewSeconds.setText(seconds);
        
        // BATTERY
        var viewBattery = View.findDrawableById("BatteryLabel");
        // get sys stats
        var systemStats = System.getSystemStats();
		var battery = Lang.format("| $1$% |", [ (systemStats.battery*100).toNumber()/100 ]);
		viewBattery.setText(battery);
		
	
		var dateInfo = Calendar.info( Time.now(), Calendar.FORMAT_MEDIUM );
		var dateString = Lang.format("$1$ $2$ $3$", [ dateInfo.day_of_week, dateInfo.day, dateInfo.month ]);
		var date = View.findDrawableById("DateLabel");     
        date.setText(dateString);
         
         setStepCountDisplay();
         setHeartrateDisplay();
         
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        
    }
    

    private function setStepCountDisplay() {
    	var stepCount = Mon.getInfo().steps.toString();		
		var stepCountDisplay = View.findDrawableById("StepCountDisplay");      
		stepCountDisplay.setText(stepCount);		
    }
    
    
    private function setHeartrateDisplay() {
    	var heartRate = "";
    	
    	if(Mon has :INVALID_HR_SAMPLE) {
    		heartRate = retrieveHeartrateText();
    	}
    	else {
    		heartRate = "";
    	}
    	
	var heartrateDisplay = View.findDrawableById("HeartrateDisplay");      
	heartrateDisplay.setText(heartRate);
    }
    
    private function retrieveHeartrateText() {
    	var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
	var currentHeartrate = heartrateIterator.next().heartRate;

	if(currentHeartrate == Mon.INVALID_HR_SAMPLE) {
		return "";
	}

	return currentHeartrate.format("%d");
    }   
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

} 