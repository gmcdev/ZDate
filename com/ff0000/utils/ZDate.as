﻿package com.ff0000.utils {		public class ZDate {								/* -- TIMESTAMP -------------------------------------------		 *		 *	time will always be UTC in seconds		 *		 */		public var timestamp:int;				/* -- CONSTANTS -------------------------------------------		 *		 *		 */		// base UTC constants		private const UTC_BASE_YEAR:int = 1970;		private const UTC_BASE_MONTH:int = 0;		private const UTC_BASE_DAY:int = 0;				// leap seconds - these are periodically and indiscriminately announced and added either on June 30 or Dec 31		private const LEAP_SECONDS:Array = [			78732000,94633200,126169200,157705200,189241200,220863600,252399600,283935600,315471600,362728800,394264800,425800800,			488959200,567932400,631090800,662626800,709884000,741420000,772956000,820393200,867650400,915087600,1136012400,1230706800		];				// string equivalents		private const MONTHS_FULL:Array = ['january','february','march','april','may','june','july','august','september','october','november','december'];		private const MONTHS_ABRV:Array = ['jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'];		private const MONTHS_EXCP:Array = ['','','','','','','','','sept','','',''];				private const WEEKDAYS_FULL:Array = ['sunday','monday','tuesday','wednesday','thursday','friday','saturday'];		private const WEEKDAYS_ABRV:Array = ['sun','mon','tue','wed','thu','fri','sat'];		private const WEEKDAYS_EXCP1:Array = ['','','tues','wednes','thur','',''];		private const WEEKDAYS_EXCP2:Array = ['','','','','thurs','',''];				// defaults		private const DEFAULT_YEAR:int = 2011;		/* -- VARS ------------------------------------------------		 *		 *		 */		// internal		private var correctForDst:Boolean = true;				// year		private var _year:int;		private function set year( $_year:int ):void {			if( $_year < 100 ) {				if( $_year < 69 ) 					_year = 2000 + $_year;				else _year = 1900 + $_year;			}			else _year = $_year;		}		private function get year():int {			return _year;		}		// month		private var _month:int;		private function set month( $_month:* ):void {			if( $_month is String ) {				$_month = $_month.toLowerCase();				var _i:int = 0;				for( _i = 0; _i < 12; _i++ ) {					if( MONTHS_FULL[_i] == $_month || MONTHS_ABRV[_i] == $_month || MONTHS_EXCP[_i] == $_month ) {						_month = _i + 1;						break;					}				}			}			else if( $_month > 0 && ( $_month >= 1 && $_month <= 12 )) {				_month = parseInt( $_month );			}		}		private function get month():int {			return _month;		}		// day		private var _day:int;		private function set day( $_day:int ):void {			if( $_day >= 1 && $_day <= 31 ) {				_day = $_day;			}		}		private function get day():int {			return _day;		}		// hour		private var _hour:int;		private function set hour( $_hour:int ):void {			if( $_hour >= 0 && $_hour <= 23 ) {				_hour = $_hour;			}		}		private function get hour():int {			return _hour;		}		// minute		private var _minute:int;		private function set minute( $_minute:int ):void {			if( $_minute >= 0 && $_minute <= 59 ) {				_minute = $_minute;			}		}		private function get minute():int {			return _minute;		}		// second		private var _second:int;		private function set second( $_second:int ):void {			if( $_second >= 0 && $_second <= 59 ) {				_second = $_second;			}		}		private function get second():int {			return _second;		}		// meridiem		private var _meridiem:String;		private function set meridiem( $_meridiem:String ):void {			$_meridiem = $_meridiem.toLowerCase();			if( $_meridiem == 'am' || $_meridiem == 'pm' ) 				_meridiem = $_meridiem;		}		private function get meridiem():String {			return _meridiem;		}		// timezone offset in seconds		private var _timezoneOffset:int;		private function set timezoneOffset( $_timezoneOffset:int ):void {			_timezoneOffset = $_timezoneOffset;		}		private function get timezoneOffset():int {			return _timezoneOffset;		}		// weekday		private var _weekday:String;		private function set weekday( $_weekday:String ):void {			$_weekday = $_weekday.toLowerCase();			var _i:int = 0;			for( _i = 0; _i < 7; _i++ ) {				if( WEEKDAYS_FULL[_i] == $_weekday || WEEKDAYS_ABRV[_i] == $_weekday || WEEKDAYS_EXCP1[_i] == $_weekday || WEEKDAYS_EXCP2[_i] == $_weekday ) {					_weekday = WEEKDAYS_FULL[_i];					break;				}			}		}		private function get weekday():String {			return _weekday;		}				// constructor		public function ZDate() {			//		}						/* -- CREATE DATE OBJECT ------------------------------------------------------------------------------------		 *		 *	make time from Flash-Date, Date-String, or Unix Timestamp		 *	 - if your date has no clear DST indication, use $_correctForDst		 *	 - if you want to make sure a date is accurate in a specific GMT-offset, even during DST,		 *		set the GMT-Offset to your target timezone without DST...so for example:		 *			you want your time to be 5pm EST, even during DST 	->	use '5pm GMT-0500', $_correctForDst = true;		 */		public function makeTimeFrom( $_dateTime:* = null, $_correctForDst:Boolean = false ):void {			trace( 'makeTimeFrom() ' + $_dateTime+ ', correctForDst? '+$_correctForDst );			if( $_dateTime is Date ) {				trace( '- is Date' );				correctForDst = false; // assume a Flash date has DST built-into the GMT offset				stringToTime( $_dateTime.toString());			}			else if( $_dateTime is int ) {				trace( '- is int' );				correctForDst = false; // no gmt or dst on a timestamp				timestamp = $_dateTime;			}			else {				trace( '- is String' );				correctForDst = $_correctForDst; // allow user to specify a zone and time, then check to correct GMT for DST				stringToTime( String( $_dateTime ));			}			}						/* -- FORMAT DATE OBJECT -----------------------------------------------------------------------------------------		 *		 *	format the value of this time object using the following codes: http://us2.php.net/manual/en/function.date.php		 *		 */		public function format( $_request:String, $_timestamp:int=0 ):String {			if( $_timestamp != 0 )				timestamp = $_timestamp;			convertTimeToDateElements();			return parseRequestString( $_request );		}						/* -- PUBLIC DATE UTILITIES --------------------------------------------------------------------------------------		 *		 *	add/subtract time in seconds		 *		 */		// add time		public function addToTime( $_seconds:int ):void {			timestamp += $_seconds;		}				// convert time to a gmtOffset, like "(UTC|GMT|Z)(-|+)[0-9]{2,4}"		public function convertTimeTo( $_gmtOffset:String ):void {			interpretTimezoneOffset( $_gmtOffset );		}			// get formatted GMT+/-0000 current client gmt offset		public function getFormattedClientGmtOffset():String {			var _timezoneOffset:int = minutesToSeconds( getClientTimezoneOffsetInMinutes()) + 				hoursToSeconds( getDstOffsetFor( getClientsTimeInUTC() ));			return printGmtOffset( _timezoneOffset );		}			// get dst offset for this date object		public function getDstOffsetFor( $_timestamp:int ):int {			var dstOffset:int = 0;			var dstStartEnd:Array = getClientDstStartEnd();			if( $_timestamp > dstStartEnd[0] && $_timestamp <= dstStartEnd[1] ) {				dstOffset = 1;			}			return dstOffset;		}				// get client's now in seconds		public function getClientsTimeInUTC():int {			var _date:Date = new Date();			return _date.time / 1000;		}																	/* -- PARSING METHODS -------------------------------------------		 *		 *		 */		// parse according to the gnu.org spec, found here > http://www.gnu.org/software/automake/manual/tar/Date-input-formats.html#SEC119		private function stringToTime( $_string:String ):void {			parseYear( $_string );			parseCalendarDate( $_string );			parseTimeOfDay( $_string );			parseDayOfWeek( $_string );			convertDateToTime();			if( correctForDst ) {				var _dstOffset:int = hoursToSeconds( getDstOffsetFor( timestamp ));				timestamp -= _dstOffset;				timezoneOffset += _dstOffset;			}		}				// parse string for 4 digit year		private function parseYear( $_string:String ):void {			// year			var _matches:Array = $_string.match( /(\A|\s)[0-9]{4}(\Z|\s)/g );			if( _matches.length > 0 ) {				trace( 'yyyy' );				year = _matches[0];				return;			}		}				// parse strings that follow the gnu.org spec for Calendar Dates		private function parseCalendarDate( $_string:String ):void {			var _year:int;			var _month:int;			var _day:int;			var _matches:Array;			var _parts:Array;			// yyyy-mm-dd			_matches = $_string.match( /[0-9]{1,4}-[0-9]{1,2}-[0-9]{1,2}/g );			if( _matches.length > 0 ) {				trace( 'yyyy-mm-dd' );				trace( _matches[0] );				_parts = _matches[0].split( '-' );				year = parseInt( _parts[0] );				month = parseInt( _parts[1] );				day = parseInt( _parts[2] );				return;			}			// mm/dd/yyyy			_matches = $_string.match( /[0-9]{1,2}\/[0-9]{1,2}\/?[0-9]{0,4}/g );			if( _matches.length > 0 ) {				trace( 'mm/dd/yyyy' );				_parts = _matches[0].split( '/' );				month = parseInt( _parts[0] );				day = parseInt( _parts[1] );				if( _parts[2] )					year = parseInt( _parts[2] );				else year = DEFAULT_YEAR;				return;			}			// dd textual-month yyyy			_matches = $_string.match( /[0-9]{1,2}\s[a-z]+\s[0-9]{0,4}/gi );			if( _matches.length > 0 ) {				trace( 'dd textual-month yyyy' );				_parts = _matches[0].split( ' ' );				day = parseInt( _parts[0] );				month = _parts[1];				if( _parts[2] )					year = parseInt( _parts[2] );				else year = DEFAULT_YEAR;				return;			}			// textual-month dd			_matches = $_string.match( /[a-z]+\s[0-9]{1,2}/gi );			if( _matches.length > 0 ) {				trace( 'textual-month dd' );				_parts = _matches[0].split( ' ' );				month = _parts[0];				day = parseInt( _parts[1].replace( /,/, '' ));				if( _parts[2] )					year = parseInt( _parts[2] );				else year = DEFAULT_YEAR;				return;			}		}				// parse times of day that follow the gnu.org spec for Time of Day Items		private function parseTimeOfDay( $_string:String ):void {			var _matches:Array;			var _parts:Array;			// hh am/pm			_matches = $_string.match( /[0-9]{1,2}(:[0-9]{2})?\s?(am|pm)/gi );			if( _matches.length > 0 ) {				trace( 'hh(:mm)||(am/pm)' );				_parts = _matches[0].split( ':' );				if( _parts.length == 1 ) {					hour = _parts[0].match( /[0-9]{1,2}/ )[0];					meridiem = _parts[0].match( /[a-z]{2}/i )[0];				}				else if( _parts.length == 2 ) {					hour = _parts[0].match( /[0-9]{1,2}/ )[0];					minute = _parts[1].match( /[0-9]{1,2}/ )[0];					meridiem = _parts[1].match( /[a-z]{2}/i )[0];				}				if( meridiem == 'pm' && hour < 12 ) {					hour += 12;				}				assumeClientTimezoneOffset();				return;			}			// hh:mm:ss			_matches = $_string.match( /[0-9]{1,2}:[0-9]{1,2}(:[0-9]{1,2})?(\s?(utc|gmt|z)?(-|\+)[0-9]{1,2}:?[0-9]{2})?/gi );			if( _matches.length > 0 ) {				trace( 'hh:mm:ss' );				_parts = _matches[0].split( ':' );				var tzOffset:Array = new Array();				if( _parts.length == 2 ) {					hour = _parts[0];					minute = _parts[1].match( /[0-9]{2}/ )[0];						tzOffset = _parts[1].match( /(utc|gmt|z)?(-|\+)[0-9]{2}:?[0-9]{2}/gi );				}				else if( _parts.length == 3 ) {					hour = _parts[0];					minute = _parts[1];					second = _parts[2].match( /[0-9]{2}/ )[0];					tzOffset = _parts[2].match( /(utc|gmt|z)?(-|\+)[0-9]{2}:?[0-9]{2}?/gi );				}				if( tzOffset.length > 0 ) {					trace( '(utc/gmt/z) (+/-) hhmm' );					interpretTimezoneOffset( tzOffset[0] );				}				else {					assumeClientTimezoneOffset();				} 				if( hour < 12 ) 					meridiem = 'am';				else meridiem = 'pm';								return;			}		}				// interpret timezone offset string		private function interpretTimezoneOffset( $_tzOffset:String ):void {			var _tzParts:Array = $_tzOffset.match( /(-|\+)[0-9]{2}:?[0-9]{2}?/g );			var _tzOffsetMinutes:int = _tzParts.length ? parseInt( _tzParts[0].substring( _tzParts[0].length-2, _tzParts[0].length )) : 0;			var _tzOffsetHours:int = _tzParts.length ? parseInt( _tzParts[0].substring( 0, _tzParts[0].length-2 )) : 0;			timezoneOffset = hoursToSeconds( _tzOffsetHours ) + minutesToSeconds( _tzOffsetMinutes );		}				// assume client timezone offset		private function assumeClientTimezoneOffset():void {			trace( 'assumeClientTimezoneOffset()' );			var _clientOffsetWithoutDst:int = getClientTimezoneOffsetInMinutes();			var _sign:int = _clientOffsetWithoutDst > 0 ? 1 : -1;			var _hoursOffset:int = Math.floor( Math.abs( _clientOffsetWithoutDst ) / 60 );			var _minutesOffset:int = Math.abs( _clientOffsetWithoutDst ) - _hoursOffset*60;			timezoneOffset = _sign * ( hoursToSeconds( _hoursOffset ) + minutesToSeconds( _minutesOffset ));			correctForDst = true;		}				// parse day of week that follow the gnu.org spec for Sec7.5 Day of Week Items		private function parseDayOfWeek( $_string:String ):void {			var regex:String = '';			for( var i:int = 0; i < WEEKDAYS_FULL.length; i++ ) {				regex += WEEKDAYS_FULL[i] + '|';				regex += WEEKDAYS_ABRV[i] + '|';				if( WEEKDAYS_EXCP1[i] != '' )					regex += WEEKDAYS_EXCP1[i] + '|';				if( WEEKDAYS_EXCP2[i] != '' )					regex += WEEKDAYS_EXCP2[i] + '|';			}			regex = regex.slice( 0, regex.length-1 );			var pattern:RegExp = new RegExp( regex, 'i' );			var _matches:Array = $_string.match( pattern );			if( _matches ) {				weekday = _matches[0];			}		}										/* -- PRIVATE ------------------------------------------------------		 *		 *		 */		 		/* -- PARSING FORMAT --		 *		 */		// parse format string		private function parseRequestString( $_request:String ):String {			var _result:String = "";			var _chars:Array =  $_request.split( "" );			var _index:int = 0;			var _escaping:Boolean = false;			for each( var _char:String in _chars ) {				if( _char == '\\' ) {					if( _escaping ) 						_escaping = false					else _escaping = true;					continue;				}				if( _escaping ) {					_result += _char;				}				if( !_escaping ) {					if( _index == 0 || ( _index > 0 && _chars[_index-1] != "\\" )) 						_result += parseSingleChar( _char );					else _result += _char;				}			}			return _result;		}		// parse single char		private function parseSingleChar( item:String ):String {			if( item.match( /a/ ))				return printAmPm();			else if( item.match( /A/ ) )				return printAmPm( true );			else if( item.match( /c/ ) )				return printIso8601();			else if( item.match( /d/ ) )				return printDayOfMonth( true );			else if( item.match( /D/ ) )				return printWeekDayAsText( true );			else if( item.match( /F/ ) )				return printMonthAsText();			else if( item.match( /g/ ) )				return printHours( false, true );						else if( item.match( /G/ ) )				return printHours( false );			else if( item.match( /h/ ) )				return printHours( true, true );						else if( item.match( /H/ ) )				return printHours();			else if( item.match( /i/ ) )				return printMinutes();			else if( item.match( /I/ ) )				return printSummertime();			else if( item.match( /j/ ) )				return printDayOfMonth( false );			else if( item.match( /l/ ) )				return printWeekDayAsText();			else if( item.match( /L/ ) )				return printLeapYear();			else if( item.match( /m/ ) )				return printMonth();			else if( item.match( /M/ ) )				return printMonthAsText( true );			else if( item.match( /n/ ) )				return printMonth( false );			else if( item.match( /N/ ) )				return printIso8601Day();			else if( item.match( /O/ ) )				return printGmtOffset( timezoneOffset );			else if( item.match( /P/ ) )				return printGmtOffset( timezoneOffset, ":" );						else if( item.match( /r/ ) )				return printRfc2822();						else if( item.match( /s/ ) )				return printSeconds();			else if( item.match( /S/ ) )				return printMonthDayOrdinalSuffix();						else if( item.match( /t/ ) )				return printNumberOfDaysInMonth();						else if( item.match( /T/ ) ) 				return printTimezone();						else if( item.match( /U/ ) )				return printUnixTimestamp();			else if( item.match( /w/ ) )				return printWeekDay();			else if( item.match( /W/ ) )				return printWeekOfYear();			else if( item.match( /y/ ) )				return printYear( true );			else if( item.match( /Y/ ) )				return printYear();						else if( item.match( /z/ ) )				return printDayOfYear();						else if( item.match( /Z/ ) )				return printTimezoneOffset();						else				return item;		}						/* -- GENERATING FORMAT --		 *		 */		private function printIso8601():String {			return '["c", ISO Dates are not supported]';		}		private function printIso8601Day():String {			return '["N", ISO Days are not supported]';		}		private function printRfc2822():String {			return '["r", RFC-2822 Dates are not supported]';		}		// print am/pm or AM/PM		private function printAmPm( $_uppercase:Boolean = false ):String {			return $_uppercase ? meridiem.toUpperCase() : meridiem;		}		private function printHours( $_leadingZero:Boolean = true, $_twelveHours:Boolean = false ):String {			var _phours:int = hour;			if( $_twelveHours ) {				_phours = hour > 12 ? hour - 12 : hour;			}			if( $_leadingZero && _phours < 10 ) 				return "0" + _phours;			else return String( _phours );		}		private function printMinutes():String {			return minute < 10 ? '0' + minute : String( minute );		}		private function printSeconds():String {			return second < 10 ? '0' + second : String( second );		}		private function printSummertime():String {						return '';		}		private function printDayOfMonth( $_leadingZero:Boolean = true ):String {			if( $_leadingZero )				return day < 10 ? '0' + day : String( day );			else return String( day );		}		private function printWeekDayAsText( $_short:Boolean = false ):String {			var _t:Array = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4];			var _year:int = year;			_year -= month < 3 ? 1 : 0;			var _dayOfWeekIndex:int = ( _year + Math.floor( _year/4 ) - Math.floor( _year/100 ) + Math.floor( _year/400 ) + _t[month-1] + day) % 7;			return $_short ? capitalize( WEEKDAYS_ABRV[_dayOfWeekIndex] ) : capitalize( WEEKDAYS_FULL[_dayOfWeekIndex] );		}		private function printLeapYear():String {			return isLeapYear( year ) ? '1' : '0';		}		private function printMonth( $_leadingZero:Boolean = true):String {			return $_leadingZero ? '0' + month : String( month );		}		private function printMonthAsText( $_short:Boolean = false ):String {			return $_short ? capitalize( MONTHS_ABRV[month-1] ) : capitalize( MONTHS_FULL[month-1] );		}		private function printGmtOffset( $_timezoneOffset:int, $_seperator:String='' ):String {			var _sign:String = $_timezoneOffset < 0 ? '-' : '+';			var _result:Object = extractHoursFrom( Math.abs( $_timezoneOffset ));			var _hoursOffset:int = _result.hours;			_result = extractMinutesFrom( _result.remainingSeconds );			var _minutesOffset:int = _result.minutes;			var _hoursOffsetFormatted:String = _hoursOffset < 10 ? '0'+_hoursOffset : String( _hoursOffset );			var _minutesOffsetFormatted:String = _minutesOffset < 10 ? '0'+_minutesOffset : String( _minutesOffset );				return 'GMT' + _sign + _hoursOffsetFormatted + $_seperator + _minutesOffsetFormatted;		}		private function printMonthDayOrdinalSuffix():String {			var _dayString:String = String( day );			var _trailingNumeral:int = parseInt( _dayString.substr( _dayString.length-1, 1 ));			if( _trailingNumeral == 1 )				return 'st';			else if( _trailingNumeral == 2 )				return 'nd';			else if( _trailingNumeral == 3 ) 				return 'rd';			else return 'th';		}		private function printNumberOfDaysInMonth():String {			return String( daysInMonthOf( month-1, year ));		}		private function printTimezone():String {			return '["T", Timezone Abbreviation is not supported]';		}		private function printUnixTimestamp():String {			return String( timestamp );		}		private function printWeekDay():String {			return '';		}		private function printWeekOfYear():String {			return '';		}		private function printYear( $_twoDigits:Boolean = false ):String {			var _year:String = String( year );			return $_twoDigits ? _year.substring( 2, _year.length ) : _year;		}		private function printDayOfYear():String {			return '';		}		private function printTimezoneOffset():String {			return String( timezoneOffset );		}						/* -- UTILITIES ------------------------------------------------------		 *		 *		 */		private function capitalize( $_string:String ):String {			var firstChar:String = $_string.substr( 0, 1 );			var restOfString:String = $_string.substr( 1, $_string.length);			return firstChar.toUpperCase() + restOfString.toLowerCase();		}		private function daysToSeconds( $_days:int ):int {			return $_days * 24 * 3600;		}		private function hoursToSeconds( $_hours:Number ):int {			return $_hours * 3600;		}		private function secondsToHours( $_seconds:int ):Number {			return $_seconds / 3600;		}		private function minutesToSeconds( $_minutes:Number ):int {			return $_minutes * 60;		}		// print days in month		private function daysInMonthOf( $_monthId:int, $_year:int ):int {			if( $_monthId == 1 ) {				return isLeapYear( $_year ) ? 29 : 28;			}			else if( $_monthId % 2 == 0 && $_monthId <= 6 ) return 31;			else if( $_monthId % 2 != 0 && $_monthId >= 7 ) return 31;			else return 30; 		}		// print days in year		private function daysInYear( $_year:int ):int {			return isLeapYear( $_year ) ? 366 : 365;		}				// is leap year		private function isLeapYear( $_year:int ):Boolean {			if( $_year == 0 ) {				return false;			}			if( $_year % 4 == 0 && $_year % 100 != 0 ) {				return true;			}			else if( $_year % 100 == 0 && $_year % 400 == 0 ) {				return true;			}			else return false;		}						// extract years from seconds and return remaining seconds		private function extractYearsFrom( $_seconds:int ):Object {			for( var j:int = 1970;; j++ ) {				var yearInSeconds:int = daysToSeconds( daysInYear( j ));				//trace( yearInSeconds+' - '+daysToSeconds( daysInYear( j )));				if( $_seconds >= yearInSeconds )					$_seconds -= yearInSeconds;				else break;			}			return {				years: j,				remainingSeconds: $_seconds			};		}		// extract months from seconds and return remaining seconds		private function extractMonthsFrom( $_seconds:int ):Object {			for( var i:int = 0; i < 12; i++ ) {				var monthInSeconds:int = daysToSeconds( daysInMonthOf( i, year ));				if( $_seconds >= monthInSeconds )					$_seconds -= monthInSeconds;				else break;			}			return {				months: i+1,				remainingSeconds: $_seconds			};		}		// extract days from seconds and return remaining seconds		private function extractDaysFrom( $_seconds:int ):Object {			var _days:int = 1;			var dayInSeconds:int = daysToSeconds( 1 );			while( $_seconds >= dayInSeconds ) {				$_seconds -= dayInSeconds;				_days++;			}			return {				days: _days,				remainingSeconds: $_seconds			};		}		// extract hours from seconds and return remaining seconds		private function extractHoursFrom( $_seconds:int ):Object {			var _hours:int = 0;			var hourInSeconds:int = hoursToSeconds( 1 );			while( $_seconds >= hourInSeconds ) {				$_seconds -= hourInSeconds;				_hours++;			}			return {				hours: _hours,				remainingSeconds: $_seconds			};		}		// extract minutes from seconds and return remaining seconds		private function extractMinutesFrom( $_seconds:int ):Object {			var _minutes:int = 0;			var minuteInSeconds:int = minutesToSeconds( 1 );			while( $_seconds >= minuteInSeconds ) {				$_seconds -= minuteInSeconds;				_minutes++;			}			return {				minutes: _minutes,				remainingSeconds: $_seconds			};		}		/* -- CONVERT DATE TO TIMESTAMP -----------------------------------------		 *		 *		 */		private function convertDateToTime():void {			var _cummulativeSeconds:int = second;			_cummulativeSeconds += minutesToSeconds( minute );			_cummulativeSeconds += hoursToSeconds( hour );			_cummulativeSeconds += daysToSeconds( day-1 );			for( var i:int = 0; i < month-1; i++ ) {				_cummulativeSeconds += daysToSeconds( daysInMonthOf( i, year ));			}			for( var j:int = 1970; j < year; j++ ) {				_cummulativeSeconds += daysToSeconds( daysInYear( j ));			}			_cummulativeSeconds -= timezoneOffset;			timestamp = _cummulativeSeconds;		}						/* -- EXTRACT DATE ELEMENTS FROM TIMESTAMP ------------------------------		 *		 *		 */		private function convertTimeToDateElements():void {			var _timeIncludingTimezoneOffset:int = timestamp + timezoneOffset;			var _result:Object = extractYearsFrom( _timeIncludingTimezoneOffset );			year = _result.years;						_result = extractMonthsFrom( _result.remainingSeconds );			month = _result.months;						_result = extractDaysFrom( _result.remainingSeconds );			day = _result.days;						_result = extractHoursFrom( _result.remainingSeconds );			hour = _result.hours;						_result = extractMinutesFrom( _result.remainingSeconds );			minute = _result.minutes;			second = _result.remainingSeconds;		}				/* -- DAYLIGHT SAVINGS UTILITIES ------------------------------		 *		 *		 */		// using client's computer clock, given a year, calculate the startSeconds and endSeconds of Daylight Savings		private static function getClientDstStartEnd() : Array {			var dtDstDetect:Date = new Date();			var dtDstStart:Date;			var dtDstEnd:Date;			var dtDstStartHold:String = '';			var intYearDayCount:int = 732;			var intHourOfYear:int = 1;			var intDayOfYear:int;			var intOffset:int = getClientTimezoneOffsetInMinutes(); 		 			//Start from a year ago to make sure we include any previously starting DST			dtDstDetect.setUTCFullYear( dtDstDetect.getFullYear() - 1 );			dtDstDetect.setUTCHours( 0, 0, 0, 0 );		 			//Going hour by hour through the year will detect DST with shorter code but that could result in 8760			//FOR loops and several seconds of script execution time. Longer code narrows this down a little.			//Go one day at a time and find out approx time of DST and if there even is DST on this computer.			//Also need to make sure we catch the most current start and end cycle.			for( intDayOfYear = 1; intDayOfYear <= intYearDayCount; intDayOfYear++ ){				dtDstDetect.setUTCDate( dtDstDetect.getUTCDate() + 1 );		 				if(( dtDstDetect.getTimezoneOffset() * ( -1 )) != intOffset && dtDstStartHold == '' ){					dtDstStartHold = new Date( dtDstDetect ).toDateString();				}				if(( dtDstDetect.getTimezoneOffset() * ( -1 )) == intOffset && dtDstStartHold != '' ){					dtDstStart = new Date( dtDstStartHold );					dtDstEnd = new Date( dtDstDetect );					dtDstStartHold = '';		 					//DST is being used in this timezone. Narrow the time down to the exact hour the change happens					//Remove 48 hours (a few extra to be on safe side) from the start/end date and find the exact change point					//Go hour by hour until a change in the timezone offset is detected.					dtDstStart.setUTCHours( dtDstStart.getUTCHours() - 48 );					dtDstEnd.setUTCHours( dtDstEnd.getUTCHours() - 48 );		 					//First find when DST starts					for( intHourOfYear = 1; intHourOfYear <= 48; intHourOfYear++ ){						dtDstStart.setUTCHours( dtDstStart.getUTCHours() + 1 );		 						//If we found it then exit the loop. dtDstStart will have the correct value left in it.						if(( dtDstStart.getTimezoneOffset() * ( -1 )) != intOffset ){							break;						}					}		 					//Now find out when DST ends					for( intHourOfYear=1; intHourOfYear <= 48; intHourOfYear++ ){						dtDstEnd.setUTCHours( dtDstEnd.getUTCHours() + 1 );		 						//If we found it then exit the loop. dtDstEnd will have the correct value left in it.						if(( dtDstEnd.getTimezoneOffset() * ( -1 )) != ( intOffset + 60 )){							break;						}					}		 					//Check if DST is currently on for this time frame. If it is then return these values.					//If not then keep going. The function will either return the last values collected					//or another value that is currently in effect					if(( new Date()).getTime() >= dtDstStart.getTime() && ( new Date()).getTime() <= dtDstEnd.getTime() ){						return new Array( dtDstStart.time/1000, dtDstEnd.time/1000 );					}		 				}			}			return new Array( dtDstStart.time/1000, dtDstEnd.time/1000 );		}						// return the client's GMT-offset *WITHOUT* Daylight Savings		private static function getClientTimezoneOffsetInMinutes():int {			var dtDate:Date = new Date('1/1/' + (new Date()).getUTCFullYear());			var intOffset:int = 10000; 			var intMonth:int;			for( intMonth=0; intMonth < 12; intMonth++ ){				dtDate.setUTCMonth( dtDate.getUTCMonth() + 1 );				if( intOffset > dtDate.getTimezoneOffset() * -1 ) {					intOffset = dtDate.getTimezoneOffset() * -1;				}			}			return intOffset;		}																		/* -- MISC ------------------------------		 *		 *		 */		// to string		public function toString():String {			return 'timestamp: '+timestamp+				', year: '+year+', month: '+month+', day: '+day+				', hour: '+hour+', minute: '+minute+', second: '+second+				', timezoneOffset: '+timezoneOffset+', meridiem: '+meridiem+				', weekday: '+weekday;		}	}	}