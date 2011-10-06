﻿package com.ff0000.utils.zdate {		public class ZDUtil {				public function ZDUtil() {			// constructor code		}						/* --- UTILITIES --------------------------------------------------------------------------------------------------------		 *		 *		 */		// converting to seconds		internal function daysToSeconds( $_days:int ):int {			return $_days * 24 * 3600;		}		internal function hoursToSeconds( $_hours:Number ):int {			return $_hours * 3600;		}		internal function secondsToHours( $_seconds:int ):Number {			return $_seconds / 3600;		}		internal function minutesToSeconds( $_minutes:Number ):int {			return $_minutes * 60;		}						// return days in month of		internal function daysInMonthOf( $_monthId:int, $_year:int ):int {			if( $_monthId == 1 ) {				return isLeapYear( $_year ) ? 29 : 28;			}			else if( $_monthId % 2 == 0 && $_monthId <= 6 ) return 31;			else if( $_monthId % 2 != 0 && $_monthId >= 7 ) return 31;			else return 30; 		}		// return days in year of		internal function daysInYear( $_year:int ):int {			return isLeapYear( $_year ) ? 366 : 365;		}								// is year a leap year?		internal function isLeapYear( $_year:int ):Boolean {			if( $_year == 0 ) {				return false;			}			if( $_year % 4 == 0 && $_year % 100 != 0 ) {				return true;			}			else if( $_year % 100 == 0 && $_year % 400 == 0 ) {				return true;			}			else return false;		}								// extract years from seconds and return remaining seconds		internal function extractYearsFrom( $_seconds:int ):Object {			for( var j:int = 1970;; j++ ) {				var yearInSeconds:int = daysToSeconds( daysInYear( j ));				if( $_seconds >= yearInSeconds )					$_seconds -= yearInSeconds;				else break;			}			return {				years: j,				remainingSeconds: $_seconds			};		}		// extract months from seconds and return remaining seconds		internal function extractMonthsFrom( $_seconds:int, $_year:int ):Object {			for( var i:int = 0; i < 12; i++ ) {				var monthInSeconds:int = daysToSeconds( daysInMonthOf( i, $_year ));				if( $_seconds >= monthInSeconds )					$_seconds -= monthInSeconds;				else break;			}			return {				months: i+1,				remainingSeconds: $_seconds			};		}		// extract days from seconds and return remaining seconds		internal function extractDaysFrom( $_seconds:int ):Object {			var _days:int = 1;			var dayInSeconds:int = daysToSeconds( 1 );			while( $_seconds >= dayInSeconds ) {				$_seconds -= dayInSeconds;				_days++;			}			return {				days: _days,				remainingSeconds: $_seconds			};		}		// extract hours from seconds and return remaining seconds		internal function extractHoursFrom( $_seconds:int ):Object {			var _hours:int = 0;			var hourInSeconds:int = hoursToSeconds( 1 );			while( $_seconds >= hourInSeconds ) {				$_seconds -= hourInSeconds;				_hours++;			}			return {				hours: _hours,				remainingSeconds: $_seconds			};		}		// extract minutes from seconds and return remaining seconds		internal function extractMinutesFrom( $_seconds:int ):Object {			var _minutes:int = 0;			var minuteInSeconds:int = minutesToSeconds( 1 );			while( $_seconds >= minuteInSeconds ) {				$_seconds -= minuteInSeconds;				_minutes++;			}			return {				minutes: _minutes,				remainingSeconds: $_seconds			};		}				/* --- DAYLIGHT SAVINGS UTILITIES ---------------------------------------------------------------------------		 *		 *		 */		// get dst offset for this timestamp		internal function getDstOffsetFor( $_timestamp:int ):int {			var _dstOffset:int = 0;			var _dstStartEnd:Array = getClientDstStartEnd();			if( $_timestamp > _dstStartEnd[0] && $_timestamp <= _dstStartEnd[1] ) {				_dstOffset = 1;			}			return _dstOffset;		}		// using client's computer clock, given a year, calculate the startSeconds and endSeconds of Daylight Savings		internal function getClientDstStartEnd() : Array {			var dtDstDetect:Date = new Date();			var dtDstStart:Date;			var dtDstEnd:Date;			var dtDstStartHold:String = '';			var intYearDayCount:int = 732;			var intHourOfYear:int = 1;			var intDayOfYear:int;			var intOffset:int = getClientTimezoneOffsetInMinutes(); 		 			dtDstDetect.setUTCFullYear( dtDstDetect.getFullYear() - 1 );			dtDstDetect.setUTCHours( 0, 0, 0, 0 );		 			for( intDayOfYear = 1; intDayOfYear <= intYearDayCount; intDayOfYear++ ){				dtDstDetect.setUTCDate( dtDstDetect.getUTCDate() + 1 );		 				if(( dtDstDetect.getTimezoneOffset() * ( -1 )) != intOffset && dtDstStartHold == '' ){					dtDstStartHold = new Date( dtDstDetect ).toDateString();				}				if(( dtDstDetect.getTimezoneOffset() * ( -1 )) == intOffset && dtDstStartHold != '' ){					dtDstStart = new Date( dtDstStartHold );					dtDstEnd = new Date( dtDstDetect );					dtDstStartHold = '';		 					dtDstStart.setUTCHours( dtDstStart.getUTCHours() - 48 );					dtDstEnd.setUTCHours( dtDstEnd.getUTCHours() - 48 );		 					for( intHourOfYear = 1; intHourOfYear <= 48; intHourOfYear++ ){						dtDstStart.setUTCHours( dtDstStart.getUTCHours() + 1 );		 						if(( dtDstStart.getTimezoneOffset() * ( -1 )) != intOffset ){							break;						}					}		 					for( intHourOfYear=1; intHourOfYear <= 48; intHourOfYear++ ){						dtDstEnd.setUTCHours( dtDstEnd.getUTCHours() + 1 );		 						if(( dtDstEnd.getTimezoneOffset() * ( -1 )) != ( intOffset + 60 )){							break;						}					}		 					if(( new Date()).getTime() >= dtDstStart.getTime() && ( new Date()).getTime() <= dtDstEnd.getTime() ){						return new Array( dtDstStart.time/1000, dtDstEnd.time/1000 );					}		 				}			}			return new Array( dtDstStart.time/1000, dtDstEnd.time/1000 );		}						// return the client's GMT-offset *WITHOUT* Daylight Savings		internal function getClientTimezoneOffsetInMinutes():int {			var dtDate:Date = new Date('1/1/' + (new Date()).getUTCFullYear());			var intOffset:int = 10000; 			var intMonth:int;			for( intMonth=0; intMonth < 12; intMonth++ ){				dtDate.setUTCMonth( dtDate.getUTCMonth() + 1 );				if( intOffset > dtDate.getTimezoneOffset() * -1 ) {					intOffset = dtDate.getTimezoneOffset() * -1;				}			}			return intOffset;		}						/* --- MISC ----------------------------------------------------------------------------------------------		 *		 *		 */		// capitalize first letter in word 		internal function capitalize( $_string:String ):String {			var firstChar:String = $_string.substr( 0, 1 );			var restOfString:String = $_string.substr( 1, $_string.length);			return firstChar.toUpperCase() + restOfString.toLowerCase();		}			}	}