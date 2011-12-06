﻿package com.ff0000.utils.zdate {			public class ZDate {		/* --- TIMESTAMP ---------------------------------------------------------------------------------------------		 *		 *		timestamp 		int						UTC time in seconds		 */		public function set timestamp( $_value:int ):void {			zdModel.timestamp = $_value;		}		public function get timestamp():int {			return zdModel.timestamp;		}		/* --- YEAR ---------------------------------------------------------------------------------------------		 *		 *		year			int		 				2-digit and 4-digit representations		 */		public function set year( $_year:int ):void { 			zdModel.year = $_year;		}		public function get year():int {			return zdModel.year;		}						/* --- YEAR ---------------------------------------------------------------------------------------------		 *		 *		month			int/string				common abbreviations, fullname, and month-number		 */		public function set month( $_month:* ):void {			zdModel.month = $_month;		}		public function get month():int {			return zdModel.month;		}						/* --- DAY ---------------------------------------------------------------------------------------------		 *		 *		day				int						numerical day of month		 */		public function set day( $_day:int ):void {			zdModel.day = $_day;		}		public function get day():int {			return zdModel.day;		}		/* --- HOUR ---------------------------------------------------------------------------------------------		 *		 *		hour			int						24 hour format		 */		public function set hour( $_hour:int ):void {			zdModel.hour = $_hour;		}		public function get hour():int {			return zdModel.hour;		}						/* --- MINUTE ---------------------------------------------------------------------------------------------		 *		 *		minute			int						0-59		 */		public function set minute( $_minute:int ):void {			zdModel.minute = $_minute;		}		public function get minute():int {			return zdModel.minute;		}				/* --- SECOND ---------------------------------------------------------------------------------------------		 *		 *		second			int						0-59		 */		public function set second( $_second:int ):void {			zdModel.second = $_second;		}		public function get second():int {			return zdModel.second;		}						/* --- TIMEZONE OFFSET -----------------------------------------------------------------------------------		 *		 *		timezone offset	int						in seconds		 */		public function set timezoneOffset( $_timezoneOffset:int ):void {			zdModel.timezoneOffset = $_timezoneOffset;		}		public function get timezoneOffset():int {			return zdModel.timezoneOffset;		}						/* --- WEEKDAY -------------------------------------------------------------------------------------------		 *		 *		weekday			String					common abbreviations and fullname		 */		public function set weekday( $_weekday:String ):void {			zdModel.weekday = $_weekday;		}		public function get weekday():String {			return zdModel.weekday;		}		/* --- VERBOSITY -------------------------------------------------------------------------------------------		 *		 *		verbosity			int					0 = no trace, 1 = all trace		 */		public function set verbosity( $_level:int ):void {			zdTrace.startZDTrace( $_level );		}										// --- PRIVATE --------------------------		private var zdModel:ZDModel;		private var zdView:ZDView;		private var zdControl:ZDControl;		private var zdUtil:ZDUtil;		private var zdTrace:ZDTrace;		// constructor		public function ZDate() {			zdModel = new ZDModel(); // singleton, make one instance for this ZDate()			zdTrace = new ZDTrace(); // singleton, make one instance for this ZDate()			zdView = new ZDView();			zdControl = new ZDControl();			zdUtil = new ZDUtil();		}										/* -- CREATE DATE OBJECT ------------------------------------------------------------------------------------		 *		 *	make time from Flash-Date, Date-String, or Unix Timestamp		 *	 - if your date has no clear DST indication, use $_correctForDst		 *	 - if you want to make sure a date is accurate in a specific GMT-offset, even during DST,		 *		set the GMT-Offset to your target timezone without DST...so for example:		 *			you want your time to be 5pm EST, even during DST 	->	use '5pm GMT-0500', $_correctForDst = true;		 */		public function makeTimeFrom( $_dateTime:* = null, $_correctForDst:Boolean = false ):void {			zdTrace.log( this+' makeTimeFrom() '+$_dateTime+', correctForDst? '+$_correctForDst, 1 );			if( $_dateTime is Date ) {				zdTrace.log( this+'  - is Date', 1 );				zdModel.correctForDst = false; // assume a Flash date has DST built-into the GMT offset				zdControl.convertToDateElementsFrom( $_dateTime.toString());				zdControl.propagateDateElementsToTimestamp();			}			else if( $_dateTime is int ) {				zdTrace.log( this+'  - is int', 1 );				zdModel.correctForDst = false; // no gmt or dst on a timestamp				zdModel.setTimestamp( $_dateTime );				zdControl.propagateTimestampToDateElements();			}			else {				zdTrace.log( this+'  - is String', 1 );				zdModel.correctForDst = $_correctForDst; // allow user to specify a zone and time, then check to correct GMT for DST				zdControl.convertToDateElementsFrom( String( $_dateTime ));				zdControl.propagateDateElementsToTimestamp();			}			}										/* -- FORMAT DATE OBJECT -----------------------------------------------------------------------------------------		 *		 *	format the value of this time object using the following codes: http://us2.php.net/manual/en/function.date.php		 *		 */		public function format( $_code:String, $_timestamp:int=0 ):String {			if( $_timestamp != 0 ) {				zdModel.correctForDst = false; // no gmt or dst on a timestamp				zdModel.setTimestamp( $_timestamp );				zdControl.propagateTimestampToDateElements();			}			return zdView.processPrintRequest( $_code );		}										/* -- PUBLIC DATE UTILITIES --------------------------------------------------------------------------------------		 *		 *			 *		 */		// change timezone to a different gmtOffset, like "(UTC|GMT|Z)(-|+)[0-9]{2,4}"		public function changeTimezoneTo( $_gmtOffset:String ):void {			zdTrace.log( this+' changeTimezoneTo( "'+$_gmtOffset+'" )', 1 );			zdControl.interpretTimezoneOffset( $_gmtOffset );			zdControl.propagateTimestampToDateElements();		}					// get formatted GMT+/-0000 current client gmt offset		public function getFormattedClientGmtOffset():String {			var _pTimezoneOffset:int = zdUtil.minutesToSeconds( zdUtil.getClientTimezoneOffsetInMinutes()) + 				zdUtil.hoursToSeconds( getDstOffsetFor( getClientsTimeInUTC() ));			return zdView.printGmtOffset( _pTimezoneOffset );		}					// get dst offset for this date object		public function getDstOffsetFor( $_timestamp:int ):int {			return zdUtil.getDstOffsetFor( $_timestamp );		}								// get client's now in seconds		public function getClientsTimeInUTC():int {			var _date:Date = new Date();			return _date.time / 1000;		}		// to string		public function toZDateString():String {			return this + ' timestamp: '+zdModel.timestamp+				', year: '+zdModel.year+', month: '+zdModel.month+', day: '+zdModel.day+				', hour: '+zdModel.hour+', minute: '+zdModel.minute+', second: '+zdModel.second+				', timezoneOffset: '+zdModel.timezoneOffset+', weekday: '+zdModel.weekday;		}		}	}