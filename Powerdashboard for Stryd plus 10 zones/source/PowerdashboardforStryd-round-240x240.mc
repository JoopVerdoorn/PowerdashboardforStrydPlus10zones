class PowerdashboardforStrydplus10zonesApp extends Toybox.Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new DatarunView() ];
    }
}


class DatarunView extends Toybox.WatchUi.DataField {
	using Toybox.WatchUi as Ui;

	//!Get device info
	var mySettings = System.getDeviceSettings();
	var screenWidth = mySettings.screenWidth;
	var screenShape = mySettings.screenShape;
	var screenHeight = mySettings.screenHeight;
	var distanceUnits = mySettings.distanceUnits;
	var watchType = mySettings.partNumber;
	var is24Hour = mySettings.is24Hour;   //!boolean
	var isTouchScreen = mySettings.isTouchScreen;  //!boolean
	var numberis24Hour = 0;
	var numberisTouchScreen = 0;

    hidden var unitP                        = 1000.0;
	hidden var uNoAlerts = false;
    hidden var uPowerZones                  = "180:Z1:210:Z2:240:Z3:270:Z4:300:Z5:330:Z6:360:Z7:390:Z8:420:Z9:450:Z10:480";	
	hidden var uRequiredPower		 		= "000:999";
	var Power1 									= 0;
    var Power2 									= 0;
    var Power3 									= 0;
	var Power4 									= 0;
    var Power5 									= 0;
	var Power6 									= 0;
    var Power7 									= 0;
    var Power8 									= 0;
	var Power9 									= 0;
    var Power10									= 0;
	var Power11 									= 0;
    var Power12 									= 0;
    var Power13 									= 0;
	var Power14 									= 0;
    var Power15 									= 0;
	var Power16 									= 0;
    var Power17 									= 0;
    var Power18									= 0;
	var Power19 									= 0;
    var Power20									= 0;
	var Power21 									= 0;
    var Power22 									= 0;
    var Power23 									= 0;
	var Power24 									= 0;
    var Power25 									= 0;
	var Power26 									= 0;
    var Power27 									= 0;
    var Power28 									= 0;
	var Power29 									= 0;
    var Power30									= 0;

	var Pace1 									= 0;
    var Pace2 									= 0;
    var Pace3 									= 0;
	var Pace4 									= 0;
    var Pace5 									= 0;
	var Pace6 									= 0;
    var Pace7 									= 0;
    var Pace8 									= 0;
	var Pace9 									= 0;
    var Pace10									= 0;
	var Pace11 									= 0;
    var Pace12 									= 0;
    var Pace13 									= 0;
	var Pace14 									= 0;
    var Pace15 									= 0;
	var Pace16 									= 0;
    var Pace17 									= 0;
    var Pace18									= 0;
	var Pace19 									= 0;
    var Pace20									= 0;
	var Pace21 									= 0;
    var Pace22 									= 0;
    var Pace23 									= 0;
	var Pace24 									= 0;
    var Pace25 									= 0;
	var Pace26 									= 0;
    var Pace27 									= 0;
    var Pace28 									= 0;
	var Pace29 									= 0;
    var Pace30									= 0;


    //! License serial
    hidden var umyNumber                    = 0;
    
    //! Show demoscreen
    hidden var uShowDemo					= false;

    hidden var uBacklight                   = false;
    //! true     => Force the backlight to stay on permanently
    //! false    => Use the defined backlight timeout as normal
	
	hidden var uPowerAveraging              = 1;

    hidden var uUpperRightMetric            = 0;    //! Data to show in upper right field
    hidden var uBottomLeftMetric            = 1;    //! Data to show in bottom left field
    hidden var uBottomRightMetric           = 2;    //! Data to show in bottom right field

    
    hidden var uWarningFreq = 5; 
	hidden var vibrateseconds = 0;
	hidden var DisplayPower = 0;
	hidden var mCurrentPowerZone = 0;
	hidden var mfillAColour = Graphics.COLOR_LT_GRAY;
	hidden var mfillLColour = Graphics.COLOR_LT_GRAY;
		
    hidden var mTimerRunning                = false;
    hidden var mStartStopPushed             = 0;    //! Timer value when the start/stop button was last pushed

    hidden var mLaps                        = 1;
    hidden var mLastLapPowerMarker          = 0;
	hidden var mLastLapHeartrateMarker      = 0;
    hidden var mLastLapTimeMarker           = 0;
    hidden var mLastLapStoppedTimeMarker    = 0;
    hidden var mLastLapStoppedPowerMarker   = 0;
    hidden var mLastLapStoppedHeartrateMarker    = 0;
    hidden var mLastLapDistMarker           = 0;
	hidden var mLastLapElapsedDistance      = 0;
    
    hidden var mLastLapTimerTime            = 0;
    hidden var mCurrentPower    			= 0; 
    hidden var mElapsedPower	   			= 0;
    hidden var mElapsedHeartrate   			= 0;
    hidden var mLastLapElapsedPower			= 0;
    hidden var mPowerTime					= 0;
    hidden var mCurrentHeartrate    		= 0; 
    hidden var mLastLapElapsedHeartrate		= 0;
    hidden var mHeartrateTime				= 0;
    hidden var mEH = 0;
    hidden var mLLHRM = 0;

    function initialize() {
    	 DataField.initialize();

		 var mApp = Application.getApp();
         uPowerAveraging     = mApp.getProperty("pPowerAveraging");
         uBottomLeftMetric   = mApp.getProperty("pBottomLeftMetric");
         uBottomRightMetric  = mApp.getProperty("pBottomRightMetric");
         uUpperRightMetric   = mApp.getProperty("pUpperRightMetric");
         uBacklight          = mApp.getProperty("pBacklight");
         umyNumber			 = mApp.getProperty("myNumber");
         uShowDemo			 = mApp.getProperty("pShowDemo");
         uPowerZones		 = mApp.getProperty("pPowerZones");
         uRequiredPower		 = mApp.getProperty("pRequiredPower");
         uWarningFreq		 = mApp.getProperty("pWarningFreq");
         
         if (System.getDeviceSettings().paceUnits == System.UNIT_STATUTE) {
            unitP = 1609.344;
        }
    }


    //! Calculations we need to do every second even when the data field is not visible
    function compute(info) {
		//! If enabled, switch the backlight on in order to make it stay on
        if (uBacklight) {
             Attention.backlight(true);
        }

        var mElapsedDistance    = (info.elapsedDistance != null) ? info.elapsedDistance : 0.0;
        var mLapElapsedDistance = mElapsedDistance - mLastLapDistMarker;
        if (mTimerRunning) {  //! We only do some calculations if the timer is running
            mCurrentPower    = (info.currentPower != null) ? info.currentPower : 0;
            mPowerTime		 = (info.currentPower != null) ? mPowerTime+1 : mPowerTime;
            mElapsedPower    = mElapsedPower + mCurrentPower;  
            var mLapElapsedPower = mElapsedPower - mLastLapPowerMarker;
            mCurrentHeartrate    = (info.currentHeartRate != null) ? info.currentHeartRate : 0;
            mHeartrateTime		 = (info.currentHeartRate != null) ? mHeartrateTime+1 : 0;
			if (mHeartrateTime == 0) {
				var mElapsedHeartrate = 0;
			} if (mHeartrateTime == 1) {
				mElapsedHeartrate = mCurrentHeartrate;
			} if (mHeartrateTime > 1) {				
            	mElapsedHeartrate    = mElapsedHeartrate + mCurrentHeartrate;
            }
            mEH = mElapsedHeartrate  ;
            var mLapElapsedHeartrate = mElapsedHeartrate - mLastLapHeartrateMarker;
        }
    }

    //! Store last lap quantities and set lap markers
    function onTimerLap() {
        var info = Activity.getActivityInfo();

        mLastLapTimerTime        = mPowerTime - mLastLapTimeMarker;
        mLastLapElapsedPower  = (info.currentPower != null) ? mElapsedPower - mLastLapPowerMarker : 0;
        mLastLapElapsedHeartrate = (info.currentHeartRate != null) ? mEH - mLLHRM : 0;
        mLastLapElapsedDistance  = (info.elapsedDistance != null) ? info.elapsedDistance - mLastLapDistMarker : 0;


        mLaps++;
        mLastLapDistMarker           = (info.elapsedDistance != 0) ? info.elapsedDistance : 0;
        mLastLapPowerMarker           = mElapsedPower;
        mLastLapTimeMarker            = mPowerTime;
        mLLHRM       = mEH;       
    }
    
    //! Timer transitions from stopped to running state
    function onTimerStart() {
        startStopPushed();
        mTimerRunning = true;
    }


    //! Timer transitions from running to stopped state
    function onTimerStop() {
        startStopPushed();
        mTimerRunning = false;
    }


    //! Timer transitions from paused to running state (i.e. resume from Auto Pause is triggered)
    function onTimerResume() {
        mTimerRunning = true;
    }


    //! Timer transitions from running to paused state (i.e. Auto Pause is triggered)
    function onTimerPause() {
        mTimerRunning = false;
    }


    //! Start/stop button was pushed - emulated via timer start/stop
    function startStopPushed() {
        var info = Activity.getActivityInfo();
        var doublePressTimeMs = null;
        if ( mStartStopPushed > 0  &&  info.elapsedTime > 0 ) {
            doublePressTimeMs = info.elapsedTime - mStartStopPushed;
        }
        if ( doublePressTimeMs != null  &&  doublePressTimeMs < 5000 ) {
            uNoAlerts = !uNoAlerts;
        }
        mStartStopPushed = (info.elapsedTime != null) ? info.elapsedTime : 0;
      }


    //! Current activity is ended
    function onTimerReset() {
        mLaps                        = 1;
        mLastLapHeartrateMarker      = 0;
        mLastLapTimeMarker           = 0;
        mLastLapTimerTime            = 0;
        mLastLapElapsedHeartrate     = 0;
        mStartStopPushed             = 0;
    }


    //! Do necessary calculations and draw fields.
    //! This will be called once a second when the data field is visible.
    function onUpdate(dc) {
        var info = Activity.getActivityInfo();
        var mColour;
		var	mColourFont = Graphics.COLOR_BLACK;
		var	mColourFont1 = Graphics.COLOR_BLACK;
		var	mColourLine = Graphics.COLOR_RED;
		var mColourBackGround = Graphics.COLOR_WHITE;
        	
    	//! Check license
		if (is24Hour == false) {
        	numberis24Hour = 77;
    	} else {
    		numberis24Hour = 19;
    	}
    	if (isTouchScreen == false) {
        	numberisTouchScreen = 93;
    	} else {
    		numberisTouchScreen = 3;
    	}
		var deviceID1 = (screenWidth+screenShape)*(screenHeight+distanceUnits)-numberis24Hour-numberisTouchScreen;
		var deviceID2 = numberis24Hour+numberisTouchScreen;
		var mtest = (numberisTouchScreen+distanceUnits)*screenWidth-(screenHeight+numberis24Hour)*screenShape;
	   	   
        //! Calculate lap power
        var mLapElapsedPower = 0;
        if (info.currentPower != null) {
            mLapElapsedPower = mElapsedPower - mLastLapPowerMarker;
        }

        //! Calculate lap heartrate
        var mLapElapsedHeartrate = 0;
        if (info.currentHeartRate != null) {
            mLapElapsedHeartrate = mElapsedHeartrate - mLastLapHeartrateMarker;
        }

        //! Calculate lap distance
        var mLapElapsedDistance = 0.0;
        if (info.elapsedDistance != null) {
            mLapElapsedDistance = info.elapsedDistance - mLastLapDistMarker;
        }
        
        //! Calculate lap time and convert timers from milliseconds to seconds
        var mTimerTime      = 0;
        var mLapTimerTime   = 0;

        if (info.timerTime != null) {
            mTimerTime = mPowerTime;
            mLapTimerTime = mPowerTime - mLastLapTimeMarker;
        }
        
                //! Calculate lap speeds
        var mLapSpeed = 0.0;
        var mLastLapSpeed = 0.0;
        if (mLapTimerTime > 0 && mLapElapsedDistance > 0) {
            mLapSpeed = mLapElapsedDistance / mLapTimerTime;
        }
        if (mLastLapTimerTime > 0 && mLastLapElapsedDistance > 0) {
            mLastLapSpeed = mLastLapElapsedDistance / mLastLapTimerTime;
        }

		//!Calculate metrics
		var AverageHeartrate			= (mHeartrateTime != 0) ? mElapsedHeartrate/mHeartrateTime : 0;  //! beats per minute
		var LapHeartrate				= (mLapTimerTime != 0) ? mLapElapsedHeartrate/mLapTimerTime : 0;  //! beats per minute
		var LastLapHeartrate			= (mLastLapTimerTime != 0) ? mLastLapElapsedHeartrate/mLastLapTimerTime : 0; //! beats per minute
		var AveragePower 				= (mPowerTime != 0) ? mElapsedPower/mPowerTime : 0; //! watt
		var LapPower 					= (mLapTimerTime != 0) ? Math.round(mLapElapsedPower/mLapTimerTime) : 0; //! watt
		var LastLapPower 				= (mLastLapTimerTime != 0) ? mLastLapElapsedPower/mLastLapTimerTime : 0; //! watt
		var AverageEfficiencyIndex   	= (info.averageSpeed != null && AveragePower != 0) ? info.averageSpeed*60/AveragePower : 0; //! average lap speed in meters per minute, divided by current lap Stryd power in watts
		var LapEfficiencyIndex   		= (LapPower != 0) ? mLapSpeed*60/LapPower : 0;   //! current lap speed in meters per minute, divided by current lap Stryd power in watts
		var LastLapEfficiencyIndex   	= (LastLapPower != 0) ? mLastLapSpeed*60/LastLapPower : 0;   //! last lap speed in meters per minute, divided by last lap Stryd power in watts
		var AverageEfficiencyFactor   	= (info.averageSpeed != null && AverageHeartrate != 0) ? info.averageSpeed*60/AverageHeartrate : 0; //! average speed in meters per minute,  divided by average heartrate in beats/minute
		var LapEfficiencyFactor   		= (LapHeartrate != 0) ? mLapSpeed*60/LapHeartrate : 0; //! current lap speed in meters per minute,  divided by current lap heartrate in beats/minute
		var LastLapEfficiencyFactor   	= (LastLapHeartrate != 0) ? mLastLapSpeed*60/LastLapHeartrate : 0;   //! last lap speed in meters per minute,  divided by last lap heartrate in beats/minute 
		
        var AveragePower3sec  	 			= 0;
        var AveragePower5sec  	 			= 0;
        var AveragePower10sec  	 			= 0;
        var AveragePower20sec  	 			= 0;
        var AveragePower30sec  	 			= 0;
        var currentPowertest				= 0;
        if (info.currentSpeed != null && info.currentPower != null) {
        	currentPowertest = info.currentPower; 
        }
        if (currentPowertest > 0) {
            if (currentPowertest > 0) {
            	//! Calculate average power
				if (info.currentSpeed != null) {
        			Power1								= info.currentPower; 
        		} else {
        			Power1								= 0;
				}
				Power30								= Power29;
        		Power29 							= Power28;
        		Power28 							= Power27;
        		Power27 							= Power26;
        		Power26 							= Power25;
        		Power25 							= Power24;
        		Power24 							= Power23;
        		Power23 							= Power22;
        		Power22 							= Power21;
        		Power21 							= Power20;
        		Power20 							= Power19;
        		Power19 							= Power18;
        		Power18 							= Power17;
        		Power17 							= Power16;
        		Power16 							= Power15;
        		Power15 							= Power14;
        		Power14 							= Power13;
        		Power13 							= Power12;
        		Power12 							= Power11;
        		Power11								= Power10;
        		Power10 							= Power9;
        		Power9 								= Power8;
        		Power8 								= Power7;
        		Power7 								= Power6;
        		Power6 								= Power5;
        		Power5 								= Power4;
        		Power4 								= Power3;
        		Power3 								= Power2;
        		Power2 								= Power1;
				AveragePower3sec= (Power1+Power2+Power3)/3;
				AveragePower5sec= (Power1+Power2+Power3+Power4+Power5)/5;
				AveragePower10sec= (Power1+Power2+Power3+Power4+Power5+Power6+Power7+Power8+Power9+Power10)/10;
				AveragePower20sec= (Power1+Power2+Power3+Power4+Power5+Power6+Power7+Power8+Power9+Power10+Power11+Power12+Power13+Power14+Power15+Power16+Power17+Power18+Power19+Power20)/20;
				AveragePower30sec= (Power1+Power2+Power3+Power4+Power5+Power6+Power7+Power8+Power9+Power10+Power11+Power12+Power13+Power14+Power15+Power16+Power17+Power18+Power19+Power20+Power21+Power22+Power23+Power24+Power25+Power26+Power27+Power28+Power29+Power30)/30;
			}
 		}


        var AveragePace3sec  	 			= 0;
        var AveragePace5sec  	 			= 0;
        var AveragePace10sec  	 			= 0;
        var AveragePace20sec  	 			= 0;
        var AveragePace30sec  	 			= 0;        
        var currentPacetest				= 0;
        if (info.currentSpeed != null) {
        	currentPacetest = info.currentSpeed; 
        }
        if (currentPacetest > 0) {
            if (currentPacetest > 0) {
            	//! Calculate average Pace
				if (info.currentSpeed != null) {
        			Pace1								= info.currentSpeed; 
        		} else {
        			Pace1								= 0;
				}
				Pace30								= Pace29;
        		Pace29 							= Pace28;
        		Pace28 							= Pace27;
        		Pace27 							= Pace26;
        		Pace26 							= Pace25;
        		Pace25 							= Pace24;
        		Pace24 							= Pace23;
        		Pace23 							= Pace22;
        		Pace22 							= Pace21;
        		Pace21 							= Pace20;
        		Pace20 							= Pace19;
        		Pace19 							= Pace18;
        		Pace18 							= Pace17;
        		Pace17 							= Pace16;
        		Pace16 							= Pace15;
        		Pace15 							= Pace14;
        		Pace14 							= Pace13;
        		Pace13 							= Pace12;
        		Pace12 							= Pace11;
        		Pace11								= Pace10;
        		Pace10 							= Pace9;
        		Pace9 								= Pace8;
        		Pace8 								= Pace7;
        		Pace7 								= Pace6;
        		Pace6 								= Pace5;
        		Pace5 								= Pace4;
        		Pace4 								= Pace3;
        		Pace3 								= Pace2;
        		Pace2 								= Pace1;
				AveragePace3sec= (Pace1+Pace2+Pace3)/3;
				AveragePace5sec= (Pace1+Pace2+Pace3+Pace4+Pace5)/5;
				AveragePace10sec= (Pace1+Pace2+Pace3+Pace4+Pace5+Pace6+Pace7+Pace8+Pace9+Pace10)/10;
				AveragePace20sec= (Pace1+Pace2+Pace3+Pace4+Pace5+Pace6+Pace7+Pace8+Pace9+Pace10+Pace11+Pace12+Pace13+Pace14+Pace15+Pace16+Pace17+Pace18+Pace19+Pace20)/20;
				AveragePace30sec= (Pace1+Pace2+Pace3+Pace4+Pace5+Pace6+Pace7+Pace8+Pace9+Pace10+Pace11+Pace12+Pace13+Pace14+Pace15+Pace16+Pace17+Pace18+Pace19+Pace20+Pace21+Pace22+Pace23+Pace24+Pace25+Pace26+Pace27+Pace28+Pace29+Pace30)/30;				
			}
 		}
				
		var AEIndex0 = (info.currentPower != null and info.currentSpeed != null and info.currentPower != 0) ? 60*(info.currentSpeed)/info.currentPower : 0;
		var AEIndex3 = (AveragePower3sec != 0) ? 60*(AveragePace3sec)/AveragePower3sec : 0;
		var AEIndex5 = (AveragePower5sec != 0) ? 60*(AveragePace5sec)/AveragePower5sec : 0;
		var AEIndex10 = (AveragePower10sec != 0) ? 60*(AveragePace10sec)/AveragePower10sec : 0;
		var AEIndex20 = (AveragePower20sec != 0) ? 60*(AveragePace20sec)/AveragePower20sec : 0;
		var AEIndex30 = (AveragePower30sec != 0) ? 60*(AveragePace30sec)/AveragePower30sec : 0;

		if (uPowerAveraging == 0) {
			DisplayPower = (info.currentPower != null) ? info.currentPower : 0;
		} else if (uPowerAveraging == 1) {
			DisplayPower = AveragePower3sec;  
		} else if (uPowerAveraging == 2) {
			DisplayPower = AveragePower5sec;  
		} else if (uPowerAveraging == 3) {
			DisplayPower = AveragePower10sec;  
		} else if (uPowerAveraging == 4) {
			DisplayPower = AveragePower20sec;  
		} else if (uPowerAveraging == 5) {
			DisplayPower = AveragePower30sec;		
		}

		
        var mZ1under = uPowerZones.substring(0, 3);
        var mZ2under = uPowerZones.substring(7, 10);
        var mZ3under = uPowerZones.substring(14, 17);
        var mZ4under = uPowerZones.substring(21, 24);
        var mZ5under = uPowerZones.substring(28, 31);
        var mZ6under = uPowerZones.substring(35, 38);
        var mZ7under = uPowerZones.substring(42, 45);
        var mZ8under = uPowerZones.substring(49, 52);
        var mZ9under = uPowerZones.substring(56, 59);
		var mZ10under = uPowerZones.substring(63, 66);
        var mZ10upper = uPowerZones.substring(71, 74);
             
        mZ1under = mZ1under.toNumber();
        mZ2under = mZ2under.toNumber();
        mZ3under = mZ3under.toNumber();
        mZ4under = mZ4under.toNumber();        
        mZ5under = mZ5under.toNumber();
        mZ6under = mZ6under.toNumber();
        mZ7under = mZ7under.toNumber();
        mZ8under = mZ8under.toNumber();
        mZ9under = mZ9under.toNumber();
        mZ10under = mZ10under.toNumber();
        mZ10upper = mZ10upper.toNumber(); 
      
        var mPowerWarningunder = uRequiredPower.substring(0, 3);
        var mPowerWarningupper = uRequiredPower.substring(4, 7);
        mPowerWarningunder = mPowerWarningunder.toNumber();
        mPowerWarningupper = mPowerWarningupper.toNumber(); 

		//! Alert when out of predefined powerzone

		var vibrateData = [
			new Attention.VibeProfile( 100, 100 ),
			new Attention.VibeProfile(  25, 100 )
		];
		if (DisplayPower>mPowerWarningupper or DisplayPower<mPowerWarningunder) {
			 //!Toybox.Attention.playTone(TONE_LOUD_BEEP);		 
			 if (Toybox.Attention has :vibrate && uNoAlerts == false) {
			 	vibrateseconds = vibrateseconds + 1;	 		  			
    			if (vibrateseconds == uWarningFreq) {
    				Toybox.Attention.vibrate(vibrateData);
    				vibrateseconds = 0;
    			}	
			 }
			 
		}		

		var mTestPower = mCurrentPower;
		var mfillulColour = Graphics.COLOR_LT_GRAY;
		var mfillurColour = Graphics.COLOR_LT_GRAY;
		var mfillblColour = Graphics.COLOR_LT_GRAY;
		var mfillbrColour = Graphics.COLOR_LT_GRAY;
		var mfillColour = Graphics.COLOR_LT_GRAY;
		var mCurrentPowerZone = 0; 
				
		if (info.currentPower != null) {
                mTestPower = DisplayPower;
                if (mTestPower >= mZ10upper) {
                    mfillColour = Graphics.COLOR_BLACK;        //! (aboveZ10)
                    mCurrentPowerZone = 11;
                } else if (mTestPower >= mZ10under) {
                    mfillColour = Graphics.COLOR_PURPLE;    	//! (Z10)
                    mCurrentPowerZone = 10;
                } else if (mTestPower >= mZ9under) {
                    mfillColour = Graphics.COLOR_PURPLE;    	//! (Z9)
                    mCurrentPowerZone = 9;
                } else if (mTestPower >= mZ8under) {
                    mfillColour = Graphics.COLOR_PINK;    	//! (Z8)
                    mCurrentPowerZone = 8;
                } else if (mTestPower >= mZ7under) {
                    mfillColour = Graphics.COLOR_DK_RED;    	//! (Z7)
                    mCurrentPowerZone = 7;
                } else if (mTestPower >= mZ6under) {
                    mfillColour = Graphics.COLOR_RED;    	//! (Z6)
                    mCurrentPowerZone = 6;
                } else if (mTestPower >= mZ5under) {
                    mfillColour = Graphics.COLOR_ORANGE;    	//! (Z5)
                    mCurrentPowerZone = 5;
                } else if (mTestPower >= mZ4under) {
                    mfillColour = Graphics.COLOR_DK_GREEN;    	//! (Z4)
                    mCurrentPowerZone = 4;
                } else if (mTestPower >= mZ3under) {
                    mfillColour = Graphics.COLOR_GREEN;        //! (Z3)
                    mCurrentPowerZone = 3;
                } else if (mTestPower >= mZ2under) {
                    mfillColour = Graphics.COLOR_BLUE;        //! (Z2)
                    mCurrentPowerZone = 2;
                } else if (mTestPower >= mZ1under) {
                    mfillColour = Graphics.COLOR_DK_GRAY;        //! (Z1)
                    mCurrentPowerZone = 1;
                } else {
                    mfillColour = Graphics.COLOR_LT_GRAY;        //! (Z0)
                    mCurrentPowerZone = 0;
                }
                mfillulColour = mfillColour;                 
        }		

		if (info.currentPower != null) {
                mTestPower = LapPower;
                if (mTestPower >= mZ10upper) {
                    mfillColour = Graphics.COLOR_BLACK;        //! (aboveZ10)
                } else if (mTestPower >= mZ10under) {
                    mfillColour = Graphics.COLOR_PURPLE;    	//! (Z10)
                } else if (mTestPower >= mZ9under) {
                    mfillColour = Graphics.COLOR_PURPLE;    	//! (Z9)
                } else if (mTestPower >= mZ8under) {
                    mfillColour = Graphics.COLOR_PINK;    	//! (Z8)
                } else if (mTestPower >= mZ7under) {
                    mfillColour = Graphics.COLOR_DK_RED;    	//! (Z7)
                } else if (mTestPower >= mZ6under) {
                    mfillColour = Graphics.COLOR_RED;    	//! (Z6)
                } else if (mTestPower >= mZ5under) {
                    mfillColour = Graphics.COLOR_ORANGE;    	//! (Z5)
                } else if (mTestPower >= mZ4under) {
                    mfillColour = Graphics.COLOR_DK_GREEN;    	//! (Z4)
                } else if (mTestPower >= mZ3under) {
                    mfillColour = Graphics.COLOR_GREEN;        //! (Z3)
                } else if (mTestPower >= mZ2under) {
                    mfillColour = Graphics.COLOR_BLUE;        //! (Z2)
                } else if (mTestPower >= mZ1under) {
                    mfillColour = Graphics.COLOR_DK_GRAY;        //! (Z1)
                } else {
                    mfillColour = Graphics.COLOR_LT_GRAY;        //! (Z0)
                }
                mfillLColour = mfillColour;                 
        }
        
		if (info.currentPower != null) {
                mTestPower = AveragePower;
                if (mTestPower >= mZ10upper) {
                    mfillColour = Graphics.COLOR_BLACK;        //! (aboveZ10)
                } else if (mTestPower >= mZ10under) {
                    mfillColour = Graphics.COLOR_PURPLE;    	//! (Z10)
                } else if (mTestPower >= mZ9under) {
                    mfillColour = Graphics.COLOR_PURPLE;    	//! (Z9)
                } else if (mTestPower >= mZ8under) {
                    mfillColour = Graphics.COLOR_PINK;    	//! (Z8)
                } else if (mTestPower >= mZ7under) {
                    mfillColour = Graphics.COLOR_DK_RED;    	//! (Z7)
                } else if (mTestPower >= mZ6under) {
                    mfillColour = Graphics.COLOR_RED;    	//! (Z6)
                } else if (mTestPower >= mZ5under) {
                    mfillColour = Graphics.COLOR_ORANGE;    	//! (Z5)
                } else if (mTestPower >= mZ4under) {
                    mfillColour = Graphics.COLOR_DK_GREEN;    	//! (Z4)
                } else if (mTestPower >= mZ3under) {
                    mfillColour = Graphics.COLOR_GREEN;        //! (Z3)
                } else if (mTestPower >= mZ2under) {
                    mfillColour = Graphics.COLOR_BLUE;        //! (Z2)
                } else if (mTestPower >= mZ1under) {
                    mfillColour = Graphics.COLOR_DK_GRAY;        //! (Z1)
                } else {
                    mfillColour = Graphics.COLOR_LT_GRAY;        //! (Z0)
                }
                mfillAColour = mfillColour;                 
        }        
              
		//!Determine whether demofield should be displayed
        if (uShowDemo == false) {
        	if (umyNumber != mtest && mTimerTime > 900)  {
        		uShowDemo = true;        		
        	}
        }

        
//!===============================Device specific code hereunder==============================================================
        
       if (uShowDemo == true ) {       
		//! Show demofield
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);

		if (umyNumber == mtest) {
			dc.drawText(118, 120, Graphics.FONT_XTINY, "Registered !!", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(81, 160, Graphics.FONT_XTINY, "License code: ", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(180, 160, Graphics.FONT_XTINY, mtest, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
		} else {
      		dc.drawText(118, 30, Graphics.FONT_XTINY, "License needed !!", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
      		dc.drawText(118, 60, Graphics.FONT_XTINY, "Run is recorded though", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(60, 122, Graphics.FONT_MEDIUM, "ID 1: ", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(161, 115, Graphics.FONT_NUMBER_MEDIUM, deviceID1, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(60, 177, Graphics.FONT_MEDIUM, "ID 2: " , Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
			dc.drawText(161, 170, Graphics.FONT_NUMBER_MEDIUM, deviceID2, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
      	}

       } else {      	
        //! Show datafield instead of demofield
        //! Coordinates of colour indicators
		var xful = 0;
		var yful = 0;
		var wful = 119;
		var hful = 64;
		
		var xfur = 121;
		var yfur = 0;
		var wfur = 118;
		var hfur = 64;

		var xfbl = 0;
		var yfbl = 176;
		var wfbl = 119;
		var hfbl = 64;
		
		var xfbr = 121;
		var yfbr = 176;
		var wfbr = 118;
		var hfbr = 64;

		//! Draw separator lines
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0,   120,  240, 120);
        dc.drawLine(120, 0,  120, 240);
        
        //! Set text colour
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
 	    var Garminfont2 = Ui.loadResource(Rez.Fonts.Garmin4);
	    var Garminfont3 = Ui.loadResource(Rez.Fonts.Garmin3);


        //!
        //! Draw field values
        //! =================
        //!

        mColour = Graphics.COLOR_BLACK;
		dc.setColor(mColour, Graphics.COLOR_TRANSPARENT);


        var xul=61;
        var yul=87;
        var xtul=73;
        var ytul=44;

        var xur=179;
        var yur=87;
        var xtur=167;
        var ytur=44;

        var xbl=61;
        var ybl=143;
        var xtbl=73;
        var ytbl=189;

        var xbr=179;
        var ybr=143;
        var xtbr=167;
        var ytbr=189;
        
        var zero = 0;
		
//!===============================Device specific code hereabove==============================================================
		
		//! Drawing upper colour indicators
        mColour = Graphics.COLOR_LT_GRAY; 
        dc.setColor(mfillulColour, Graphics.COLOR_TRANSPARENT);		
		dc.fillRectangle(xful, yful, wful, hful);
				
        //! Top row left: Power
        dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xul, yul, Garminfont2, DisplayPower, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(xtul, ytul, Garminfont3,  "Power", Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        
        //! Top row right: lap power is default
		var fieldValue = 0;
		var fieldLabel = "Error";
		var fieldformat = "0decimal";
        if (uUpperRightMetric == 0) {
            fieldValue = LapPower;
            fieldLabel = "Lap P";
            fieldformat = "0decimal";
            mfillurColour = mfillLColour;           
        } else if (uUpperRightMetric == 1) {
            fieldValue = mCurrentPowerZone;
            fieldLabel = "P Zone";
            fieldformat = "0decimal";
            mfillurColour = mfillulColour;
        } else if (uUpperRightMetric == 4) {
            fieldValue = LapEfficiencyIndex;
            fieldLabel = "LE index";
            fieldformat = "2decimal";
        } else if (uUpperRightMetric == 7) {
            fieldValue = LapEfficiencyFactor;
            fieldLabel = "LE factor";
            fieldformat = "2decimal";
        } else if (uUpperRightMetric == 9) {
            fieldValue = AveragePower30sec;
            fieldLabel = "30s P";
            fieldformat = "0decimal";
        } else if (uUpperRightMetric == 10) {
            fieldValue = AEIndex0;
            fieldLabel = "AEI 0s";
            fieldformat = "2decimal";
        } else if (uUpperRightMetric == 11) {
            fieldValue = AEIndex3;
            fieldLabel = "AEI 3s";
            fieldformat = "2decimal";
		} else if (uUpperRightMetric == 16) {
            fieldValue = mCurrentHeartrate;
            fieldLabel = "HR";
            fieldformat = "0decimal";
		} else if (uUpperRightMetric == 17) {
            fieldValue = Pace1;
            fieldLabel = "Pace";
            fieldformat = "pace";
        } else if (uUpperRightMetric == 18) {
            fieldValue = AveragePace3sec;
            fieldLabel = "Pace 3s";
            fieldformat = "pace";
        }

		//! Drawing upper right colour indicator
        dc.setColor(mfillurColour, Graphics.COLOR_TRANSPARENT);		
        dc.fillRectangle(xfur, yfur, wfur, hfur);
        
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
        if (fieldformat.equals("0decimal" ) == true ) {
           dc.drawText(xur, yur, Garminfont2, fieldValue.format("%d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        } else if ( fieldformat.equals("1decimal" ) == true ) {
        	dc.drawText(xur, yur, Garminfont2, fieldValue.format("%.1f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        } else if ( fieldformat.equals("2decimal" ) == true ) {
        	dc.drawText(xur, yur, Garminfont2, fieldValue.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        } else if ( fieldformat.equals("pace" ) == true ) {
        	dc.drawText(xur, yur, Garminfont2, (fieldValue != 0) ? fmtPace(fieldValue) : 0, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
        dc.drawText(xtur, ytur, Garminfont3, fieldLabel, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

        //! Bottom left: Average power is default		
		fieldValue = 0;
		fieldLabel = "Error";
		fieldformat = "0decimal";
        if (uBottomLeftMetric == 0) {
            fieldValue = LapPower;
            fieldLabel = "Lap P";
            fieldformat = "0decimal";
            mfillblColour = mfillLColour;           
        } else if (uBottomLeftMetric == 1) {
            fieldValue = AveragePower;
            fieldLabel = "Average";
            fieldformat = "0decimal";
            mfillblColour = mfillAColour; 
        } else if (uBottomLeftMetric == 2) {
            fieldValue = LastLapPower;
            fieldLabel = "L-1 P";
            fieldformat = "0decimal";
        } else if (uBottomLeftMetric == 3) {
            fieldValue = AverageEfficiencyIndex;
            fieldLabel = "AE index";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 4) {
            fieldValue = LapEfficiencyIndex;
            fieldLabel = "LE index";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 5) {
            fieldValue = LastLapEfficiencyIndex;
            fieldLabel = "L-1E ind";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 6) {
            fieldValue = AverageEfficiencyFactor;
            fieldLabel = "AE factor";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 7) {
            fieldValue = LapEfficiencyFactor;
            fieldLabel = "LE factor";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 8) {
            fieldValue = LastLapEfficiencyFactor;
            fieldLabel = "L-1E fact";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 9) {
            fieldValue = AveragePower30sec;
            fieldLabel = "30s P";
            fieldformat = "0decimal";
        } else if (uBottomLeftMetric == 10) {
            fieldValue = AEIndex0;
            fieldLabel = "AEI 0s";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 11) {
            fieldValue = AEIndex3;
            fieldLabel = "AEI 3s";
            fieldformat = "2decimal";
		} else if (uBottomLeftMetric == 12) {
            fieldValue = AEIndex5;
            fieldLabel = "AEI 5s";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 13) {
            fieldValue = AEIndex10;
            fieldLabel = "AEI 10s";
            fieldformat = "2decimal";
		}  else if (uBottomLeftMetric == 14) {
            fieldValue = AEIndex20;
            fieldLabel = "AEI 20s";
            fieldformat = "2decimal";
        } else if (uBottomLeftMetric == 15) {
            fieldValue = AEIndex30;
            fieldLabel = "AEI 30s";
            fieldformat = "2decimal";
		}

		//! Drawing lower left colour indicator
        dc.setColor(mfillblColour, Graphics.COLOR_TRANSPARENT);        
        dc.fillRectangle(xfbl, yfbl, wfbl, hfbl);        
        
		dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
        if (fieldformat.equals("0decimal" ) == true ) {
           dc.drawText(xbl, ybl, Garminfont2, fieldValue.format("%d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        } else if ( fieldformat.equals("1decimal" ) == true ) {
        	dc.drawText(xbl, ybl, Garminfont2, fieldValue.format("%.1f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        } else if ( fieldformat.equals("2decimal" ) == true ) {
        	dc.drawText(xbl, ybl, Garminfont2, fieldValue.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
        dc.drawText(xtbl, ytbl, Garminfont3, fieldLabel, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);


        //! Bottom right: Last lap power is default
		fieldValue = 0;
		fieldLabel = "Error";
		fieldformat = "0decimal";
        if (uBottomRightMetric == 0) {
            fieldValue = LapPower;
            fieldLabel = "Lap P";
            fieldformat = "0decimal";
            mfillbrColour = mfillLColour;           
        } else if (uBottomRightMetric == 1) {
            fieldValue = AveragePower;
            fieldLabel = "Average";
            fieldformat = "0decimal";
            mfillbrColour = mfillAColour; 
        } else if (uBottomRightMetric == 3) {
            fieldValue = AverageEfficiencyIndex;
            fieldLabel = "AE index";
            fieldformat = "2decimal";
        } else if (uBottomRightMetric == 4) {
            fieldValue = LapEfficiencyIndex;
            fieldLabel = "LE index";
            fieldformat = "2decimal";
        } else if (uBottomRightMetric == 6) {
            fieldValue = AverageEfficiencyFactor;
            fieldLabel = "AE factor";
            fieldformat = "2decimal";
        } else if (uBottomRightMetric == 9) {
            fieldValue = AveragePower30sec;
            fieldLabel = "30s P";
            fieldformat = "0decimal";
        } else if (uBottomRightMetric == 10) {
            fieldValue = AEIndex0;
            fieldLabel = "AEI 0s";
            fieldformat = "2decimal";
        } else if (uBottomRightMetric == 11) {
            fieldValue = AEIndex3;
            fieldLabel = "AEI 3s";
            fieldformat = "2decimal";
		}

		//! Drawing lower right colour indicator        
        dc.setColor(mfillbrColour, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(xfbr, yfbr, wfbr, hfbr);

        dc.setColor(mColourFont, Graphics.COLOR_TRANSPARENT);
        if (fieldformat.equals("0decimal" ) == true ) {
           dc.drawText(xbr, ybr, Garminfont2, fieldValue.format("%d"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);        
        } else if ( fieldformat.equals("1decimal" ) == true ) {
        	dc.drawText(xbr, ybr, Garminfont2, fieldValue.format("%.1f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        } else if ( fieldformat.equals("2decimal" ) == true ) {
        	dc.drawText(xbr, ybr, Garminfont2, fieldValue.format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
		dc.drawText(xtbr, ytbr, Garminfont3, fieldLabel, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);

	   } 
		
	}
	
    function fmtPace(secs) {
        var s = (unitP/secs).toLong();
        return (s / 60).format("%0d") + ":" + (s % 60).format("%02d");
    }	
}
